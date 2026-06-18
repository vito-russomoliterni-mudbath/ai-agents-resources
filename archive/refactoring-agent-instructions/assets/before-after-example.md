# Before/After Example: Refactoring a Bloated Agent File

This document shows a real transformation: a 350+ line monolithic CLAUDE.md file refactored into progressive disclosure structure with a lean root file + 4 detailed guides.

---

## The Problem: Bloated File

### Original CLAUDE.md (349 lines, ~5,200 tokens)

Many agent instruction files grow organically, accumulating details that should be linked. This is the **BEFORE** state:

```markdown
# MyProject - Comprehensive Agent Instructions

## Overview
MyProject is a full-stack web application with React frontend, Node.js backend, PostgreSQL database,
and Docker containerization. This document contains ALL guidance for working with the codebase.

## Quick Start
```bash
npm install
npm run dev
npm run build
npm test
```

## Prerequisites
- Node.js 18+
- npm 8+
- Docker 20+
- PostgreSQL 14+

## Project Structure
The project is organized as follows:
- `frontend/` - React application with TypeScript
- `backend/` - Express.js server
- `database/` - PostgreSQL migrations
- `docker/` - Docker configuration
- `tests/` - Test suite

## Frontend Development

### Running the Frontend
```bash
cd frontend
npm install
npm run dev
```

### TypeScript Conventions
All frontend code must follow these rules:

1. Always use explicit types - never use `any`
2. Use interfaces for component props
3. Use discriminated unions for complex state
4. Never use `var`, only `const` and `let`
5. Function return types must be explicit
6. Use `unknown` instead of `any` for uncertain types
7. Import ordering: React, external libs, internal modules
8. Use PascalCase for component names, camelCase for functions
9. Props interfaces should end with "Props"
10. All interfaces should be exported from a types.ts file

### React Component Patterns
Components must follow these rules:

1. Use functional components only (no class components)
2. Use hooks for all state management
3. Components must have prop types defined
4. Extract complex logic into custom hooks
5. Use React.memo for performance-critical components
6. Event handlers should be prefixed with "handle"
7. Always include loading and error states
8. Use composition over inheritance
9. Components should be in their own directory with index.ts
10. CSS modules should co-locate with components

### Testing Frontend Code
Tests should follow Vitest patterns:

1. Use describe() to group related tests
2. Test behavior, not implementation
3. Mock external dependencies
4. Use render() from @testing-library/react
5. Use fireEvent for user interactions
6. Each test should be independent
7. Test names should describe the behavior
8. Don't test component internals
9. Test user-facing text content
10. 80% coverage target for components

### State Management
We use Redux Toolkit:

1. One store per application
2. Slices for domain-specific state
3. Selectors for accessing state
4. Async thunks for side effects
5. Normalize data in store
6. Use immer in reducers
7. Avoid deeply nested state
8. Use reselect for memoized selectors
9. Test reducers and selectors separately
10. Actions should describe what happened

## Backend Development

### Running the Backend
```bash
cd backend
npm install
npm run dev
```

### Express.js Best Practices
All backend code must follow:

1. Use middleware for cross-cutting concerns
2. Organize routes into separate files
3. Controllers handle HTTP concerns
4. Services contain business logic
5. Repositories handle data access
6. Use dependency injection
7. Validate all inputs
8. Handle errors with middleware
9. Return consistent response formats
10. Use async/await, never callbacks

### API Design
All APIs must:

1. Use RESTful conventions
2. Use appropriate HTTP methods (GET, POST, PUT, DELETE)
3. Return correct status codes (200, 201, 400, 404, 500)
4. Include error messages in response
5. Use pagination for list endpoints
6. Document all endpoints with comments
7. Use consistent naming in responses
8. Include request/response examples
9. Version the API (v1, v2)
10. Support CORS for frontend requests

### Database & PostgreSQL
PostgreSQL setup:

1. Use migrations for schema changes
2. Never modify schema manually
3. Use indexes for frequently queried columns
4. Normalize data appropriately
5. Use foreign key constraints
6. Backup database regularly
7. Test migrations in development first
8. Use transactions for related updates
9. Optimize queries with EXPLAIN
10. Monitor slow queries

### Logging & Monitoring
Logging approach:

1. Log at INFO level for important events
2. Log at DEBUG level for development details
3. Log at ERROR level for failures
4. Include context in logs (user ID, request ID)
5. Avoid logging sensitive data
6. Use structured logging format
7. Aggregate logs to central system
8. Set up alerts for errors
9. Monitor response times
10. Track database performance

## Testing Strategy

### Unit Tests
- Test individual functions in isolation
- Mock external dependencies
- 80% coverage target
- Fast execution (<1s for entire suite)
- Run on every commit

### Integration Tests
- Test API endpoints end-to-end
- Use test database
- Test authentication flows
- Test error scenarios
- 70% coverage target

### E2E Tests
- Test complete user workflows
- Use Cypress for browser automation
- Test on multiple browsers
- Test on mobile viewport
- Run on deployment

## Deployment

### Docker Setup
```bash
docker build -t myproject .
docker run -p 3000:3000 myproject
```

### Production Deployment
1. Use GitHub Actions for CI/CD
2. Deploy on every merge to main
3. Run tests before deployment
4. Use environment variables for config
5. Monitor application in production
6. Set up error tracking
7. Enable security headers
8. Use HTTPS only
9. Cache static assets
10. Set up database backups

### Environment Variables
Required variables:

- `NODE_ENV` - development or production
- `DATABASE_URL` - PostgreSQL connection
- `API_KEY` - External API key
- `JWT_SECRET` - JWT signing secret
- `CORS_ORIGIN` - Allowed CORS origins

## Code Review Process

1. All changes must be reviewed
2. Tests must pass before review
3. Linting must pass
4. Code coverage must not decrease
5. Reviewers should check for architecture violations
6. Require approval before merge
7. Squash commits on merge

## Git Workflow

1. Create feature branches from develop
2. Branch naming: feature/name or bugfix/name
3. Commit messages should be descriptive
4. Rebase instead of merge
5. Never force push to develop or main
6. Create pull requests for all changes
7. Link PRs to issues
8. Delete branches after merge

## Common Workflows

### Adding a New Component
1. Create directory in components/
2. Create component file
3. Create types file
4. Create test file
5. Create styles file
6. Export from index.ts
7. Write tests first (TDD)
8. Document props with JSDoc

### Adding a New API Endpoint
1. Create route handler
2. Write validation schema
3. Write business logic in service
4. Add database queries in repository
5. Write unit tests for service
6. Write integration tests for endpoint
7. Add error handling
8. Document in API spec

### Adding a Database Migration
1. Create migration file
2. Write SQL for schema change
3. Write rollback logic
4. Test migration in dev
5. Run migration in staging
6. Verify with queries
7. Then deploy to production

## Troubleshooting

### Common Issues

**Issue: Port 3000 already in use**
Solution: `lsof -i :3000` and kill the process

**Issue: Database connection fails**
Solution: Check DATABASE_URL environment variable

**Issue: Tests timeout**
Solution: Increase timeout: `{ timeout: 10000 }`

**Issue: Build fails**
Solution: Delete node_modules, run `npm install`

## Architecture Decisions

The system uses:
- React for frontend (chosen for ecosystem and developer experience)
- Express.js for backend (lightweight, flexible)
- PostgreSQL for data (ACID compliance, proven)
- Docker for consistency (same env dev/prod)
- GitHub Actions for CI/CD (native integration)
- JWT for authentication (stateless, scalable)
- Redux for state (predictable, debuggable)

## Performance Considerations

- Lazy load React components for faster initial load
- Paginate API responses to limit data
- Use database indexes for frequently queried fields
- Enable gzip compression on server
- Cache static assets in CDN
- Use connection pooling for database
- Implement request rate limiting
- Monitor slow API endpoints
- Optimize images and assets
- Use async/await instead of callbacks

## Security Practices

- All inputs must be validated and sanitized
- Use parameterized queries to prevent SQL injection
- Never log sensitive data (passwords, tokens)
- Use HTTPS in production only
- Implement CORS correctly
- Use helmet middleware for security headers
- Implement authentication before sensitive endpoints
- Rate limit login attempts
- Use environment variables for secrets
- Regularly update dependencies

## Dependencies
The key dependencies are:
- React 18.2.0
- TypeScript 4.9.5
- Express.js 4.18.2
- PostgreSQL 14
- Redux Toolkit 1.9.2
- Vitest 1.0.0
- Docker 20.10

## Contributing
- Follow the code review process
- Follow the git workflow
- Follow the testing strategy
- Follow the deployment process
- Ask for help in #dev-help Slack channel

## Links
- Main repository: https://github.com/org/myproject
- Documentation: https://docs.example.com
- Design system: https://design.example.com
- API documentation: https://api.example.com/docs
- Issue tracking: https://github.com/org/myproject/issues

---

**Issues with this file:**
- ❌ 349 lines - too long for rapid scanning
- ❌ ~5,200 tokens - expensive for Claude to process
- ❌ Mixes quick start with deep architectural details
- ❌ Frontend and backend rules in one file
- ❌ Testing strategy squeezed between sections
- ❌ Rules repeated (e.g., "test behavior, not implementation" mentioned 3+ times)
- ❌ No clear priority - everything feels equally important
- ❌ Difficult to update - changing one rule requires finding it in a long document
```

