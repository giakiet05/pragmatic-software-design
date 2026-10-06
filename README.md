# Pragmatic Software Design: Spec & Architecture First AI Skill Suite

> A rigorous yet pragmatic Software Engineering & Architecture skill suite for Agentic AI (Antigravity & Gemini CLI, Claude Code, Cursor, Copilot). Eliminates "vibe coding" through 11 discrete, human-in-the-loop skills (`/prag-*`) that bridge enterprise-grade rigor (BRD, SRS, Utility Tree, ADD, SAD, API Contracts, DBDD, ADR) with fast developer velocity.

---

## 1. Why This Exists: The Three Paradigms

```
┌─────────────────────────┐     ┌─────────────────────────┐     ┌─────────────────────────┐
│       Vibe Coding       │     │    Agile / Spec-Kit     │     │ Pragmatic Architecture  │
├─────────────────────────┤     ├─────────────────────────┤     ├─────────────────────────┤
│ • Unguided chat prompts │     │ • Feature-level slices  │     │ • Foundation & System   │
│ • Hallucinated schemas  │     │ • Fast for tiny tasks   │     │   blueprint first       │
│ • Brittle architecture │     │ • Lacks NFR metrics     │     │ • Utility Tree + ADD    │
│ • Unmaintainable code   │     │ • Architecture erosion  │     │ • Mermaid C4 & ERD      │
│ • Zero review gates     │     │ • Heavy Python CLI tool │     │ • Human-in-the-loop     │
│                         │     │ • Hidden dotfiles       │     │ • First-class docs/     │
└─────────────────────────┘     └─────────────────────────┘     └─────────────────────────┘
```

1.  **Vibe Coding (Unguided Prompts)**: Developers prompt AI on the fly. Produces fragmented context, schema drift, inconsistent error handling, and eventual collapse of the codebase.
2.  **Agile Feature-Driven (e.g., GitHub Spec-Kit)**: A step forward by requiring specs before code. However, it operates on micro feature slices without establishing an upfront system foundation. It lacks rigorous Non-Functional Requirements (NFRs), ignores architectural trade-offs, and relies on heavy Python CLI tooling (`specify-cli`, `uv`) and hidden internal dotfiles (`.specify/`).
3.  **Pragmatic Architecture First (This Framework)**: Builds the structural foundation, domain invariants, and database blueprint *before* code implementation. It stores first-class documentation directly in `docs/` for both humans and AI, and enforces strict **Human-in-the-Loop review gates**.

---

## 2. Enterprise Concepts Mapped to Lean Artifacts

| Enterprise Standard | Engineering Purpose | Mapped Lean Artifact | What Is Preserved & Compressed |
| :--- | :--- | :--- | :--- |
| **Constitution** | Engineering principles, quality gates & stack rules | `docs/constitution.md` | 7 non-negotiable articles, stack specialization, zero secrets, structured logging, 4-tier layer boundary. |
| **BRD** *(CMMI-DEV v2.0 / ISO 29148)* | Business objectives, scope boundaries, rules & traceability | `docs/01-brd.md` | Measurable Objectives (`BO-xxx`), In/Out Scope, RACI Matrix, AS-IS vs TO-BE, Business Rules (`BU-R-xxx`), and Bidirectional Traceability Matrix. |
| **SRS** *(ISO/IEC/IEEE 29148 / IEEE 830)* | Functional requirements, system behavior, data retention | `docs/02-srs.md` | Formal requirements written in **EARS Syntax** (Ubiquitous, Event, State, Error, Optional), external interfaces, state transitions. |
| **Utility Tree** *(ATAM)* | Quantifying quality attributes (Latency, Scale, Security) | `docs/02-srs.md` | **Quality Attribute Scenarios Matrix** with measurable Stimulus -> Response targets and Priority. |
| **ADD** *(Attribute-Driven Design)* | Selecting architectural tactics to satisfy NFRs | `docs/03-architecture.md` | **Tactics Mapping Table** linking High-priority scenarios directly to proven patterns (Cache-aside, Outbox, Circuit Breaker). |
| **SAD** *(Software Architecture Doc)* | System views, components, layering | `docs/03-architecture.md` | **Mermaid C4 Diagrams** (Context & Container), 4-tier layer mapping, Complexity Tracking. |
| **API Contract** *(OpenAPI 3.1)* | RESTful contracts, DTO schemas, error envelopes | `docs/04-api.md` | Endpoint definitions, request/response JSON schemas, RFC 7807 error format, custom error code dictionary, ETag concurrency, deprecation lifecycle. |
| **DBDD & ERD** *(IEEE 1016)* | Physical schema, tables, types, indexing & constraints | `docs/05-database.md` | **Mermaid ERD**, column-by-column Data Dictionary, connection pool math, pessimistic/optimistic locking, advanced indexing (ESR, partial, covering), partitioning, migration safety checklist. |
| **Tasks Checklist** *(WBS)* | Work breakdown and execution tracking | `docs/06-tasks.md` | Phased markdown checklist with `[P]` (parallelizable) markers, 6-point DoD, and a blocking Foundational gate. |
| **ADR** *(MADR 3.0 / ISO 42010)* | Recording architectural decisions & trade-offs | `docs/adr/` | Lightweight MADR records documenting context, Olaf Zimmermann Y-Statement, consequences, validation criteria (k6), and re-evaluation triggers. |

