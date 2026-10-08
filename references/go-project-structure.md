# Pragmatic Go Backend Project Structure Reference

> **Standard Production Backend Architecture**  
> This specification defines the standardized, idiomatic Go backend project structure. It implements the **Consumer-Driven Interface** philosophy, enforces the **Zero-Colocation** boundary rule, maintains **Flat Layered Symmetry**, and establishes production-grade containerization.

---

## 1. Core Architecture Philosophy

1. **Consumer-Driven Interfaces (Go-Specific Paradigm)**:
   > [!NOTE]
   > **Go-Specific Superpower (Structural Typing vs Nominal Typing)**:  
   > Consumer-Driven Interfaces—where the producer struct has zero compile-time knowledge of the consumer's interface—is uniquely enabled by Go's **structural typing** (implicit interface satisfaction, zero `implements` keyword). In nominal languages (Java, C#, TypeScript), classes must explicitly declare `implements`, forcing those architectures to place interfaces in shared domain/ports packages. In Go, interfaces strictly belong to the consumer and remain unexported.
   - Interfaces belong to the **consumer** package (e.g., `service`, `handler`), not the producer.
   - Interfaces are kept **unexported** and tailored strictly to what the consumer needs (Interface Segregation Principle).
   - Repositories and external infrastructure clients export **concrete structs only** (`func NewUserRepo(...) *UserRepo`).
   - **Strictly Banned**: Centralized `interfaces/` packages or `interfaces.go` God-contracts.
2. **Pragmatic 2-Model Architecture**:
   - **Tiers below transport (`service` & `repository`)**: Share unified entity structs in `internal/model/` carrying database tags (`gorm:`, `db:`), eliminating duplicate mapping boilerplate when DB and domain models match 1-to-1.
   - **Transport boundary (`internal/handler`)**: Strictly isolated by dedicated DTOs in `internal/dto/` to prevent mass-assignment vulnerabilities, separate API contracts from DB schemas, and prevent leaking sensitive fields.
3. **Zero-Colocation Rule**:
   - Entities (`model/`), Request/Response schemas (`dto/`), Handlers (`handler/`), and Business Logic (`service/`) **MUST NEVER** be colocated in the same file or shared directory.
4. **Accept Interfaces, Return Structs**:
   - Functions and constructors accept interface abstractions as dependencies, but return concrete struct pointers.
5. **Flat Layered Symmetry & Explicit Suffixes**:
   - All core layers (`router`, `handler`, `service`, `repository`) are maintained as **flat packages** to avoid package stuttering and arbitrary folder nesting.
   - Files use explicit suffixes (`*_router.go`, `*_handler.go`, `*_service.go`, `*_repo.go`, `*_dto.go`) for fast navigation (`Ctrl+P`) and multi-tab clarity in IDEs.

---

## 2. Directory Tree Layout

```text
<project-root>/
├── cmd/
│   └── api/
│       └── main.go                  # Composition Root: Load config, init DB, wire DI, start HTTP & graceful shutdown
│
├── internal/
│   ├── config/                      # Strongly-typed environment configuration
│   │   └── config.go
│   │
│   ├── apperror/                    # Centralized domain error taxonomy & RFC 7807 HTTP mapping
│   │   └── error.go
│   │
│   ├── logger/                      # STRUCTURED LOGGING: Slog/Zap configuration & context helpers
│   │   └── logger.go
│   │
│   ├── security/                    # CRYPTOGRAPHIC TOOLING: JWT signing/verifying & password hashing
│   │   ├── jwt.go                   # GenerateToken, VerifyToken, Claims struct
│   │   └── password.go              # HashPassword, VerifyPassword (Bcrypt / Argon2)
│   │
│   ├── metrics/                     # OBSERVABILITY: Prometheus metrics registry (counters, histograms)
│   │   └── prometheus.go
│   │
│   ├── router/                      # ROUTE REGISTRY: URL mapping & middleware attachment ONLY
│   │   ├── router.go                # Base router setup (Chi / ServeMux / Gin), global middlewares, API v1 group
│   │   ├── user_router.go           # User endpoint mappings (/api/v1/users)
│   │   └── post_router.go           # Post endpoint mappings (/api/v1/posts)
│   │
│   ├── handler/                     # TRANSPORT ADAPTER: HTTP request/response parsing ONLY (FLAT)
│   │   ├── user_handler.go          # UserHandler struct + unexported consumer interface
│   │   ├── user_handler_test.go     # Colocated transport unit test
│   │   ├── post_handler.go          # PostHandler struct + unexported consumer interface
│   │   └── post_handler_test.go
│   │
│   ├── middleware/                  # HTTP INTERCEPTORS: Cross-cutting pipeline middleware
│   │   ├── auth.go                  # Token extraction & verification (uses internal/security)
│   │   ├── logger.go                # Structured HTTP access logger (uses internal/logger)
│   │   ├── metrics.go               # HTTP latency & status tracking (uses internal/metrics)
│   │   ├── rate_limit.go            # Request rate limiting (429 Too Many Requests)
│   │   ├── recovery.go              # Panic recovery
│   │   └── cors.go                  # CORS headers
│   │
│   ├── service/                     # BUSINESS LOGIC LAYER: Workflows & Domain Invariants (FLAT)
│   │   ├── user_service.go          # UserService struct + unexported userStore interface
│   │   ├── user_service_test.go     # Black-box unit test (package service_test) with manual mock
│   │   ├── post_service.go          # PostService struct + unexported postStore / postAuthorFinder interfaces
│   │   ├── post_service_test.go
│   │   └── order_orchestrator.go    # (Optional) Multi-domain workflow coordinator
│   │
│   ├── event/                       # DOMAIN EVENTS: Event payloads & publisher contracts
│   │   ├── event.go                 # Event interface & EventPublisher contract
│   │   ├── user_events.go           # struct UserRegisteredEvent { UserID, Email, Timestamp }
│   │   └── post_events.go           # struct PostPublishedEvent { PostID, AuthorID, Timestamp }
│   │
│   ├── worker/                      # ASYNCHRONOUS CONSUMERS: Background event subscribers
│   │   ├── email_worker.go          # Listens to UserRegisteredEvent -> sends welcome email
│   │   └── audit_worker.go          # Listens to domain events -> writes audit trail
│   │
│   ├── repository/                  # DATA ACCESS: Application-owned persistence (Postgres, Redis) (FLAT)
│   │   ├── db.go                    # Database connection pool setup & transaction helper
│   │   ├── user_repo.go             # Concrete UserRepo struct (returns *UserRepo, NO interface)
│   │   ├── post_repo.go             # Concrete PostRepo struct (returns *PostRepo)
│   │   └── user_repo_test.go        # Integration test (using testcontainers / isolated test DB)
│   │
│   ├── infra/                       # EXTERNAL ADAPTERS: Third-party APIs / Cloud SDKs / Messaging
│   │   ├── eventbus/
│   │   │   └── memory_bus.go        # In-memory Go channel Event Bus (or redis_bus.go)
│   │   ├── gemini/
│   │   │   └── client.go            # Concrete GeminiClient calling Google AI API
│   │   └── mailer/
│   │       └── mailer.go            # Concrete Mailer client (SMTP / Resend)
│   │
│   ├── model/                       # DOMAIN / DB ENTITIES: Shared entities carrying DB tags
│   │   ├── user.go                  # Struct User with DB tags (gorm / db)
│   │   └── post.go
│   │
│   └── dto/                         # REQUEST & RESPONSE PAYLOADS: JSON & validation tags
│       ├── response.go              # Standard API response envelope (success, data, error)
│       ├── pagination.go            # Generic pagination request/response metadata
│       ├── user_dto.go              # CreateUserRequest, UpdateUserRequest, UserResponse
│       └── post_dto.go              # CreatePostRequest, PostResponse
│
├── migrations/                      # Versioned SQL migration files
│   ├── 000001_create_users_table.up.sql
│   └── 000001_create_users_table.down.sql
│
├── .dockerignore                    # Build exclusions (.git, .env, binaries)
├── .env.example                     # Sanitized environment variable template
├── Dockerfile                       # Multi-stage production container build
├── docker-compose.yml               # Local development stack (App + Postgres + Redis)
├── Makefile                         # Engineering task runners (run, test, migrate, build)
├── go.mod
└── go.sum
```

---

## 3. Package Responsibility Matrix

| Package | Primary Responsibility | Mandatory Invariants | Forbidden Dependencies & Actions |
| :--- | :--- | :--- | :--- |
| **`cmd/api/`** | Composition root: read configs, initialize connection pools, wire DI, bind handlers to routes, start HTTP server, handle graceful shutdown signals (`SIGINT`, `SIGTERM`). | Single binary entrypoint for the API service. | **FORBIDDEN**: Writing HTTP routing handlers, raw business logic, or SQL queries directly in `main.go`. |
| **`internal/config/`** | Parsing environment variables into strongly-typed Go structs with validation at startup. | Must panic/fail fast on boot if any mandatory environment variable is missing. | **FORBIDDEN**: Storing hardcoded secrets, database credentials, or API keys. |
| **`internal/apperror/`** | Standardizing application error types, error codes (`ErrNotFound`, `ErrConflict`), and mapping domain errors to HTTP status codes following RFC 7807 (Problem Details). | Single source of truth for error response formatting. | **FORBIDDEN**: Leaking raw SQL error strings, database connection traces, or sensitive server internals to public error responses. |
| **`internal/logger/`** | Configuring structured application logging (Slog / Zap), formatting JSON outputs, and managing context-aware logger helpers (`FromContext`). | Single source of truth for logger instance and format configuration. | **FORBIDDEN**: Writing domain business logic, SQL queries, or hardcoding log levels in source code. |
| **`internal/security/`** | Pure cryptographic tooling: JWT token signing and verification (`GenerateToken`, `VerifyToken`), password hashing (`Bcrypt`, `Argon2`). | Pure technical security functions. Zero business rules. | **FORBIDDEN**: Housing business authentication workflows (registration, login); querying database tables directly. |
| **`internal/metrics/`** | Declaring and registering Prometheus observability metrics (counters, histograms, gauges). | Adheres strictly to Prometheus metric naming standards. | **FORBIDDEN**: Executing HTTP transport logic or persisting operational metrics to relational DBs. |
| **`internal/router/`** | Pure endpoint mapping: registering URL paths, HTTP methods, route groups (`/api/v1`), and attaching route-specific middleware. | Clean separation between URL registration and request handling. | **FORBIDDEN**: Parsing JSON bodies; invoking services or repositories directly; containing business logic. |
| **`internal/handler/`** | Transport adapter: decoding HTTP requests into DTOs, validating input, invoking service methods via unexported consumer interfaces, and writing JSON responses. | Must declare **unexported consumer interfaces** for required service behaviors. Can be shared across multiple handlers (User Web, Admin CMS, gRPC). | **FORBIDDEN**: Calling `repository` or database pools directly; executing database transactions; writing core business logic. |
| **`internal/middleware/`** | Intercepting incoming HTTP requests for cross-cutting policies (auth token validation, request logging, latency metrics, rate limiting, panic recovery, CORS). | Pure transport interceptors executed in defined sequence. | **FORBIDDEN**: Directly invoking database pools or executing domain business workflows. |
| **`internal/service/`** | Pure business logic, workflow orchestration, invariant verification, and transaction boundary coordination. | Must declare **unexported consumer interfaces** for required repository/infra capabilities. | **FORBIDDEN**: Importing `net/http`, handling raw HTTP requests/responses, or returning HTTP status codes (400, 404, 500). |
| **`internal/event/`** | Defining domain event payload structs and publisher interfaces (`UserRegisteredEvent`, `EventPublisher`). | Pure event data contracts. | **FORBIDDEN**: Writing consumer business logic, SQL operations, or transport-specific code. |
| **`internal/worker/`** | Background consumers subscribing to domain events via Event Bus (e.g. sending welcome emails, building search indexes, audit logging). | Runs asynchronously decoupled from HTTP request lifecycles. | **FORBIDDEN**: Returning responses to HTTP clients or blocking incoming web requests. |
| **`internal/repository/`** | Executing queries and mutations against storage owned directly by the application (PostgreSQL, MySQL, MongoDB, Redis). | Exports **concrete structs only** (`*UserRepo`). Must manage connections and SQL execution. | **FORBIDDEN**: Calling another repository; declaring public interfaces in this package; interacting with external 3rd-party SaaS APIs (Gemini, Stripe, S3). |
| **`internal/infra/`** | Interacting with external systems, third-party web services, cloud providers, and SaaS endpoints (including Event Bus engines). | Encapsulates external SDKs and outbound HTTP/gRPC clients. Exports concrete structs. | **FORBIDDEN**: Querying internal relational database tables or managing core domain entity persistence. |
| **`internal/model/`** | Defining core domain and database entities (e.g. `User`, `Post`) carrying database tags (`gorm:`, `db:`). | Represents application entities stored in the primary persistence engine. | **FORBIDDEN**: Declaring HTTP request/response payloads; writing SQL queries or repository operations in model files. |
| **`internal/dto/`** | Defining request and response schemas transferred over HTTP transport, JSON tags, and field-level validation rules (`validate:"required,email"`). | Must protect domain entities from mass-assignment; must sanitize responses (e.g., strip password hashes). | **FORBIDDEN**: Carrying database tags (`gorm:`, `sql:`); directly calling database or repository methods. |

---

## 4. Architectural Guardrails & Rules

### Rule 1: Zero-Colocation Invariant
- Entities (`model/`), Request/Response schemas (`dto/`), Handlers (`handler/`), and Business Logic (`service/`) **MUST NEVER** be colocated in the same file or shared directory.
- DTOs live in `internal/dto/`, Models live in `internal/model/`. Never define DTOs inside handler files.

### Rule 2: Repository Isolation (Zero Cross-Repo Calls)
- **Repositories MUST NEVER call other repositories.**
- *Rationale*: A repository represents an atomic aggregate root boundary. Calling Repo B from Repo A creates hidden coupling and causes database transaction leaks, connection deadlocks, or ambiguous commit boundaries.
- Cross-entity coordination must always occur at the **Service layer**.

### Rule 3: Service-to-Service Interaction & Orchestration
When a business operation spans multiple domain concepts (e.g., creating a post requires validating the user, or deleting a user requires cleaning up posts):
1. **Unidirectional Dependency (DAG - Directed Acyclic Graph)**:
   - Service A may depend on Service B via an unexported consumer interface:
     ```go
     // In post_service.go
     type authorValidator interface {
         ValidateAuthorCanPost(ctx context.Context, userID string) error
     }
     ```
   - Service B (`UserService`) satisfies this interface.
   - **STRICT FORBIDDEN**: Bidirectional circular references (`UserService` calling `PostService` while `PostService` calls `UserService`).
2. **Orchestrator / Facade Service (Recommended for Multi-Domain Workflows)**:
   - For complex, multi-step operations (e.g., `CheckoutOrder`, `DeleteAccount`):
   - Create a dedicated **Orchestrator Service** (e.g., `checkout_orchestrator.go` or `account_deletion_orchestrator.go`).
   - The Orchestrator coordinates the lower-level domain services (`CartService`, `PaymentService`, `InventoryService`) without forcing them to know about each other.

### Rule 4: Multi-Service Invocations from Handlers (Read vs Write)
A transport handler CAN inject and call multiple services, but under strict behavioral constraints:
- **PERMITTED (Read-Only Aggregation)**: A dashboard or profile handler may call `UserService.GetProfile()`, `OrderService.GetRecentOrders()`, and `NotificationService.GetUnreadCount()` to assemble a composite response DTO. This avoids artificial wrapper services.
- **FORBIDDEN (Mutating / Transactional Flows)**: A handler **MUST NOT** orchestrate multi-step mutating workflows (e.g., calling Payment, then Order, then Inventory). Leaking transactional coordination or rollback logic into HTTP handlers destroys code reusability (e.g. for gRPC or CLI) and pollutes transport boundaries. Multi-step mutations belong in an **Orchestrator Service**.

### Rule 5: Asynchronous Decoupling via Event Bus (Foreground vs Background)
- Side-effects that are not required for immediate client consistency (sending confirmation emails, push notifications, logging audit trails, cache pre-warming) **MUST NOT** be invoked synchronously inside request-serving services.
- The service performs atomic primary persistence, then publishes an event (`event.UserRegisteredEvent`) to the **Event Bus**.
- Asynchronous consumers in `internal/worker/` subscribe to the event and execute out-of-band.
- *Result*: The HTTP request completes in sub-10ms without blocking on third-party network latency, and the primary domain service remains completely decoupled from notification and auditing modules.

### Rule 6: One Service Serving Multiple Handlers
- A single domain service can be injected into multiple transport handlers:
  - `UserHandler` (public user-facing web API: `GET /api/v1/profile`)
  - `AdminUserHandler` (internal backoffice CMS API: `POST /api/v1/admin/users/{id}/ban`)
  - `InternalGrpcHandler` (inter-service RPC call)
  - `WorkerHandler` (asynchronous cron job / background consumer)
- Transport handlers are mere entrypoint adapters; the core service encapsulates the single source of business truth.

### Rule 7: Helper Function Discipline (No Junk Drawer)
- **Local Helpers**: Helpers specific to a single package must remain inside that package as private unexported functions (or in a private `helper.go` file within that package).
- **Shared Helpers**: Never create a generic `util/` or `helper/` package. Create domain-specific, leaf-node packages named after their single purpose:
  - `internal/datetime/` (Timezone parsing, formatting)
  - `internal/crypto/` (Hashing, password salting)
  - `internal/slug/` (Vietnamese slug generation)
- Shared helper packages **MUST NOT** import `model`, `dto`, `service`, or `repository` (must be pure leaf dependencies).

### Rule 8: Self-Describing Package Names (The Anti-Junk-Drawer Doctrine)
- In Go, a package name MUST be an unambiguous noun that explicitly communicates its single architectural responsibility without inspecting internal source files.
- **Strictly Banned Package Names**: `util`, `helper`, `common`, `platform`, `shared`, `misc`, `tools`, `base`.
- Packages such as `logger/`, `security/`, `metrics/`, `router/`, `dto/`, `model/` are immediately self-describing leaf-nodes. Anyone viewing the directory tree instantly knows where every single responsibility lives.

---

## 5. Consumer-Driven Interface Pattern & Testing

### 5.1 Interface Declaration at Consumer Layer
```go
// File: internal/service/user_service.go
package service

import (
    "context"
    "myproject/internal/model"
)

// Unexported consumer interface: defines only what UserService needs
type userStore interface {
    Create(ctx context.Context, u *model.User) error
    FindByID(ctx context.Context, id string) (*model.User, error)
    FindByEmail(ctx context.Context, email string) (*model.User, error)
}

type UserService struct {
    store userStore
}

// Accept interface, return concrete struct pointer
func NewUserService(store userStore) *UserService {
    return &UserService{store: store}
}
```

```go
// File: internal/service/post_service.go
package service

import (
    "context"
    "myproject/internal/model"
)

// Role-based consumer interface: PostService only needs to find the author
type postAuthorFinder interface {
    FindByID(ctx context.Context, id string) (*model.User, error)
}

type postStore interface {
    Create(ctx context.Context, p *model.Post) error
}

type PostService struct {
    store  postStore
    author postAuthorFinder
}

func NewPostService(store postStore, author postAuthorFinder) *PostService {
    return &PostService{store: store, author: author}
}
```

### 5.2 Concrete Implementation at Repository Layer
```go
// File: internal/repository/user_repo.go
package repository

import (
    "context"
    "gorm.io/gorm"
    "myproject/internal/model"
)

// Concrete struct: exported for callers to wire
type UserRepo struct {
    db *gorm.DB
}

// Return concrete struct pointer: NO INTERFACE RETURNED
func NewUserRepo(db *gorm.DB) *UserRepo {
    return &UserRepo{db: db}
}

func (r *UserRepo) Create(ctx context.Context, u *model.User) error {
    return r.db.WithContext(ctx).Create(u).Error
}

func (r *UserRepo) FindByID(ctx context.Context, id string) (*model.User, error) {
    var u model.User
    if err := r.db.WithContext(ctx).First(&u, "id = ?", id).Error; err != nil {
        return nil, err
    }
    return &u, nil
}

func (r *UserRepo) FindByEmail(ctx context.Context, email string) (*model.User, error) {
    var u model.User
    if err := r.db.WithContext(ctx).First(&u, "email = ?", email).Error; err != nil {
        return nil, err
    }
    return &u, nil
}
```

### 5.3 High-Speed Manual Mocking (Zero-Dependency Black-Box Testing)
```go
// File: internal/service/user_service_test.go
package service_test

import (
    "context"
    "errors"
    "testing"
    "myproject/internal/model"
    "myproject/internal/service"
)

// Lightweight manual mock with function fields
type mockUserStore struct {
    createFn      func(ctx context.Context, u *model.User) error
    findByIDEFn   func(ctx context.Context, id string) (*model.User, error)
    findByEmailFn func(ctx context.Context, email string) (*model.User, error)
}

func (m *mockUserStore) Create(ctx context.Context, u *model.User) error {
    if m.createFn != nil {
        return m.createFn(ctx, u)
    }
    return nil
}

func (m *mockUserStore) FindByID(ctx context.Context, id string) (*model.User, error) {
    if m.findByIDEFn != nil {
        return m.findByIDEFn(ctx, id)
    }
    return nil, nil
}

func (m *mockUserStore) FindByEmail(ctx context.Context, email string) (*model.User, error) {
    if m.findByEmailFn != nil {
        return m.findByEmailFn(ctx, email)
    }
    return nil, nil
}

func TestRegister_DuplicateEmail_ReturnsError(t *testing.T) {
    mockStore := &mockUserStore{
        findByEmailFn: func(ctx context.Context, email string) (*model.User, error) {
            return &model.User{ID: "existing-id", Email: email}, nil
        },
    }

    svc := service.NewUserService(mockStore)

    // Execute service logic and assert error
    err := svc.Register(context.Background(), "existing-id", "test@domain.com", "secret")
    if err == nil {
        t.Fatal("expected duplicate email error, got nil")
    }
}
```

---

## 6. Production Multi-Stage Dockerfile

```dockerfile
# ==========================================
# STAGE 1: Build Binary
# ==========================================
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Install security certificates and timezone data
RUN apk add --no-cache git ca-certificates tzdata

# Cache dependency downloads
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# Copy complete project source
COPY . .

# Compile static binary with optimizations (-ldflags="-s -w" strips debug tables)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-s -w" \
    -o /app/bin/server ./cmd/api/main.go

# ==========================================
# STAGE 2: Minimal Production Runtime
# ==========================================
FROM alpine:3.21

WORKDIR /app

# Install runtime dependencies and configure unprivileged user
RUN apk add --no-cache ca-certificates tzdata \
    && addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy system certificates and timezones from builder
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy compiled binary
COPY --from=builder /app/bin/server /app/server

# Security: run as non-root user
USER appuser

EXPOSE 8080

CMD ["/app/server"]
```

---

## 7. Local Development `docker-compose.yml`

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: backend-api
    restart: unless-stopped
    ports:
      - "8080:8080"
    env_file:
      - .env
    environment:
      - DB_HOST=postgres
      - DB_PORT=5432
      - REDIS_ADDR=redis:6379
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - app-net

  postgres:
    image: postgres:16-alpine
    container_name: backend-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${DB_USER:-postgres}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-postgres}
      POSTGRES_DB: ${DB_NAME:-app_db}
    ports:
      - "5432:5432"
    volumes:
      - pg_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-postgres}"]
      interval: 5s
      timeout: 5s
      retries: 5
    networks:
      - app-net

  redis:
    image: redis:7-alpine
    container_name: backend-redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 5s
      retries: 5
    networks:
      - app-net

networks:
  app-net:
    driver: bridge

volumes:
  pg_data:
  redis_data:
```
