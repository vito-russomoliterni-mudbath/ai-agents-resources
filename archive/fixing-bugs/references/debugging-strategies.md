# Debugging Strategies Guide

## Table of Contents
1. [Systematic Investigation Approaches](#systematic-investigation-approaches)
2. [Investigation Techniques](#investigation-techniques)
3. [Debugging Tools and Methods](#debugging-tools-and-methods)
4. [Reproduction Strategies](#reproduction-strategies)
5. [Data Gathering](#data-gathering)

## Systematic Investigation Approaches

### The Scientific Method for Debugging

1. **Observe the Problem**: Document what went wrong
   - User report or error message
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, version, browser, etc.)

2. **Form Hypotheses**: Generate possible causes
   - Think about recent changes
   - Consider affected systems
   - List most likely culprits
   - Prioritize by probability

3. **Design Experiments**: Create tests to validate hypotheses
   - Isolate variables
   - Change one thing at a time
   - Measure the outcome
   - Document results

4. **Analyze Results**: Draw conclusions
   - Does data support hypothesis?
   - What can we rule out?
   - What new questions emerged?
   - Narrow the search space

### The Divide and Conquer Approach

Break the system into smaller sections and test each:

```
System
├── Frontend Layer
│   ├── UI Components
│   ├── State Management
│   └── API Client
├── Backend Layer
│   ├── API Endpoints
│   ├── Business Logic
│   └── Database Layer
└── Integration Points
    ├── Network Communication
    ├── Data Serialization
    └── Error Handling
```

For each section, ask:
- Does this component work in isolation?
- Does it receive correct inputs?
- Does it produce correct outputs?
- How does it fail?

### The Timeline Approach

Work backward from the symptom:

```
Effect (Bug Observed)
  ↑
What code executed?
  ↑
What triggered that code?
  ↑
What preconditions exist?
  ↑
What assumptions are we making?
  ↑
Root Cause
```

Example: "Page is blank"
- What renders the page? (Component rendering)
- What data does it need? (API response)
- Did the API call succeed? (Network/endpoint)
- Is the endpoint receiving correct parameters? (Frontend state)
- Why is the state wrong? (State management/initialization)

## Investigation Techniques

### Print/Log-Based Debugging

Add strategic logging to understand execution flow:

```python
def process_order(order_id, items):
    print(f"[DEBUG] Starting process_order with order_id={order_id}, items={items}")

    validated_items = validate_items(items)
    print(f"[DEBUG] After validation: {validated_items}")

    total_price = calculate_price(validated_items)
    print(f"[DEBUG] Total price calculated: {total_price}")

    result = save_to_db(order_id, validated_items, total_price)
    print(f"[DEBUG] DB save result: {result}")

    return result
```

Best practices:
- Use appropriate log levels (DEBUG, INFO, WARNING, ERROR)
- Include variable names and values
- Add timestamps and context
- Remove or disable logs before committing
- Use structured logging in production

### Debugger Techniques

Interactive debugging for deep investigation:

**Python (pdb)**:
```python
import pdb

def buggy_function():
    data = fetch_data()
    pdb.set_trace()  # Execution pauses here
    result = process(data)
    return result
```

Commands:
- `n` (next) - Execute next line
- `s` (step) - Step into function calls
- `c` (continue) - Resume execution
- `p variable` - Print variable value
- `pp variable` - Pretty print
- `l` - List current code
- `b lineno` - Set breakpoint
- `w` - Show stack trace

**JavaScript/TypeScript**:
```typescript
debugger; // Pauses execution in DevTools
console.log("Critical value:", complexObject);
```

Browser DevTools:
- Set breakpoints by clicking line numbers
- Conditional breakpoints for specific values
- Watch expressions
- Step through code
- Inspect variables in console
- Network tab for API calls

### Tracing and Profiling

Understand performance and execution paths:

**Call Stack Analysis**:
- Where did we come from?
- What's the execution path?
- Is it in an unexpected order?
- Are we calling something recursively?

**Memory Profiling**:
```python
from memory_profiler import profile

@profile
def memory_intensive_function():
    large_list = [i for i in range(1000000)]
    return sum(large_list)
```

**Performance Profiling**:
```python
import cProfile
import pstats

profiler = cProfile.Profile()
profiler.enable()
# ... code to profile ...
profiler.disable()
stats = pstats.Stats(profiler)
stats.sort_stats('cumulative').print_stats(10)
```

### State Inspection

Understand data at key points:

```javascript
// React component state debugging
const [state, setState] = useState(initialState);

useEffect(() => {
  console.log('State changed:', state);
  console.table(state); // Format as table
  console.dir(state);   // Show properties
}, [state]);
```

**Checkpoint Validation**:
```python
def complex_calculation(inputs):
    # Checkpoint 1: Input validation
    assert isinstance(inputs, list), "inputs must be list"
    assert len(inputs) > 0, "inputs cannot be empty"
    assert all(isinstance(x, (int, float)) for x in inputs), "all items must be numbers"

    # Checkpoint 2: Intermediate result
    step1 = [x * 2 for x in inputs]
    assert len(step1) == len(inputs), "step1 lost items"

    # Checkpoint 3: Final result
    result = sum(step1)
    assert result >= 0 or any(x < 0 for x in inputs), "unexpected negative result"

    return result
```

## Debugging Tools and Methods

### Static Analysis

Find bugs without running code:

**Linters** (catch style and logical errors):
```bash
# Python
pylint myfile.py
flake8 myfile.py

# JavaScript
eslint myfile.js
```

**Type Checking**:
```bash
# TypeScript
tsc --strict

# Python with mypy
mypy myfile.py
```

**Code Analysis Tools**:
- Identify dead code
- Find unused variables
- Detect potential null pointer dereferences
- Spot type inconsistencies

### Dynamic Analysis

Run code and observe behavior:

```python
# Unit test as investigation tool
def test_edge_case():
    # Does it handle empty input?
    result = function_under_test([])
    assert result is not None

    # Does it handle None?
    result = function_under_test(None)

    # Does it handle large input?
    result = function_under_test(list(range(100000)))
```

### Instrumentation

Add code to gather debug information:

```javascript
// Middleware pattern for tracking
function withDebugTracking(fn, name) {
  return async (...args) => {
    console.log(`[${name}] Called with:`, args);
    const start = performance.now();
    try {
      const result = await fn(...args);
      console.log(`[${name}] Returned:`, result);
      return result;
    } catch (error) {
      console.error(`[${name}] Error:`, error);
      throw error;
    } finally {
      console.log(`[${name}] Duration: ${performance.now() - start}ms`);
    }
  };
}
```

### Diff-Based Debugging

Compare working vs broken versions:

```bash
# Find what changed
git diff HEAD~5

# See commit that introduced bug
git bisect start
git bisect bad HEAD
git bisect good v1.0.0

# Compare versions side-by-side
git diff version1..version2 -- path/to/file.js
```

## Reproduction Strategies

### Creating Minimal Reproducible Examples

Extract the bug into simplest form:

**Good**: Isolates the problem
```python
# Minimal example that shows the bug
def test_bug():
    data = [1, 2, 3]
    result = sum_elements(data)  # Returns wrong value
    assert result == 6
```

**Poor**: Includes unnecessary complexity
```python
# Hard to see what's actually broken
def test_with_db():
    connect_to_database()
    authenticate_user()
    fetch_user_profile()
    load_settings()
    result = sum_elements([1, 2, 3])
    cleanup_database()
    assert result == 6
```

### Environmental Reproduction

Verify bug occurs in specific environments:

```bash
# Can we reproduce locally?
python -m pytest tests/test_buggy_feature.py -v

# Does it happen with different Python versions?
python3.8 -m pytest
python3.9 -m pytest
python3.10 -m pytest

# Is it platform-specific?
# Test on Windows, Linux, macOS
```

### Deterministic vs Non-Deterministic Bugs

**Deterministic Bug** (Always reproduces):
- Follow standard reproduction steps
- Should consistently fail
- Easier to debug

**Non-Deterministic Bug** (Random/intermittent):
- Harder to reproduce
- Often timing or race conditions
- Strategies:
  - Run many times to trigger
  - Add delays/waits
  - Use stress testing
  - Check for uninitialized variables
  - Look for race conditions
  - Add synchronization primitives

```python
# Reproducing race condition
import threading
import time

def stress_test_concurrent_access():
    results = []
    errors = []

    def worker():
        try:
            result = buggy_concurrent_function()
            results.append(result)
        except Exception as e:
            errors.append(e)

    # Run many times concurrently to trigger race condition
    for _ in range(100):
        threads = [threading.Thread(target=worker) for _ in range(10)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

    if errors:
        print(f"Found {len(errors)} errors in {len(results)} successful runs")
        raise errors[0]
```

### Regression Testing for Reproducibility

Once reproduced, create test that captures the bug:

```python
# tests/test_regressions.py
def test_issue_1234_payment_calculation():
    """
    Bug: Payment calculation returns wrong value for specific input
    Issue: https://github.com/org/repo/issues/1234
    """
    # Exact inputs that trigger the bug
    items = [
        {"name": "Item A", "price": 10.00, "quantity": 3},
        {"name": "Item B", "price": 5.50, "quantity": 2},
    ]
    tax_rate = 0.08

    total = calculate_total(items, tax_rate)

    # Expected: (10*3 + 5.50*2) * 1.08 = 41.04
    assert total == 41.04
```

## Data Gathering

### Log Analysis

Extract patterns from logs:

```bash
# Find all errors in log
grep ERROR app.log

# Count occurrences
grep ERROR app.log | wc -l

# Show context around error
grep -B5 -A5 "NullPointerException" app.log

# Filter by time
grep "2024-01-15 14:" app.log
```

### Error Message Analysis

Decode what's really happening:

| Error | Typical Cause | Investigation |
|-------|---------------|-----------------|
| `NullPointerException` | Variable is null | Check initialization, null checks |
| `TypeError: Cannot read property` | Object is undefined | Verify object structure |
| `IndexError: list index out of range` | Wrong array size | Check array length, loop bounds |
| `KeyError: 'field'` | Missing dict key | Verify data structure, defaults |
| `TypeError: unsupported operand type(s)` | Wrong types | Check type conversions |
| `RecursionError: maximum recursion depth` | Infinite recursion | Check base case, recursive termination |
| `ConnectionError` | Network issue | Check endpoints, timeouts, retries |

### Metrics Collection

Gather quantitative data about the bug:

```python
import time
from collections import defaultdict

class BugAnalytics:
    def __init__(self):
        self.call_counts = defaultdict(int)
        self.timings = defaultdict(list)
        self.errors = defaultdict(int)

    def track_function(self, func_name, duration, error=None):
        self.call_counts[func_name] += 1
        self.timings[func_name].append(duration)
        if error:
            self.errors[error] += 1

    def get_report(self):
        report = {}
        for func_name in self.call_counts:
            timings = self.timings[func_name]
            report[func_name] = {
                'calls': self.call_counts[func_name],
                'avg_time': sum(timings) / len(timings),
                'max_time': max(timings),
                'errors': self.errors.get(func_name, 0)
            }
        return report

analytics = BugAnalytics()
# Instrument your code with analytics.track_function()
```
