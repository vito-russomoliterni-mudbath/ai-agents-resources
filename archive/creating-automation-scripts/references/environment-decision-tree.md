# Environment Decision Tree

Guide for choosing the appropriate script type based on requirements.

## Quick Decision Flow

```
START
  │
  ├─ Is target environment known?
  │   │
  │   ├─ YES → Use that environment's native scripting
  │   │         • Windows → PowerShell 5.1
  │   │         • Linux/macOS → Bash
  │   │
  │   └─ NO → Ask user to specify
  │
  └─ Does user need cross-platform?
      │
      ├─ YES → Discuss options:
      │         • PowerShell 7+ (single script)
      │         • Dual scripts (.sh + .ps1)
      │
      └─ NO → Use detected/specified environment
```

---

## When to Use PowerShell

### Primary Indicators
- Target is Windows
- Script will interact with:
  - Windows Registry
  - Windows Services
  - Active Directory
  - IIS
  - .NET assemblies
  - COM objects
  - WMI/CIM

### Advantages
- Pre-installed on Windows 10/11
- Rich object pipeline (not just text)
- Strong .NET integration
- Excellent Windows system access
- Built-in remoting (PSRemoting)
- Good parameter validation

### Best For
- Windows system administration
- .NET application deployment
- Windows service management
- Active Directory management
- Azure/Microsoft 365 automation

### Example Scenarios
```
✓ "Create a script to manage Windows services"
✓ "Automate Active Directory user creation"
✓ "Deploy a .NET application to IIS"
✓ "Clean up Windows temp files"
✓ "Configure Windows firewall rules"
```

---

## When to Use Bash

### Primary Indicators
- Target is Linux or macOS
- Script will run in:
  - CI/CD pipelines (GitHub Actions, GitLab CI, Jenkins)
  - Docker containers
  - Cloud environments (AWS, GCP, Azure Linux VMs)
  - WSL on Windows

### Advantages
- Universal on Unix systems
- Available on Windows via Git Bash/WSL
- Native to CI/CD environments
- Lightweight and fast
- Excellent for text processing
- Strong tool ecosystem (grep, sed, awk, jq)

### Best For
- Linux server administration
- CI/CD pipelines
- Docker/container operations
- Text file processing
- Quick automation scripts
- Build processes

### Example Scenarios
```
✓ "Create a deployment script for our Linux servers"
✓ "Automate our GitHub Actions workflow"
✓ "Process log files and extract errors"
✓ "Create a Docker build script"
✓ "Set up development environment on macOS"
```

---

## When to Offer Cross-Platform (Only If User Requests)

### User Requests Indicators
- "needs to work on both Windows and Linux"
- "should run anywhere"
- "cross-platform"
- "works on all operating systems"

### Option 1: PowerShell 7+

**Pros:**
- Single script for all platforms
- Same syntax everywhere
- Object pipeline works cross-platform
- Good for teams already using PowerShell

**Cons:**
- Requires PowerShell 7+ installation on Linux/macOS
- Less common in CI/CD environments
- Learning curve for Unix users

**Best when:**
- Team primarily uses PowerShell
- Script needs .NET features
- Windows is primary target with Linux support

### Option 2: Dual Scripts (.sh + .ps1)

**Pros:**
- Native experience on each platform
- No additional installations required
- Best performance on each platform
- CI/CD friendly

**Cons:**
- Maintenance of two scripts
- Logic may drift between versions
- More files to manage

**Best when:**
- Different teams manage different platforms
- Maximum compatibility needed
- CI/CD requires native scripts

---

## Decision Matrix

| Requirement | PowerShell 5.1 | Bash | PowerShell 7+ | Dual Scripts |
|-------------|----------------|------|---------------|--------------|
| Windows only | **Best** | - | Good | - |
| Linux only | - | **Best** | Good | - |
| macOS only | - | **Best** | Good | - |
| Windows + Linux | - | - | Good | **Best** |
| CI/CD pipelines | - | **Best** | - | Good |
| Docker containers | - | **Best** | - | - |
| .NET integration | **Best** | - | **Best** | - |
| Windows Registry | **Best** | - | - | - |
| Text processing | Good | **Best** | Good | **Best** |
| Quick scripts | Good | **Best** | Good | - |

---

## Questions to Ask User

When environment is unclear, ask:

1. **Target environment:**
   - "Where will this script run? (Windows, Linux, macOS, or multiple?)"

2. **Execution context:**
   - "Will this run locally, in CI/CD, or in containers?"

3. **Integration needs:**
   - "Does it need to interact with Windows-specific features (Registry, Services, AD)?"
   - "Does it need to work with .NET?"

4. **Team familiarity:**
   - "What scripting language is your team most comfortable with?"

5. **Cross-platform (only if relevant):**
   - "Do you need this to work on multiple operating systems?"

---

## AskUserQuestion Examples

### When detection fails:

```
Question: "What is the target environment for this script?"
Options:
1. Windows (PowerShell 5.1)
2. Linux/macOS (Bash)
3. Need cross-platform support
```

### When cross-platform is requested:

```
Question: "How would you like to handle cross-platform support?"
Options:
1. PowerShell 7+ - Single script, requires PS7 installation on Linux/macOS
2. Dual scripts - Native .sh and .ps1 for each platform
3. Bash only - Works on Windows via Git Bash or WSL
```

### When target is known but want to confirm:

```
Question: "I detected you're on Windows. Is PowerShell 5.1 the target for this script?"
Options:
1. Yes, PowerShell 5.1 for Windows
2. No, I need Bash (for WSL or deployment to Linux)
3. No, I need cross-platform support
```
