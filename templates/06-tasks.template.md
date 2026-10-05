<!--
[AI AGENT DIRECTIVE: PRAGMATIC TEMPLATE ADAPTATION]
1. DOMAIN FIDELITY: This document is a structural and semantic guide. You MUST adapt all entities, terminology, state transitions, and architectures strictly to the USER'S ACTUAL SYSTEM DOMAIN. NEVER copy placeholder examples (e.g., e-commerce orders, payments) unless they are genuinely required by the user's domain.
2. PRAGMATIC PRUNING (YAGNI): Tailor depth and complexity to the project's scale. If a specific advanced architectural pattern (e.g., Table Partitioning, WebSockets, Circuit Breakers, Complex Multi-region DR) is demonstrably over-engineered for the current scope, explicitly mark it as "N/A - Omitted because [concrete technical reason]" rather than fabricating unnecessary complexity.
3. ZERO PLACEHOLDER LEAKS: Replace all [BRACKETED_PLACEHOLDERS] with real, concrete project data. Never leave unpopulated template tags in the final generated document.
-->

# Implementation Tasks: [PROJECT / FEATURE NAME]

> **Document Identifier**: TSK-[PROJECT]-001  
> **Document Version**: 1.0.0  
> **Execution Model**: Pragmatic Phased Execution with Parallelism [P] Gate Rules  
> **Derived From**: `docs/01-brd.md`, `docs/02-srs.md`, `docs/03-architecture.md`, `docs/04-api.md` & `docs/05-database.md`  
> **Status**: [Draft | In Progress | Completed]  
> **Lead Implementation Engineer**: [Name / Role]  
> **Last Updated**: [YYYY-MM-DD]  

---

### Document Control & Revision History

| Version | Release Date | Author / Contributor | Summary of Changes | Approval Status |
| :---: | :---: | :--- | :--- | :---: |
| **0.1** | [YYYY-MM-DD] | [Lead Engineer] | Initial task breakdown and dependency planning | Draft |
| **1.0** | [YYYY-MM-DD] | [Lead Engineer] | Phased implementation task plan ratified with DoD gates | Approved |

---

## 1. Task Format & Traceability Conventions

Every task item in this checklist MUST adhere to this strict structure:

*   **Syntax**: `- [ ] [TaskID] [P?] [StoryTag] [RequirementRef] [TargetFile] Description`
    *   `[TaskID]`: Sequential task identifier (`T001`, `T002`, ...).
    *   `[P?]`: Marker indicating the task **can be executed in parallel** with other tasks in the same phase (independent file, zero shared locks or uncommitted interface dependencies).
    *   `[StoryTag]`: Target feature, user story, or layer (`[INFRA]`, `[US1]`, `[US2]`, `[AUTH]`, `[QA]`).
    *   `[RequirementRef]`: Direct trace to upstream specifications:
        *   `[FR-xxx]`: Functional Requirement from `docs/02-srs.md`.
        *   `[API: path]`: Endpoint contract from `docs/04-api.md`.
        *   `[DB: table]`: Table schema / migration from `docs/05-database.md`.
    *   `[TargetFile]`: Exact source code or test file path to create or modify.

---

## 2. Definition of Done (DoD) - Mandatory Completion Checklist

Before marking any task as complete (`- [x]`), the implementing engineer or AI Agent MUST verify that the change satisfies all 6 criteria:

1.  **Compilation & Build Cleanliness**: Code compiles cleanly with zero warnings, zero unused imports, and zero deprecated library calls.
2.  **Automated Testing & Race Safety**: Accompanying unit or integration tests are implemented and passing in terminal. In Go, test execution MUST include the race detector: `go test -race ./...`.
3.  **Strict Error Handling**: Explicit error handling implemented (e.g., `if err != nil` with contextual wrapping via `fmt.Errorf`). Zero ignored error returns (`_ = err` is strictly prohibited). Zero empty catch blocks.
4.  **Static Analysis & Linting**: Code passes project linter with zero warnings (`golangci-lint run`, `ruff check`, or `eslint`).
5.  **Zero-Secrets Compliance**: No hardcoded API tokens, database credentials, passwords, or private URLs. All configuration loaded via environment variables.
6.  **Contract & Schema Fidelity**: Implementation strictly conforms to the JSON schemas in `docs/04-api.md` and table definitions in `docs/05-database.md`.

---

## Phase 1: Setup & Shared Infrastructure

**Goal**: Initialize repository environment, developer toolchains, logging, and configuration infrastructure.

- [ ] T001 [INFRA] [Target: go.mod / pyproject.toml / package.json] Initialize project runtime, module namespace, and lock dependencies
- [ ] T002 [P] [INFRA] [Target: .golangci.yml / .ruff.toml / .gitignore] Configure linter rules, code formatting, and Git ignore rules
- [ ] T003 [P] [INFRA] [Target: internal/config/config.go] Implement type-safe configuration loader reading strictly from environment variables
- [ ] T004 [P] [INFRA] [Target: internal/logger/logger.go] Implement structured JSON logger wrapper with contextual `trace_id` and `request_id` fields

---

## Phase 2: Foundational Infrastructure (Blocking Prerequisites)

**Goal**: Establish core database schemas, connection pools, base models, routing middleware, and error handling envelopes.

