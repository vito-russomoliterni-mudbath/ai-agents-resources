# Testing Strategies for Bug Fixes

## Table of Contents
1. [When to Add Unit Tests](#when-to-add-unit-tests)
2. [Regression Test Patterns](#regression-test-patterns)
3. [Test Frameworks Overview](#test-frameworks-overview)
4. [Effective Test Design](#effective-test-design)
5. [Common Test Scenarios](#common-test-scenarios)

## When to Add Unit Tests

### Always Add Tests For:

**1. Fixed Bugs - Critical**
- Create a test that reproduces the bug
- Verify the fix resolves it
- Prevents regression

```python
def test_issue_1234_calculate_total_with_decimal():
    """
    Regression test for Issue #1234
    Bug: calculate_total() rounds down for decimal quantities
    Expected: 3.5 items at $10 = $35.00
    Was: $30.00 (rounded down to 3)
    """
    result = calculate_total(
        quantity=3.5,
        unit_price=10.00,
        quantity_unit="items"
    )

    assert result == 35.00, f"Expected 35.00, got {result}"
```

**2. Boundary Conditions**
- Edge cases that might break again
- Off-by-one errors
- Empty collections
- Null/None values

```python
def test_process_items_edge_cases():
    """Test boundary conditions to prevent regressions"""
    # Empty list
    assert process_items([]) == []

    # Single item
    assert process_items([1]) == [1]

    # Large numbers
    assert process_items([999999, 1000000, 1000001]) == [999999, 1000000, 1000001]

    # Negative numbers (if applicable)
    assert process_items([-5, 0, 5]) == [-5, 0, 5]
```

**3. Error Handling**
- Verify proper exceptions are raised
- Check error messages are helpful
- Validate graceful degradation

```python
def test_connect_to_database_error_handling():
    """Test that connection errors are handled properly"""
    with pytest.raises(ConnectionError) as exc_info:
        connect_to_database(host="nonexistent-host")

    assert "Failed to connect" in str(exc_info.value)
    assert "nonexistent-host" in str(exc_info.value)
```

**4. Complex Logic**
- Multi-step processes
- Conditional branches
- State transitions

```python
def test_payment_processing_workflow():
    """Test complex payment workflow"""
    # Valid payment
    result = process_payment(amount=100, card=valid_card)
    assert result.success is True
    assert result.transaction_id is not None

    # Declined payment
    result = process_payment(amount=100, card=declined_card)
    assert result.success is False
    assert "declined" in result.error.lower()

    # Fraud check
    result = process_payment(amount=100000, card=card)
    assert result.success is False
    assert "unusual activity" in result.error.lower()
```

### Consider Tests For:

**1. Performance Fixes**
- Verify the fix improves performance
- Check it doesn't regress

```python
def test_search_performance_improvement():
    """Verify search performance with new index"""
    large_dataset = create_test_data(10000)

    start = time.time()
    results = search(large_dataset, "query")
    duration = time.time() - start

    # After optimization, should be fast
    assert duration < 0.1, f"Search took {duration}s, expected < 0.1s"
```

**2. Security Fixes**
- Verify vulnerability is closed
- Check for bypass possibilities

```python
def test_sql_injection_prevented():
    """Verify SQL injection vulnerability is fixed"""
    malicious_input = "'; DROP TABLE users; --"

    # Should be safely escaped
    result = query_users(name=malicious_input)

    # Should find nothing, not crash or delete data
    assert result == []
```

**3. Integration Issues**
- Verify components work together
- Check data flow between systems

```python
def test_api_to_database_integration():
    """Verify data flows correctly from API to database"""
    # Send request to API
    response = client.post("/api/users", json={
        "name": "John",
        "email": "john@example.com"
    })

    assert response.status_code == 201

    # Verify data in database
    user = get_user_from_db("john@example.com")
    assert user.name == "John"
    assert user.email == "john@example.com"
```

### Skip Tests Only If:

- Unit test would require mocking entire system
- Test would be slower than it's worth
- Bug fix is in documentation only
- Issue is environmental (hardware-specific)

## Regression Test Patterns

### Pattern 1: Bug Reproduction Test

Most direct pattern - test reproduces the exact bug:

```python
def test_payment_rounding_bug():
    """
    Issue: #456 Payment calculation rounds incorrectly
    Steps: Calculate total for 3 items at $10.33 each
    Expected: $30.99
    Actual: $31 (rounded up incorrectly)
    """
    items = [
        {"price": 10.33, "quantity": 3}
    ]

    total = calculate_total(items)

    assert total == 30.99
```

### Pattern 2: Before/After Test

Compare behavior before and after fix:

```python
def test_user_search_case_sensitivity_fix():
    """
    Before: search("John") only found exact case "John", not "john"
    After: search("John") finds all variations: John, john, JOHN
    """
    create_test_users([
        User(name="John Doe"),
        User(name="john smith"),
        User(name="JOHN Jones")
    ])

    # Should find all three
    results = search_users("John")

    assert len(results) == 3
    names = [u.name for u in results]
    assert "John Doe" in names
    assert "john smith" in names
    assert "JOHN Jones" in names
```

### Pattern 3: Input Variation Test

Test fix works across different inputs:

```python
def test_email_validation_fix():
    """
    Bug: Accepted invalid emails
    Fix: Validate email format correctly
    """
    valid_emails = [
        "user@example.com",
        "user.name@example.com",
        "user+tag@example.co.uk",
        "123@example.com"
    ]

    invalid_emails = [
        "user@",
        "@example.com",
        "user@.com",
        "user example@com",
        "user@exam ple.com"
    ]

    for email in valid_emails:
        assert is_valid_email(email), f"{email} should be valid"

    for email in invalid_emails:
        assert not is_valid_email(email), f"{email} should be invalid"
```

### Pattern 4: State Transition Test

Verify fix works across state changes:

```python
def test_order_status_transition_fix():
    """
    Bug: Order couldn't transition from PROCESSING to COMPLETED
    Fix: Added missing state transition rule
    """
    order = create_test_order(status=OrderStatus.PROCESSING)

    # Should be able to mark as completed
    order.mark_completed()

    assert order.status == OrderStatus.COMPLETED
    assert order.completed_at is not None

    # Should not be able to go backward
    with pytest.raises(InvalidStateTransition):
        order.mark_processing()
```

### Pattern 5: Data Integrity Test

Verify fix doesn't corrupt data:

```python
def test_bulk_update_data_integrity():
    """
    Bug: Bulk update corrupted data for some records
    Fix: Fixed transaction handling in bulk operation
    """
    original_users = create_test_users(100)

    # Perform bulk update
    bulk_update_user_status(user_ids=[u.id for u in original_users], status="active")

    # Verify all updated correctly
    for original in original_users:
        updated = get_user(original.id)
        assert updated.status == "active"
        # Other fields unchanged
        assert updated.name == original.name
        assert updated.email == original.email
```

## Test Frameworks Overview

### Python: pytest

**Setup**:
```bash
pip install pytest pytest-cov pytest-mock
```

**Basic Test**:
```python
import pytest

def test_add_numbers():
    """Test addition"""
    assert add(2, 3) == 5
```

**Fixtures** (setup/teardown):
```python
@pytest.fixture
def test_db():
    """Set up test database"""
    db = create_test_database()
    yield db
    db.cleanup()

def test_with_database(test_db):
    """Test that uses fixture"""
    result = test_db.query("SELECT * FROM users")
    assert result is not None
```

**Mocking**:
```python
def test_with_mock(mocker):
    """Test with mocked external service"""
    mock = mocker.patch('external_service.call')
    mock.return_value = {"status": "success"}

    result = my_function()

    assert result.status == "success"
    mock.assert_called_once()
```

**Run tests**:
```bash
pytest                          # Run all tests
pytest -v                       # Verbose output
pytest tests/test_file.py       # Run specific file
pytest -k test_name             # Run by name pattern
pytest --cov                    # Show coverage
```

### JavaScript/TypeScript: Jest or Vitest

**Setup with Jest**:
```bash
npm install --save-dev jest @testing-library/react
```

**Basic Test**:
```typescript
describe("Calculator", () => {
  test("adds two numbers", () => {
    expect(add(2, 3)).toBe(5);
  });
});
```

**Mocking**:
```typescript
jest.mock("axios");

test("fetches user data", async () => {
  const mockAxios = axios as jest.Mocked<typeof axios>;
  mockAxios.get.mockResolvedValue({ data: { name: "John" } });

  const data = await fetchUser(1);

  expect(data.name).toBe("John");
});
```

**Async Tests**:
```typescript
test("async operation", async () => {
  const result = await asyncFunction();
  expect(result).toBe("expected value");
});
```

**Run tests**:
```bash
npm test                        # Run all tests
npm test -- --watch             # Watch mode
npm test -- --coverage          # Show coverage
npm test test_file              # Run specific file
```

## Effective Test Design

### Principle 1: Test Should Be Fast

```python
# SLOW - Talks to real database
def test_user_creation_slow():
    user = create_user_in_database("john@example.com")
    assert user.email == "john@example.com"

# FAST - Uses in-memory mock
def test_user_creation_fast(mocker):
    mock_db = mocker.Mock()
    user = User("john@example.com")
    assert user.email == "john@example.com"
```

### Principle 2: One Assertion Per Test (Generally)

```python
# WRONG - Tests multiple things
def test_user_everything():
    user = create_user("john", "john@example.com")
    assert user.name == "john"
    assert user.email == "john@example.com"
    assert user.created_at is not None
    assert user.is_active is True

# RIGHT - Each test focuses on one thing
def test_user_name_is_set():
    user = create_user("john", "john@example.com")
    assert user.name == "john"

def test_user_email_is_set():
    user = create_user("john", "john@example.com")
    assert user.email == "john@example.com"

def test_user_created_with_timestamp():
    user = create_user("john", "john@example.com")
    assert user.created_at is not None
```

### Principle 3: Clear Naming

```python
# WRONG - Unclear what's being tested
def test_1():
    x = process(data)
    assert x is not None

# RIGHT - Name describes what's being tested
def test_process_returns_result_when_data_valid():
    result = process_user_data(valid_user_data)
    assert result is not None

def test_process_raises_error_when_data_missing_required_fields():
    with pytest.raises(ValidationError):
        process_user_data(data_missing_email)
```

### Principle 4: Use Test Helpers

```python
# WRONG - Repeated setup
def test_payment_1():
    customer = Customer("john@example.com")
    payment = Payment(customer=customer, amount=100)
    assert payment.is_valid()

def test_payment_2():
    customer = Customer("jane@example.com")
    payment = Payment(customer=customer, amount=50)
    assert payment.is_valid()

# RIGHT - Use helper
def create_test_payment(amount=100):
    customer = Customer("test@example.com")
    return Payment(customer=customer, amount=amount)

def test_payment_valid():
    payment = create_test_payment(100)
    assert payment.is_valid()

def test_payment_with_different_amount():
    payment = create_test_payment(50)
    assert payment.is_valid()
```

## Common Test Scenarios

### Scenario 1: Testing Exception Handling

```python
def test_invalid_input_raises_error():
    """Verify proper error raised with invalid input"""
    with pytest.raises(ValueError) as exc_info:
        process_data(None)

    assert "data cannot be None" in str(exc_info.value)

def test_multiple_error_types():
    """Test different error conditions"""
    with pytest.raises(ValueError):
        process_data(None)

    with pytest.raises(TypeError):
        process_data("not a dict")

    with pytest.raises(KeyError):
        process_data({})  # Missing required keys
```

### Scenario 2: Testing with Different Data Types

```python
@pytest.mark.parametrize("value,expected", [
    (0, False),
    (1, True),
    (-1, True),
    (100, True),
    ("0", True),  # Non-empty string
])
def test_is_truthy(value, expected):
    """Test function with various inputs"""
    assert is_truthy(value) == expected
```

### Scenario 3: Testing Async Code

```python
@pytest.mark.asyncio
async def test_async_fetch_data():
    """Test async function"""
    result = await fetch_data_async()
    assert result is not None

@pytest.mark.asyncio
async def test_async_with_timeout():
    """Test that async operation completes in time"""
    with pytest.raises(asyncio.TimeoutError):
        await asyncio.wait_for(slow_operation(), timeout=1)
```

### Scenario 4: Testing Side Effects

```python
def test_function_calls_handler(mocker):
    """Verify function calls expected handler"""
    mock_handler = mocker.Mock()

    process_event(event, handler=mock_handler)

    # Verify handler was called with correct args
    mock_handler.assert_called_once_with(event)

def test_file_is_created():
    """Verify function creates expected file"""
    output_file = "test_output.txt"

    generate_report(output_file=output_file)

    assert os.path.exists(output_file)

    # Cleanup
    os.remove(output_file)
```

### Scenario 5: Testing Database Operations

```python
def test_user_saved_to_database(test_db):
    """Test that user is properly saved"""
    user = User(name="John", email="john@example.com")

    test_db.save(user)

    saved = test_db.query(User).filter(User.email == "john@example.com").first()
    assert saved.name == "John"

def test_transaction_rolled_back_on_error(test_db):
    """Test that changes are rolled back on error"""
    user1 = User(name="John")
    test_db.save(user1)

    try:
        user2 = User(name="Jane")
        test_db.save(user2)
        raise Exception("Simulated error")
    except Exception:
        test_db.rollback()

    # user2 should not be saved
    assert test_db.query(User).filter(User.name == "Jane").first() is None
```
