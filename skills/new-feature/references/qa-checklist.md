# QA Checklist

Comprehensive quality assurance checklist for reviewing features before completion.

## Code Quality Review

### Readability
- [ ] Variable and function names are clear and descriptive
- [ ] Code follows existing project conventions and style
- [ ] Complex logic has explanatory comments (only where needed)
- [ ] No commented-out code left in (delete unused code)
- [ ] No debug statements (console.log, print, etc.) left in

### Structure
- [ ] Code is organized logically
- [ ] Functions/methods are focused and do one thing
- [ ] No excessive nesting (max 3-4 levels)
- [ ] No duplicate code (DRY principle)
- [ ] Proper separation of concerns

### Error Handling
- [ ] User input is validated at system boundaries
- [ ] Error messages are clear and actionable
- [ ] No unhandled promise rejections or exceptions
- [ ] Error handling doesn't mask real issues
- [ ] No error handling for impossible scenarios

### Dependencies
- [ ] No unnecessary dependencies added
- [ ] Dependencies are up to date (no known vulnerabilities)
- [ ] Import statements are organized and clean
- [ ] No circular dependencies

## Security Review

### Input Validation
- [ ] All user input is validated
- [ ] Input validation uses allowlists when possible
- [ ] File uploads have type and size restrictions
- [ ] Query parameters are validated

### Injection Prevention
- [ ] SQL queries use parameterized statements (no string concatenation)
- [ ] Shell commands don't include unsanitized user input
- [ ] HTML output is properly escaped (XSS prevention)
- [ ] JSON parsing uses safe methods
- [ ] XML parsing prevents XXE attacks

### Authentication & Authorization
- [ ] Authentication checks are present where needed
- [ ] Authorization checks verify user permissions
- [ ] Password fields use proper input types
- [ ] Passwords are hashed (never stored plain text)
- [ ] Session tokens are secure and properly validated

### Data Protection
- [ ] Sensitive data is not logged
- [ ] API keys and secrets are not hard-coded
- [ ] HTTPS is used for sensitive communications
- [ ] Personal data handling complies with privacy requirements
- [ ] No sensitive data in URLs or query parameters

### Common Vulnerabilities (OWASP Top 10)
- [ ] No SQL injection vulnerabilities
- [ ] No Cross-Site Scripting (XSS) vulnerabilities
- [ ] No Cross-Site Request Forgery (CSRF) vulnerabilities
- [ ] No insecure deserialization
- [ ] No security misconfiguration
- [ ] No broken authentication
- [ ] No sensitive data exposure
- [ ] No broken access control

## Functionality Review

### Feature Completeness
- [ ] Feature meets all specified requirements
- [ ] Happy path works correctly
- [ ] Edge cases are handled
- [ ] Error cases are handled gracefully
- [ ] Feature works across supported browsers/platforms

### User Experience
- [ ] UI is intuitive and consistent
- [ ] Loading states are shown for async operations
- [ ] Error messages are user-friendly
- [ ] Success feedback is provided
- [ ] Forms have proper validation feedback

### Data Integrity
- [ ] Data is validated before storage
- [ ] Database constraints are properly set
- [ ] Transactions are used where needed
- [ ] Data migrations are reversible
- [ ] No data loss in error scenarios

## Testing Review

### Test Coverage
- [ ] New code has unit tests
- [ ] Tests cover happy path
- [ ] Tests cover edge cases
- [ ] Tests cover error conditions
- [ ] All tests pass locally

### Test Quality
- [ ] Tests are independent (no test interdependencies)
- [ ] Tests are deterministic (no flaky tests)
- [ ] Tests use descriptive names
- [ ] Tests are focused (test one thing)
- [ ] Test data is clear and minimal

### Manual Testing
- [ ] Feature tested manually in development
- [ ] Feature tested on different screen sizes (if UI)
- [ ] Feature tested on different browsers (if web)
- [ ] Feature tested with different user roles (if applicable)

## Performance Review

### Efficiency
- [ ] No unnecessary re-renders (React) or re-computations
- [ ] Database queries are optimized (use indexes, avoid N+1)
- [ ] No memory leaks (listeners cleaned up, refs released)
- [ ] Large lists are paginated or virtualized
- [ ] Images are optimized and lazy-loaded

### Scalability
- [ ] Feature handles large data sets
- [ ] Feature handles concurrent users
- [ ] No blocking operations on main thread
- [ ] Async operations are properly managed
- [ ] Resource cleanup happens properly

### Bundle Size (Frontend)
- [ ] No large libraries added unnecessarily
- [ ] Code splitting used for large features
- [ ] Tree shaking is effective
- [ ] Build output size is reasonable

## Documentation Review

### Code Documentation
- [ ] Complex algorithms have explanations
- [ ] Public APIs have documentation comments
- [ ] Type definitions are accurate (TypeScript/Python)
- [ ] Configuration options are documented

