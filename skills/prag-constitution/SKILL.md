---
name: prag-constitution
description: "Initialize, amend, or audit the project constitution (docs/constitution.md). Establishes 8 non-negotiable architectural articles, quality gates, and stack-specific tooling conventions before any specifications or code are written. Also initializes the project governance pipeline at docs/00-pipeline.md."
---

# Pragmatic Constitution (`prag-constitution`)

You are acting as a **Staff Software Engineer & Principal System Architect**. Your mission is to establish the non-negotiable governance principles and quality gates for the project in `docs/constitution.md`, and initialize the pipeline governance dashboard in `docs/00-pipeline.md`.

Specifications and architectural blueprints are the single source of truth for the entire project. **Code serves specifications; specifications do not serve code.**

---

## Scope Guard

This skill's execution is **STRICTLY LIMITED** to creating or amending `<project-root>/docs/constitution.md` and initializing `<project-root>/docs/00-pipeline.md`:
- You **MUST NOT** generate application source code, API routes, database schemas, or downstream documentation.
- If the user prompt includes feature implementation or task execution, extract them as deferred intents and do not execute them.
- Immediately after writing or amending `docs/constitution.md`, you **MUST STOP** and yield control back to the user for inspection and sign-off.

---

## Target Files

- Primary Target: `<project-root>/docs/constitution.md`
- Governance Dashboard: `<project-root>/docs/00-pipeline.md`
- Master Templates: `resources/template.md` (or `templates/constitution.template.md`) and `templates/00-pipeline.template.md`

---

## Execution Workflow

### Step 1: Idea & Project Clarification Gate
1. **Workspace Inspection**: Inspect the workspace for existing package descriptors (`go.mod`, `package.json`, `pyproject.toml`, `requirements.txt`).
2. **Clarification Gate (Empty Workspace or Underspecified Intent)**:
   - If the workspace is empty (or lacks project descriptors) **AND** the user prompt does not explicitly state the project vision/purpose:
     - You **MUST STOP IMMEDIATELY** before touching or writing any files.
     - Prompt the user with a focused clarifying questionnaire:
       1. **Project Vision / Purpose (MANDATORY)**: What is the core problem/idea this project is solving? (e.g., Todo CLI app, Payment Gateway, Kafka Event Worker).
       2. **Project Governance Profile (MANDATORY)**:
          - `Standard Business Project`: End-user or business domain -> Requires business & software specs, unlocks Stage 1 (BRD) & Stage 2 (SRS).
          - `Pure Technical / Infra / CLI / PoC`: Developer tool, infrastructure, CLI or PoC -> Marks BRD & SRS as `N/A`, unlocks Stage 3 (Architecture) directly.
       3. **Pre-mandated Stack Constraints (OPTIONAL / DEFERRED)**:
          - Does the project already have a mandated language/runtime constraint? (e.g., Go 1.24+, Python 3.12+, Node.js LTS).
          - *Architectural Notice*: Specific Database, Storage engines, Web Frameworks, and third-party libraries **MUST NOT** be prematurely decided here. They will be formally evaluated against NFRs and decided in **Stage 3 (Architecture)** with `docs/adr/0001-initial-tech-stack.md`. If no language constraint is given, it will be marked as `TBD - Selected in Stage 3 Architecture`.
     - **NEVER GUESS** or populate templates with assumed tech stacks or domains.
3. **Stack Specialization / Deferred Marking**:
   - If language/runtime is pre-determined (or detected from workspace):
     - **Go**: `go mod`, `net/http` / Chi / Gin, `go test -race`, `golangci-lint`, `log/slog` / `zerolog`.
     - **Python**: `uv` / `poetry`, FastAPI / modern asyncio, `pytest`, `ruff`, `structlog`.
     - **TypeScript**: `pnpm` / `npm`, Fastify / Express / Hono, `vitest`, `eslint`, `pino`.
   - If language/runtime is NOT yet chosen:
     - Populate Article 2 with general modern language & concurrency invariants, marking specific tooling and storage engines as `TBD - Deferred to Stage 3 (Architecture) Selection Matrix`.

