# Planning Strategies

Effective planning is critical for successful feature implementation. This guide provides strategies for breaking down features into actionable tasks.

## Planning Approach

### 1. Understand the Requirement

Before planning implementation:
- Clarify the user's request - what problem does this feature solve?
- Identify the scope - what's included and excluded?
- Determine success criteria - how will we know it's complete?
- Ask questions early using **AskUserQuestion** if anything is unclear

### 2. Survey Existing Code

Use discovery tools to understand current patterns:

**Find Similar Features:**
```bash
# Search for similar functionality
grep -r "similar_pattern" src/

# Find files by naming convention
find . -name "*component*" -o -name "*service*"
```

**Understand File Structure:**
```bash
# List directory structure
ls -R src/ | less

# Find all TypeScript React components
find src/ -name "*.tsx" -type f

# Find all Python modules
find . -name "*.py" -not -path "./venv/*"
```

**Read Related Code:**
- Use **Read** to examine similar implementations
- Look for naming conventions, patterns, and styles
- Identify dependencies and imports
- Understand testing approaches

### 3. Identify Dependencies

Map out what the feature depends on:
- **Data Models**: What data structures are needed?
- **APIs/Services**: What external services or APIs are required?
- **UI Components**: What UI elements are needed (if applicable)?
- **Configuration**: Does this require config changes or environment variables?
- **Database**: Are schema changes or migrations needed?
- **Tests**: What test infrastructure exists?

### 4. Break Down into Sub-Tasks

Decompose the feature into logical units:

**Layer-Based Breakdown:**
1. Data layer (models, database, migrations)
2. Business logic layer (services, handlers, utilities)
3. API layer (endpoints, routes, controllers)
4. UI layer (components, pages, forms)
5. Testing layer (unit tests, integration tests)

**Flow-Based Breakdown:**
1. Input handling (validation, parsing)
2. Processing (business logic, transformations)
3. Storage (database writes, caching)
4. Output (API responses, UI rendering)
5. Error handling (edge cases, failures)

**Incremental Breakdown:**
1. Minimal viable implementation (happy path only)
2. Input validation and error handling
3. Edge cases and error scenarios
4. Performance optimization (if needed)
5. Documentation and tests

## Planning Patterns

### Small Feature Pattern
For simple, focused features:
1. Understand the requirement
2. Find similar code
3. Implement the change
4. Add tests
5. Verify it works

**Example:** Add a new field to an existing form
- Read existing form component
- Add new field with validation
- Update form submission handler
- Add test for new field
- Verify form works

### Medium Feature Pattern
For features spanning multiple files:
1. Plan the architecture (which files/modules)
2. Create task list for each component
3. Implement in order (data → logic → API → UI)
4. Write tests for each layer
5. Integration verification

**Example:** Add a new API endpoint with UI
- Plan: Backend endpoint, frontend service, UI component
- Tasks: Create endpoint, create service, create UI, add tests
- Implement: Backend first, then frontend
- Verify: Manual testing + automated tests

### Large Feature Pattern
For complex features requiring coordination:
1. Design the overall architecture
2. Identify integration points
3. Create detailed task breakdown
4. Implement incrementally with milestones
5. Continuous testing and verification

**Example:** Add authentication system
- Design: Choose auth method (JWT, session), database schema, API flow
- Integration: Identify all protected endpoints, UI login/logout flow
- Tasks: Database migrations, auth middleware, login API, protected routes, UI components, tests
- Milestones: Backend auth working, UI login working, protected routes working
- Verify: Security testing, edge cases, session management

## Task Creation Best Practices

When creating tasks with **TaskCreate**:

### Good Task Subjects
- Clear, actionable, imperative form
- "Add user authentication endpoint"
- "Create login form component"
- "Write tests for validation logic"
- "Update database schema for user roles"

### Poor Task Subjects
- Vague or unclear
- "Fix stuff"
- "Work on authentication"
- "Do the UI"

### Good Task Descriptions
- Specific scope and acceptance criteria
- "Implement POST /api/auth/login endpoint that accepts email/password, validates credentials, returns JWT token. Add error handling for invalid credentials and missing fields."

