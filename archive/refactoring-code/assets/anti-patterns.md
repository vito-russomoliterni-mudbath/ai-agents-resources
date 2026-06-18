# Anti-Patterns: What NOT to Do in Refactoring

Things that look like refactoring but break code, change behavior, or make things worse.

## Anti-Pattern 1: Optimizing While Refactoring

**Problem**: Mixing performance optimization with refactoring.

**Example**:
```python
# Original
def find_user_by_email(email):
    for user in all_users:
        if user.email == email:
            return user
    return None

# WRONG: "Refactoring" that optimizes
def find_user_by_email(email):
    return user_email_cache.get(email)  # Added caching - now behavior changed!
```

**Why It's Bad**:
- Added a dependency (cache) that didn't exist
- If cache isn't invalidated, returns stale data
- Tests might not catch this if not careful
- Refactoring + optimization in one = hard to review

**How to Do It Right**:
```python
# Step 1: Refactor (no optimization)
def find_user_by_email(email):
    matching_users = [u for u in all_users if u.email == email]
    return matching_users[0] if matching_users else None

# Tests pass, behavior unchanged

# Step 2: In separate commit, optimize
def find_user_by_email(email):
    if email in user_email_cache:
        return user_email_cache[email]
    # Find and cache
    user = next((u for u in all_users if u.email == email), None)
    if user:
        user_email_cache[email] = user
    return user
```

## Anti-Pattern 2: Changing API While Refactoring

**Problem**: Changing method signatures as part of refactoring.

**Example**:
```python
# Original
def calculate_total(items):
    return sum(item.price for item in items)

# WRONG: Changed signature without checking all callers
def calculate_total(items, apply_discount=True):  # New parameter!
    total = sum(item.price for item in items)
    if apply_discount:
        total *= 0.9
    return total
```

**Why It's Bad**:
- Breaks all existing callers
- Introduces feature (discount) during refactoring
- Inconsistent behavior if callers forget parameter
- This is a feature addition, not refactoring

**How to Do It Right**:
```python
# Refactoring: Keep same signature
def calculate_total(items):
    return sum(calculate_item_total(item) for item in items)

def calculate_item_total(item):
    return item.price

# Later: Feature work (separate PR)
def calculate_total_with_discount(items, discount_percent):
    total = calculate_total(items)
    return total * (1 - discount_percent / 100)
```

## Anti-Pattern 3: Premature Abstraction

**Problem**: Creating abstractions "for flexibility" when not needed.

**Example**:
```python
# Original: Clear and concrete
class PricingService:
    def calculate_price(self, quantity, unit_price):
        return quantity * unit_price

# WRONG: Abstracted too much
class PricingCalculator:
    def __init__(self, strategy_factory):
        self.strategy_factory = strategy_factory

class PricingStrategy:
    def calculate(self, data):
        pass

class StandardPricingStrategy(PricingStrategy):
    def calculate(self, data):
        return data["quantity"] * data["unit_price"]
```

