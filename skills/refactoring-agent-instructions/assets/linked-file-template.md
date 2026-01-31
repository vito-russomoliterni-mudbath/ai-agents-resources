# Linked File Template: Detailed Instruction Guidelines

Use this template when creating detailed `.claude/` subdirectory files. These files provide deep-dive guidance on specific topics referenced from the root CLAUDE.md.

## Template Structure

```markdown
# [Topic] - [Project Name]

## Overview
[2-3 sentence explanation of what this document covers and why it matters]

## Rules & Conventions

### Rule Category 1: [Specific Rule]
**When**: [Situations where this rule applies]
**Why**: [Reasoning and benefits]
**Implementation**:
- [Specific implementation detail 1]
- [Specific implementation detail 2]

### Rule Category 2: [Another Rule]
[Same structure as above]

## Examples

### Good Examples ✓
[Example 1 - Code or pattern]
[Explanation of why it's good]

### Avoid ❌
[Example 1 - Anti-pattern]
[Explanation of what's wrong]

## See Also
- [Link to related document] - Brief description
- [External resource] - Brief description
- [Reference](link)

---

**Typical length**: 100-200 lines | **Token count**: 1,500-3,000 tokens
```

---

# Complete Example 1: TypeScript Conventions

```markdown
# TypeScript Conventions - Web Application

## Overview
This document provides TypeScript-specific conventions for the web application project. Strict typing is required to maintain code quality and catch errors at compile time. All new code must follow these conventions to ensure consistency across the codebase.

## Rules & Conventions

### Rule 1: Always Define Explicit Types
**When**: Declaring variables, function parameters, return types
**Why**: Prevents `any` types from hiding errors; improves IDE autocomplete and documentation
**Implementation**:
- Define interfaces for complex objects
- Use union types for multiple valid shapes
- Specify return types on all functions (including void)
- Never use `any` - use `unknown` if truly unknown, then narrow

**Code**:
```typescript
// ✓ GOOD - Explicit types
interface User {
  id: number;
  name: string;
  email: string;
}

function getUserById(id: number): User | null {
  // implementation
}

const user: User = { id: 1, name: "Alice", email: "alice@example.com" };
```

```typescript
// ❌ BAD - Using any
function getUserById(id: any): any {
  // implementation
}

const user: any = getUserById(1);
user.unknownProperty.someMethod(); // No type safety!
```

### Rule 2: Strict Mode Configuration
**When**: Project setup and tsconfig.json configuration
**Why**: Catches more errors at compile time; enforces stricter checks
**Implementation**:
- Set `strict: true` in tsconfig.json
- Enable `noImplicitAny`, `strictNullChecks`, `strictFunctionTypes`
- Use `noUnusedLocals` and `noUnusedParameters`
- Enable `noImplicitReturns`

**tsconfig.json**:
```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "target": "ES2020",
    "module": "ESNext"
  }
}
```

### Rule 3: Use Interfaces for Props
**When**: Defining React component props
**Why**: Self-documents component API; improves tooling support
**Implementation**:
- Create named interfaces (not inline types)
- Document required vs optional props with `?`
- Use specific types instead of `object` or `any`
- Group related props into nested interfaces

**Code**:
```typescript
// ✓ GOOD - Clear interface
interface ButtonProps {
  label: string;
  onClick: () => void;
  disabled?: boolean;
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
}

const Button: React.FC<ButtonProps> = ({
  label,
  onClick,
  disabled = false,
  variant = 'primary',
  size = 'md'
}) => {
  // implementation
};
```

```typescript
// ❌ BAD - Vague types
const Button = ({ props }: any) => {
  // What props are required? No IDE help!
};

interface ButtonProps {
  [key: string]: any; // Too loose
}
```

### Rule 4: Nullable Handling
**When**: Working with optional data, API responses, conditional rendering
**Why**: Prevents runtime errors from null/undefined values
**Implementation**:
- Use `T | null` or `T | undefined` explicitly
- Never assume data exists without checking
- Use optional chaining (`?.`) and nullish coalescing (`??`)
- Handle both null and undefined consistently

**Code**:
```typescript
// ✓ GOOD - Explicit null handling
interface ApiResponse {
  data: User | null;
  error: string | null;
}

