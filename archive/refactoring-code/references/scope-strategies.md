# Scope Strategies for Refactoring

How to determine the size and scale of refactoring work.

## Scope Levels

### Level 1: Single Function/Method

**Indicators**:
- Function > 50 lines
- Function has multiple concerns
- Function is hard to test
- Function's name doesn't match what it does

**Typical Duration**: 30-60 minutes

**Example**: Extract validation and calculation from single 65-line function into multiple focused functions

**Scope Decision**:
- Safe bet for single refactoring session
- Minimal risk of breaking other code
- Easy to test and verify

### Level 2: Related Functions/Class

**Indicators**:
- Multiple functions in same module share concerns
- Class has 2-3 mixed responsibilities
- Functions duplicate similar logic
- Related to same feature or domain

**Typical Duration**: 2-4 hours

**Example**: Separating UserManager class into UserValidator, UserRepository, UserNotifier, UserReporter

**Scope Decision**:
- One refactoring session or short pair programming
- Requires understanding multiple functions
- Higher impact on codebase

### Level 3: Module/Package

**Indicators**:
- Entire module could be reorganized
- Multiple classes with mixed concerns
- Module has grown organically over time
- Clear but scattered domain concept

**Typical Duration**: 1-3 days

**Example**: Reorganizing users module into separate repository, service, validator, models

**Scope Decision**:
- Multiple sessions or team effort
- Requires coordination with other developers
- Consider splitting PR or feature branch

### Level 4: Cross-Module/System

**Indicators**:
- Refactoring affects 5+ files
- Touches multiple domain concepts
- Changes shared interfaces/contracts
- Risk of breaking dependent systems

**Typical Duration**: Several days or weeks

**Scope Decision**:
- Requires planning and team consensus
- Break into smaller tasks if possible
- Coordinate with dependent teams
- May need migration period

## Scope Decision Matrix

| Scope | Duration | Risk | Complexity | When to Use |
|-------|----------|------|-----------|------------|
| Single Function | 30-60 min | Low | Simple | Regular maintenance |
| Related Functions | 2-4 hours | Medium | Moderate | Feature work |
| Module | 1-3 days | Medium-High | High | Planned refactoring |
| System | 1+ weeks | High | Very High | Major restructuring |

## Bounding Your Scope

### Too Large? Break Down By:

1. **Feature**: Refactor one feature path at a time
2. **Module**: Tackle one module per session
3. **Responsibility**: Extract one responsibility per PR
4. **File**: Refactor one file completely before next
5. **Concern**: Separate one concern at a time

### Too Small? Combine With:

1. **Related Methods**: Extract multiple related methods
2. **Same Module**: Refactor entire module organization
3. **Same Responsibility**: Move all instances of concern

### Check Scope Size

**Questions to Ask**:
- Can I complete in single session? (4-6 hours)
- Can I test after each step? (Yes = good size)
- Will this PR be reviewable? (< 400 lines changed = good)
- Can I explain changes in 1-2 minutes? (Yes = right scope)
- Will other developers need to know about this? (Consider communication)

If answer to any is "no", consider breaking down further.

## Phasing for Large Refactoring

### Phase 1: Prepare

1. Add tests for current behavior
2. Identify all locations to change
3. Create detailed refactoring plan
4. Communicate with team

### Phase 2: Extract Common

1. Create new shared code
2. Make both old and new work in parallel
3. Test thoroughly

### Phase 3: Migrate Incrementally

1. Update one module to use new code
2. Verify tests pass
3. Commit
4. Repeat for each module

### Phase 4: Clean Up

1. Remove old code
2. Update documentation
3. Final testing

### Phase 5: Communicate

1. Document what changed
2. Update architectural docs
3. Explain to team

## Scope Red Flags

### Sign You're Going Too Big

- "This refactoring will take weeks"
- Can't describe scope in one sentence
- Multiple responsibilities being addressed
- PR would be 1000+ lines
- Need major design discussions
- Affects multiple teams

**Solution**: Break into smaller, independent tasks

### Sign You're Too Small

- Change is trivial (single variable rename)
- No meaningful improvement to code
- Gets lost in other changes
- Doesn't address root issue

**Solution**: Combine with related work or defer

## Scope and PR Size

### Single Commit
- Changes only to one file
- Changes to multiple functions in same file
- Related refactoring without breaking changes

### Multiple Commits
- Extract then rename (2 commits)
- Create new class, then migrate callers (2+ commits)
- One commit per logical step

### Single PR
- Scope fits comfortably in 1-2 hours review
- All changes related to single concern
- < 400 lines changed (guideline)

### Multiple PRs
- Large refactoring in phases
- Independent refactorings in series
- Each PR reviewable independently

## Estimating Your Scope

### Time Estimation

1. **Identify changes needed**: 10-15 minutes
2. **Per-change refactoring**: 5-10 minutes each
3. **Testing per change**: 2-5 minutes each
4. **Integration/cleanup**: 10-20 minutes
5. **Buffer** (unexpected issues): +30%

Example: 5 changes = 1.5-2.5 hours