---

## 3. Directory Layout (First-Class `docs/`)

All architecture artifacts live directly in the visible `docs/` directory. The root folder remains pristine and clean:

```text
<project-root>/
└── docs/
    ├── constitution.md       # Engineering principles & non-negotiable quality gates
    ├── 00-pipeline.md        # Project Engineering Pipeline & Governance Dashboard (State Machine & Gates)
    ├── 01-brd.md             # Business Requirements Document (SEI CMMI-DEV v2.0 / ISO 29148)
    ├── 02-srs.md             # Software Requirements Specification (ISO 29148 / IEEE 830 / EARS / Utility Tree)
    ├── 03-architecture.md    # System Architecture Blueprint (C4 Model, 4-Tier Layering, ADD Tactics)
    ├── 04-api.md             # API Specification (RESTful Contracts, RFC 7807, Error Code Dictionary)
    ├── 05-database.md        # Database Design Document (Mermaid ERD + DBDD Physical Data Dictionary)
    ├── 06-tasks.md           # Phased execution checklist with [P] parallel flags & 6-point DoD
    └── adr/                  # Architectural Decision Records (MADR 3.0 format)
        ├── ADR-0001-architecture-pattern.md
        └── ADR-0002-primary-database.md
```

---

## 4. Multi-Skill Suite Architecture

The framework is organized as **11 discrete, single-purpose skills** following Antigravity's progressive disclosure standard. Each skill has its own `SKILL.md` and dedicated scope guard:

```text
pragmatic-software-design/
├── templates/                           # Master templates (shared across skills)
│   ├── 00-pipeline.template.md          # State machine governance dashboard
│   ├── constitution.template.md
│   ├── 01-brd.template.md
│   ├── 02-srs.template.md
│   ├── 03-architecture.template.md
│   ├── 04-api.template.md
│   ├── 05-database.template.md
│   ├── 06-tasks.template.md
│   └── adr.template.md
│
├── references/                          # Tactical reference guides
│   ├── clarification-guide.md
│   ├── demo-scenario.md                 # Real-world simulation walkthrough (Go/Postgres/RabbitMQ)
│   ├── ears-syntax.md
│   ├── milestone-breakdown.md           # Master Section Stepper & milestone protocol
│   └── quality-tactics.md
│
├── skills/                              # 11 discrete Antigravity / Gemini skills
│   ├── prag-constitution/              # /prag-constitution -> docs/constitution.md & 00-pipeline.md
│   ├── prag-clarify/                   # /prag-clarify -> Interactive ambiguity elicitation
│   ├── prag-status/                    # /prag-status -> Inspect & approve pipeline stages
│   ├── prag-brd/                       # /prag-brd -> docs/01-brd.md
│   ├── prag-srs/                       # /prag-srs -> docs/02-srs.md
│   ├── prag-arch/                      # /prag-arch -> docs/03-architecture.md & C4 diagrams
│   ├── prag-api/                       # /prag-api -> docs/04-api.md
│   ├── prag-db/                        # /prag-db -> docs/05-database.md
│   ├── prag-tasks/                     # /prag-tasks -> docs/06-tasks.md
│   ├── prag-implement/                 # /prag-implement -> Test-first code execution
│   └── prag-adr/                       # /prag-adr -> docs/adr/ADR-xxx.md
│
├── scripts/
│   └── install.sh                       # Global / workspace installer
└── README.md
```

---

## 5. The 11 Discrete Skills Overview

Running an unbroken "full pipeline from A to Z" is prohibited. Each skill executes its specific mandate, checks its prerequisite gate in `docs/00-pipeline.md`, and **STOPS** for human review:

| Skill Command | Primary Target | Standard / Framework | Gate Action |
| :--- | :--- | :--- | :--- |
| `/prag-constitution` | `docs/constitution.md` | 7 Core Articles, Stack conventions, Init Pipeline | **STOPS** for review |
| `/prag-clarify` | Chat / Clarifications Log | 6 Ambiguity Dimensions (1 question at a time) | Waits for response |
| `/prag-status` | `docs/00-pipeline.md` | Dashboard inspection & human stage sign-off | Unlocks next stage |
| `/prag-brd` | `docs/01-brd.md` | CMMI-DEV v2.0 (RD/REQM), ISO 29148, SMART BOs | **STOPS** for review |
| `/prag-srs` | `docs/02-srs.md` | ISO 29148, IEEE 830, EARS Syntax, ATAM Utility Tree | **STOPS** for review |
| `/prag-arch` | `docs/03-architecture.md` | ISO 42010, C4 Model L1/L2, ADD, Capacity Sizing | **STOPS** for review |
| `/prag-api` | `docs/04-api.md` | OpenAPI 3.1, RFC 7807, Custom Error Dictionary | **STOPS** for review |
| `/prag-db` | `docs/05-database.md` | IEEE 1016 DBDD, Connection Pool Math, ESR Indexing | **STOPS** for review |
| `/prag-tasks` | `docs/06-tasks.md` | Phased `[P]` breakdown, 6-Point DoD, Blocking Gate | **STOPS** for review |
| `/prag-implement` | Source Code | Interactive Scope Gate, Test-First, Race Detection | Confirms scope before code |
| `/prag-adr` | `docs/adr/ADR-xxx.md` | MADR 3.0.0, ISO 42010, Olaf Zimmermann Y-Statement | **STOPS** for review |