> [!WARNING]
> **CRITICAL ARCHITECTURAL GATE**: No User Story implementation (Phase 3+) can begin until ALL tasks in Phase 2 are complete, verified, and checked off.

- [ ] T005 [INFRA] [DB: migrations] [Target: migrations/000001_initial_schema.up.sql] Create reversible SQL migration files matching `docs/05-database.md`
- [ ] T006 [INFRA] [DB: pool] [Target: internal/repository/db.go] Initialize database connection pool with `max_open_conns`, `statement_timeout = 3000ms`, and `/healthz` ping
- [ ] T007 [P] [INFRA] [DB: seeds] [Target: migrations/seeds/001_initial_seeds.sql] Create deterministic seed scripts for system roles, permissions, and test accounts
- [ ] T008 [P] [INFRA] [MODEL] [Target: internal/model/*.go] Create base domain entity structs with JSON tags and optimistic locking `version` fields per `docs/05-database.md`
- [ ] T009 [P] [INFRA] [ROUTER] [Target: internal/router/router.go] Setup HTTP router, recovery middleware, request logger, and CORS exposed headers per `docs/04-api.md`
- [ ] T010 [INFRA] [API: RFC7807] [Target: internal/controller/error.go] Implement standardized RFC 7807 problem details error responder and custom error code mapper per `docs/04-api.md` Section 3.4

**Gate Checkpoint**: Run database migrations against test database. Verify connection pool boots cleanly and router responds with `200 OK` on `/healthz`.

---

## Phase 3: User Story 1 - [Title] (Priority: P1 - MVP Core)

**Goal**: Deliver the primary end-to-end user journey as an independently testable increment.
**Traceability**: Mapped to `US-01` in `docs/01-brd.md`, `FR-001` in `docs/02-srs.md`, and endpoints in `docs/04-api.md`.

### Tests for User Story 1 (Write First - Test-Driven)
- [ ] T011 [P] [US1] [FR-001] [Target: internal/service/order_test.go] Write unit tests for US1 domain business invariants, stock validation, and state transitions
- [ ] T012 [P] [US1] [FR-001] [API: POST /api/v1/orders] [Target: tests/integration/order_test.go] Write integration test verifying full HTTP request-to-database persistence flow

### Implementation for User Story 1
- [ ] T013 [P] [US1] [DB: orders, order_items] [Target: internal/repository/order.go] Implement order repository interface, SQL queries with `FOR UPDATE` locking, and connection pool execution
- [ ] T014 [US1] [FR-001] [Target: internal/service/order.go] Implement domain service workflow, transaction boundaries, and stock deduction logic (depends on T013)
- [ ] T015 [US1] [API: POST /api/v1/orders] [Target: internal/controller/order.go] Implement controller handler, request DTO validation, idempotency checks, and HTTP 201 response serialization
- [ ] T016 [US1] [Target: cmd/server/main.go] Register US1 routes in router and wire repository-service-controller dependencies in server entrypoint

**Gate Checkpoint**: Execute `go test -race ./internal/service/... ./tests/integration/...`. Manually verify end-to-end flow using curl or HTTP client.

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: Deliver the secondary capability building on top of the MVP foundation.
**Traceability**: Mapped to `US-02` in `docs/01-brd.md`, `FR-002` in `docs/02-srs.md`, and endpoints in `docs/04-api.md`.

### Tests for User Story 2 (Write First)
- [ ] T017 [P] [US2] [FR-002] [Target: internal/service/user_test.go] Write unit and integration tests for US2 scenarios and validation edge cases

### Implementation for User Story 2
- [ ] T018 [P] [US2] [DB: users] [Target: internal/repository/user.go] Implement repository methods and queries for US2 entities
- [ ] T019 [US2] [FR-002] [Target: internal/service/user.go] Implement domain service logic and invariants for US2
- [ ] T020 [US2] [API: /api/v1/users] [Target: internal/controller/user.go] Implement controller methods, DTO binding, and route registration for US2

**Gate Checkpoint**: Verify that both US1 and US2 tests pass simultaneously without regressions.

---

## Phase 5: Hardening, Polish & Operational Verification

**Goal**: Comprehensive quality assurance, security audits, container smoke testing, and operational documentation.

- [ ] T021 [QA] [Target: whole codebase] Execute full test suite with race detection enabled: `go test -race -cover ./...` (Target: >= 80% coverage on domain service packages)
- [ ] T022 [QA] [Target: whole codebase] Run static analysis and linter; eliminate 100% of warnings: `golangci-lint run`
- [ ] T023 [SEC] [Target: dependencies] Run security vulnerability scan on all third-party packages: `govulncheck ./...` (or `pip-audit` / `npm audit`)
- [ ] T024 [OPS] [Target: docker-compose.yml] Execute Docker container smoke test (`docker compose up --build`) and verify container starts cleanly with healthy status
- [ ] T025 [PERF] [Target: benchmarks/load_test.js] Verify High-priority NFR scenarios from `docs/02-srs.md` Utility Tree via k6 benchmark (verify P99 latency < SLA threshold)
- [ ] T026 [DOCS] [Target: README.md] Update `README.md` with prerequisite setup, local run commands, environment variables table, and test execution instructions
