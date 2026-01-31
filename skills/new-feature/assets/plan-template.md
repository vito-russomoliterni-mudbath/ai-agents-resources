# Plan Template

This template shows how to structure implementation plans for features.

## Planning Output Structure

When planning a feature implementation, organize the plan with:

1. **Feature Overview**: What is being built and why
2. **Approach**: High-level strategy
3. **Components**: What will be built
4. **Implementation Steps**: Ordered breakdown
5. **Verification Strategy**: How to test it works
6. **Dependencies**: External requirements
7. **Risks/Considerations**: Potential issues

---

## Example Plan: User Authentication Feature

### Feature Overview

Implement user authentication system allowing users to:
- Register new accounts with email/password
- Log in to existing accounts
- Maintain authenticated sessions
- Log out securely

This provides the foundation for user-specific features and access control.

### Approach

- Use JWT (JSON Web Tokens) for stateless authentication
- Store password hashes using bcrypt
- Implement rate limiting to prevent brute force attacks
- Use HTTP-only cookies for token storage (XSS protection)
- Add middleware for protecting routes

### Components

**Backend:**
- User model with password hashing
- Authentication service (register, login, verify token)
- Auth middleware for protected routes
- API endpoints:
  - POST /api/auth/register
  - POST /api/auth/login
  - POST /api/auth/logout
  - GET /api/auth/me (get current user)

**Frontend:**
- Login form component
- Register form component
- Authentication context/store
- Protected route wrapper
- Auth service for API calls

**Database:**
- Users table (if doesn't exist)
- Indexes on email for fast lookup

### Implementation Steps

#### Phase 1: Backend Foundation
1. Create User model with password hashing
2. Create database migration for users table
3. Implement authentication service (register, login, token generation)
4. Add unit tests for auth service

#### Phase 2: API Layer
5. Create POST /api/auth/register endpoint
6. Create POST /api/auth/login endpoint
7. Create POST /api/auth/logout endpoint
8. Create GET /api/auth/me endpoint
9. Implement auth middleware for route protection
10. Add API integration tests

#### Phase 3: Frontend Implementation
11. Create authentication context/store
12. Build LoginForm component
13. Build RegisterForm component
14. Create auth API service
15. Implement protected route wrapper
16. Add form validation

#### Phase 4: Integration & Testing
17. Integrate auth with existing protected routes
18. Manual testing of complete flow
19. Add E2E tests (if applicable)
20. Security review (OWASP checklist)

#### Phase 5: Polish
21. Add loading states and error handling
22. Implement "remember me" functionality (optional)
23. Add password strength indicator (optional)
24. Update documentation

### Verification Strategy

**Unit Tests:**
- Password hashing and comparison
- Token generation and validation
- User registration logic
- Login validation logic

**Integration Tests:**
- Complete registration flow
- Complete login flow
- Protected route access with valid token
- Protected route rejection without token
- Logout clears authentication

**Manual Testing:**
- Register new user via UI
- Login with valid credentials
- Login with invalid credentials (error handling)
- Access protected pages when authenticated
- Cannot access protected pages when not authenticated
- Logout removes authentication
- Session persistence across page reloads

**Security Testing:**
- Passwords are hashed (not stored in plain text)
- SQL injection attempts fail
- XSS attempts fail
- Rate limiting works
- CSRF protection (if needed)

### Dependencies

**Backend:**
- bcrypt (password hashing)
- jsonwebtoken (JWT generation/validation)
- express-rate-limit (rate limiting)

**Frontend:**
- react-hook-form (form management)
- yup (validation schema)
- State management library (Redux/Zustand/Jotai)

**Database:**
- PostgreSQL/MySQL/MongoDB (existing database)

### Risks & Considerations

**Security:**
- Must use HTTPS in production
- Token expiration needs to be configured appropriately
- Refresh token strategy may be needed for long sessions
- Account lockout after failed attempts?

**Performance:**
- bcrypt rounds should balance security vs performance (10-12 rounds)
- Database queries need indexes on email
- Token verification on every request adds overhead

**User Experience:**
- Password reset flow needed? (out of scope for v1)
- Email verification needed? (out of scope for v1)
- Social auth needed? (out of scope for v1)

**Compatibility:**
- Works with existing API structure
- Frontend routing needs update for login/register routes
- May affect existing user-related features

---

## Example Plan: CSV Export Feature

### Feature Overview

Add CSV export functionality to the reports page, allowing users to download report data in CSV format for analysis in Excel or other tools.

### Approach

- Add "Export" button to reports page
- Create backend endpoint to generate CSV from report data
- Use streaming for large datasets
- Include proper headers for Excel compatibility
- Sanitize data to prevent CSV injection

### Components

**Backend:**
- CSV generation utility
- GET /api/reports/:id/export endpoint
- Streaming response for large files

**Frontend:**
- Export button on reports page
- Download progress indicator
- Error handling for failed exports

### Implementation Steps

1. Search for existing CSV export code with `grep -r "csv" src/`
2. Create CSV generation utility (or use existing library)
3. Implement GET /api/reports/:id/export endpoint
4. Add CSV injection protection
5. Add export button to reports page UI
6. Implement download trigger
7. Add loading state during export
8. Test with small dataset
9. Test with large dataset (10k+ rows)
10. Add unit tests for CSV generation
11. Add integration test for export endpoint

### Verification Strategy

**Unit Tests:**
- CSV generation from data array
- CSV escaping (quotes, commas, newlines)
- CSV injection prevention

**Integration Tests:**
- Export endpoint returns valid CSV
- Export endpoint handles errors
- Export includes all expected data

**Manual Testing:**
- Download CSV for small report (< 100 rows)
- Download CSV for large report (> 10,000 rows)
- Open CSV in Excel
- Verify all columns present
- Verify data accuracy
- Test with special characters (quotes, commas)

### Dependencies

**Backend:**
- csv-writer or fast-csv (Node.js)
- or csv module (Python)
- or CsvHelper (.NET)

**Frontend:**
- No new dependencies (use native download)

### Risks & Considerations

**Performance:**
- Large exports may timeout - use streaming
- May need pagination or background job for very large datasets

**Data:**
- CSV has no standardized date format - document format used
- Special characters need escaping
- Excel has row limits (1,048,576 rows) - document if reports can exceed

**Security:**
- CSV injection risk - sanitize formulas (=, +, -, @)
- Ensure user has permission to export this report
- PII/sensitive data in exports?

---

## Planning Checklist

Before starting implementation from a plan:

- [ ] Feature overview clearly states what and why
- [ ] Approach chosen and justified
- [ ] All components identified (backend, frontend, database)
- [ ] Steps are ordered logically
- [ ] Verification strategy covers functionality and security
- [ ] Dependencies identified
- [ ] Risks documented
- [ ] Open questions resolved or documented
- [ ] Tasks created from plan steps

## See Also

- [Planning Strategies](../references/planning-strategies.md) - Detailed planning guidance
- [Task Template](task-template.md) - Converting plan steps to tasks
- [Verification Patterns](../references/verification-patterns.md) - Testing strategies
