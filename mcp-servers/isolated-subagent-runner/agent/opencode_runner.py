import os
import json
import sys
import urllib.request
from pathlib import Path

SYSTEM_PROMPT = """You are OpenCode running gpt-5.1-codex-mini, an execution subagent inside a secure container workspace.
Your task is to apply a code modification to a file.
You are given:
1. A summary of the overall task.
2. The current content of the file (if applicable).
3. The specific instruction detailing the changes to be made.

You must output only the new content of the target file. Do not include markdown code block formatting (like ```python or ```) in your output; output the raw code directly.
"""

class OpenCodeRunner:
    def __init__(self, task_file: str):
        """
        Initializes the OpenCode runner inside the sandboxed container.
        :param task_file: Path to the JSON task file (e.g. /workspace/.agent/task.json)
        """
        self.task_file = Path(task_file).resolve()
        # The workspace is the root of the worktree mount
        self.workspace = Path("/workspace")

    def load_task(self) -> dict:
        with open(self.task_file, "r") as f:
            return json.load(f)

    def read_file_content(self, relative_path: str) -> str:
        full_path = self.workspace / relative_path
        if not full_path.exists():
            return ""
        try:
            return full_path.read_text(encoding="utf-8")
        except Exception as e:
            return f"Error reading file: {e}"

    def write_file_content(self, relative_path: str, content: str):
        full_path = self.workspace / relative_path
        full_path.parent.mkdir(parents=True, exist_ok=True)
        full_path.write_text(content, encoding="utf-8")

    def clean_code_block(self, content: str) -> str:
        content = content.strip()
        if content.startswith("```"):
            first_newline = content.find("\n")
            if first_newline != -1:
                content = content[first_newline + 1:]
            if content.endswith("```"):
                content = content[:-3]
        return content.strip()

    def delete_file(self, relative_path: str):
        full_path = self.workspace / relative_path
        if full_path.exists():
            full_path.unlink()

    def call_llm(self, prompt: str, system_prompt: str) -> str:
        api_key = os.environ.get("OPENCODE_API_KEY")
        api_url = os.environ.get("OPENCODE_API_URL", "https://api.opencode.ai/v1/chat/completions")

        if not api_key:
            # Under mock/test conditions where no API key is supplied, return simulated output based on instruction
            print("[INFO] No OPENCODE_API_KEY found. Simulating completion...")
            if "CREATE" in prompt or "create" in prompt.lower():
                return "# Created file content by simulation\nprint('Hello from OpenCode sandbox!')\n"
            return f"# Simulated modified content\n"

        # Standard payload format for the model (OpenAI compatible schema)
        model_name = os.environ.get("OPENCODE_MODEL", "gpt-5.1-codex-mini")
        payload = {
            "model": model_name,
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt}
            ],
            "temperature": 0.1
        }
        
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {api_key}"
        }

        try:
            req = urllib.request.Request(
                api_url,
                data=json.dumps(payload).encode("utf-8"),
                headers=headers,
                method="POST"
            )
            with urllib.request.urlopen(req, timeout=60) as response:
                res_data = json.loads(response.read().decode("utf-8"))
                return res_data["choices"][0]["message"]["content"]
        except Exception as e:
            raise RuntimeError(f"API request failed: {e}")

    def execute(self) -> dict:
        task_data = self.load_task()
        summary = task_data.get("summary", "")
        instructions = task_data.get("instructions", [])
        files_to_read = task_data.get("files_to_read", [])

        print(f"Starting execution of SDD task: {task_data.get('task_id')}")
        print(f"Summary: {summary}")

        # Load context files
        context_data = {}
        for f_path in files_to_read:
            context_data[f_path] = self.read_file_content(f_path)

        logs = []
        success = True

        for idx, inst in enumerate(instructions):
            file_path = inst.get("file_path")
            action = inst.get("action", "").upper()
            description = inst.get("description", "")

            print(f"\nStep {idx+1}/{len(instructions)}: {action} {file_path}")
            print(f"Description: {description}")

            current_content = self.read_file_content(file_path)

            if action == "DELETE":
                try:
                    self.delete_file(file_path)
                    logs.append({
                        "step": idx + 1,
                        "file_path": file_path,
                        "action": action,
                        "status": "success",
                        "message": "File deleted successfully"
                    })
                except Exception as e:
                    success = False
                    logs.append({
                        "step": idx + 1,
                        "file_path": file_path,
                        "action": action,
                        "status": "error",
                        "message": f"Failed to delete file: {e}"
                    })
                continue

            # Build model prompt
            user_prompt = f"Overall Task Summary: {summary}\n\n"
            user_prompt += f"Target File Path: {file_path}\n"
            user_prompt += f"Action: {action}\n"
            user_prompt += f"Instruction Details: {description}\n\n"
            if action == "MODIFY":
                user_prompt += f"Current Content of {file_path}:\n---\n{current_content}\n---\n"

            if context_data:
                user_prompt += "Context Files:\n"
                for ctx_path, ctx_content in context_data.items():
                    if ctx_path != file_path:
                        user_prompt += f"--- Content of {ctx_path} ---\n{ctx_content}\n---\n"

            try:
                new_content = self.call_llm(user_prompt, SYSTEM_PROMPT)
                new_content = self.clean_code_block(new_content)
                self.write_file_content(file_path, new_content)

                logs.append({
                    "step": idx + 1,
                    "file_path": file_path,
                    "action": action,
                    "status": "success",
                    "message": "Applied successfully"
                })
            except Exception as e:
                success = False
                logs.append({
                    "step": idx + 1,
                    "file_path": file_path,
                    "action": action,
                    "status": "error",
                    "message": f"Failed during execution: {e}"
                })
                print(f"[ERROR] Step {idx+1} failed: {e}")

        result = {
            "task_id": task_data.get("task_id"),
            "success": success,
            "logs": logs
        }

        # Write execution outcomes back to the .agent workspace folder
        result_file = self.task_file.parent / "task_result.json"
        with open(result_file, "w") as f:
            json.dump(result, f, indent=2)

        return result

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 opencode_runner.py <path_to_task_json>")
        sys.exit(1)
    
    runner = OpenCodeRunner(sys.argv[1])
    res = runner.execute()
    sys.exit(0 if res["success"] else 1)
