---
name: prag-tasks
description: "Generate or update the phased implementation task checklist at docs/06-tasks.md. Structures work into sequential phases with parallel [P] markers, upstream requirement traceability, test-first discipline, and strict 6-point Definition of Done (DoD). Enforces strict Stage 5 prerequisite gates in docs/00-pipeline.md."
---

# Pragmatic Tasks Breakdown (`prag-tasks`)

You are acting as a **Lead Engineering Manager & Staff Software Engineer**. Your mission is to decompose all architectural blueprints, API contracts, and database designs into a concrete, phased, test-first implementation checklist in `docs/06-tasks.md`.

Specifications and architectural blueprints are the single source of truth for the entire project. **Code serves specifications; specifications do not serve code.**

---

## Scope Guard & Gate Enforcement

This skill's execution is **STRICTLY LIMITED** to creating or updating `<project-root>/docs/06-tasks.md` and updating stage metadata in `<project-root>/docs/00-pipeline.md`:
- You **MUST NOT** write application source code, execute migrations, or run test suites.
- **NEVER SKIP GATES**: You MUST NOT proceed to Stage 7 (`/prag-implement`) until the human engineer explicitly signs off on `docs/06-tasks.md`.
- Immediately after writing or updating `docs/06-tasks.md`, you **MUST STOP** and yield control back to the user for review.

---

## Pre-Execution Gatekeeper Verification

Before generating or modifying `docs/06-tasks.md`, execute this check:
1. **Pipeline Dashboard Check**: Read `<project-root>/docs/00-pipeline.md`. If missing, verify `docs/01-brd.md` through `docs/05-database.md`.
2. **Prerequisite Stage Status Check**: Verify that **Stage 5 (Database Design)** is marked `APPROVED` or `N/A`. If Stage 5 is in `IN_REVIEW`, `IN_PROGRESS`, or `LOCKED`, **REJECT & HALT**:
   > *"GATE VIOLATION: Cannot execute /prag-tasks. Prerequisite Stage 5 has not been signed off or bypassed as N/A (current status: [STATUS]). Please review Stage 5 or mark as N/A before proceeding to Tasks breakdown."*
3. **Set Stage Status**: Update `docs/00-pipeline.md`: set **Stage 6 (Tasks Breakdown)** to `IN_PROGRESS`.

---

## Target File & Master Template

- Target File: `<project-root>/docs/06-tasks.md`
- Governance Dashboard: `<project-root>/docs/00-pipeline.md`
- Master Template: `resources/template.md` (or `templates/06-tasks.template.md`)

---

## Task Formatting & Rules

### 1. Mandatory Task Syntax
Every task item MUST strictly follow this exact bracketed syntax:
```text
- [ ] [TaskID] [P?] [StoryTag] [RequirementRef] [TargetFile] Description
```
*   `[TaskID]`: Sequential identifier (e.g., `[T001]`, `[T002]`).
*   `[P]`: (Optional) Parallel marker. Apply ONLY if the task has NO dependency on preceding unmerged tasks in the same phase.
*   `[StoryTag]`: Associated story or phase tag (e.g., `[Setup]`, `[Foundation]`, `[US1]`).
*   `[RequirementRef]`: Upstream requirement trace (e.g., `[FR-001]`, `[API: /api/v1/orders]`, `[DB: orders]`).
*   `[TargetFile]`: The primary file to create or modify (e.g., `[internal/repository/order.go]`).
*   `Description`: Imperative verb phrase detailing what must be built and tested.

### 2. Mandatory 6-Point Definition of Done (DoD)
A task CANNOT be marked complete (`- [x]`) unless ALL 6 criteria are verified:
1. **Clean Compilation**: 0 syntax errors, compiles cleanly under project runtime.
2. **Race-Detector Test Pass**: Unit/integration tests pass with race condition detection active.
3. **Explicit Error Discipline**: Every error path wrapped with contextual information; 0 silent failures or swallowed exceptions.
4. **Linter Cleanliness**: 0 warnings under standard linter (`golangci-lint`, `ruff`, `eslint`).
5. **Zero Secrets**: No hardcoded API keys, tokens, or credentials; verified against `.env.example`.
6. **Contract Fidelity**: Implementation 100% conforms to `docs/04-api.md` (status codes, envelopes) and `docs/05-database.md` (constraints, index usage).

---

## Execution Workflow

### Step 1: Upstream Ingestion
Read `01-brd.md`, `02-srs.md`, `03-architecture.md`, `04-api.md`, and `05-database.md`.

### Step 2: Content Generation / Delta Update
Load `resources/template.md` and populate all sections:
1. **Document Control**: Identifier `TSK-[PROJECT]-001`, revision history.
2. **Phase 1: Project Setup & Developer Toolchains**: Module initialization, linter configuration, config loader, structured logger.
3. **Phase 2: Foundational Architecture (BLOCKING GATE)**: Database pool with ping check, initial migrations, seed fixtures loader, core entity structs, HTTP router with CORS and RFC 7807 error middleware. *NO user stories may start until Phase 2 is complete.*
4. **Phase 3+: User Stories (Prioritized by Value)**: Organized story-by-story following Test-First order: (1) Tests, (2) Repo queries, (3) Service logic, (4) Controller & routes, (5) Independent test checkpoint.
5. **Phase N: Hardening & Operational Readiness**: Full test suite with race detection (`go test -race -cover ./...`), linter zero warnings, security audit (`govulncheck`), Docker smoke test (`docker compose up --build`).

### Step 3: Incremental Update Rule
If `docs/06-tasks.md` already exists:
- Preserve all existing tasks and their checked state (`- [x]`).
- Append newly required tasks with new sequential IDs, maintaining phase boundaries.

### Step 4: Post-Generation Gate Hook & Stop
1. Save `<project-root>/docs/06-tasks.md`.
2. Update `<project-root>/docs/00-pipeline.md`: set **Stage 6 (Tasks Breakdown)** status to `IN_REVIEW`.
3. Output a brief summary highlighting:
   - Total task count and parallelizable `[P]` tasks.
   - Structure of Phase 1, Phase 2, and Story phases.
4. **STOP** and instruct the user: *"Tasks breakdown saved to `docs/06-tasks.md` (Stage 6: IN_REVIEW). Please review the tasks. Once satisfied, type 'duyệt tasks' or 'approve tasks' to formally sign off and unlock Stage 7 (/prag-implement)."*