function processResponse(response: ApiResponse): string {
  if (response.error) {
    return `Error: ${response.error}`;
  }

  const userName = response.data?.name ?? 'Unknown User';
  return `Hello, ${userName}`;
}
```

```typescript
// ❌ BAD - Unsafe null access
function processResponse(response: any): string {
  return `Hello, ${response.data.name}`; // Crashes if data is null!
}
```

### Rule 5: Discriminated Unions for State
**When**: Representing multiple possible states (loading, success, error)
**Why**: Forces handling all cases; prevents invalid state combinations
**Implementation**:
- Use discriminator property (`type`, `status`, `kind`)
- Leverage TypeScript's type narrowing
- Never have optional fields that should be mutually exclusive

**Code**:
```typescript
// ✓ GOOD - Discriminated union
type AsyncState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: string };

function renderState<T>(state: AsyncState<T>): React.ReactNode {
  switch (state.status) {
    case 'idle':
      return null;
    case 'loading':
      return <Spinner />;
    case 'success':
      return <Content data={state.data} />; // data available here!
    case 'error':
      return <Error message={state.error} />; // error available here!
  }
}
```

```typescript
// ❌ BAD - Loose state representation
interface State {
  data?: T;
  error?: string;
  isLoading?: boolean;
}
// Can have data AND error both set - invalid state!
// Missing isLoading doesn't prevent rendering attempt
```

## Examples

### Good Examples ✓

**Example A: API Response Handler**
```typescript
interface ApiError {
  code: string;
  message: string;
  details?: Record<string, unknown>;
}

interface ApiSuccess<T> {
  success: true;
  data: T;
  timestamp: Date;
}

type ApiResult<T> = ApiSuccess<T> | ApiError;

async function fetchUser(id: number): Promise<ApiResult<User>> {
  try {
    const response = await fetch(`/api/users/${id}`);

    if (!response.ok) {
      const error: ApiError = await response.json();
      return error;
    }

    const data: User = await response.json();
    return {
      success: true,
      data,
      timestamp: new Date()
    };
  } catch (err) {
    return {
      code: 'NETWORK_ERROR',
      message: err instanceof Error ? err.message : 'Unknown error'
    };
  }
}

// Usage with full type safety
const result = await fetchUser(1);
if ('success' in result && result.success) {
  console.log(result.data.name); // data is guaranteed to exist
} else {
  console.error(result.message); // error details available
}
```

**Example B: React Hook with Types**
```typescript
interface UseAsyncOptions<T> {
  initialData?: T;
  onSuccess?: (data: T) => void;
  onError?: (error: ApiError) => void;
}

interface UseAsyncReturn<T> {
  data: T | undefined;
  loading: boolean;
  error: ApiError | null;
  retry: () => Promise<void>;
}

function useAsync<T>(
  asyncFn: () => Promise<T>,
  options?: UseAsyncOptions<T>
): UseAsyncReturn<T> {
  const [state, setState] = React.useState<{
    data: T | undefined;
    loading: boolean;
    error: ApiError | null;
  }>({
    data: options?.initialData,
    loading: true,
    error: null
  });

  // implementation...

  return {
    data: state.data,
    loading: state.loading,
    error: state.error,
    retry: async () => { /* */ }
  };
}
```

### Avoid ❌

**Anti-Pattern A: Any Type Leakage**
```typescript
// ❌ AVOID
function processData(input: any): any {
  const result = input.map((x: any) => x.value);
  return result;
}

const data = processData([1, 2, 3]);
data.unknownMethod(); // TypeScript won't catch this error!
```

**Better Alternative**:
```typescript
// ✓ BETTER
function processData(input: number[]): number[] {
  const result = input.map(x => x); // x is inferred as number
  return result;
}

const data = processData([1, 2, 3]);
// data.unknownMethod(); // TypeScript error: Property 'unknownMethod' does not exist
```

**Anti-Pattern B: Optional Everything**
```typescript
// ❌ AVOID
interface Product {
  name?: string;
  price?: number;
  category?: string;
  stock?: number;
}

// Now I don't know which fields are actually required
function updateProduct(id: number, product: Product): void {
  // Is name required? Is price required?
}
```

**Better Alternative**:
```typescript
// ✓ BETTER
interface Product {
  name: string;      // Always required
  price: number;     // Always required
  category: string;  // Always required
  stock: number;     // Always required
}

interface ProductUpdate {
  name?: string;     // Only optional fields here
  price?: number;
  category?: string;
  stock?: number;
}