---

## The Solution: Progressive Disclosure

### New Structure

**Root file** (`CLAUDE.md` - 38 lines, ~600 tokens):
```markdown
# MyProject - Agent Instructions

## Quick Start
Full-stack web application with React frontend, Node.js backend, PostgreSQL database, and Docker.

### Prerequisites
- Node.js 18+, npm 8+, Docker 20+, PostgreSQL 14+

### Core Commands
\`\`\`bash
npm install
npm run dev      # Frontend on port 3000
npm run build    # Production build
npm test         # Run tests
\`\`\`

## Documentation
- [Architecture & Setup](.claude/architecture.md) - Project structure, tech stack decisions
- [Frontend Development](.claude/frontend.md) - React, TypeScript, component patterns
- [Backend Development](.claude/backend.md) - Express.js, API design, database
- [Testing Strategy](.claude/testing.md) - Unit, integration, E2E testing
- [Deployment & CI/CD](.claude/deployment.md) - Docker, production setup, GitHub Actions
- [Common Workflows](.claude/workflows.md) - Step-by-step guides for typical tasks

## Quick Links
- Repository: https://github.com/org/myproject
- Issue Tracker: https://github.com/org/myproject/issues
- Slack: #dev-help
```

**Linked file 1** (`.claude/frontend.md` - 140 lines, ~2,100 tokens):
```markdown
# Frontend Development - MyProject

## Overview
React + TypeScript frontend with Redux state management, Vitest testing, and Material-UI components.

## Rules & Conventions

### Rule 1: TypeScript - Explicit Types Only
**When**: Declaring any variable, function parameter, or component prop
**Why**: Catches errors at compile time; improves IDE support
**Implementation**:
- Never use `any` (use `unknown` instead)
- Function return types explicit
- Interface all component props
- Props interface naming: `ComponentNameProps`

**Example**:
\`\`\`typescript
// ✓ GOOD
interface ButtonProps {
  label: string;
  onClick: () => void;
  disabled?: boolean;
}

const Button: React.FC<ButtonProps> = ({ label, onClick, disabled }) => (
  <button onClick={onClick} disabled={disabled}>{label}</button>
);

// ❌ BAD
const Button = (props: any) => (
  <button onClick={props.onClick}>{props.label}</button>
);
\`\`\`

### Rule 2: React - Functional Components Only
**When**: Creating components
**Why**: Hooks are simpler than class lifecycle; easier to test and compose
**Implementation**:
- Use React.FC<Props> typing
- Extract complex logic to custom hooks
- Use React.memo for performance-critical components
- Event handlers prefixed with "handle"

### Rule 3: State Management - Redux Toolkit
**When**: Sharing state across multiple components
**Why**: Predictable, debuggable, centralized state
**Implementation**:
- One store per app
- Domain-specific slices
- Use immer in reducers (automatic)
- Async thunks for side effects
- Memoized selectors with reselect

### Rule 4: Component Structure
**When**: Organizing component code
**Why**: Clear location for related code
**Implementation**:
- Each component in its own directory
- `ComponentName.tsx` for component
- `types.ts` for TypeScript definitions
- `ComponentName.module.css` for styles
- `index.ts` for exports

**Example structure**:
```
components/
├── Button/
│   ├── Button.tsx
│   ├── Button.module.css
│   ├── types.ts
│   └── index.ts
└── Modal/
    ├── Modal.tsx
    ├── Modal.module.css
    ├── types.ts
    └── index.ts
