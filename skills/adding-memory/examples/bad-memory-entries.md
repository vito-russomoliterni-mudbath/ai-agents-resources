# Bad Memory Entries: What Not to Do

Learn from poor documentation examples and how to improve them.

## Example 1: Too Vague

### Bad Entry

```markdown
### Write Good Code

Always write good, clean code that is maintainable and follows best practices.
```

**Problems**:
- What does "good code" mean?
- Doesn't tell you what to actually do
- No example to clarify
- Not specific to this project
- Impossible to verify compliance
- Everyone has different definition

### Better Version

```markdown
### Naming Reveals Intent

Use clear, descriptive names for variables and functions. Names should answer:
"What does this contain?" or "What does this do?"

**Good**:
```python
user_registration_date = datetime.now()
def calculate_monthly_revenue(orders):
    return sum(order.amount for order in orders)
```

**Bad**:
```python
d = datetime.now()  # What is d?
def calc(orders):  # What gets calculated?
    return sum(orders)
```

**Why**: Clear names make code self-documenting. New developers understand purpose without reading implementation.

**Related**: Reduce Comments, Extract Methods
```

## Example 2: Too Specific

### Bad Entry

```markdown
### Use Version 2.1.0 of Lodash

We determined that 2.1.0 has the exact performance we need for our use case.
Don't use 3.0.0.
```

**Problems**:
- Will be outdated soon
- Doesn't explain why
- Doesn't mention when to upgrade
- No guidance for similar decisions
- Specific version numbers don't belong in guidelines

### Better Version

```markdown
### Minimize External Dependencies

Add a new library only if:
1. Solves a problem that's hard to solve ourselves
2. Actively maintained by reputable team
3. Code review approves the addition

**Why**: Reduces:
- Security attack surface
- Dependency resolution issues
- Build size
- Onboarding complexity

**Current Dependencies**: See package.json for versions (auto-updated)

**New Dependencies**: Propose in RFC or design doc with justification
```

## Example 3: Contradicts Existing Documentation

### Bad Entry (Newer)

```markdown
### Always Use .then() for Callbacks

.then() chains are clearer than async/await and more familiar to JavaScript developers.
```

### Existing Entry

```markdown
### Use async/await, Not .then()

Async/await is more readable and has better error handling.
```

**Problems**:
- Contradicts existing guidance
- No explanation for new approach
- Creates team confusion
- Will cause code review conflicts

### Fix

1. Determine which is actually correct (async/await is modern best practice)
2. Update contradicting entry:

```markdown
### Use async/await, Not .then()

Async/await provides:
- More readable code (looks synchronous)
- Better error handling (try/catch)
- Better stack traces

Project standard: async/await only. .then() was previously used but deprecated in 2026-01.
```

3. Add note to old pattern:

```markdown
### Legacy: Using .then() Callbacks

DEPRECATED: See "Use async/await, Not .then()" for current standard.

Previous approaches are in git history if you need examples.
```

## Example 4: No Context

### Bad Entry

```markdown
### Cache Everything

Performance: 5x faster
```

**Problems**:
- 5x faster than what?
- Cache everything?? (cache invalidation is hard)
- When to use this?
- How to implement?
- No actual guidance

### Better Version

```markdown
### Cache Frequently-Accessed Database Queries

**Situation**: User lookups happen 100+ times per second

**Optimization**: Cache with 5-minute TTL using Redis

**Performance Impact**:
- Before: 50ms per lookup
- After: 1ms per lookup (from cache)
- Improvement: 50x faster

**Implementation**:
```python
def get_user(user_id):
    # Check cache first
    cached = redis.get(f"user:{user_id}")
    if cached:
        return json.loads(cached)

    # Fetch from DB
    user = db.query(User).filter_by(id=user_id).first()

    # Store in cache
    if user:
        redis.setex(
            f"user:{user_id}",
            300,  # 5 minutes
            json.dumps(user.to_dict())
        )

    return user
```

**Cache Invalidation**: Clear user cache when record updates

**When NOT to use**: Real-time data (prices, inventory), infrequent access
```

## Example 5: No Way to Verify

### Bad Entry

```markdown
### Keep It Simple

Always keep code simple and understandable.
```

