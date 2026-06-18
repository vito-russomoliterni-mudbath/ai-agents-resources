# Root Cause Analysis Guide

## Table of Contents
1. [Symptom vs Root Cause](#symptom-vs-root-cause)
2. [Five Whys Technique](#five-whys-technique)
3. [Execution Tracing](#execution-tracing)
4. [Assumption Checking](#assumption-checking)
5. [Common Root Causes](#common-root-causes)

## Symptom vs Root Cause

Understanding the difference is crucial to fixing the right thing:

### Symptoms (What we observe)
- The error or unexpected behavior
- Often misleading or incomplete
- Multiple symptoms can come from one root cause
- Treating symptoms doesn't fix the problem

### Root Causes (Why it happens)
- The underlying issue
- Must be addressed for permanent fix
- May require refactoring or redesign
- Fixing root cause prevents future occurrences

### Example: E-Commerce Application

**Symptom**: "Orders are not being created"

**Initial Assumption**: Database is down
- Check: Database is running fine

**Second Assumption**: API endpoint is broken
- Check: Endpoint returns 200 OK

**Deeper Investigation**:
- What data is the endpoint receiving?
- Is validation passing?
- What does the order creation function do?
- Check: Validation fails due to missing field

**Further Digging**:
- Why is the field missing?
- Is frontend sending it?
- Check: Frontend form has the field, but it's being filtered out

**Even Further**:
- Why is it filtered?
- Check: New middleware added yesterday that strips unknown fields

**Root Cause Found**: Middleware is overly aggressive in filtering, removing required fields not in its allowlist

**Fix**: Update middleware to preserve order-related fields
- This is the actual fix
- Treating "database is down" or "endpoint broken" won't help

## Five Whys Technique

A structured method to dig deeper:

### Process

Start with the observed problem, then ask "Why?" five times, digging deeper with each answer:

### Example 1: Web Application Crashes

```
Problem: Web application crashes after 2 hours of use

Why? → Memory usage grows unbounded
  Why? → Objects are created but never released
    Why? → Event listeners are never removed
      Why? → Components don't have cleanup logic
        Why? → Developers weren't trained on proper cleanup patterns
          → Root Cause: Lack of knowledge about React useEffect cleanup

Fix: Add useEffect cleanup to remove listeners
```

### Example 2: Database Slow Performance

```
Problem: Database queries take 30+ seconds

Why? → Full table scan is happening
  Why? → No index on search column
    Why? → Nobody added an index when the feature was built
      Why? → Requirements didn't specify performance needs
        Why? → Business didn't communicate performance requirements
          → Root Cause: Poor communication between teams

Fix: Add composite index, establish performance requirements upfront
```

### Example 3: Data Corruption

```
Problem: Customer records have incorrect email addresses

Why? → Email field is being overwritten with garbage data
  Why? → String buffer is too small for incoming data
    Why? → Buffer size was hardcoded to 50 characters
      Why? → Developer assumed email would never exceed 50 chars
        Why? → No validation was performed on email length
          → Root Cause: Missing input validation

Fix: Add email validation, use dynamic buffer sizes
```

### Tips for Five Whys

- **Don't Stop Too Early**: "Why?" at the symptom level
  - ❌ "Payment failed" → "Because payment processor returned error"
  - ✅ Continue asking why the processor returned error

- **Go Beyond One Person**: Look at systems, not blame
  - ❌ "Developer didn't test"
  - ✅ "Test environment wasn't set up correctly" or "Testing process is manual and error-prone"

- **Find Preventable Issues**: Look for things that could have been caught
  - ✅ "No code review process for this file"
  - ✅ "No automated tests for this scenario"
  - ✅ "Build process doesn't run linter"

## Execution Tracing

Follow the execution path to understand where things go wrong:

### Manual Stack Trace Analysis

When an error occurs, read the stack trace carefully:

```
Traceback (most recent call last):
  File "app.py", line 42, in process_order
    total = calculate_total(order)
  File "pricing.py", line 15, in calculate_total
    tax = items[0].price * tax_rate
TypeError: unsupported operand type(s) for *: 'NoneType' and 'float'
```

Reading this:
1. **Start at bottom**: Real error is `TypeError` in pricing.py line 15
2. **Work upward**: Called from process_order in app.py line 42
3. **Understand context**: Trying to multiply None by float
4. **Find root cause**: `items[0].price` is None
5. **Investigate**: Why is price None?
   - Is the item initialized correctly?
   - Is the database returning NULL?
   - Is there a type conversion issue?

### Execution Trace Mapping

Create a map of execution flow:

```python
def analyze_execution():
    """
    Trace: User clicks "Checkout"
    │
    ├─→ Frontend validates form ✓
    │   └─→ Sends POST /api/checkout
    │
    ├─→ Backend receives request
    │   ├─→ Request middleware validates token ✓
    │   ├─→ Parse request body ✓
    │   └─→ Call process_order()
    │       ├─→ Validate items ✓
    │       ├─→ Calculate price ✗ FAILS HERE
    │       │   └─→ items[0].price is None
    │       └─→ Save to database
    │
    └─→ Return error to frontend
    """
    pass
```

### Checkpoint Validation

Insert checkpoints to validate assumptions:

```python
def process_payment(order):
    print(f"[CP1] Order received: {order}")
    assert order is not None, "Order cannot be None"
    assert order.items, "Order must have items"

    print(f"[CP2] Order items: {order.items}")
    for item in order.items:
        assert item.price is not None, f"Item {item.id} has None price"
        assert item.price > 0, f"Item {item.id} has invalid price: {item.price}"

    total = sum(item.price * item.quantity for item in order.items)
    print(f"[CP3] Total before tax: {total}")
    assert total > 0, "Total must be positive"

    tax_amount = total * order.tax_rate
    print(f"[CP4] Tax amount: {tax_amount}")

    final_total = total + tax_amount
    print(f"[CP5] Final total: {final_total}")

    result = charge_card(order.card, final_total)
    print(f"[CP6] Charge result: {result}")
    assert result.success, f"Charge failed: {result.error}"

    return result
```

## Assumption Checking

Most bugs come from wrong assumptions. Systematically verify them:

### Common Assumptions to Challenge

**1. "The data is in the expected format"**
```python
# WRONG: Assume data is correct
user = api_response['user']
name = user['name']  # Crashes if user or name doesn't exist

# RIGHT: Validate structure
user = api_response.get('user')
if not user:
    raise ValueError("API response missing 'user' field")
name = user.get('name', 'Unknown')
```

**2. "This function will always complete quickly"**
```python
# WRONG: Assume quick completion
result = fetch_data_from_api()  # Might take 30 seconds
process_result(result)

# RIGHT: Add timeout and handling
try:
    result = fetch_data_from_api(timeout=5)
except TimeoutError:
    log_warning("API timeout, using cached data")
    result = get_cached_data()
```

**3. "The value is never null/undefined"**
```javascript
// WRONG: Assume user always exists
const email = user.profile.email.toLowerCase();

// RIGHT: Check at each level
const email = user?.profile?.email?.toLowerCase() ?? 'no-email@example.com';
```

**4. "The order of operations doesn't matter"**
```python
# WRONG: Assume initialization order is fine
service = MyService()
# But MyService.__init__ depends on config being set
result = service.process()

# RIGHT: Explicit dependency order
config = load_config()
service = MyService(config)
result = service.process()
```

**5. "This only affects this one place"**
```python
# WRONG: Only look at one call site
def add_user(name):
    users.append(name)  # This is used in 5 different places

# RIGHT: Search for all usages
# grep -r "add_user" --include="*.py"
# Check all 5 call sites for correct behavior
```

### Assumption Verification Checklist

Before declaring you found the root cause:

- [ ] Does the fix address the actual observed symptom?
- [ ] Could this same issue occur elsewhere?
- [ ] Are there any assumptions about data types?
- [ ] Are there any assumptions about timing/order?
- [ ] Are there any assumptions about external systems?
- [ ] What happens with edge cases?
- [ ] What happens with invalid input?
- [ ] Have you verified with actual data, not just test data?

## Common Root Causes

Reference table of typical root causes and how to find them:

| Category | Root Cause | Investigation Method | Prevention |
|----------|-----------|----------------------|------------|
| **Type Issues** | Wrong type conversion | Check type: `type(variable)`, use static analysis | Enable strict typing (TypeScript, mypy) |
| | Type mismatch | Check function signatures | Add type hints/annotations |
| | Null/undefined handling | Check null checks | Use optional chaining, nullish coalescing |
| **Logic Errors** | Wrong condition | Trace through logic | Add unit tests for conditions |
| | Off-by-one error | Check array indices, loop bounds | Test boundary cases |
| | Reversed comparison | Check if condition makes sense | Code review checklists |
| **State Management** | Stale state | Check when state updates | Use immutable patterns |
| | Race condition | Add synchronization | Use locks/promises appropriately |
| | Uninitialized variable | Check initialization code | Fail loudly on uninitialized vars |
| **Configuration** | Wrong environment | Check config loading | Use environment detection |
| | Hardcoded values | Search codebase for magic numbers | Use configuration files |
| | Version mismatch | Check dependency versions | Lock dependency versions |
| **Integration** | API contract changed | Check API spec vs code | Use API versioning |
| | Data format mismatch | Check serialization/deserialization | Use schema validation |
| | Timeout too short | Monitor actual latency | Set timeouts based on SLA |
| **Performance** | Memory leak | Profile memory usage | Use weak references, cleanup |
| | N+1 queries | Analyze database queries | Use query analysis tools |
| | Blocking operations | Check for long operations | Use async/await patterns |

### Finding Each Type

**Type Issues**:
```python
# Debug: Print types
print(f"Type of {var}: {type(var)}")

# Test: Create minimal case
assert isinstance(result, expected_type), f"Got {type(result)}"

# Analyze: Use linter
mypy --strict script.py
```

**Logic Errors**:
```python
# Debug: Trace through condition
if value > 10:
    print(f"Value {value} is > 10: BRANCH A")
else:
    print(f"Value {value} is <= 10: BRANCH B")

# Test: Test edge cases
assert function(0) == expected
assert function(10) == expected
assert function(11) == expected
```

**State Issues**:
```python
# Debug: Print state at key points
print(f"State before update: {state}")
update_state(new_value)
print(f"State after update: {state}")

# Analyze: Check synchronization
# Look for: unprotected shared state, race conditions
```

**Configuration Issues**:
```python
# Debug: Print config
import json
print(json.dumps(config, indent=2))

# Verify: Trace config loading
print("Config file locations checked:")
for path in config_search_paths:
    if os.path.exists(path):
        print(f"  ✓ Found: {path}")
    else:
        print(f"  ✗ Not found: {path}")
```

**Integration Issues**:
```python
# Debug: Log request/response
print(f"Request: {request}")
response = call_external_service(request)
print(f"Response: {response}")

# Test: Mock external service
from unittest.mock import patch
with patch('external_service') as mock:
    mock.return_value = expected_response
    result = function_using_service()
```

**Performance Issues**:
```python
# Profile: Measure time
import time
start = time.time()
function_to_profile()
print(f"Duration: {time.time() - start}s")

# Analyze: Check database queries
# Enable query logging in your ORM
# Analyze for N+1 patterns
```