```

### Rule 5: Testing - Behavior Over Implementation
**When**: Writing component tests
**Why**: Tests document user-facing behavior; ignore internal details
**Implementation**:
- Use @testing-library/react
- Test user interactions, not implementation
- Mock external dependencies only
- 80% coverage target
- Each test independent

**Example**:
\`\`\`typescript
// ✓ GOOD - Tests user behavior
it('shows success message after submission', async () => {
  render(<Form />);
  const input = screen.getByPlaceholderText('Name');
  const submit = screen.getByText('Submit');

  await user.type(input, 'Alice');
  await user.click(submit);

  expect(screen.getByText('Thanks, Alice!')).toBeInTheDocument();
});

// ❌ BAD - Tests implementation
it('calls onSubmit handler', () => {
  const mock = vi.fn();
  render(<Form onSubmit={mock} />);
  // This test breaks when internal implementation changes
});
\`\`\`

## Project Layout
\`\`\`
frontend/
├── src/
│   ├── components/     # Reusable UI components
│   ├── hooks/          # Custom React hooks
│   ├── pages/          # Page-level components
│   ├── store/          # Redux slices and config
│   ├── types/          # TypeScript types
│   ├── utils/          # Helper functions
│   ├── App.tsx         # Root component
│   └── main.tsx        # Entry point
├── tests/              # Test utilities
├── package.json
└── vitest.config.ts
\`\`\`

## See Also
- [Backend Development](./../backend.md) - API integration patterns
- [Testing Strategy](./../testing.md) - Comprehensive testing guide
- [Common Workflows](./../workflows.md) - Step-by-step guides

---

**Token count**: ~2,100 tokens | **Reading time**: ~8 minutes
```

