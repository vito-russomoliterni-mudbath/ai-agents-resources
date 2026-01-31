# Task Template

This template shows examples of well-structured tasks for feature implementation.

## Task Structure

Each task should have:
- **subject**: Clear, actionable, imperative form (verb phrase)
- **description**: Detailed scope, acceptance criteria, and context
- **activeForm**: Present continuous form for progress spinner (gerund phrase)

## Examples

### Example 1: Backend API Endpoint

**Subject**: "Add user authentication endpoint"

**Description**:
```
Implement POST /api/auth/login endpoint that:
- Accepts email and password in request body
- Validates credentials against database
- Returns JWT token on success
- Returns 401 with error message on failure
- Includes rate limiting (5 attempts per minute)
- Logs authentication attempts
```

**ActiveForm**: "Adding user authentication endpoint"

---

### Example 2: Frontend Component

**Subject**: "Create user profile form component"

**Description**:
```
Build UserProfileForm component that:
- Displays name, email, and bio fields
- Implements form validation (required fields, email format)
- Shows inline validation errors
- Submits to PUT /api/users/:id endpoint
- Shows loading state during submission
- Displays success/error messages
- Matches existing form styling patterns
```

**ActiveForm**: "Creating user profile form component"

---

### Example 3: Database Migration

**Subject**: "Create user_roles table migration"

**Description**:
```
Create migration for user_roles table with:
- id (primary key, auto-increment)
- user_id (foreign key to users table)
- role (enum: 'admin', 'editor', 'viewer')
- created_at (timestamp)
- Unique constraint on (user_id, role)
- Index on user_id
- Migration should be reversible (down method)
```

**ActiveForm**: "Creating user_roles table migration"

---

### Example 4: Testing Task

**Subject**: "Add unit tests for authentication service"

**Description**:
```
Write unit tests for AuthService covering:
- Successful login with valid credentials
- Failed login with invalid password
- Failed login with non-existent user
- Token generation and validation
- Password hashing
- Rate limiting behavior
- Minimum 80% code coverage for the service
```

**ActiveForm**: "Adding unit tests for authentication service"

---

### Example 5: Verification Task

**Subject**: "Verify feature works in all browsers"

**Description**:
```
Manual testing of authentication feature in:
- Chrome (latest)
- Firefox (latest)
- Safari (if macOS available)
- Edge (latest)
Test cases:
- Login with valid credentials
- Login with invalid credentials
- Session persistence
- Logout functionality
- Token expiration handling
```

**ActiveForm**: "Verifying feature in all browsers"

---

### Example 6: Integration Task

**Subject**: "Integrate authentication with protected routes"

**Description**:
```
Update protected routes to use authentication:
- Add auth middleware to protected API endpoints
- Redirect unauthenticated users to login page
- Preserve intended destination for post-login redirect
- Handle token expiration gracefully
- Update all existing protected routes (/dashboard, /profile, /settings)
- Test that public routes remain accessible
```

**ActiveForm**: "Integrating authentication with protected routes"

---

## Task Breakdown Patterns

### Small Feature (2-4 tasks)
1. Implement core functionality
2. Add tests
3. Verify and document

### Medium Feature (5-8 tasks)
1. Plan and design approach
2. Implement backend logic
3. Create database migration (if needed)
4. Implement frontend UI
5. Add unit tests (backend and frontend)
6. Integration testing
7. Verify in multiple environments
8. Update documentation

### Large Feature (9+ tasks)
1. Research and design architecture
2. Create database schema changes
3. Implement data access layer
4. Implement business logic layer
5. Create API endpoints
6. Build frontend services
7. Create UI components
8. Add comprehensive tests (unit, integration)
9. Manual QA testing
10. Performance testing
11. Security review
12. Documentation and examples

## Task Dependencies

Use **TaskUpdate** with `addBlockedBy` to set dependencies:

```
Task 1: Create database migration
Task 2: Implement data access layer (blocked by Task 1)
Task 3: Implement business logic (blocked by Task 2)
Task 4: Create API endpoints (blocked by Task 3)
Task 5: Build UI components (blocked by Task 4)
Task 6: Add tests (blocked by Tasks 3, 4, 5)
```

This ensures:
- Database schema exists before data access code
- Data access exists before business logic
- Business logic exists before API
- API exists before UI
- Tests can cover all layers

## Anti-Patterns (Avoid These)

### ❌ Bad Task Subject
- "Work on authentication" (too vague)
- "Fix stuff" (unclear)
- "Implement the login endpoint at line 45 of server.js using bcrypt..." (too prescriptive)

### ✅ Good Task Subject
- "Add user authentication endpoint"
- "Fix login validation error"
- "Implement JWT token generation"

### ❌ Bad Task Description
- "Add login" (no details)
- "Make it work" (no acceptance criteria)
- Too much implementation detail (should allow flexibility)

### ✅ Good Task Description
- Clear scope and boundaries
- Specific acceptance criteria
- Context about why the task matters
- Flexibility in how to implement

### ❌ Bad ActiveForm
- "Login endpoint" (not a gerund phrase)
- "Will add authentication" (future tense, not present continuous)
- "Added authentication" (past tense)

### ✅ Good ActiveForm
- "Adding user authentication endpoint"
- "Creating login form component"
- "Writing tests for validation"

## Task Status Flow

**pending** → **in_progress** → **completed**

- **pending**: Task created but not started
- **in_progress**: Currently working on this task (use TaskUpdate when you start)
- **completed**: Task finished and verified (use TaskUpdate when done)

## Tips

1. **Break down large tasks**: If a task takes more than 1-2 hours, split it
2. **Include verification**: Add testing/verification tasks explicitly
3. **Order matters**: Create tasks in implementation order
4. **Be specific**: Clear acceptance criteria prevent confusion
5. **Stay flexible**: Describe what, not exactly how
6. **Update status**: Mark tasks in_progress when starting, completed when done
7. **Use dependencies**: Set blockedBy for tasks that depend on others

## See Also

- [Planning Strategies](../references/planning-strategies.md) - Breaking down features into tasks
- [Verification Patterns](../references/verification-patterns.md) - Creating verification tasks
- [assets/plan-template.md](plan-template.md) - Planning output structure
