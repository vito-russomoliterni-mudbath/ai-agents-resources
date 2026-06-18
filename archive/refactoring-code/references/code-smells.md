# Code Smells Reference

Indicators that code might benefit from refactoring. Not always problems, but worth investigating.

## Long Method

**Signs**:
- Function > 30 lines
- Hard to name in one sentence
- Mixes multiple concerns
- Many parameters or local variables
- Deep nesting

**Solutions**:
- Extract Method for each logical chunk
- Extract helper methods for calculations
- Use guard clauses to reduce nesting
- Split into smaller focused methods

## Large Class

**Signs**:
- Class > 400 lines
- Multiple responsibilities (too many reasons to change)
- Many instance variables
- Complex constructor
- Hard to understand purpose

**Solutions**:
- Extract Class for cohesive responsibilities
- Identify and separate domain objects
- Move data and methods together
- Consider composition over inheritance

## Duplicate Code

**Signs**:
- Same logic in 2+ places
- Similar variable names
- Identical algorithm structure
- Copy-pasted code sections

**Solutions**:
- Extract Method for shared logic
- Consolidate in parent class if in subclasses
- Use helper functions in shared module
- Template Method pattern for similar algorithms

## Long Parameter List

**Signs**:
- Function > 3-4 parameters
- Related parameters that group together
- Hard to call function correctly
- Parameters change frequently

**Solutions**:
- Introduce Parameter Object (group related params)
- Create builder for complex construction
- Use configuration object
- Extract method to reduce what's passed

## Long Conditional

**Signs**:
- Deep nesting (> 3 levels)
- Complex boolean expressions
- Multiple if/else chains
- Hard to understand intent

**Solutions**:
- Extract Method for each condition branch
- Use guard clauses for early exit
- Replace type checks with polymorphism
- Introduce Strategy pattern
- Extract boolean expression to named variable

## Magic Numbers/Strings

**Signs**:
- Unexplained numeric values in code
- Hardcoded strings without explanation
- Same value repeated multiple times
- No context for why value exists

**Solutions**:
- Create named constants
- Add comments explaining meaning
- Group related constants
- Consider configuration files for deployment-specific values

## Unclear Names

**Signs**:
- Names don't match what code does
- Single letter or abbreviated names
- Generic names (data, value, obj)
- Name doesn't reveal intent

**Solutions**:
- Rename to reveal intent
- Use full words, not abbreviations
- Test clarity: can someone understand without reading implementation?
- Use domain terminology

## Dead Code

**Signs**:
- Unreachable code paths
- Unused methods or variables
- Parameters never used
- Commented-out code blocks
- Deprecated methods still called nowhere

**Solutions**:
- Delete unreachable code
- Remove unused methods/variables
- Use version control to recover if needed
- Don't leave commented code; use VCS history
- Mark truly deprecated with warnings

## Divergent Change

**Signs**:
- Class changes for different reasons
- Different teams modifying same class
- Changes to unrelated parts for different requirements
- Hard to describe single responsibility

**Solutions**:
- Split into multiple classes by reason for change
- Each class should have one reason to change
- Group methods that change together

## Shotgun Surgery

**Signs**:
- Change requires modifications in many places
- Similar changes in unrelated classes
- Difficult to make consistent changes
- Scattered related functionality

**Solutions**:
- Move related code closer together
- Extract common code to shared location
- Use inheritance or composition appropriately
- Consolidate scattered logic

## Feature Envy

**Signs**:
- Method uses more fields/methods from another class
- Method seems to belong elsewhere
- Tight coupling to external class

**Solutions**:
- Move method to class where it belongs
- Extract common functionality to shared utility
- Consider if accessor methods reveal design issue
- Review if class has proper boundaries

## Lazy Class

**Signs**:
- Class doesn't do much
- Minimal responsibility
- Class mainly delegates to another class
- Doesn't justify its existence

**Solutions**:
- Merge with another class if small
- Consolidate into parent class
- Remove if truly unnecessary
- Consider if it's placeholder for future functionality

## Data Clumps

**Signs**:
- Same variables appear together in multiple places
- Parameters that are always used together
- Fields that cluster in objects

**Solutions**:
- Extract Parameter Object or Class
- Group related data together
- Create domain object for cohesive data
- Pass object instead of individual pieces

## Primitive Obsession

**Signs**:
- Overuse of primitives (int, string, bool)
- Business logic scattered across primitives
- Validation duplicated for same type
- Magic values that should be objects

**Solutions**:
- Create domain objects (Money, Date, Address, etc.)
- Encapsulate validation in objects
- Use type system to prevent errors
- Replace type-checking with polymorphism

## Comments

**Signs**:
- Dense comments explaining what code does
- Comments contradict code
- Comments for obvious code
- Outdated comments

**Solutions**:
- Refactor code to be self-explanatory
- Use clear names instead of comments
- Delete obvious comments
- Keep comments for WHY, not WHAT
- Use comments for non-obvious business logic

## Detection Strategy

1. **Code Review**: Have another developer look
2. **Metrics**: Use linters for complexity, length
3. **IDE Analysis**: Built-in code analysis tools
4. **Read-Through**: Read code as if unfamiliar
5. **Test Difficulty**: If hard to test, likely has issues

## Prioritization

Refactor when:
1. Fixing bugs in that code
2. Adding related features
3. Preparing for major changes
4. Code blocks understanding of new work
5. Multiple team members complaining about it

Refactor less when:
- Code works and doesn't change
- Code is already clear and maintainable
- Time is extremely constrained
- Refactoring would break other dependencies