**Linked file 2** (`.claude/backend.md` - 130 lines, ~2,000 tokens):
```markdown
# Backend Development - MyProject

## Overview
Express.js + TypeScript backend with PostgreSQL database, REST API design, and async/await patterns.

## Rules & Conventions

### Rule 1: Express Architecture - MVC Pattern
**When**: Organizing backend code
**Why**: Clear separation of concerns; easy to test; team coordination
**Implementation**:
- Routes handle HTTP details
- Controllers interpret requests
- Services contain business logic
- Repositories handle data access
- Middleware for cross-cutting concerns

**Example structure**:
\`\`\`
backend/
├── src/
│   ├── routes/         # Route definitions
│   ├── controllers/     # HTTP request handling
│   ├── services/        # Business logic
│   ├── repositories/    # Data access
│   ├── middleware/      # Middleware functions
│   ├── types/           # TypeScript types
│   ├── db/              # Database config
│   └── app.ts           # Express setup
\`\`\`

### Rule 2: API Design - RESTful Conventions
**When**: Designing API endpoints
**Why**: Consistency; predictable for clients; RESTful standards
**Implementation**:
- GET /users - list
- GET /users/:id - retrieve
- POST /users - create
- PUT /users/:id - update
- DELETE /users/:id - delete
- Use correct status codes (200, 201, 400, 404, 500)
- Include errors in response body

**Example**:
\`\`\`typescript
// ✓ GOOD - RESTful
router.get('/users', getUsers);           // List all
router.get('/users/:id', getUserById);    // Get one
router.post('/users', createUser);        // Create
router.put('/users/:id', updateUser);     // Update
router.delete('/users/:id', deleteUser);  // Delete

// ❌ BAD - Not RESTful
router.get('/getUsers');
router.get('/fetchUser');
router.post('/insertUser');
\`\`\`

### Rule 3: Validation & Error Handling
**When**: Processing requests
**Why**: Prevent invalid data; consistent error responses
**Implementation**:
- Validate all inputs (type, range, format)
- Return 400 Bad Request for validation errors
- Return 500 Internal Server Error with generic message
- Include error details in logs but not responses
- Centralized error handling middleware

**Example**:
\`\`\`typescript
const createUser = async (req: Request, res: Response) => {
  const { email, name } = req.body;

  // Validate inputs
  if (!email || !name) {
    return res.status(400).json({
      error: 'Missing required fields: email, name'
    });
  }

  if (!isValidEmail(email)) {
    return res.status(400).json({
      error: 'Invalid email format'
    });
  }

  // Create user...
};
\`\`\`

### Rule 4: Database Access - Async/Await
**When**: Querying database
**Why**: Readable, modern, better error handling
**Implementation**:
- Use async/await (no callbacks)
- Use transactions for related updates
- Use indexes for frequently queried columns
- Parameterized queries (prevent SQL injection)
- Connection pooling

**Example**:
\`\`\`typescript
const getUserById = async (id: number): Promise<User | null> => {
  try {
    const result = await pool.query(
      'SELECT * FROM users WHERE id = $1',
      [id]
    );
    return result.rows[0] || null;
  } catch (error) {
    logger.error('Database error', { id, error });
    throw new Error('Failed to fetch user');
  }
};
\`\`\`

### Rule 5: Logging - Structured & Contextual
**When**: Logging events
**Why**: Production debugging; performance monitoring; audit trail
**Implementation**:
- INFO for important events
- ERROR for failures
- Include context (user ID, request ID)
- Never log passwords or tokens
- Structured format (JSON)

**Example**:
\`\`\`typescript
logger.info('User created', {
  userId: user.id,
  email: user.email,
  timestamp: new Date().toISOString()
});

logger.error('Database connection failed', {
  error: err.message,
  code: err.code,
  timestamp: new Date().toISOString()
});
\`\`\`

## See Also
- [Frontend Development](./../frontend.md) - API integration from React
- [Testing Strategy](./../testing.md) - Integration test patterns
- [Database & Migrations](./../database.md) - Schema and migrations
- [Common Workflows](./../workflows.md) - API development workflows

---

**Token count**: ~2,000 tokens | **Reading time**: ~8 minutes
```

