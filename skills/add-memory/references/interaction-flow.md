# Add Memory Interaction Flow

Detailed step-by-step flow for how the skill guides users through adding memory.

## Step 1: Capture Memory Content

**If user provided an argument:**
```
User: /add-memory use pandas for data filtering
Memory captured: "use pandas for data filtering"
→ Proceed to Step 2
```

**If user didn't provide an argument:**
```
Skill: What would you like to remember?
User: Always validate dates before querying
Memory captured: "Always validate dates before querying"
→ Proceed to Step 2
```

## Step 2: Determine Scope

**Skill asks:**
```
Where should this be saved?

1. Global    - Across all your projects (~/.claude/CLAUDE.md)
2. Project   - This project only (.claude/CLAUDE.md)
3. Personal  - Just for you, not committed (CLAUDE.local.md)
```

**Based on answer:**
- If Global → Setup guide for ~/.claude/ structure
- If Project → Proceed to Step 3
- If Personal → Go to CLAUDE.local.md sections

## Step 3: Find Right Location

**Skill analyzes the memory content and suggests a section:**

**For development practices:**
```
✓ This looks like a development guideline.

Best fit: "Development Guidelines" section in CLAUDE.md

Other options:
- Code Conventions
- Performance Notes
- Database Guidelines
```

**For setup/environment:**
```
✓ This looks like an environment or setup note.

Best fit: "Setup" section in CLAUDE.md

Other options:
- Development Guidelines (if it's a code practice)
```

**User confirms or chooses alternative section.**

## Step 4: Format the Memory

**Skill applies writing guidelines:**

```
Original user input:
"use pandas for data filtering"

Formatted with context:
"**Prefer Python for data filtering:**
Use SQL for basic queries, but move filtering operations
to Python/Pandas for easier maintenance and testing."
```

**Skill checks for:**
- ✓ Specific action (not vague advice)
- ✓ Reason or context
- ✓ Concise (1-3 sentences)
- ✓ Proper markdown formatting

## Step 5: Conflict Detection

**Before adding, skill checks for:**

1. **Existing similar entries** - Is this already documented?
   ```
   ⚠ Found similar entry in Development Guidelines:
   "Prefer Python for complex transformations..."

   Update existing entry instead? (yes/no)
   ```

2. **Conflicting guidelines** - Does this contradict existing advice?
   ```
   ⚠ Potential conflict:
   Existing: "Always use SQL for performance"
   New: "Use Python for filtering"

   These might be for different scenarios. Clarify? (edit/proceed)
   ```

3. **Duplicates** - Is this exactly the same as something already saved?
   ```
   ✓ This is identical to the entry in Development Guidelines.
   Skipping (already saved).
   ```

## Step 6: Confirmation

**Skill shows final preview:**

```
═══════════════════════════════════════════════
PREVIEW: Adding to CLAUDE.md

📁 Location: Development Guidelines
📝 Entry:

**Prefer Python for data filtering:**
Use SQL for basic queries, but move filtering operations
to Python/Pandas for easier maintenance and testing.

═══════════════════════════════════════════════

Proceed? (yes/no/edit)
```

**If user chooses "edit":**
- Return to Step 4 for reformatting

**If user chooses "yes":**
- Save to file (Step 7)

**If user chooses "no":**
- Discard without saving

## Step 7: Save

**File operations:**

1. Load existing CLAUDE.md or create if missing
2. Find the target section
3. Append new entry (or update existing if flagged)
4. Preserve markdown formatting and structure
5. Write file
6. Confirm: "✓ Saved to CLAUDE.md"

## Special Flows

### Global Scope (New for Personal Skills)

If user chooses "Global":

```
⚠ This will save to ~/.claude/CLAUDE.md (across all projects)

Your global CLAUDE.md will be created if it doesn't exist.
This guideline applies to all your projects.

Proceed? (yes/no)
```

### Creating New Sections

If no matching section exists:

```
No existing "Database Guidelines" section found.

Create new section? (yes/no)

If yes, it will be added after the Development Guidelines section.
```

### Merge Opportunities

If entry improves an existing line:

```
✓ This entry enhances existing guidance:

Current: "Validate dates before querying"
Enhanced: "Validate dates before querying. The created_at column
           can be NULL for imported records—use pandas isnull()."

Replace existing entry? (yes/no)
```
