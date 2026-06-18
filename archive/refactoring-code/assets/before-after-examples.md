# Before and After Examples

Real-world examples of good refactoring that preserve behavior while improving code.

## Example 1: Extract Method - Long Payment Processing

### Before

```python
def process_payment(order, customer):
    # Validate input
    if not order or not order.items or len(order.items) == 0:
        raise ValueError("Invalid order")
    if not customer or not customer.email:
        raise ValueError("Invalid customer")

    # Calculate totals
    subtotal = 0
    for item in order.items:
        item_total = item.price * item.quantity
        if item.discount_percentage:
            item_total *= (1 - item.discount_percentage / 100)
        subtotal += item_total

    # Apply order-level discount
    if order.is_vip_customer:
        discount = subtotal * 0.10
    elif subtotal > 500:
        discount = subtotal * 0.05
    else:
        discount = 0

    total = subtotal - discount

    # Calculate tax
    tax = total * (order.tax_rate or 0.08)
    final_amount = total + tax

    # Process payment
    try:
        payment_result = payment_gateway.charge(customer.payment_method, final_amount)
        if not payment_result.success:
            raise Exception(f"Payment failed: {payment_result.error}")
    except PaymentException as e:
        logger.error(f"Payment processing error: {e}")
        raise

    # Send confirmation
    email_service.send_confirmation(customer.email, final_amount)

    # Update records
    order.status = "completed"
    order.payment_id = payment_result.transaction_id
    order.total_paid = final_amount
    db.save(order)

    return payment_result
```

**Problems**:
- 40+ lines with multiple responsibilities
- Hard to test individual concerns
- Hard to understand flow
- Difficult to reuse payment calculation logic
- Hard to change email/logging without touching payment logic

### After

```python
def process_payment(order, customer):
    validate_order_and_customer(order, customer)

    final_amount = calculate_total_with_tax(order)
    payment_result = charge_payment(customer, final_amount)

    send_confirmation(customer, final_amount)
    update_order_status(order, payment_result, final_amount)

    return payment_result

def validate_order_and_customer(order, customer):
    if not order or not order.items or len(order.items) == 0:
        raise ValueError("Invalid order")
    if not customer or not customer.email:
        raise ValueError("Invalid customer")

def calculate_total_with_tax(order):
    subtotal = sum(calculate_item_total(item) for item in order.items)
    discount = calculate_order_discount(subtotal, order)
    total = subtotal - discount
    tax = total * (order.tax_rate or 0.08)
    return total + tax

def calculate_item_total(item):
    item_total = item.price * item.quantity
    if item.discount_percentage:
        item_total *= (1 - item.discount_percentage / 100)
    return item_total

def calculate_order_discount(subtotal, order):
    if order.is_vip_customer:
        return subtotal * 0.10
    elif subtotal > 500:
        return subtotal * 0.05
    return 0

def charge_payment(customer, amount):
    try:
        payment_result = payment_gateway.charge(customer.payment_method, amount)
        if not payment_result.success:
            raise Exception(f"Payment failed: {payment_result.error}")
        return payment_result
    except PaymentException as e:
        logger.error(f"Payment processing error: {e}")
        raise

def send_confirmation(customer, amount):
    email_service.send_confirmation(customer.email, amount)

def update_order_status(order, payment_result, amount):
    order.status = "completed"
    order.payment_id = payment_result.transaction_id
    order.total_paid = amount
    db.save(order)
```

**Benefits**:
- Main flow clear at a glance
- Each function has single responsibility
- Easy to test calculation logic separately
- Easy to mock payment gateway
- Easy to change email template without touching payment logic
- Each function is reusable

## Example 2: Remove Duplication - Configuration Validation

### Before

