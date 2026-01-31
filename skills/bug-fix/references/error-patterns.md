# Error Patterns Reference Guide

## Table of Contents
1. [Null Pointer / Undefined Reference Errors](#null-pointer--undefined-reference-errors)
2. [Type Errors](#type-errors)
3. [Async and Race Condition Errors](#async-and-race-condition-errors)
4. [Integration Errors](#integration-errors)
5. [Configuration Errors](#configuration-errors)
6. [Performance Errors](#performance-errors)
7. [Data/Logic Errors](#datalogic-errors)

## Null Pointer / Undefined Reference Errors

### Pattern: NullPointerException / TypeError: Cannot read property of undefined

**Common Messages**:
- Python: `AttributeError: 'NoneType' object has no attribute 'X'`
- JavaScript: `TypeError: Cannot read property 'X' of undefined`
- Java: `NullPointerException at line 42`
- C#: `NullReferenceException: Object reference not set to an instance of an object`

**Typical Causes**:
1. Variable initialized to null/undefined
2. Function returns null unexpectedly
3. Missing null check before accessing property
4. API response changed structure
5. Condition doesn't properly guard access
6. Object not created yet

**Finding the Bug**:
```python
# WRONG - No null check
user = get_user(user_id)
print(user.email)  # Crashes if user is None

# RIGHT - Add null checks
user = get_user(user_id)
if user is None:
    logger.warning(f"User {user_id} not found")
    return None

email = user.email if user else "no-email@example.com"
```

**Investigation Steps**:
1. Find the crash line in the traceback
2. Identify which object is null
3. Ask: Why would this be null?
   - Was it initialized?
   - Did the function creating it fail?
   - Is there a logic error in conditions?
4. Add null checks at the source, not just where it crashes

**Prevention**:
```typescript
// Use optional chaining (?.operator)
const email = user?.profile?.contact?.email;

// Use nullish coalescing for defaults (?? operator)
const name = user?.name ?? 'Anonymous';

// Use proper initialization
const items = [] as Item[];  // Never undefined

// Use strict null checking
// In tsconfig.json: "strictNullChecks": true
```

**Test Case**:
```python
def test_get_user_not_found():
    """Bug: Crashes when user doesn't exist"""
    user = get_user(user_id=99999)  # User doesn't exist

    # Should handle gracefully, not crash
    assert user is None

    # Or return safe default
    result = get_user_with_default(user_id=99999)
    assert result.email == "no-email@example.com"
```

## Type Errors

### Pattern: TypeError / Type Mismatch

**Common Messages**:
- `TypeError: unsupported operand type(s) for +: 'str' and 'int'`
- `TypeError: 'int' object is not iterable`
- `ValueError: invalid literal for int() with base 10: 'abc'`

**Typical Causes**:
1. Passing wrong type to function
2. Type conversion failed
3. API returns different type than expected
4. String instead of number (or vice versa)
5. Forgot to convert type
6. User input not validated

**Finding the Bug**:
```python
# WRONG - Assuming type
total = "10" + "20"  # Returns "1020", not 30
print(f"Total: ${total}")  # Prints: Total: $1020

# RIGHT - Convert types
total = int("10") + int("20")
print(f"Total: ${total}")  # Prints: Total: $30

# DEFENSIVE - Handle conversion errors
try:
    count = int(user_input)
except ValueError:
    logger.error(f"Invalid number: {user_input}")
    count = 0
```

**Investigation Steps**:
1. Look at the operation that failed
2. Check what types are involved
3. Print types: `print(f"Type: {type(x)}, Value: {x}")`
4. Trace back where each variable comes from
5. Find the conversion point that was missed

**Prevention**:
```typescript
// Use strict typing
function add(a: number, b: number): number {
  return a + b;
}

// Catch at compile time, not runtime
// This would fail TypeScript compilation:
const result = add("10", "20");  // ✗ Error

// Use type guards
function processValue(val: string | number): string {
  if (typeof val === "string") {
    return val.toUpperCase();
  }
  return val.toString();
}
```

**Test Case**:
```python
def test_add_numbers_with_string_input():
    """Bug: Crashes with string input instead of number"""
    # This should either convert or raise clear error
    try:
        result = add_numbers("10", 5)
        assert False, "Should have raised ValueError"
    except ValueError as e:
        assert "Expected number" in str(e)

def test_calculate_percentage():
    """Bug: Returns string concatenation instead of calculation"""
    result = calculate_percentage("10", "50")  # Strings instead of numbers
    assert result == 20.0  # Should be 20%, not "1050"
```

## Async and Race Condition Errors

### Pattern: Race Conditions / Timing Issues

**Common Messages**:
- Intermittent failures (happens sometimes, not always)
- "Flaky" tests that sometimes pass, sometimes fail
- Deadlock or timeout errors
- Undefined/wrong order of events
- Data corruption or unexpected state

**Typical Causes**:
1. Multiple threads/tasks accessing shared state
2. Not awaiting promises/async operations
3. Event listeners triggered in unexpected order
4. Missing locks/synchronization
5. Cleanup not waiting for completion
6. Order-dependent code executed out of order

**Finding the Bug**:
```javascript
// WRONG - Race condition
function loadUserData() {
  let user;

  // These run concurrently
  fetchUser().then(data => user = data);
  fetchUserSettings().then(data =>
    console.log(user.settings = data)  // user might still be undefined!
  );
}

// RIGHT - Wait for both to complete
async function loadUserData() {
  const [user, settings] = await Promise.all([
    fetchUser(),
    fetchUserSettings()
  ]);

  console.log(`User: ${user.name}, Settings: ${settings}`);
}
```

**Investigation Steps**:
1. Add timestamps and thread/task IDs to logs
2. Run code many times to trigger race condition
3. Use tools to detect race conditions
4. Review async/await chains
5. Look for shared state modifications
6. Check for missing synchronization

**Prevention**:
```python
import asyncio
import threading

# Use asyncio for async safety
async def fetch_data():
    result1 = await get_data(url1)  # Wait before proceeding
    result2 = await get_data(url2)
    return combine(result1, result2)

# Use locks for thread safety
lock = threading.Lock()
shared_data = {}

def update_shared_data(key, value):
    with lock:  # Acquire lock before modifying
        shared_data[key] = value

# Use event loops properly
async def main():
    tasks = [
        fetch_data(id1),
        fetch_data(id2),
        fetch_data(id3)
    ]
    results = await asyncio.gather(*tasks)  # Wait for all
```

**Test Case**:
```python
def test_concurrent_updates():
    """Bug: Race condition when multiple threads update counter"""
    counter = {"value": 0}

    def increment():
        for _ in range(1000):
            counter["value"] += 1

    # Run threads concurrently
    import threading
    threads = [threading.Thread(target=increment) for _ in range(10)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

    # Should be 10,000 but race condition causes fewer
    assert counter["value"] == 10000, f"Expected 10000, got {counter['value']}"
```

## Integration Errors

### Pattern: External Service Failures

**Common Messages**:
- `ConnectionError: Failed to establish connection`
- `HTTPError: 500 Internal Server Error`
- `TimeoutError: Request timed out after 30s`
- `JSONDecodeError: Invalid JSON response`

**Typical Causes**:
1. External service is down
2. Wrong API endpoint
3. Authentication failed
4. Network connectivity issue
5. API response format changed
6. Rate limit exceeded
7. Data format mismatch

**Finding the Bug**:
```python
# WRONG - No error handling
response = requests.get(api_url)
data = response.json()  # Crashes if response is error

# RIGHT - Handle errors
try:
    response = requests.get(api_url, timeout=5)
    response.raise_for_status()  # Raise on HTTP error
    data = response.json()
except requests.exceptions.Timeout:
    logger.error(f"API timeout: {api_url}")
    data = get_cached_data()
except requests.exceptions.HTTPError as e:
    logger.error(f"API returned {e.response.status_code}: {e}")
    raise
except requests.exceptions.RequestException as e:
    logger.error(f"Request failed: {e}")
    raise
except json.JSONDecodeError:
    logger.error(f"Invalid JSON: {response.text}")
    raise
```

**Investigation Steps**:
1. Check if external service is accessible
2. Test the API endpoint manually (curl, Postman)
3. Verify authentication credentials
4. Check request format matches API spec
5. Inspect actual response (not assumed)
6. Verify response parsing matches actual format
7. Check rate limits and quotas

**Prevention**:
```python
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

def create_resilient_client():
    """Create HTTP client with retries and timeouts"""
    session = requests.Session()

    # Retry on network errors
    retries = Retry(
        total=3,
        backoff_factor=1,
        status_forcelist=[500, 502, 503, 504]
    )
    adapter = HTTPAdapter(max_retries=retries)
    session.mount('http://', adapter)
    session.mount('https://', adapter)

    return session

# Use with proper error handling
client = create_resilient_client()
try:
    response = client.get(url, timeout=10)
    response.raise_for_status()
except requests.RequestException as e:
    # Log and use fallback
    logger.error(f"API call failed: {e}")
    return get_fallback_data()
```

**Test Case**:
```python
def test_api_call_with_server_error(mocker):
    """Bug: Crashes on 500 error instead of handling gracefully"""
    # Mock API to return error
    mock_response = mocker.Mock()
    mock_response.status_code = 500
    mock_response.raise_for_status.side_effect = requests.HTTPError("500 Error")

    mocker.patch('requests.get', return_value=mock_response)

    # Should handle error, not crash
    result = fetch_data_from_api()
    assert result is not None  # Uses fallback
```

## Configuration Errors

### Pattern: Config Not Loaded / Wrong Values

**Common Messages**:
- Feature works in dev but not prod
- "Configuration not found" errors
- Connection strings for wrong database
- API keys are invalid/missing
- Features disabled unexpectedly

**Typical Causes**:
1. Environment variables not set
2. Config file in wrong location
3. Config loaded before initialization
4. Hardcoded values overriding config
5. Wrong environment being used
6. Config not reloaded after changes

**Finding the Bug**:
```python
# WRONG - Hardcoded values
DATABASE_URL = "postgresql://localhost/dev_db"

# WRONG - Loaded at import time, before env vars set
config = load_config()
app = Flask(__name__)

# RIGHT - Load from environment
import os
DATABASE_URL = os.getenv(
    'DATABASE_URL',
    'postgresql://localhost/dev_db'  # Fallback only for local dev
)

# RIGHT - Load config after initialization
def create_app():
    app = Flask(__name__)
    app.config.from_object(os.getenv('CONFIG_OBJECT', 'config.DevelopmentConfig'))
    return app
```

**Investigation Steps**:
1. Print all config values at startup
2. Check which config files are loaded
3. Verify environment variables are set
4. Check for hardcoded values
5. Verify config file permissions (if file-based)
6. Compare dev vs prod configs

**Prevention**:
```python
import os
from dataclasses import dataclass
from typing import Optional

@dataclass
class Config:
    """Configuration with validation"""
    debug: bool = False
    database_url: str = ""
    api_key: str = ""
    api_timeout: int = 30

    def validate(self) -> None:
        """Validate required settings"""
        if not self.database_url:
            raise ValueError("DATABASE_URL is required")
        if not self.api_key and not self.debug:
            raise ValueError("API_KEY is required for production")

def load_config() -> Config:
    """Load config from environment"""
    config = Config(
        debug=os.getenv("DEBUG", "false").lower() == "true",
        database_url=os.getenv("DATABASE_URL"),
        api_key=os.getenv("API_KEY", ""),
        api_timeout=int(os.getenv("API_TIMEOUT", 30))
    )

    config.validate()  # Fail fast if config invalid

    logger.info(f"Loaded config: debug={config.debug}, db={config.database_url[:20]}...")

    return config
```

**Test Case**:
```python
def test_missing_required_config(monkeypatch):
    """Bug: App starts with missing required configuration"""
    # Clear required env var
    monkeypatch.delenv('DATABASE_URL', raising=False)

    # Should fail on startup, not at first query
    with pytest.raises(ValueError) as exc_info:
        load_config()

    assert "DATABASE_URL" in str(exc_info.value)
```

## Performance Errors

### Pattern: Slow Performance / Timeouts

**Common Messages**:
- "Timeout waiting for response"
- "Request took 60 seconds"
- "Out of memory"
- "CPU at 100%"
- Performance degradation over time

**Typical Causes**:
1. N+1 query problem
2. Memory leak
3. Inefficient algorithm (O(n²) instead of O(n))
4. Missing indexes in database
5. Blocking operations on main thread
6. Large data transfers
7. Infinite loops
8. Resource not released

**Finding the Bug**:
```python
# WRONG - N+1 query problem
users = get_all_users()  # 1 query
for user in users:  # For each user
    orders = get_user_orders(user.id)  # 1 query per user = N queries
    print(f"{user.name}: {len(orders)} orders")

# RIGHT - Load all data at once
users = get_all_users_with_orders()  # 1 query with JOIN
for user in users:
    print(f"{user.name}: {len(user.orders)} orders")
```

**Investigation Steps**:
1. Profile execution time: `time python script.py`
2. Use profiler to find slow functions
3. Check database query count
4. Monitor memory usage
5. Check for infinite loops
6. Look for blocking operations
7. Test with larger datasets

**Prevention**:
```python
import time
from functools import wraps

def profile_function(func):
    """Decorator to profile function execution"""
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        duration = time.time() - start

        if duration > 1:  # Log slow functions
            logger.warning(f"{func.__name__} took {duration:.2f}s")

        return result

    return wrapper

@profile_function
def potentially_slow_function():
    # Query analysis
    # Database query logging
    pass

# Use async for I/O operations
async def fetch_many_urls(urls):
    """Fetch multiple URLs concurrently"""
    import aiohttp
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
        return results
```

**Test Case**:
```python
def test_performance_large_dataset():
    """Bug: Performance degrades with large dataset"""
    large_data = list(range(100000))

    start = time.time()
    result = process_data(large_data)
    duration = time.time() - start

    # Should complete in reasonable time
    assert duration < 5, f"Processing took {duration}s, expected < 5s"
```

## Data/Logic Errors

### Pattern: Wrong Results

**Common Messages**:
- Calculation produces wrong number
- Data sorted incorrectly
- Filtering returns wrong items
- Boolean condition inverted
- State is corrupted

**Typical Causes**:
1. Off-by-one error
2. Wrong comparison operator
3. Logic inverted
4. Wrong variable used
5. Operator precedence issue
6. Integer division vs float division
7. Mutation of data
8. Incorrect assumptions

**Finding the Bug**:
```python
# WRONG - Off by one
items = [1, 2, 3, 4, 5]
for i in range(len(items)):  # i goes 0-4
    if i < len(items) - 1:  # Skips last element!
        process(items[i])

# RIGHT - Use proper iteration
for item in items:
    process(item)

# WRONG - Inverted logic
if not user_is_admin:
    grant_admin_access()  # Grants to non-admins!

# RIGHT - Check logic carefully
if user_is_admin:
    grant_admin_access()
```

**Investigation Steps**:
1. Test with specific known values
2. Trace through logic step by step
3. Check boundary cases (0, 1, negative, max)
4. Verify assumptions are correct
5. Print intermediate values
6. Test with actual data, not just test data

**Prevention**:
```python
def calculate_discount(quantity: int, price: float) -> float:
    """Calculate discounted price"""
    # Make assumptions explicit
    assert quantity > 0, "Quantity must be positive"
    assert price > 0, "Price must be positive"

    # Use named calculations instead of complex expressions
    if quantity >= 100:
        discount_rate = 0.20  # 20% for bulk orders
    elif quantity >= 50:
        discount_rate = 0.10  # 10% for medium orders
    else:
        discount_rate = 0.0

    discount_amount = price * quantity * discount_rate
    total_price = (price * quantity) - discount_amount

    # Verify result makes sense
    assert total_price > 0, "Total price should be positive"
    assert total_price <= price * quantity, "Discounted price should be less than original"

    return total_price
```

**Test Case**:
```python
def test_calculate_discount():
    """Bug: Discount calculation wrong or inverted"""
    # Test boundary cases
    assert calculate_discount(quantity=1, price=100) == 100  # No discount
    assert calculate_discount(quantity=50, price=100) == 4500  # 10% discount
    assert calculate_discount(quantity=100, price=100) == 8000  # 20% discount

    # Verify discount never increases total
    original = 50 * 100
    discounted = calculate_discount(50, 100)
    assert discounted <= original, f"Discount increased total! {original} -> {discounted}"
```