### 5.1 Collaborative Discussion-First Protocol (No Auto-Dumping)
Unlike machine-centric tools that immediately dump entire documents into context, Pragmatic Design operates as an interactive engineering session between human and AI:
- **Default Mode (Collaborative Stepper)**: When a skill is invoked, the AI does **NOT** write the entire document at once. It guides the engineer milestone by milestone, debating trade-offs and drafting options in chat. It writes or updates the document **only upon explicit user command** (*"viết doc phần này"*, *"chốt"*, *"save section"*).
- **Fast-Track Override**: If the user explicitly asks to generate the whole document at once (*"gen cả file docs luôn đi"*, *"generate full doc at once"*), the AI produces the complete document in a single run.
- **In-Place Canonical Editing**: All updates are written directly to canonical files (`docs/01-brd.md`, etc.). Numbered version files (`brd-v1.md`, `brd-v2.md`) and version subfolders (`1-brd/`) are prohibited. Git manages historical revisions.
- **Surgical Maintenance**: Minor tweaks (adding a field, adjusting an index) are handled via standard chat prompts without re-invoking the ceremony of the skill. Full skill re-runs are reserved for major architectural pivots.

---

## 6. Bilingual Adaptation Rule

*   **Human Prose Language**: Adapts automatically to the user's conversational language (e.g., if you chat in Vietnamese, all documentation narratives are generated in Vietnamese; if in English, in English).
*   **Technical Identifiers**: All code symbols, database columns, Mermaid diagram syntax, commit messages, and internal log keys remain strictly in **100% English**. Emojis and decorative icons in code or commit messages are prohibited.

---

## 7. Supported Ecosystems (The Big 3)

The framework strictly enforces universal engineering laws and 4-tier layered architecture (`Router` → `Controller` → `Service` → `Repository`), with native idiomatic conventions for the Big 3 modern backend stacks:

| Principle / Concern | Go 1.24+ | Python 3.12+ (FastAPI / etc.) | TypeScript / Node.js LTS |
| :--- | :--- | :--- | :--- |
| **Package Management** | `go modules` (`go.mod`) | `uv` / `poetry` / `pip` | `pnpm` / `npm` (`package.json`) |
| **Test Runner** | `go test -race ./...` (table-driven) | `pytest -v` (`pytest-asyncio`) | `node:test` / `vitest run` |
| **Structured JSON Logging** | `log/slog` or `zerolog` | `structlog` or JSON formatter | `pino` or `winston` |
| **Configuration** | `os.Getenv` typed parser | `pydantic-settings` | `zod` + `process.env` validation |
| **Layered Directory Layout** | `cmd/server/` + `internal/{router,controller,service,repository,model}/` | `app/{main.py,routers,controllers,services,repositories,models}/` | `src/{index.ts,routes,controllers,services,repositories,models}/` |
| **Docstring Standard** | GoDoc comments | PEP 257 Docstrings | TSDoc / JSDoc standards |

---

## 8. Installation & Setup

### Global Installation (Antigravity & Gemini CLI)
Run the automated installer script to symlink all 11 skills into `~/.gemini/config/skills/`:

```bash
cd pragmatic-software-design
./scripts/install.sh --global
```

To install directly into a specific project workspace:
```bash
./scripts/install.sh --workspace /path/to/my-project
```

To uninstall:
```bash
./scripts/install.sh --uninstall
```

### Usage
In any workspace, trigger the skills via autocomplete or natural prompts:
*   Type `/prag-` to see the full autocomplete list of skills.
*   `/prag-constitution` - Ratify project principles.
*   `/prag-clarify` - Interactive interview on edge cases.
*   `/prag-brd` - Author business requirements.
*   `/prag-srs` - Author software specifications.
*   `/prag-arch` - Design architecture and C4 diagrams.
*   `/prag-api` - Define API contracts & error code dictionary.
*   `/prag-db` - Design database schema, ERD & indexing.
*   `/prag-tasks` - Break down phased tasks with `[P]` markers.
*   `/prag-implement` - Execute tasks test-first with race detection.
*   `/prag-adr` - Record significant architectural decisions.