**Problems**:
- Subjective - what's "simple"?
- Can't verify if someone followed it
- No actionable advice
- Every developer has different definition

### Better Version

```markdown
### Extract Complex Logic into Named Functions

**Rule**: If a code block needs 2+ lines of comment to explain, extract it.

**Example**:
```javascript
// BAD: Complex logic without extraction
if (user.role === 'admin' || (user.role === 'moderator' && post.author === user.id)) {
    canDelete = true;
}

// GOOD: Logic extracted and named
function canUserDeletePost(user, post) {
    const isAdmin = user.role === 'admin';
    const isModerator = user.role === 'moderator' && post.author === user.id;
    return isAdmin || isModerator;
}

if (canUserDeletePost(user, post)) {
    canDelete = true;
}
```

**Verification**: Code review checks that complex logic is extracted and named
```

## Example 6: Outdated Without Notice

### Bad Entry (Never Updated)

```markdown
### Use Redux for State Management

Version: Redux 4.0

Best way to manage complex state in React applications.
```

**Problems**:
- Redux 4.0 was released 5+ years ago
- Redux Toolkit is now preferred
- No indication when last reviewed
- Team members might follow outdated guidance

### Better Version

```markdown
### Use Redux Toolkit for State Management

Modern Redux requires significant boilerplate. Redux Toolkit eliminates this.

**Current version**: 1.9 (updated 2026-02)

When to use:
- Large application with complex state
- Need time-travel debugging
- Team familiarity with Redux

Alternatives:
- Zustand: Smaller/simpler apps
- Jotai: Atomic state management
- Context API: Simple local state

**See also**: Redux DevTools, Reducer Patterns

**Last Reviewed**: 2026-02 (still current)

**Review Schedule**: Quarterly (next: 2026-05)
```

## Example 7: Implies Rather Than States

### Bad Entry

```markdown
### Error Handling

Our error handling is comprehensive and handles all edge cases appropriately.
```

**Problems**:
- What does "comprehensive" mean?
- No specific guidance
- Implies standards exist but doesn't state them
- No way to verify compliance

### Better Version

```markdown
### Error Handling Standards

All functions must explicitly handle errors:

**Rule 1: Catch Errors in Async Functions**
```python
async def fetch_data():
    try:
        return await get_data()
    except ConnectionError as e:
        logger.error("Failed to fetch data", exc_info=True)
        raise  # Re-raise or return default
```

**Rule 2: Return Error Responses in APIs**
```python
@app.post("/users")
def create_user(data):
    try:
        user = save_user(data)
        return {"status": "success", "user": user}
    except ValidationError as e:
        return {"status": "error", "message": str(e)}, 400
```

**Rule 3: Log All Errors with Context**
```python
logger.error("Failed to process order", extra={
    "order_id": order.id,
    "user_id": user.id,
    "error": str(error)
})
```

**Verification**: Code review checks all error paths are handled
```

## Improvement Checklist

When reviewing entry for quality:

### Clarity
- [ ] Clear title describing topic
- [ ] Explains what to do
- [ ] Explains why to do it
- [ ] Would a new developer understand?
- [ ] No ambiguous terms

### Specificity
- [ ] Specific to this project
- [ ] Not generic advice
- [ ] Actionable steps
- [ ] Measurable/verifiable

### Completeness
- [ ] Good example included
- [ ] Bad example shown
- [ ] Exceptions mentioned
- [ ] Related entries linked

### Currency
- [ ] Reflects actual practice
- [ ] Versions up to date
- [ ] Links work
- [ ] Not contradicted elsewhere
- [ ] Not outdated (or marked as such)

### Usability
- [ ] Clear section placement
- [ ] Easy to find/search
- [ ] Formatted consistently
- [ ] Cross-referenced

## Template: Fixing Bad Entries

If you find a bad entry, fix it:

1. **Identify**: What's wrong? (vague, outdated, contradicting, etc.)
2. **Research**: What's the actual practice/standard?
3. **Rewrite**: Using appropriate template
4. **Review**: Does it meet quality checklist?
5. **Commit**: With message explaining change

Example commit:
```
docs: clarify error handling standards

Replaced vague error handling entry with specific rules,
examples, and verification approach. Entry was too generic
to be actionable.
```