**Linked file 3** (`.claude/testing.md` - 110 lines, ~1,600 tokens):
```markdown
# Testing Strategy - MyProject

## Overview
Three-layer testing approach: unit tests (fast, isolated), integration tests (real dependencies), E2E tests (user workflows).

## Testing Pyramid
```
        E2E (Cypress)
          /     \
         /       \
    Integration Tests
       /           \
      /             \
Unit Tests (80% coverage)
```

## Rule 1: Unit Tests - Vitest + Testing Library
**When**: Testing individual functions or React components
**Why**: Fast, isolated, catches regressions
**Implementation**:
- Describe what the component does (not how)
- Mock external APIs/services
- Each test independent
- 80% coverage target

**Example**:
\`\`\`typescript
describe('LoginForm', () => {
  it('displays error on invalid email', async () => {
    render(<LoginForm />);
    const input = screen.getByLabelText('Email');
    const submit = screen.getByText('Login');

    await user.type(input, 'invalid-email');
    await user.click(submit);

    expect(screen.getByText('Invalid email')).toBeInTheDocument();
  });
});
\`\`\`

## Rule 2: Integration Tests - API Testing
**When**: Testing API endpoints with database
**Why**: Validates real interactions; catches integration issues
**Implementation**:
- Use test database
- Clean database between tests
- Test request/response contracts
- Test error scenarios

**Example**:
\`\`\`typescript
describe('GET /api/users/:id', () => {
  it('returns user with valid id', async () => {
    const user = await db.createUser({ name: 'Alice' });

    const res = await request(app)
      .get(`/api/users/${user.id}`)
      .expect(200);

    expect(res.body.name).toBe('Alice');
  });

  it('returns 404 for unknown user', async () => {
    await request(app)
      .get('/api/users/999')
      .expect(404);
  });
});
\`\`\`

## Rule 3: E2E Tests - User Workflows
**When**: Testing complete user scenarios
**Why**: Validates full application flow
**Implementation**:
- Use Cypress for browser automation
- Test on multiple viewports
- Realistic user interactions
- Run on every deployment

**Example**:
\`\`\`typescript
describe('User Registration Flow', () => {
  it('creates account and logs in', () => {
    cy.visit('/signup');
    cy.get('input[name=email]').type('alice@example.com');
    cy.get('input[name=password]').type('SecurePassword123');
    cy.get('button[type=submit]').click();

    cy.url().should('include', '/login');
    cy.get('input[name=email]').type('alice@example.com');
    cy.get('input[name=password]').type('SecurePassword123');
    cy.get('button[type=submit]').click();

    cy.url().should('include', '/dashboard');
    cy.contains('Welcome, Alice').should('exist');
  });
});
\`\`\`

## Coverage Goals
- Components: >80%
- Services: >85%
- Repositories: >70%
- Total: >75%

## Running Tests
\`\`\`bash
npm test              # Run all tests
npm test -- --ui      # UI mode
npm test -- src/components  # Specific directory
npm run test:coverage # Coverage report
npm run test:e2e      # E2E tests only
\`\`\`

## See Also
- [Frontend Development](./../frontend.md) - Component testing
- [Backend Development](./../backend.md) - API testing
- [Common Workflows](./../workflows.md) - TDD workflow

---

**Token count**: ~1,600 tokens | **Reading time**: ~6 minutes
```