```python
class ConfigManager:
    def validate_database_config(self, config):
        if not config.get("host"):
            raise ValueError("Database host required")
        if not isinstance(config.get("port"), int) or config.get("port") < 1 or config.get("port") > 65535:
            raise ValueError("Database port must be integer between 1-65535")
        if not config.get("username"):
            raise ValueError("Database username required")
        if not config.get("password"):
            raise ValueError("Database password required")
        return True

    def validate_cache_config(self, config):
        if not config.get("host"):
            raise ValueError("Cache host required")
        if not isinstance(config.get("port"), int) or config.get("port") < 1 or config.get("port") > 65535:
            raise ValueError("Cache port must be integer between 1-65535")
        if not config.get("password"):
            raise ValueError("Cache password required")
        return True

    def validate_smtp_config(self, config):
        if not config.get("host"):
            raise ValueError("SMTP host required")
        if not isinstance(config.get("port"), int) or config.get("port") < 1 or config.get("port") > 65535:
            raise ValueError("SMTP port must be integer between 1-65535")
        return True
```

**Problems**:
- Port validation duplicated 3 times
- Host validation duplicated 3 times
- Hard to fix validation bug in one place without remembering others
- Easy to have inconsistencies

### After

```python
class ConfigManager:
    def validate_database_config(self, config):
        self._validate_required_field(config, "host", "Database")
        self._validate_port(config, "Database")
        self._validate_required_field(config, "username", "Database")
        self._validate_required_field(config, "password", "Database")
        return True

    def validate_cache_config(self, config):
        self._validate_required_field(config, "host", "Cache")
        self._validate_port(config, "Cache")
        self._validate_required_field(config, "password", "Cache")
        return True

    def validate_smtp_config(self, config):
        self._validate_required_field(config, "host", "SMTP")
        self._validate_port(config, "SMTP")
        return True

    def _validate_required_field(self, config, field, service_name):
        if not config.get(field):
            raise ValueError(f"{service_name} {field} required")

    def _validate_port(self, config, service_name):
        port = config.get("port")
        if not isinstance(port, int) or port < 1 or port > 65535:
            raise ValueError(f"{service_name} port must be integer between 1-65535")
```

**Benefits**:
- Validation logic centralized
- Change port validation once, applies everywhere
- Each config validator is clearer about requirements
- Easy to add new service config validation
- Consistent error messages

## Example 3: Simplify Conditional - User Permission Checking

### Before

```python
def can_user_perform_action(user, action, resource):
    if user:
        if user.is_admin:
            return True
        else:
            if user.is_moderator:
                if action in ["edit", "delete"]:
                    if resource.owner_id == user.id:
                        return True
                    else:
                        return False
                else:
                    return True
            else:
                if user.id == resource.owner_id:
                    if action in ["read", "edit", "delete"]:
                        return True
                    else:
                        return False
                else:
                    if action == "read":
                        return True
                    else:
                        return False
    else:
        if action == "read":
            return resource.is_public
        else:
            return False
```

**Problems**:
- Very deeply nested
- Hard to understand permission logic
- Hard to trace through for specific case
- Easy to miss a condition

### After

```python
def can_user_perform_action(user, action, resource):
    if not user:
        return action == "read" and resource.is_public

    if user.is_admin:
        return True

    if user.is_moderator:
        return action in ["read", "edit", "delete"] or not (action in ["edit", "delete"] and resource.owner_id != user.id)

    if user.id == resource.owner_id:
        return action in ["read", "edit", "delete"]

    return action == "read"
```

Even better with extracted methods:

```python
def can_user_perform_action(user, action, resource):
    if not user:
        return is_public_read(action, resource)

    if user.is_admin:
        return True

    if user.is_moderator:
        return can_moderator_perform(action, resource, user)

    if user.is_owner(resource):
        return action in ["read", "edit", "delete"]

    return action == "read"

def is_public_read(action, resource):
    return action == "read" and resource.is_public

def can_moderator_perform(action, resource, user):
    return action in ["read", "edit", "delete"] or not (action in ["edit", "delete"] and not user.is_owner(resource))
```