### Poor Task Descriptions
- Too vague or too detailed
- "Add login" (too vague)
- "Create endpoint at line 45 of server.js, import bcrypt, hash password with salt rounds 10..." (too prescriptive)

## Common Planning Mistakes

### Mistake: Planning Too Much Detail
**Problem**: Spending too much time on detailed plans that change during implementation

**Solution**: Plan at the right level - identify components and order, but stay flexible

### Mistake: Not Researching Existing Patterns
**Problem**: Implementing features inconsistently with the codebase

**Solution**: Always search for similar features first with **Grep** and **Glob**

### Mistake: Skipping Task Breakdown
**Problem**: Losing track of progress, forgetting steps

**Solution**: Use **TaskCreate** even for small features (3+ steps)

### Mistake: Planning in Isolation
**Problem**: Missing requirements or making wrong assumptions

**Solution**: Use **AskUserQuestion** early and often to clarify

### Mistake: Ignoring Testing
**Problem**: Features implemented without tests, breaking later

**Solution**: Always include testing tasks in the plan

## Planning Checklist

Before starting implementation, verify:
- [ ] Feature requirement is clear and understood
- [ ] Similar features found and examined
- [ ] Dependencies identified (data, APIs, UI, config)
- [ ] Tasks created with **TaskCreate**
- [ ] Task order makes sense (data before UI, tests included)
- [ ] Verification approach defined (how to test)
- [ ] Open questions resolved with **AskUserQuestion**

## Examples

### Example 1: Add Export Functionality

**Requirement**: "Add CSV export to the reports page"

**Planning:**
1. Find existing export code: `grep -r "export.*csv" src/`
2. Find reports page: `find . -name "*report*" -o -name "*Report*"`
3. Read existing export utilities
4. Identify: Export button UI, export API endpoint, CSV generation logic
5. Tasks:
   - Add export button to reports page UI
   - Create GET /api/reports/export endpoint
   - Implement CSV generation from report data
   - Add tests for CSV generation
   - Verify export downloads correctly

### Example 2: Add User Profile Page

**Requirement**: "Create a user profile page where users can update their name and email"

**Planning:**
1. Find similar pages: `find src/ -name "*Profile*" -o -name "*profile*"`
2. Find existing form components: `grep -r "TextField\|Input" src/components/`
3. Find user API endpoints: `grep -r "/api/users" src/`
4. Identify:
   - Profile page component (new)
   - Form with validation
   - API endpoint for PUT /api/users/:id
   - Navigation/routing update
5. Tasks:
   - Create ProfilePage component
   - Add form with name/email fields and validation
   - Create/update PUT /api/users/:id endpoint
   - Add route for /profile
   - Write tests for form validation
   - Write tests for API endpoint
   - Verify profile updates correctly

### Example 3: Add Real-Time Notifications

**Requirement**: "Add real-time notifications using WebSockets"

**Planning:**
1. Research WebSocket patterns: `grep -r "websocket\|WebSocket" .`
2. Check if WebSocket library exists: `cat package.json` or `cat requirements.txt`
3. Identify:
   - Backend WebSocket server setup
   - Frontend WebSocket client connection
   - Notification data structure
   - UI notification display component
   - Database storage for notifications
4. Tasks:
   - Set up WebSocket server (backend)
   - Create notification model and database migration
   - Implement notification sending logic
   - Create WebSocket client connection (frontend)
   - Build notification UI component
   - Add tests for notification delivery
   - Verify real-time updates work
5. Questions for user:
   - What events should trigger notifications?
   - Should notifications persist in database or be ephemeral?
   - What authentication is needed for WebSocket connection?

## See Also

- [Cross-Platform Commands](cross-platform-commands.md) - Bash/PowerShell command equivalents
- [Verification Patterns](verification-patterns.md) - Testing and verification approaches
- [assets/task-template.md](../assets/task-template.md) - Task creation examples
- [assets/plan-template.md](../assets/plan-template.md) - Planning output structure