function updateProduct(id: number, updates: ProductUpdate): void {
  // Clear which fields can be updated
}
```

**Anti-Pattern C: Nested Any**
```typescript
// ❌ AVOID
function handleResponse(response: { data: { items: any[] } }): void {
  response.data.items.forEach(item => {
    console.log(item.someField); // TypeScript won't check if someField exists
  });
}
```

**Better Alternative**:
```typescript
// ✓ BETTER
interface ResponseItem {
  id: string;
  someField: string;
}

interface Response {
  data: {
    items: ResponseItem[];
  };
}

function handleResponse(response: Response): void {
  response.data.items.forEach(item => {
    console.log(item.someField); // TypeScript checks this exists
  });
}
```

## Linting & Enforcement

**ESLint Configuration** (.eslintrc.js):
```javascript
module.exports = {
  extends: ['eslint:recommended', 'plugin:@typescript-eslint/recommended', 'plugin:@typescript-eslint/recommended-requiring-type-checking'],
  rules: {
    '@typescript-eslint/no-explicit-any': 'error',
    '@typescript-eslint/explicit-function-return-types': 'error',
    '@typescript-eslint/explicit-member-accessibility': 'error',
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/no-non-null-assertion': 'warn'
  }
};
```

## See Also
- [Testing Guidelines](./testing.md) - TypeScript testing patterns with Vitest
- [React Component Patterns](./components.md) - Typing React functional components
- [State Management](./state.md) - Redux/Jotai TypeScript patterns
- [TypeScript Handbook](https://www.typescriptlang.org/docs/) - Official documentation
- [Type Challenges](https://github.com/type-challenges/type-challenges) - Advanced TypeScript

---

**File location**: `.claude/typescript-conventions.md`
**Token count**: ~2,100 tokens
**Reading time**: ~8 minutes
```

---

# Complete Example 2: Testing Guidelines

```markdown
# Testing Guidelines - Backend Services

## Overview
This document outlines testing strategy and patterns for .NET backend services. Tests are organized in three layers: unit, integration, and E2E. Maintain >80% code coverage on business logic while being pragmatic about infrastructure code.

## Rules & Conventions

### Rule 1: Unit Test Structure - Arrange/Act/Assert
**When**: Testing individual functions, services, or components in isolation
**Why**: Clear test structure makes failures obvious; tests become living documentation
**Implementation**:
- Each test tests one behavior
- Three clear sections: Arrange (setup), Act (execute), Assert (verify)
- Test name describes the behavior, not the implementation
- Mock external dependencies

**Pattern**:
```csharp
[TestFixture]
public class InventoryServiceTests
{
    private InventoryService _service;
    private Mock<IInventoryRepository> _mockRepository;

    [SetUp]
    public void Setup()
    {
        _mockRepository = new Mock<IInventoryRepository>();
        _service = new InventoryService(_mockRepository.Object);
    }

    [Test]
    public void DeductStock_WithValidQuantity_UpdatesInventory()
    {
        // ARRANGE
        var productId = 123;
        var quantity = 5;
        var existingStock = 10;

        _mockRepository
            .Setup(r => r.GetStock(productId))
            .ReturnsAsync(existingStock);

        // ACT
        var result = _service.DeductStock(productId, quantity);

        // ASSERT
        Assert.That(result, Is.EqualTo(5)); // New stock: 10 - 5 = 5
        _mockRepository.Verify(r => r.UpdateStock(productId, 5), Times.Once);
    }

    [Test]
    [TestCase(0)]
    [TestCase(-5)]
    public void DeductStock_WithInvalidQuantity_ThrowsException(int quantity)
    {
        // ARRANGE
        var productId = 123;

        // ACT & ASSERT
        var ex = Assert.ThrowsAsync<ArgumentException>(
            () => _service.DeductStock(productId, quantity));

        Assert.That(ex.Message, Contains.Substring("Quantity must be positive"));
    }
}
```

### Rule 2: Integration Tests with Test Database
**When**: Testing API endpoints, database operations, repository patterns
**Why**: Validates real interactions; catches issues mocking would miss
**Implementation**:
- Use in-memory database or test container
- Create fresh database for each test (or rollback transactions)
- Test the full stack: controller → service → repository → database
- Keep tests focused on specific workflows

**Pattern**:
```csharp
[TestFixture]
public class OrderServiceIntegrationTests
{
    private AppDbContext _dbContext;
    private OrderService _service;