**Linked file 4** (`.claude/deployment.md` - 100 lines, ~1,500 tokens):
```markdown
# Deployment & CI/CD - MyProject

## Overview
GitHub Actions for CI/CD, Docker for containerization, GitHub Container Registry for image hosting.

## CI/CD Pipeline

**On Pull Request**:
1. Lint code (ESLint + Prettier)
2. Run unit tests
3. Check code coverage
4. Build application

**On Merge to Main**:
1. Run all tests (unit + integration)
2. Build Docker image
3. Push to GitHub Container Registry
4. Deploy to production

## GitHub Actions Workflow
\`\`\`yaml
name: CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - run: npm run build

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: docker/setup-buildx-action@v2
      - uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v4
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}:latest
\`\`\`

## Environment Variables
\`\`\`
Production:
- NODE_ENV=production
- DATABASE_URL=postgres://...
- JWT_SECRET=... (from GitHub Secrets)
- API_KEY=... (from GitHub Secrets)

Development:
- NODE_ENV=development
- DATABASE_URL=postgres://localhost/myproject_dev
\`\`\`

## Deployment Checklist
- [ ] All tests passing
- [ ] Code coverage not decreased
- [ ] No console.log or debugger statements
- [ ] Environment variables configured
- [ ] Database migrations run
- [ ] Static assets cached
- [ ] Security headers configured

## See Also
- [Backend Development](./../backend.md) - Building backends
- [Testing Strategy](./../testing.md) - Test coverage requirements
- [Common Workflows](./../workflows.md) - Deployment workflows

---

**Token count**: ~1,500 tokens | **Reading time**: ~5 minutes
```

---

## Comparison: Before vs After

### Token Count Analysis

| Metric | Before | After | Reduction |
|--------|--------|-------|-----------|
| Root file only | 5,200 | 600 | 88% ↓ |
| All files combined | 5,200 | 6,700 | +29% (but distributed) |
| Average agent reads | 5,200 | 1,200-1,800 (linked files) | 75% ↓ |

**Why this matters**: When an agent needs to work on frontend code, it only loads the 600-token root + 2,100-token frontend guide = 2,700 tokens instead of 5,200 tokens.

### Readability & Navigation

| Aspect | Before | After |
|--------|--------|-------|
| Time to find info | 5-10 min scanning | <2 min (quick links) |
| Update a rule | Update, search for related mentions (time-consuming) | Update in specific file (fast) |
| Onboard new developer | Read 350 lines | Read root, then linked guides as needed |
| Jump to topic | Use Ctrl+F within huge file | Click link to dedicated file |

### DX Improvements

**Before - Developer searching for "testing strategy"**:
```
Control+F → "test" → 47 matches → scroll through bloated sections → find relevant info scattered across 3 areas
```

**After - Developer searching for "testing strategy"**:
```
Click [Testing Strategy](.claude/testing.md) → 110 lines → specific to testing → done
```