### Project Documentation
- [ ] README updated if feature affects setup
- [ ] API documentation updated (if applicable)
- [ ] Migration guide provided (if breaking change)
- [ ] Changelog updated

## Compatibility Review

### Browser Compatibility (Web)
- [ ] Works in Chrome/Edge
- [ ] Works in Firefox
- [ ] Works in Safari (if required)
- [ ] Polyfills included for older browsers (if needed)

### Platform Compatibility
- [ ] Works on Windows (if applicable)
- [ ] Works on macOS (if applicable)
- [ ] Works on Linux (if applicable)
- [ ] Works in Docker (if containerized)

### Dependency Compatibility
- [ ] Compatible with current Node.js/Python/.NET version
- [ ] Compatible with current framework version
- [ ] Compatible with other project dependencies
- [ ] No version conflicts

## Git and Version Control

### Commit Quality
- [ ] Commits are logical and focused
- [ ] Commit messages are descriptive
- [ ] No sensitive data in commits
- [ ] No large binary files added

### Branch Hygiene
- [ ] Branch is up to date with base branch
- [ ] No merge conflicts
- [ ] No unnecessary files committed (.env, node_modules, etc.)
- [ ] .gitignore is properly configured

## Deployment Readiness

### Configuration
- [ ] Environment variables documented
- [ ] Default configuration is sensible
- [ ] No hard-coded environment-specific values
- [ ] Feature flags configured correctly (if applicable)

### Database Changes
- [ ] Migrations are tested
- [ ] Migrations are backward compatible (if needed)
- [ ] Rollback plan exists for migrations
- [ ] Database backups taken before migration (production)

### Dependencies
- [ ] New dependencies documented in requirements
- [ ] Dependencies are installed in all environments
- [ ] Version pinning is appropriate

## Accessibility (If UI Feature)

### Keyboard Navigation
- [ ] All interactive elements are keyboard accessible
- [ ] Tab order is logical
- [ ] Keyboard shortcuts don't conflict
- [ ] Focus indicators are visible

### Screen Readers
- [ ] Semantic HTML used
- [ ] ARIA labels provided where needed
- [ ] Alt text on images
- [ ] Form labels are properly associated

### Visual Accessibility
- [ ] Color contrast meets WCAG standards
- [ ] Text is readable at different sizes
- [ ] No information conveyed by color alone
- [ ] UI is usable at 200% zoom

## Common Anti-Patterns to Avoid

### Over-Engineering
- [ ] No unnecessary abstractions
- [ ] No premature optimization
- [ ] No "what if" features not requested
- [ ] No complex frameworks for simple tasks

### Code Smells
- [ ] No god objects or classes
- [ ] No magic numbers (use named constants)
- [ ] No boolean parameters (use enums or objects)
- [ ] No long parameter lists (>3-4 parameters)
- [ ] No feature envy (method using more of another class than its own)

### Bad Practices
- [ ] No swallowed exceptions (empty catch blocks)
- [ ] No mutable global state
- [ ] No hard-coded values that should be configurable
- [ ] No copy-pasted code
- [ ] No TODO comments without tickets

## Review Sign-Off

After completing this checklist:

### Self-Review Completed
- [ ] Reviewed all changed files
- [ ] Tested manually
- [ ] All tests pass
- [ ] No linter errors or warnings
- [ ] Checklist items addressed or N/A

### Ready for Peer Review
- [ ] PR description is clear
- [ ] Screenshots/demos included (if UI change)
- [ ] Breaking changes documented
- [ ] Reviewers assigned

### Ready for Merge
- [ ] Peer review approved
- [ ] CI/CD pipeline passes
- [ ] No merge conflicts
- [ ] Deployed to staging (if applicable)

## Issue Triage

If issues found during QA:

### Critical (Block Merge)
- Security vulnerabilities
- Data corruption or loss
- Feature doesn't work
- Breaking changes without migration

### Major (Fix Before Merge)
- Significant bugs in main functionality
- Performance regressions
- Test failures
- Linter errors

### Minor (Can Address Later)
- Minor UI issues
- Non-critical edge cases
- Code style improvements
- Documentation updates

### Nice to Have
- Performance optimizations
- Additional test coverage
- Refactoring opportunities

## Tools for QA

### Automated Tools
```bash
# Run all checks
npm run lint && npm run type-check && npm test

# Security audit
npm audit
pip-audit

# Code complexity
npx complexity-report src/
radon cc src/

# Dependency analysis
npm ls
pip list
```

### Manual Review Tools
- Chrome DevTools (Performance, Network, Console)
- React DevTools / Vue DevTools
- Lighthouse (Performance, Accessibility, SEO)
- Browser accessibility testing tools
- Database query analyzers

## See Also

- [Verification Patterns](verification-patterns.md) - Testing and verification commands
- [Planning Strategies](planning-strategies.md) - Quality planning from the start
- [Cross-Platform Commands](cross-platform-commands.md) - Running verification commands
