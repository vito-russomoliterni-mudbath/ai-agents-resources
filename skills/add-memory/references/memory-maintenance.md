# Memory Maintenance: Keeping Documentation Fresh

Strategy for reviewing and updating stored knowledge over time.

## Why Maintenance Matters

- Outdated documentation is worse than no documentation
- Team patterns evolve; guidance should too
- Links break, tools get updated, practices change
- Memory consistency prevents confusion

## Maintenance Schedule

### Monthly (Quick Review - 5-10 min)

**What to Check**:
- Any obvious typos?
- Any broken links?
- Any obvious contradictions?
- Any recent code changes affecting guidance?

### Quarterly (Full Review - 30-60 min)

**What to Review**:
- All code conventions still relevant?
- Tools/versions still current?
- Architecture decisions still valid?
- Entries that need updating?
- New patterns discovered?
- Any guidance that's deprecated?

### Semi-Annual (Refresh - 1-2 hours)

**What to Do**:
1. Compare against actual codebase
2. Check if team consensus shifted
3. Consolidate redundant entries
4. Update critical links
5. Consider moving to structured docs

### Annual (Deep Audit - 3-4 hours)

**What to Audit**:
1. Completeness: Are there gaps?
2. Accuracy: Does docs match practices?
3. Currency: Are tools/versions current?
4. Organization: Is structure logical?
5. Clarity: Is everything understandable?
6. Relevance: Should entries be archived?

## Deprecation Process

### Marking Outdated Guidance

```markdown
**DEPRECATED**: Use [New Pattern] instead. Reason: [why]
```

### Lifecycle

1. **Discovery**: Notice pattern is no longer recommended
2. **Mark**: Add DEPRECATED notice
3. **Keep**: For 1-2 cycles (months/quarters)
4. **Archive**: Move to Archived section
5. **Remove**: Delete after long enough

## Common Maintenance Tasks

### Updating Versions

Old:
```markdown
**Version**: 1.6.0
```

New:
```markdown
**Version**: 2.0+ (updated 2026-02)
```

### Adding New Discoveries

```markdown
**Discovered**: 2026-02-15 during [context]

**The Pattern**: [Documentation]
```

### Fixing Contradictions

1. Find all conflicting entries
2. Discuss why they differ
3. Decide which is correct
4. Update incorrect guidance
5. Tell team about change

### Consolidating Duplication

1. Keep most authoritative version
2. Link other locations to main version
3. Add cross-references
4. Delete redundant copies

## Tools for Maintenance

### Check for Broken Links

```bash
# Find all markdown links
grep -r "\[.*\](.*)" CLAUDE.md docs/

# Manually verify or use IDE detection
```

### Find Outdated References

```bash
# Search for old versions
grep -r "v1\." CLAUDE.md docs/

# Search for deprecated
grep -r "deprecated\|legacy" -i CLAUDE.md docs/
```

## Maintenance Checklist

### Quick Monthly
- [ ] Any obvious typos?
- [ ] Any broken links?
- [ ] Any obvious contradictions?
- [ ] Recent code changes?

### Quarterly Review
- [ ] Versions current?
- [ ] New team patterns?
- [ ] Experimental items proven?
- [ ] Examples accurate?
- [ ] Unclear entries need help?
- [ ] Anything to archive?

### Semi-Annual Refresh
- [ ] Code follows docs?
- [ ] Team consensus shifted?
- [ ] Move anything to structured docs?
- [ ] Consolidate redundancy?
- [ ] Update links?

### Annual Audit
- [ ] Every entry accurate?
- [ ] All links working?
- [ ] Organization logical?
- [ ] Missing sections?
- [ ] Need reorganization?
- [ ] Still relevant?

## Preventing Outdated Documentation

### At Decision Time
- Document WHY (helps future reviewers)
- Include versions
- Note date and context
- Plan review if experimental

### During Code Review
- Reviewer: "Does docs match this code?"
- Update either docs or code
- Never let them diverge

### When Tools Change
- Update immediately
- Add migration notes if breaking
- Update examples
- Note date

## Responsibilities

| Task | Owner | Frequency |
|---|---|---|
| Fix typos | Anyone | Immediately |
| Fix links | Anyone | Immediately |
| Check contradictions | Tech lead | Monthly |
| Update versions | Expert | After upgrade |
| Add patterns | Team | As discovered |
| Quarterly review | Module owner | Every 3 months |
| Annual audit | Tech lead | Annually |

## Success Indicators

Good documentation maintenance when:
- Team members reference it regularly
- Code matches documented practices
- Links all work
- Versions are current
- No major contradictions
- Updates happen within weeks
- Team gives input on relevance