    [SetUp]
    public void Setup()
    {
        // Use in-memory SQLite for integration tests
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseSqlite("Data Source=:memory:")
            .Options;

        _dbContext = new AppDbContext(options);
        _dbContext.Database.EnsureCreated();
        _service = new OrderService(_dbContext);
    }

    [TearDown]
    public void TearDown()
    {
        _dbContext.Dispose();
    }

    [Test]
    public async Task CreateOrder_WithValidItems_PersistsToDatabase()
    {
        // ARRANGE
        var customer = new Customer { Id = 1, Name = "Alice" };
        var product = new Product { Id = 1, Name = "Widget", Price = 29.99m };

        _dbContext.Customers.Add(customer);
        _dbContext.Products.Add(product);
        await _dbContext.SaveChangesAsync();

        var orderRequest = new CreateOrderRequest
        {
            CustomerId = 1,
            Items = new[] { new OrderItem { ProductId = 1, Quantity = 2 } }
        };

        // ACT
        var order = await _service.CreateOrderAsync(orderRequest);

        // ASSERT
        var savedOrder = _dbContext.Orders.FirstOrDefault(o => o.Id == order.Id);
        Assert.That(savedOrder, Is.Not.Null);
        Assert.That(savedOrder.Items, Has.Count.EqualTo(1));
        Assert.That(savedOrder.Total, Is.EqualTo(59.98m)); // 29.99 * 2
    }
}
```

### Rule 3: Test Naming Convention
**When**: Naming all test methods and test classes
**Why**: Test names document expected behavior; failed test names immediately show what's broken
**Implementation**:
- Format: `[Method]_[Condition]_[Expected Outcome]`
- Use descriptive names - avoid generic names like "Test1"
- Include edge case names like "WithNullInput" or "WithInvalidQuantity"

**Examples**:
```csharp
// ✓ GOOD - Clear behavior
[Test]
public void ValidateEmail_WithValidEmail_ReturnsTrue()

[Test]
public void ValidateEmail_WithNullInput_ThrowsArgumentNullException()

[Test]
public void ProcessPayment_WithExpiredCard_RejectsTransaction()

// ❌ BAD - Unclear what's being tested
[Test]
public void Test1()

[Test]
public void EmailTest()

[Test]
public void PaymentCheck()
```

### Rule 4: Avoid Test Interdependencies
**When**: Writing multiple tests in a test class
**Why**: Tests must run in any order; shared state causes mysterious failures
**Implementation**:
- Use `[SetUp]` to create fresh instances for each test
- Never depend on test execution order
- Don't share state between tests
- Use factories to create consistent test data

**Pattern**:
```csharp
// ✓ GOOD - Each test is independent
[TestFixture]
public class UserServiceTests
{
    private UserService _service;
    private Mock<IUserRepository> _mockRepo;

    [SetUp]
    public void Setup() // Runs BEFORE each test
    {
        _mockRepo = new Mock<IUserRepository>();
        _service = new UserService(_mockRepo.Object);
    }

    [Test]
    public void CreateUser_ValidData_Success() { }

    [Test]
    public void CreateUser_DuplicateEmail_Fails() { }

    // Both tests run with fresh _service and _mockRepo instances
}

// ❌ BAD - Tests depend on execution order
private static List<User> _allUsers = new();

[Test]
public void First_CreateUser()
{
    _allUsers.Add(new User { Id = 1 });
}

[Test]
public void Second_GetUser()
{
    var user = _allUsers[0]; // Fails if First_CreateUser doesn't run!
}
```

### Rule 5: Mock External Dependencies, Test Internal Logic
**When**: Deciding what to mock vs. test
**Why**: Mocking external systems keeps tests fast; real internal logic testing catches bugs
**Implementation**:
- Mock: external APIs, databases (for unit tests), file systems, third-party services
- Test: business logic, calculations, validation, state transitions
- Use real objects for internal dependencies (factories, validators)
- Test behavior, not implementation details

**Pattern**:
```csharp
// ✓ GOOD - Mocks external, tests logic
[Test]
public async Task ProcessPayment_WithValidCard_CallsPaymentGateway()
{
    // ARRANGE
    var mockPaymentGateway = new Mock<IPaymentGateway>();
    mockPaymentGateway
        .Setup(g => g.ChargeAsync(It.IsAny<decimal>()))
        .ReturnsAsync(true);

    var service = new OrderService(mockPaymentGateway.Object);
    var order = CreateTestOrder(total: 100m);

    // ACT
    var result = await service.ProcessPaymentAsync(order);

    // ASSERT - Tests real business logic
    Assert.That(result.Success, Is.True);
    Assert.That(result.TransactionId, Is.Not.Empty);

    // Verifies correct parameters sent to external system
    mockPaymentGateway.Verify(
        g => g.ChargeAsync(100m),
        Times.Once);
}