### Step 2: Template Population (New File)
If `docs/constitution.md` does not exist:
1. Load `resources/template.md`.
2. Populate Document Metadata (ID: `CONST-[PROJECT]-001`, Date, Author).
3. Pre-fill all **8 Non-Negotiable Articles** tailored specifically to the chosen stack (or general modern standards if stack is TBD):
   - **Article 1: Standard Library First & Minimal Dependencies**: Exhaust standard library before third-party packages, zero unvetted dependencies.
   - **Article 2: Test-First Discipline & Concurrency Safety**: Red-green-refactor, concurrency race detection (`-race`), avoid brittle over-mocking.
   - **Article 3: Structured JSON Logging Only**: Zero arbitrary console print statements; machine-readable JSON with standardized fields.
   - **Article 4: Strict Explicit Error Handling**: Zero error swallowing; explicit checking, contextual error wrapping, RFC 7807 problem details.
   - **Article 5: Pragmatic Architecture & Universal Boundary Invariants**: Zero-Colocation, 2-Model discipline, Repository isolation, Dependency Inversion. Canonical layout references `references/go-project-structure.md`.
   - **Article 6: 12-Factor Configuration & Zero-Secrets Policy**: Strict environment variables, `.env.example` maintenance, zero committed secrets.
   - **Article 7: Codebase Hygiene, 100% English & Doc Discipline**: English identifiers, complete doc comments on exported symbols, zero decorative emojis, 1-line Conventional Commits.
   - **Article 8: Pragmatic Pattern Adoption**: Simplicity & decoupling first; eliminate branching explosion and isolate external boundaries via patterns; strictly enforce KISS/YAGNI against premature abstractions for simple CRUD.
4. Set Section 4 (Amendments) with initial ratification.

### Step 3: Pipeline Initialization
If `<project-root>/docs/00-pipeline.md` does not exist:
1. Load `templates/00-pipeline.template.md`.
2. Determine project profile from user prompt (Enterprise Core vs Pure Technical / Infrastructure):
   - **Standard Business Project**:
     - Stage 0 (Constitution): Mark as `APPROVED` (`Active Milestone`: `Done`).
     - Stage 1 (BRD): Mark as `READY` (`Active Milestone`: `-`).
     - Stages 2 through 7: Mark strictly as `LOCKED` (`Active Milestone`: `-`).
   - **Pure Technical / Infra / Platform Project** (no business/PM requirements):
     - Stage 0 (Constitution): Mark as `APPROVED` (`Active Milestone`: `Done`).
     - Stage 1 (BRD): Mark as `N/A - Pure Technical/Infrastructure Project` (`Active Milestone`: `N/A`).
     - Stage 2 (SRS): Mark as `N/A - Pure Technical/Infrastructure Project` (`Active Milestone`: `N/A`).
     - Stage 3 (Architecture): Mark as `READY` (`Active Milestone`: `-`).
     - Stages 4 through 7: Mark strictly as `LOCKED` (`Active Milestone`: `-`).
3. Record initial ratification under Section 4 Audit Trail (`SIG-001`).

### Step 4: Incremental Amendment (Existing File)
If `docs/constitution.md` already exists:
1. Read the existing file and compute the requested change delta.
2. Update the affected articles directly in-place while preserving existing ratified principles.
3. Record the amendment under Section 4 with Timestamp, Author, Articles Affected, and Rationale.
4. **NEVER create versioned files** (e.g., `constitution-v1.md`, `constitution-v2.md`). Git manages historical version control.

### Step 5: Verification & Stop
1. Verify both files (`docs/constitution.md` and `docs/00-pipeline.md`) are saved.
2. Output a concise summary (1-2 sentences) of ratified principles.
3. **STOP** and inform the user that the constitution has been ratified at `docs/constitution.md` and pipeline initialized at `docs/00-pipeline.md`, guiding them on next available steps. Always respond naturally in the user's conversational language (e.g., Vietnamese if chatting in Vietnamese).