**Benefits**:
- Control flow clear
- Permission logic understandable
- Easy to test individual permission checks
- Easy to modify specific permissions

## Example 4: Extract Class - Customer Entity

### Before

```python
class Customer:
    def __init__(self, name, email, phone, address_street, address_city,
                 address_state, address_zip, address_country,
                 billing_street, billing_city, billing_state, billing_zip, billing_country):
        self.name = name
        self.email = email
        self.phone = phone
        self.address_street = address_street
        self.address_city = address_city
        self.address_state = address_state
        self.address_zip = address_zip
        self.address_country = address_country
        self.billing_street = billing_street
        self.billing_city = billing_city
        self.billing_state = billing_state
        self.billing_zip = billing_zip
        self.billing_country = billing_country

    def validate_address(self):
        if not self.address_street or not self.address_city or not self.address_state or not self.address_zip:
            return False
        return True

    def format_shipping_label(self):
        return f"{self.name}\n{self.address_street}\n{self.address_city}, {self.address_state} {self.address_zip}\n{self.address_country}"

    def format_billing_address(self):
        return f"{self.billing_street}\n{self.billing_city}, {self.billing_state} {self.billing_zip}\n{self.billing_country}"
```

**Problems**:
- Address logic mixed with customer
- Hard to reuse address in other contexts
- Multiple responsibilities in one class

### After

```python
class Address:
    def __init__(self, street, city, state, zip_code, country):
        self.street = street
        self.city = city
        self.state = state
        self.zip_code = zip_code
        self.country = country

    def validate(self):
        return bool(self.street and self.city and self.state and self.zip_code)

    def format(self):
        return f"{self.street}\n{self.city}, {self.state} {self.zip_code}\n{self.country}"

class Customer:
    def __init__(self, name, email, phone, shipping_address, billing_address):
        self.name = name
        self.email = email
        self.phone = phone
        self.shipping_address = shipping_address
        self.billing_address = billing_address

    def format_shipping_label(self):
        return f"{self.name}\n{self.shipping_address.format()}"

    def format_billing_address(self):
        return self.billing_address.format()
```

**Benefits**:
- Address can be used independently
- Address logic encapsulated
- Customer simpler and focused
- Easy to test address validation separately
- Easy to reuse Address in other entities

## Refactoring Anti-Example: Risky Change

### What NOT to Do

```python
# Before
def calculate_price(quantity, unit_price, discount_percent):
    total = quantity * unit_price
    if discount_percent:
        total = total * (1 - discount_percent / 100)
    tax = total * 0.08
    return total + tax

# WRONG: "Refactoring" that changes behavior
def calculate_price(quantity, unit_price, discount_percent):
    # Calculate with optimization
    tax_rate = 0.08
    discount_multiplier = 1 - (discount_percent / 100) if discount_percent else 1
    return quantity * unit_price * discount_multiplier * (1 + tax_rate)  # Changed: tax applied differently!
```

**Problems**:
- Original: tax added to discounted total
- New: tax multiplied on discounted total (mathematically different)
- This is NO LONGER refactoring, it's a behavior change
- Tests would catch this

**How to do it RIGHT**:

```python
# Before: Original logic preserved
def calculate_price(quantity, unit_price, discount_percent):
    total = quantity * unit_price
    if discount_percent:
        total = total * (1 - discount_percent / 100)
    tax = total * 0.08
    return total + tax

# After: Same logic, clearer intent
def calculate_price(quantity, unit_price, discount_percent):
    subtotal = calculate_subtotal(quantity, unit_price, discount_percent)
    tax = calculate_tax(subtotal)
    return subtotal + tax

def calculate_subtotal(quantity, unit_price, discount_percent):
    total = quantity * unit_price
    if discount_percent:
        total = total * (1 - discount_percent / 100)
    return total

def calculate_tax(subtotal):
    return subtotal * 0.08
```

**Better**:
- Same exact logic
- Clearer intent with function names
- Easier to test tax separately
- Now it's real refactoring