**Why It's Bad**:
- Added 3x the code for same functionality
- Harder to trace through the logic
- Strategy pattern not needed (only one strategy)
- Future developers confused about why this complexity
- Violates YAGNI (You Aren't Gonna Need It)

**When It's Right**:
```python
# Only if you have MULTIPLE strategies
class StandardPricingStrategy(PricingStrategy):
    def calculate(self, quantity, unit_price):
        return quantity * unit_price

class BulkPricingStrategy(PricingStrategy):
    def calculate(self, quantity, unit_price):
        if quantity > 1000:
            return quantity * unit_price * 0.8
        return quantity * unit_price
```

## Anti-Pattern 4: Breaking Tests to Fix Tests

**Problem**: Modifying tests instead of fixing the code they expose.

**Example**:
```python
# Original test
def test_calculate_discount():
    assert calculate_discount(100, 10) == 90

# WRONG: Changed refactored code, broke test, so changed test
def test_calculate_discount():
    assert calculate_discount(100, 10) == 91  # Changed assertion to match wrong code!
```

**Why It's Bad**:
- Tests are your safety net
- Changing tests defeats the purpose
- Code now has a bug you're hiding
- Next developer won't know the right behavior

**How to Do It Right**:
```python
# If test fails after refactoring:
# 1. Understand why it failed
# 2. Fix the refactored code, not the test
# 3. Verify test passes with original behavior

def test_calculate_discount():
    assert calculate_discount(100, 10) == 90

# Fixed implementation:
def calculate_discount(original_price, discount_percent):
    return original_price * (1 - discount_percent / 100)  # Corrected
```

## Anti-Pattern 5: Over-Extracting

**Problem**: Extracting methods too aggressively, creating trivial methods.

**Example**:
```python
# WRONG: Over-extracted
def process_order(order):
    order_data = format_order_data(order)
    message = create_message(order_data)
    send_message(message)

def format_order_data(order):
    return {"id": order.id, "total": order.total}

def create_message(order_data):
    return f"Order {order_data['id']} for {order_data['total']}"

def send_message(message):
    print(message)
```

**Why It's Bad**:
- Trivial methods don't improve understanding
- More indirection, harder to follow
- One-line methods that are just wrappers
- Worse readability than before

**How to Do It Right**:
```python
# Fewer, more meaningful extractions
def process_order(order):
    message = format_order_confirmation(order)
    email_service.send(message)

def format_order_confirmation(order):
    return f"Order {order.id} for {order.total}"
```

## Anti-Pattern 6: Incomplete Refactoring

**Problem**: Leaving duplicated code or half-refactored code.

**Example**:
```python
# WRONG: Some places updated, some not
class UserService:
    def get_user_name(self):
        return self.user.first_name + " " + self.user.last_name

class AdminService:
    def get_user_name(self):
        return self.user.first_name + " " + self.user.last_name  # Same, but not refactored!

class ReportService:
    def get_user_name(self):
        return format_full_name(self.user)  # Different approach!
```

**Why It's Bad**:
- Inconsistent code
- When you need to fix one, you miss the others
- Confusing for developers
- Defeats purpose of removing duplication

**How to Do It Right**:
```python
# Refactor ALL instances
def format_full_name(user):
    return f"{user.first_name} {user.last_name}"

class UserService:
    def get_user_name(self):
        return format_full_name(self.user)

class AdminService:
    def get_user_name(self):
        return format_full_name(self.user)

class ReportService:
    def get_user_name(self):
        return format_full_name(self.user)
```

## Anti-Pattern 7: Refactoring Untested Code

**Problem**: Refactoring code without tests to fall back on.

**Example**:
```python
# WRONG: No tests, just refactoring
def complex_calculation(data):
    # Complex logic with no tests
    # Try to improve...
    # Now it's broken and no tests to tell you!
```

**Why It's Bad**:
- No safety net
- Easy to introduce bugs silently
- Can't confidently verify behavior unchanged

**How to Do It Right**:
```python
# Step 1: Add tests for current behavior
def test_complex_calculation():
    result = complex_calculation(test_data)
    assert result == expected_output

# Step 2: Now refactor safely
def complex_calculation(data):
    # Refactored with confidence tests will catch issues
```

## Anti-Pattern 8: Massive Refactoring PRs

**Problem**: Trying to refactor too much at once.

**Example**:
```
PR: "Refactor entire UserService"
Files changed: 47
Lines changed: 2300
Commits: 1 (giant commit)
```

**Why It's Bad**:
- Impossible to review properly
- Hard to identify which change broke something
- Easy to introduce bugs in volume
- Rebasing nightmare if conflicts
- Team loses confidence

**How to Do It Right**:
```
PR 1: Extract UserValidator class
PR 2: Extract UserRepository class
PR 3: Extract UserNotifier class
PR 4: Remove original mixed methods

Each PR:
- < 400 lines changed
- Clear single purpose
- Easy to review
- Easy to bisect if issue found
```

## Anti-Pattern 9: Changing Logic Subtly

**Problem**: Small logic changes that seem innocent but alter behavior.

**Example**:
```python
# Original
def get_discount_rate(customer):
    if customer.is_vip:
        return 0.20
    elif customer.is_loyal:
        return 0.10
    else:
        return 0

# WRONG: Seems like refactoring but changes behavior
def get_discount_rate(customer):
    rates = {
        "vip": 0.20,
        "loyal": 0.10,
    }

    # Changed logic: returns 0 for missing keys
    # BUT now treats unknown customer types same as non-loyal
    return rates.get(customer.type, 0)  # Different from elif chain!
```

**Why It's Bad**:
- Original: checks is_vip first, then is_loyal (might be both)
- Refactored: uses customer.type (different attribute!)
- Behavior might be same, but different mechanism
- More brittle if customer.type not set

**How to Do It Right**:
```python
# Verify same logic
def get_discount_rate(customer):
    if customer.is_vip:
        return 0.20
    if customer.is_loyal:
        return 0.10
    return 0

# Then improve readability without changing logic
def get_discount_rate(customer):
    discount_rates = [
        (customer.is_vip, 0.20),
        (customer.is_loyal, 0.10),
        (True, 0)  # Default
    ]

    for condition, rate in discount_rates:
        if condition:
            return rate
```

## Anti-Pattern 10: Ignoring Performance

**Problem**: Refactoring that makes code slower without realizing.

**Example**:
```python
# Original: O(n)
def find_user(user_id):
    return next((u for u in users if u.id == user_id), None)

# WRONG: O(n²) after "refactoring"
def find_user(user_id):
    for user in users:
        if user.id == user_id:
            for preference in user.preferences:  # Added loop!
                validate_preference(preference)
            return user
    return None
```

**Why It's Bad**:
- Behavior changed (added preference validation)
- Performance degraded significantly
- No longer refactoring, now optimization + feature

**How to Do It Right**:
```python
# Pure refactoring: same performance
def find_user(user_id):
    return get_user_by_id(users, user_id)

def get_user_by_id(user_list, user_id):
    return next((u for u in user_list if u.id == user_id), None)

# Separate: validation if needed
def validate_user_preferences(user):
    for preference in user.preferences:
        validate_preference(preference)
```

## Checklist to Avoid Anti-Patterns

Before committing refactoring:
- [ ] Code does EXACTLY the same thing (tests prove it)
- [ ] No new features added
- [ ] No API changes
- [ ] No performance degradation
- [ ] No new dependencies introduced
- [ ] Tests still pass unchanged (or minimal updates for structure)
- [ ] Code is clearer or more maintainable
- [ ] Changes are focused on one pattern/concern
- [ ] Would accept this PR if colleague submitted it
