# Testing Frameworks Reference

This document provides guidance on detecting and working with common testing frameworks.

## Framework Detection

### Python - pytest
**Config files**: `pytest.ini`, `pyproject.toml`, `setup.cfg`, `tox.ini`
**Test patterns**: `test_*.py`, `*_test.py`
**Common commands**:
```bash
pytest
pytest --cov
pytest -v
python -m pytest
```

### Python - unittest
**Config files**: Usually no config file
**Test patterns**: `test*.py` (with TestCase classes)
**Common commands**:
```bash
python -m unittest
python -m unittest discover
```

### JavaScript/TypeScript - Vitest
**Config files**: `vitest.config.ts`, `vitest.config.js`, `vite.config.ts`
**Test patterns**: `*.test.ts`, `*.test.js`, `*.spec.ts`, `*.spec.js`
**Common commands**:
```bash
vitest
vitest run
npm test
npm run test
bun test
```

### JavaScript/TypeScript - Jest
**Config files**: `jest.config.js`, `jest.config.ts`, `package.json` (jest section)
**Test patterns**: `*.test.js`, `*.test.ts`, `*.spec.js`, `*.spec.ts`, `__tests__/*.js`
**Common commands**:
```bash
jest
npm test
npm run test
npx jest
```

### JavaScript/TypeScript - Mocha
**Config files**: `.mocharc.json`, `.mocharc.js`, `package.json` (mocha section)
**Test patterns**: `test/*.js`, `*.test.js`, `*.spec.js`
**Common commands**:
```bash
mocha
npm test
npx mocha
```

### .NET - xUnit
**Config files**: `*.csproj` (package references)
**Test patterns**: `*.Tests.csproj`, `*Tests.cs`, `*Test.cs`
**Common commands**:
```bash
dotnet test
dotnet test --collect:"XPlat Code Coverage"
```

### .NET - NUnit
**Config files**: `*.csproj` (package references)
**Test patterns**: `*.Tests.csproj`, `*Tests.cs`, `*Test.cs`
**Common commands**:
```bash
dotnet test
nunit3-console
```

### Java - JUnit
**Config files**: `pom.xml`, `build.gradle`
**Test patterns**: `*Test.java`, `*Tests.java`
**Common commands**:
```bash
mvn test
gradle test
./gradlew test
```

### Go - go test
**Config files**: None (built into Go)
**Test patterns**: `*_test.go`
**Common commands**:
```bash
go test
go test ./...
go test -v
go test -cover
```

## Framework-Specific Patterns

### pytest Patterns
```python
# Basic test
def test_function_name():
    assert result == expected

# Parametrized test
@pytest.mark.parametrize("input,expected", [
    (1, 2),
    (2, 4),
])
def test_with_params(input, expected):
    assert double(input) == expected

# Fixtures
@pytest.fixture
def sample_data():
    return {"key": "value"}

def test_with_fixture(sample_data):
    assert sample_data["key"] == "value"
```

### Vitest Patterns
```typescript
// Basic test
import { describe, it, expect } from 'vitest'

describe('feature', () => {
  it('should do something', () => {
    expect(result).toBe(expected)
  })
})

// With mock
import { vi } from 'vitest'

it('mocks a module', () => {
  const mock = vi.fn()
  mock.mockReturnValue(42)
  expect(mock()).toBe(42)
})
```

### xUnit Patterns
```csharp
using Xunit;

public class FeatureTests
{
    [Fact]
    public void TestMethod()
    {
        Assert.Equal(expected, actual);
    }

    [Theory]
    [InlineData(1, 2)]
    [InlineData(2, 4)]
    public void TestWithData(int input, int expected)
    {
        Assert.Equal(expected, Double(input));
    }
}
```

## Detection Algorithm

1. **Check for config files** in project root and subdirectories
2. **Scan for test file patterns** using Glob
3. **Examine package.json** (for JS/TS) or **project files** (for .NET/Java)
4. **Look for test commands** in package.json scripts or Makefile
5. **Default to most common** for the language if multiple frameworks detected

## Running Tests

### Before Running
- Ensure dependencies are installed
- Check for environment variables needed
- Verify database/service dependencies

### Common Issues
- **Tests not found**: Check test pattern matches framework expectations
- **Import errors**: Verify test dependencies installed
- **Timeout errors**: Some tests may need longer timeout configuration
- **Database errors**: May need test database setup or mocking

### Coverage Tools
- Python: `pytest --cov`, `coverage run`
- JavaScript: `vitest --coverage`, `jest --coverage`
- .NET: `dotnet test --collect:"XPlat Code Coverage"`
- Java: JaCoCo plugin
- Go: `go test -cover`