// ❌ BAD - Mocks internal logic, doesn't test anything real
[Test]
public async Task ProcessPayment_CallsInternalValidator()
{
    var mockValidator = new Mock<IOrderValidator>();
    var service = new OrderService(mockValidator.Object);

    // Why mock the validator? We should test it!
    mockValidator.Setup(v => v.IsValid(It.IsAny<Order>())).Returns(true);

    // This test teaches us nothing about real validation
}
```

## Examples

### Good Examples ✓

**Example A: Complete Unit Test Suite**
```csharp
[TestFixture]
public class CartServiceTests
{
    private CartService _cartService;
    private Mock<IPricingService> _mockPricingService;
    private Mock<IInventoryService> _mockInventoryService;

    [SetUp]
    public void Setup()
    {
        _mockPricingService = new Mock<IPricingService>();
        _mockInventoryService = new Mock<IInventoryService>();
        _cartService = new CartService(
            _mockPricingService.Object,
            _mockInventoryService.Object);
    }

    [Test]
    public void AddItem_WithValidItem_IncreasesCartCount()
    {
        // ARRANGE
        var item = new CartItem { ProductId = 1, Quantity = 1 };

        // ACT
        _cartService.AddItem(item);

        // ASSERT
        Assert.That(_cartService.Items.Count, Is.EqualTo(1));
    }

    [Test]
    [TestCase(0)]
    [TestCase(-1)]
    public void AddItem_WithInvalidQuantity_ThrowsException(int quantity)
    {
        // ARRANGE
        var item = new CartItem { ProductId = 1, Quantity = quantity };

        // ACT & ASSERT
        Assert.Throws<ArgumentException>(() => _cartService.AddItem(item));
    }

    [Test]
    public void CalculateTotal_WithMultipleItems_SumsCorrectly()
    {
        // ARRANGE
        _mockPricingService.Setup(p => p.GetPrice(1)).Returns(10m);
        _mockPricingService.Setup(p => p.GetPrice(2)).Returns(20m);

        _cartService.AddItem(new CartItem { ProductId = 1, Quantity = 2 }); // 20
        _cartService.AddItem(new CartItem { ProductId = 2, Quantity = 1 }); // 20

        // ACT
        var total = _cartService.CalculateTotal();

        // ASSERT
        Assert.That(total, Is.EqualTo(40m));
    }

    [Test]
    public void Clear_EmptiesCart()
    {
        // ARRANGE
        _cartService.AddItem(new CartItem { ProductId = 1, Quantity = 1 });

        // ACT
        _cartService.Clear();

        // ASSERT
        Assert.That(_cartService.Items.Count, Is.Zero);
    }
}
```

**Example B: Parameterized Tests**
```csharp
[TestFixture]
public class ValidationTests
{
    private ValidationService _validator;

    [SetUp]
    public void Setup()
    {
        _validator = new ValidationService();
    }

    [TestCase("john@example.com", true)]
    [TestCase("jane_doe@company.co.uk", true)]
    [TestCase("invalid.email", false)]
    [TestCase("@example.com", false)]
    [TestCase("user@.com", false)]
    [TestCase("", false)]
    public void ValidateEmail_WithVariousInputs_ReturnsExpected(
        string email,
        bool expected)
    {
        // ACT
        var result = _validator.IsValidEmail(email);

        // ASSERT
        Assert.That(result, Is.EqualTo(expected));
    }
}
```

### Avoid ❌

**Anti-Pattern A: Testing Implementation Details**
```csharp
// ❌ AVOID - Tests implementation, not behavior
[Test]
public void GetUsers_CallsDatabaseQuery()
{
    var mockDb = new Mock<IDatabase>();
    var service = new UserService(mockDb.Object);

    service.GetUsers();

    // This test only validates internal implementation changed
    // Doesn't verify the actual returned data is correct
    mockDb.Verify(d => d.Query("SELECT * FROM Users"), Times.Once);
}

