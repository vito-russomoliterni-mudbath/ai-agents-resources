# Refactoring Patterns

Proven techniques for improving code structure while preserving behavior. Each pattern addresses specific code problems and improves maintainability.

## Extract Method

**Problem**: Function is too long or mixes multiple concerns.

**How to Apply**:
1. Identify a logical chunk of code
2. Extract to new function with descriptive name
3. Pass required variables as parameters
4. Return any values needed by original code
5. Replace original code with function call
6. Run tests after each extraction

**Before**:
```python
def process_order(order):
    total = 0
    for item in order.items:
        price = item.price * (1 - item.discount)
        tax = price * 0.08
        total += price + tax

    shipping = 10 if total < 50 else 5
    final = total + shipping
    email_user(order.customer, final)
    update_inventory(order.items)
    return final
```

**After**:
```python
def process_order(order):
    total = calculate_total(order.items)
    shipping = calculate_shipping(total)
    final = total + shipping
    notify_and_update(order, final)
    return final
```

**Benefits**: Easier to understand, test, and reuse. Functions with single responsibility.

## Extract Class

**Problem**: Class has multiple responsibilities or is too large (>400 lines).

**How to Apply**:
1. Identify cohesive set of methods/data
2. Create new class for them
3. Move methods and fields to new class
4. Create instance of new class in original
5. Update references to use new class
6. Remove original methods/fields
7. Run tests after each step

**Benefits**: SRP - each class has one reason to change. Easier to test and reuse.

## Inline

**Problem**: Function/variable is trivial, misleading, or obfuscates intent.

**How to Apply**:
1. Identify trivial or misleading abstraction
2. Replace calls with actual value or expression
3. Delete function/variable
4. Run tests

**Before**:
```python
def get_price():
    return self.price

def process(item):
    total = get_price()
    return total * 1.1
```

**After**:
```python
def process(item):
    return self.price * 1.1
```

**Use Carefully**: Only when function/variable makes code harder to read, not easier.

## Move Method/Field

**Problem**: Method or field is in wrong class or module.

**How to Apply**:
1. Identify method/field belonging elsewhere
2. Create in target class/module
3. Update original to call/delegate
4. Run tests
5. When confident, remove delegation

**Benefits**: Better organization, reduced coupling, clearer intent.

## Rename

**Problem**: Names are unclear or misleading.

**How to Apply**:
1. Choose clearer name
2. Use IDE rename refactoring (safer than manual)
3. Update all references
4. Run tests

**Guidelines**:
- Names should reveal intent
- Use full words, not abbreviations (except very common ones)
- Classes: Nouns
- Methods: Verbs
- Booleans: is/has/should prefix

## Replace Temp with Query

**Problem**: Temporary variables obscure intent and fragment logic.

**How to Apply**:
1. Extract expression into method
2. Replace all temp uses with method call
3. Delete temp variable

**Before**:
```python
def get_price(quantity):
    base_price = self.item_price * quantity
    if base_price > 1000:
        return base_price * 0.95
    else:
        return base_price * 0.98
```

**After**:
```python
def get_price(quantity):
    base_price = calculate_base_price(quantity)
    return apply_discount(base_price)
```

## Remove Duplication

**Problem**: Same logic appears in multiple places.

**How to Apply**:
1. Find all instances of duplicated code
2. Extract to shared function/class
3. Update all callers
4. Run tests

**Benefits**: DRY principle, easier maintenance, single point of change.

## Simplify Conditional

**Problem**: Deep nesting or complex boolean logic.

**How to Apply**:
1. Use guard clauses to eliminate nesting
2. Extract conditions to named variables
3. Replace polymorphism for complex type checks

**Before**:
```python
def get_price(customer, quantity):
    if customer:
        if customer.is_loyal:
            if quantity > 100:
                return self.price * 0.15
            else:
                return self.price * 0.10
```

**After**:
```python
def get_price(customer, quantity):
    if not customer:
        return self.price
    if not customer.is_loyal:
        return self.price * 0.05 if quantity > 100 else self.price
    return self.price * 0.15 if quantity > 100 else self.price * 0.10
```

## Replace Magic Numbers with Constants

**Problem**: Unexplained numeric values in code.

**How to Apply**:
1. Create named constant
2. Use constant instead of magic number
3. Add comment explaining meaning

**Before**:
```python
if total < 50:
    return 10
elif total < 100:
    return 5
```

**After**:
```python
SHIPPING_THRESHOLD_LOW = 50
SHIPPING_COST_LOW = 10

if total < SHIPPING_THRESHOLD_LOW:
    return SHIPPING_COST_LOW
```

## Replace Temp with Field

**Problem**: Same calculation repeated in different methods.

**How to Apply**:
1. Move temp variable to instance field
2. Calculate in constructor or lazy-load
3. Update methods to use field

**Benefits**: Reduces duplicate calculations, clearer shared state.

## Introduce Parameter Object

**Problem**: Function has many similar parameters.

**How to Apply**:
1. Group related parameters into a class/object
2. Update function signature
3. Update all callers

**Before**:
```python
def create_user(name, email, phone, address):
    pass
```

**After**:
```python
class Contact:
    def __init__(self, email, phone, address):
        self.email = email
        self.phone = phone
        self.address = address

def create_user(name, contact):
    pass
```

## Pull Up Method

**Problem**: Subclasses have duplicate methods.

**How to Apply**:
1. Identify identical methods in subclasses
2. Move to parent class
3. Remove from subclasses
4. Run tests

**Benefits**: Eliminates duplication, enforces contract.