### AI Agent Efficiency

**Before**: Agent processes 5,200-token root file for every query
- Extracts backend guidelines from frontend section
- Re-reads deployment info when only needing architecture
- Wastes tokens on repeated context

**After**: Agent loads targeted documents
- Frontend work: root (600) + frontend guide (2,100) = 2,700 tokens
- Backend work: root (600) + backend guide (2,000) = 2,600 tokens
- Testing work: root (600) + testing guide (1,600) = 2,200 tokens
- Deployment: root (600) + deployment guide (1,500) = 2,100 tokens

**Result**: 50-75% token savings per query by using targeted linked files

---

## Implementation Steps

### Step 1: Identify Sections in Bloated File
From original 349-line file:
- Overview & Quick Start (30 lines)
- Frontend rules (80 lines)
- Backend rules (70 lines)
- Testing (40 lines)
- Deployment (50 lines)
- Misc (79 lines)

### Step 2: Create Linked Files
- ✓ `.claude/frontend.md` ← Frontend section + examples
- ✓ `.claude/backend.md` ← Backend section + examples
- ✓ `.claude/testing.md` ← Testing section + workflows
- ✓ `.claude/deployment.md` ← Deployment section + checklist

### Step 3: Trim Root File
- Keep quick start (3-5 lines)
- Keep core commands (5-7 lines)
- Add links to detailed guides (6-8 lines)
- Remove all rules, examples, and details
- Total: 35-45 lines

### Step 4: Enhance Linked Files
- Add "When/Why/Implementation" structure
- Include good AND bad examples
- Add cross-links to related files
- Include token counts and reading times
- Better formatting and syntax highlighting

### Step 5: Verify & Test Links
- [ ] All markdown links point to correct files
- [ ] No broken internal references
- [ ] Each linked file is self-contained
- [ ] Root file mentions all major topics
- [ ] Try navigation flow: start at root, explore any topic

---

## Benefits Achieved

### 1. Faster Onboarding
- **New dev**: Read 40-line root file + specific guide (5-10 min)
- **Old way**: Read 350-line file (15-20 min)

### 2. Targeted Learning
- Frontend dev reads frontend guide only (not backend rules)
- Backend dev skips frontend conventions
- QA reads testing strategy without deployment details

### 3. Easier Maintenance
- Update "React patterns"? Edit `.claude/frontend.md` once
- Update "API design"? Edit `.claude/backend.md` once
- Old way: Find and update in 5 different places

### 4. AI Agent Efficiency
- 70-80% token reduction for most queries
- Faster processing of more targeted information
- Less context pollution from unrelated sections

### 5. Scalability
- New topic? Create new `.claude/` file
- No bloating of root file
- Easy to add more guides as project grows

---

## Conversion Checklist

When converting your bloated file:

- [ ] **Extract sections** - Identify natural groupings (frontend, backend, testing, deployment)
- [ ] **Create linked files** - One file per section, in `.claude/` directory
- [ ] **Add structure** - Use "Overview → Rules → Examples → See Also" template
- [ ] **Trim root** - Keep only quick start and links
- [ ] **Add cross-links** - Reference related guides in each file
- [ ] **Estimate tokens** - Add token count to bottom of each file
- [ ] **Verify links** - Test all internal markdown links work
- [ ] **Update docs** - Reference new structure in README
- [ ] **Commit changes** - Version the new structure in git

---

## File Organization

Final structure after refactoring:

```
.claude/
├── CLAUDE.md (root - 40 lines)
├── architecture.md (100 lines)
├── frontend.md (140 lines)
├── backend.md (130 lines)
├── testing.md (110 lines)
├── deployment.md (100 lines)
└── workflows.md (120 lines)
```

Total: ~740 lines across 7 files (vs. 350 in one file)
- ✓ Same information
- ✓ Much better organized
- ✓ Easier to update
- ✓ More discoverable
- ✓ Better for agents

---

**Summary**: This example demonstrates how 349 lines of one bloated file became 7 focused documents totaling 740 lines. The result is 75% token savings per query, 70% faster onboarding, and much easier maintenance. The "cost" is slightly more total documentation, but the structure pays dividends in usability and agent efficiency.