// ✓ BETTER - Tests behavior
[Test]
public void GetUsers_ReturnsAllActiveUsers()
{
    var users = new[] {
        new User { Id = 1, IsActive = true, Name = "Alice" },
        new User { Id = 2, IsActive = false, Name = "Bob" },
        new User { Id = 3, IsActive = true, Name = "Charlie" }
    };

    var mockDb = new Mock<IUserRepository>();
    mockDb.Setup(d => d.GetAllUsers()).ReturnsAsync(users);
    var service = new UserService(mockDb.Object);

    var result = service.GetUsers();

    Assert.That(result.Count, Is.EqualTo(3));
}
```

**Anti-Pattern B: Shared Test State**
```csharp
// ❌ AVOID - Shared mutable state between tests
[TestFixture]
public class BrokenTests
{
    private static List<int> _testIds = new(); // SHARED STATE!

    [Test]
    public void Test1_AddId()
    {
        _testIds.Add(1);
        Assert.That(_testIds.Count, Is.EqualTo(1));
    }

    [Test]
    public void Test2_CheckId()
    {
        // Fails if Test1 didn't run! Or if tests run in different order!
        Assert.That(_testIds.Count, Is.EqualTo(1));
        Assert.That(_testIds[0], Is.EqualTo(1));
    }
}

// ✓ BETTER - Each test independent
[TestFixture]
public class IndependentTests
{
    private List<int> _testIds; // Instance variable, created fresh

    [SetUp]
    public void Setup()
    {
        _testIds = new List<int>();
    }

    [Test]
    public void Test1_AddId()
    {
        _testIds.Add(1);
        Assert.That(_testIds.Count, Is.EqualTo(1));
    }

    [Test]
    public void Test2_StartsEmpty()
    {
        // Fresh _testIds for each test
        Assert.That(_testIds.Count, Is.Zero);
    }
}
```

**Anti-Pattern C: Over-Mocking**
```csharp
// ❌ AVOID - Mocks too many internal dependencies
[Test]
public void Calculate_MocksEverything()
{
    var mockValidator = new Mock<IValidator>();
    var mockParser = new Mock<IParser>();
    var mockFormatter = new Mock<IFormatter>();

    // This test validates mock setup, not actual logic
    // If internal logic changes, test still passes (bad!)
}

// ✓ BETTER - Only mock external dependencies
[Test]
public void Calculate_UsesRealLogic()
{
    var externalApi = new Mock<IExternalApi>();
    externalApi.Setup(x => x.GetRate()).ReturnsAsync(1.5m);

    var calculator = new Calculator(externalApi.Object);
    var result = calculator.Calculate(10m);

    // Tests real internal logic with mocked external call
    Assert.That(result, Is.EqualTo(15m));
}
```

## Running Tests

**Command Line**:
```bash
# Run all tests
dotnet test

# Run specific test class
dotnet test --filter TestFixture=CartServiceTests

# Run with coverage
dotnet test /p:CollectCoverage=true

# Run with verbose output
dotnet test --verbosity detailed
```

## Coverage Requirements

- **Business Logic**: >80% coverage
- **Repositories**: >70% coverage (pragmatic about DB edge cases)
- **Infrastructure**: >50% coverage (file I/O, logging, etc.)
- **Controllers**: >60% coverage (focus on API contracts, not infrastructure)

## See Also
- [TypeScript Testing](./typescript-testing.md) - Frontend testing patterns with Vitest
- [Mocking Best Practices](./mocking.md) - Moq and xUnit patterns
- [Performance Testing](./performance.md) - Load and stress testing
- [xUnit Documentation](https://xunit.net/) - Official testing framework

---

**File location**: `.claude/testing.md`
**Token count**: ~2,400 tokens
**Reading time**: ~10 minutes
```

---

## Key Guidelines for Linked Files

1. **Keep focused** - One topic per file (not multiple topics)
2. **Include rules with context** - Not just "do this" but "why" and "when"
3. **Show good AND bad** - Anti-patterns teach more than theory alone
4. **Use real examples** - Snippets from actual codebases
5. **Link between files** - Reference related detailed guides
6. **Estimate token count** - Helps agents prioritize reading
7. **Typical length** - 150-300 lines (1,500-4,000 tokens)

## Structure Checklist

- [ ] Clear overview (2-3 sentences explaining scope)
- [ ] 3-5 core rules with "When/Why/Implementation"
- [ ] At least 2 complete good examples with explanations
- [ ] At least 2 anti-patterns with what's wrong
- [ ] "See Also" section linking related files
- [ ] Token count estimate at bottom
- [ ] File path location at bottom
- [ ] Syntax highlighting on all code blocks
