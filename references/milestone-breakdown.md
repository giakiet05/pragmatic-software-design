# Pragmatic Software Design: Master Milestone Breakdown & Stepper Protocol

This document serves as the **Single Source of Truth** for the **Collaborative Section Stepper** model across the entire `pragmatic-software-design` suite.

It defines:
1. **Interaction Protocols & Command Triggers** between the Engineer (Human) and the AI Agent.
2. **Standard Milestone Decomposition** for each engineering document (Stage 1 through Stage 6), mapped 1-to-1 with headings in `templates/*.template.md`.
3. **Dedicated Operational Procedures** for Stage 0 (Constitution) and Stage 7 (Source Code Implementation).
4. **Master Orchestration Matrix** encompassing all 8 stages of the engineering lifecycle.

---

## 0. Collaborative Stepper Operational Protocol & Command Triggers

### 0.1 Four Golden Rules
1. **Discussion-First (Debate First, Write Later)**:
   - When any skill is invoked, the Agent **SHALL NEVER write the entire document unilaterally**.
   - The Agent presents technical analysis, 2–3 viable options with trade-offs, and a recommended approach directly in chat for the active Milestone.
2. **Write-Trigger (Explicit Command Required)**:
   - The Agent writes (appends / updates in-place) to the canonical document if and only if the engineer issues an explicit command (*"lock milestone"*, *"write this section"*, *"save section"*, *"commit to file"*).
3. **In-Place Canonical Editing (Zero Draft Artifacts)**:
   - All write operations update the canonical target file directly (`docs/01-brd.md`, `docs/02-srs.md`, etc.).
   - Creating versioned duplicate files (`brd-v1.md`, `srs-draft.md`) or version subdirectories (`1-brd/`) is strictly prohibited. Git handles version history.
4. **Fast-Track Override (Emergency Speed Valve)**:
   - If the engineer explicitly commands a full document generation (*"generate full doc at once"*, *"write the whole file"*), the Agent loads all upstream context and generates the complete document in a single turn.

### 0.2 Standard Command Triggers

| Engineer Command | AI Agent Behavior |
| :--- | :--- |
| `lock milestone [N]` / `write this section` / `save section` | Writes Milestone N content into target document, updates `Active Milestone` column in `docs/00-pipeline.md`, reports checkpoint, and opens discussion for Milestone N+1. |
| `revise [content]` / `switch to option B` | Keeps current Milestone discussion active, adjusts technical approach per feedback, **does not write to file**. |
| `next` / `skip this section` | Skips or applies defaults to the current Milestone, updates `Active Milestone` in `docs/00-pipeline.md`, and advances directly to the next Milestone discussion. |
| `generate full doc at once` / `write the whole file` | **Fast-Track Override**: Ingests all upstream context, generates 100% of the document to disk in a single pass, and sets `Active Milestone` to `Complete (Awaiting Sign-off)`. |
| `approve [stage]` (e.g., `approve brd`, `approve srs`) | Transitions stage status in `docs/00-pipeline.md` from `IN_REVIEW` to `APPROVED`, sets `Active Milestone` to `Done`, unlocking the next stage to `READY`. |
| `skip [stage] due to [reason]` / `bypass [stage]` | Marks stage as `N/A - [Reason]` with `Active Milestone` as `N/A` in pipeline, records audit log entry, and unlocks the next stage. |

---

## 1. Stage 0: `/prag-constitution` (`docs/constitution.md`)
**Template Reference**: `templates/constitution.template.md` & `templates/00-pipeline.template.md`  
**Objective**: Establish 8 non-negotiable architectural articles, bind language/runtime constraints, and initialize the Master Governance Dashboard.  
**Execution Characteristic**: *One-Shot Ratification Gate* (Executes in 4 sequential steps, stops for human sign-off before unlocking Stage 1).

| Execution Step | Technical Objective | Detailed Agent Behavior |
| :--- | :--- | :--- |
| **Step 1: Clarification Gate** | Establish project identity | Scans workspace. If empty, clarifies: (1) Project concept/objectives, (2) Governance profile (`Standard Business` vs `Pure Technical/Infra`), (3) Language/runtime constraints if any. |
| **Step 2: Ratify 8 Core Articles** | Establish non-negotiable rules | Tailors 8 core articles to stack (4-tier boundary, modern runtime, zero secrets, structured logging, test-first & Docker, clean code, KISS/YAGNI, pragmatic pattern adoption). |
| **Step 3: Init Governance Dashboard** | Initialize pipeline state machine | Generates `docs/00-pipeline.md`. Sets Stage 0 to `APPROVED` (`Active Milestone`: `Done`), Stage 1 to `READY` (`Active Milestone`: `-`) (or `N/A` if Pure Technical), remaining stages to `LOCKED` (`-`). |
| **Step 4: Verification & Sign-off** | Deliver project baseline | Persists `docs/constitution.md` and `docs/00-pipeline.md`. Reports summary and prompts engineer to run `/prag-brd`. |

---

## 2. Stage 1: `/prag-brd` (`docs/01-brd.md`)
**Template Reference**: `templates/01-brd.template.md`  
**Objective**: Elicit business context, scope boundaries, user operational flows, and invariant business rules prior to architectural design.

| Milestone | Headings / Sections in Template | Technical Details & Acceptance Criteria |
| :--- | :--- | :--- |
| **Milestone 1** | **`## 2. Business Context & Strategic Vision`**<br>• `2.1 Problem Statement`<br>• `2.2 Project Vision Statement`<br>• `2.3 Measurable Business Objectives (BO)` | • Document enterprise/user pain points.<br>• Articulate target system vision statement.<br>• Define SMART Business Objectives catalog (`BO-01`, `BO-02`...) with quantitative ROI/KPI targets. |
| **Milestone 2** | **`## 3. Stakeholder Profiles & Personas`**<br>• `3.1 Stakeholder RACI Matrix`<br>• `3.2 User Personas`<br>**`## 4. Project Scope Boundaries`**<br>• `4.1 In-Scope (MVP & Release Baseline)`<br>• `4.2 Strict Out-of-Scope (Deferred or Prohibited)` | • Construct RACI responsibility matrix (Responsible, Accountable, Consulted, Informed).<br>• Define primary User Personas and interaction goals.<br>• Enforce strict **In-Scope** (MVP feature baseline) and **Strict Out-of-Scope** boundaries (prevent scope creep by explicitly stating what the system *shall not do*). |
| **Milestone 3** | **`## 5. Operational Concepts & User Scenarios`**<br>• `5.1 Current State Operational Flow (AS-IS Process)`<br>• `5.2 Target State Operational Flow (TO-BE Process)`<br>• **`5.3 Core User Scenarios & User Stories (US)`** | • Perform operational gap analysis: Current State (AS-IS, manual/fragmented) vs Target State (TO-BE, automated/centralized).<br>• **Specify all User Stories (`US-01`, `US-02`...)** following standard structure: Persona, Value Statement, Governing Business Rules, Independent Test, and BDD Acceptance Criteria (Given-When-Then). |
| **Milestone 4** | **`## 6. High-Level Business Requirements (BR)`**<br>**`## 7. Business Rules (BU-R)`**<br>• `BU-R-01`: Threshold / Qualification Rule<br>• `BU-R-02`: Lifecycle State Transition Rule<br>• `BU-R-03`: Scoring & Classification Rule<br>• `BU-R-04`: Deduplication & Merge Rule | • High-Level Business Requirements inventory (`BR-xxx`).<br>• Invariant Business Rules system (`BU-R-xxx`): quantitative thresholds, entity state transition constraints, deduplication and merge criteria. |
| **Milestone 5** | **`## 8. Business Constraints, Assumptions & Traceability Matrix`**<br>• `8.1 Business Constraints`<br>• `8.2 Business Assumptions`<br>• `8.3 Bidirectional Traceability Matrix (SEI CMMI-DEV REQM)` | • Technical, regulatory (GDPR, data privacy), budgetary, and timeline constraints.<br>• Project assumptions inventory.<br>• Bidirectional Traceability Matrix linking business objectives to user stories and business rules: `BO-xxx` <-> `US-xxx` <-> `BR-xxx` <-> `BU-R-xxx`. |

---

## 3. Stage 2: `/prag-srs` (`docs/02-srs.md`)
**Template Reference**: `templates/02-srs.template.md`  
**Objective**: Transform business requirements from BRD into formal software specifications with Use Case scenarios, EARS syntax, domain model, and ATAM Utility Tree.

| Milestone | Headings / Sections in Template | Technical Details & Acceptance Criteria |
| :--- | :--- | :--- |
| **Milestone 1** | **`## 1. System Overview & Scope`**<br>• `1.1 Product Perspective & Context`<br>• `1.2 System Boundary & Responsibility`<br>**`## 2. External Interface Requirements`**<br>• `2.1 User Interfaces (UI / UX / CLI Expectations)`<br>• `2.2 Software & Third-Party Interfaces`<br>• `2.3 Communications Protocols` | • Define system context boundaries and responsibility perimeter.<br>• Specify user interface contracts (Web/Mobile/CLI).<br>• Third-party software interface contracts (Payment Gateways, Identity Providers, SMTP...).<br>• Standardize network communication protocols (HTTP/2, gRPC, TLS 1.3, WebSockets). |
| **Milestone 2** | **`## 3. Domain Model & State Machine Lifecycles`**<br>• `3.1 Core Domain Entities & Attributes`<br>• `3.2 State Transition Matrix (State Machine)` | • Core domain entity catalog with attributes and relational cardinalities.<br>• State Transition Table/Matrix: valid states, triggers, preconditions, and strictly prohibited transitions.<br>• Mermaid `stateDiagram-v2` for core entity lifecycles. |
| **Milestone 3** | **`## 4. System Use Cases & Scenario Specifications (UC)`**<br>• `4.1 Use Case Catalog`<br>• `4.2 Detailed Use Case Specifications` | • Construct **Use Case Catalog (Table 4.1)** overview (`UC-01`, `UC-02`...) mapped from User Stories (`US-xxx`), Primary Actor, and Priority.<br>• Formal Cockburn Use Case specifications: Preconditions, Postconditions (Success & Failure Guarantees), step-by-step Happy Path, Alternative Flows, and Exception Flows (e.g., 2a, 3a: timeout, rollback).<br>• *Diagram Rule*: **Do NOT use traditional UML Use Case diagrams** (avoids redundancy with Table 4.1 and awkward Mermaid syntax). For complex multi-party interactions, model with Mermaid Sequence Diagrams or Flowcharts. |
| **Milestone 4** | **`## 5. Functional Requirements (EARS Syntax & I/O Contracts)`**<br>• `5.1 Ubiquitous Requirements (UBI)`<br>• `5.2 Event-Driven Requirements (EVT)`<br>• `5.3 State-Driven Requirements (STA)`<br>• `5.4 Unwanted Behavior & Error Handling (UNW)`<br>• `5.5 Optional Feature Requirements (OPT)` | • Translate functional requirements directly from Use Case steps and error branches into 5 strict EARS syntactic patterns.<br>• Complete I/O contracts and CMMI verification methods (`T/D/I/A`). |
| **Milestone 5** | **`## 6. Non-Functional Requirements (ATAM Utility Tree Matrix)`**<br>**`## 7. Data Requirements & Retention Policies`**<br>• `7.1 Volume & Sizing Assumptions`<br>• `7.2 Data Retention & Purge Policies` | • **Quantified Quality Targets**: ATAM Utility Tree quantifying Latency (p95/p99), Throughput, Availability, RPO/RTO via Stimulus -> Response scenarios.<br>• Establish high-priority scenarios `(H, H)` and `(H, M)`.<br>• Data volume assumptions, archival schedules, and retention/purge policies. |
| **Milestone 6** | **`## 8. Verification & Validation Framework (CMMI Standards)`**<br>**`## 9. Requirements Traceability Matrix & Clarifications`**<br>• `9.1 Bidirectional Traceability Matrix (CMMI REQM)`<br>• `9.2 Clarifications Log` | • CMMI verification method mapping for every requirement (`T`est, `D`emonstration, `I`nspection, `A`nalysis).<br>• **Complete Bidirectional Traceability Matrix**: `BO-xxx` <-> `BR-xxx` <-> `US-xxx` <-> `UC-xxx` <-> `FR-xxx` <-> `NFR-xxx` <-> `Verification Method`.<br>• Consolidated `Clarifications Log` recording all resolved engineering ambiguities. |

---

## 4. Stage 3: `/prag-arch` (`docs/03-architecture.md`)
**Template Reference**: `templates/03-architecture.template.md` & `templates/adr.template.md`  
**Objective**: Architect overall system design, C4 models, source layering invariants, capacity sizing, fault tolerance, and generate discrete ADRs.

| Milestone | Headings / Sections in Template | Technical Details & Acceptance Criteria |
| :--- | :--- | :--- |
| **Milestone 1** | **`## 1. Architecture Drivers & Constraints`**<br>• `1.1 Key SLA/SLO Targets`<br>• `1.2 Non-Negotiable Technical Constraints`<br>**`## 2. Technology Stack & Selection Matrix`** | • **Architecture Discovery Gate (MANDATORY)**: Analyze SLA/SLO targets from SRS, propose 2–3 architectural styles (Modular Monolith vs Microservices) with trade-offs.<br>• Propose & finalize Core Technology Selection Matrix (Language/Runtime, Primary DB, Broker/Cache) with rationale.<br>• **STOP and wait for engineer sign-off** on architectural style and tech stack before writing any files. |
| **Milestone 2** | **`## 3. Architecture Style & Boundary Rules`**<br>• `3.1 Architectural Pattern`<br>• `3.2 Strict 4-Tier Layering Invariants`<br>• `3.3 Architectural Guardrails (Forbidden Dependencies)`<br>• `3.4 Unified Directory Layout` | • **Source Layering Invariants**: Establish strict rules for 4 tiers (`Router` -> `Controller` -> `Service` -> `Repository`).<br>• Enforce Architectural Guardrails: prohibit circular dependencies, forbid lower-tier calls to upper tiers, enforce interface-driven decoupling.<br>• Define standard project directory layout (e.g., for Go: `cmd/`, `internal/{router,controller,service,repository,model}/`). |
| **Milestone 3** | **`## 4. Structural Views (C4 Model)`**<br>• `4.1 System Context View (C4 Level 1)`<br>• `4.2 Container View (C4 Level 2)`<br>• `4.3 Component View (C4 Level 3 - Selective)` | • Mermaid C4 L1 System Context diagram (System & users/external actors).<br>• Mermaid C4 L2 Container diagram (Containers, Datastores, Message Queues).<br>• Selective C4 L3 Component diagrams for highly complex internal modules. |
| **Milestone 4** | **`## 5. Dynamic, Data & Event Flow View`**<br>• `5.1 Streamlined Data & Event Pipeline`<br>• `5.2 Core Interaction Sequences` | • Data processing pipelines and real-time asynchronous event streams.<br>• Mermaid Sequence Diagrams for the most critical end-to-end interaction paths. |
| **Milestone 5** | **`## 6. Capacity Planning & Scalability Horizons`**<br>• `6.1 Resource Sizing & Storage Growth Estimations`<br>• `6.2 Scalability Horizons & Evolution Triggers` | • Arithmetic sizing models: Peak RPS, Network Bandwidth, DB and Object Storage growth at 1 month / 1 year.<br>• Hardware baseline requirements (CPU, RAM, Disk IOPS).<br>• Scalability triggers (Scale-up, Scale-out, Read Replicas, Partitioning thresholds). |
| **Milestone 6** | **`## 7. Cross-Cutting Tactics & High Availability / Disaster Recovery (HA/DR)`**<br>**`## 8. Deployment, Infrastructure & Rollout Strategy`**<br>**`## 9. Appendix: Architectural Decision Records & Complexity Tracking`** | • Cross-cutting tactics: Caching strategy, Rate Limiting, Circuit Breaker, Idempotency.<br>• FMEA failure mode analysis table and recovery mechanics; RPO/RTO and failover strategy.<br>• Deployment topology (Compose/K8s) and zero-downtime rollout strategy.<br>• **Generate N discrete ADRs in `docs/adr/`** (1 decision = 1 ADR file).<br>• Complexity tracking defense table (KISS & YAGNI justification). |

---

## 5. Stage 4: `/prag-api` (`docs/04-api.md`)
**Template Reference**: `templates/04-api.template.md`  
**Objective**: Standardize RESTful API contracts per OpenAPI 3.1, write conflict mitigation (ETag/412), streaming, and webhooks.

| Milestone | Headings / Sections in Template | Technical Details & Acceptance Criteria |
| :--- | :--- | :--- |
| **Milestone 1** | **`## 1. Global API Conventions, Transport & Security`**<br>• `1.1 Base URL & Content Negotiation`<br>• `1.2 Authentication & Security Headers`<br>• `1.3 CORS Policy & Header Exposure`<br>**`## 2. Querying Standards`**<br>• `2.1 Pagination Standards`<br>• `2.2 Sorting Conventions`<br>• `2.3 Filtering Conventions`<br>• `2.4 Sparse Fieldsets` | • Base URL conventions, TLS, Bearer Auth/API Key, Content Negotiation.<br>• Query standards via Pragmatic JSON:API: cursor vs offset pagination, multi-field sorting (`sort=-created_at,id`), filter syntax and comparison operators. |
| **Milestone 2** | **`## 3. Standardized Response & Error Envelopes`**<br>• `3.1 Unified Success Envelope`<br>• `3.2 Unified Error Envelope (RFC 7807 Compliant)`<br>• `3.3 HTTP Status Codes Matrix`<br>• `3.4 Application-Specific Custom Error Code Dictionary` | • Unified standard success response envelope.<br>• Unified error response strictly adhering to RFC 7807 Problem Details (`type`, `title`, `status`, `detail`, `instance`, `invalid_params`).<br>• HTTP status code matrix and custom business error code dictionary. |
| **Milestone 3** | **`## 4. Concurrency Control, HTTP Caching & API Lifecycle`**<br>• `4.1 Concurrency Control (Lost Update Prevention via ETags)`<br>• `4.2 HTTP Caching & Bandwidth Optimization`<br>• `4.3 Versioning, Breaking Changes & Deprecation Policy` | • ETag concurrency control: `PUT/PATCH` requires `If-Match: "<hash>"`, returns `412 Precondition Failed` on mutation collision.<br>• Caching GET responses via `If-None-Match` -> `304 Not Modified`.<br>• API versioning strategy and `Sunset`/`Deprecation` header lifecycle. |
| **Milestone 4** | **`## 5. Endpoint Specifications by Resource`**<br>• `5.1 Authentication Resource`<br>• `5.2 Core Domain Resources`<br>• `5.3 Bulk / Batch Operations`<br>• `5.4 Long-Running Asynchronous Jobs` | • Detailed CRUD endpoints with OpenAPI 3.1 / JSON Schema (Draft 2020-12).<br>• Comprehensive Request/Response payloads with data types, formats, validation rules, examples.<br>• Bulk/batch endpoint contracts and long-running asynchronous jobs (`202 Accepted` + polling/webhook). |
| **Milestone 5** | **`## 6. File Transfer Architecture`**<br>• `6.1 Direct-to-Storage via Pre-signed URL`<br>• `6.2 Multipart Form-Data (Small Asset Fallback)`<br>**`## 7. Real-Time & Event Streaming`**<br>• `7.1 Outbound Webhooks`<br>• `7.2 Server-Sent Events (SSE)`<br>• `7.3 WebSockets` | • Large file upload flow via S3/Blob storage pre-signed URLs.<br>• Outbound webhook architecture with cryptographic signature (`HMAC-SHA256`) and exponential backoff retry policy.<br>• Real-time unidirectional streaming (SSE) or full-duplex bidirectional protocol (WebSocket). |

---

## 6. Stage 5: `/prag-db` (`docs/05-database.md`)
**Template Reference**: `templates/05-database.template.md`  
**Objective**: Author physical data model, calculate connection pool sizing, optimize ESR indexes, and ensure zero-downtime migration safety.

| Milestone | Headings / Sections in Template | Technical Details & Acceptance Criteria |
| :--- | :--- | :--- |
| **Milestone 1** | **`## 1. Database Overview, Engine Configuration & Connection Pooling`**<br>• `1.1 RDBMS Engine & Instance Parameters`<br>• `1.2 Connection Pooling & Query Protection Limits`<br>• `1.3 Naming Conventions` | • Engine selection and core instance parameters (shared_buffers, work_mem...).<br>• **Standard Connection Pool Formula**: `max_conns = (CPU Cores * 2) + Disk Spindles`.<br>• Strict timeout budgets (`statement_timeout`, `idle_in_transaction_session_timeout`) and naming conventions (snake_case, plural tables). |
| **Milestone 2** | **`## 2. Logical Data Model (Mermaid ERD)`** | • Comprehensive Mermaid ERD with all domain entities, primary keys (PK), foreign keys (FK), and cardinality notations (1:1, 1:N, N:M). |
| **Milestone 3** | **`## 3. Physical Data Dictionary (Table Specifications)`**<br>**`## 7. Data Integrity, Cascade Rules & Constraints`**<br>• `7.1 Foreign Key Cascade Rules`<br>• `7.2 Domain Check Constraints`<br>• `7.3 Soft Deletion vs Hard Deletion Protocol` | • Column-by-column physical data dictionary using precise engine types (Postgres: `TIMESTAMPTZ`, `BIGINT`, `NUMERIC(12,4)` over floating point, `JSONB`).<br>• Explicit NOT NULL, default values, and domain CHECK constraints.<br>• Foreign key cascade rules (`RESTRICT` vs `CASCADE`) and standardized soft deletion protocol (`deleted_at`). |
| **Milestone 4** | **`## 4. Transaction Isolation & Concurrency Locking Strategy`**<br>• `4.1 Isolation Levels`<br>• `4.2 Locking Strategy Comparison`<br>**`## 5. Indexing & Query Optimization Strategy`**<br>• `5.1 Index Inventory (ESR Rule)` | • Transaction isolation levels (`READ COMMITTED` vs `REPEATABLE READ`).<br>• Pessimistic locking (`FOR UPDATE SKIP LOCKED`) for background job queues; deadlock mitigation strategy.<br>• Index inventory strictly engineered following ESR rule (`Equality` -> `Sort` -> `Range`), partial indexes, and covering indexes. |
| **Milestone 5** | **`## 6. Table Partitioning & Data Lifecycle (Hot / Warm / Cold)`**<br>• `6.1 Declarative Partitioning Specification`<br>• `6.2 Data Retention & Tiering Policy`<br>**`## 8. Migration & Zero-Downtime Deployment Discipline`**<br>• `8.1 Migration File Conventions`<br>• `8.2 Production Migration Safety Checklist`<br>• `8.3 Initial Seeding Baseline` | • Declarative table partitioning specification (Range/List partitioning by time/tenant).<br>• Data tiering lifecycle (Hot -> Warm -> Cold) and automated purge policies.<br>• Migration conventions (Up/Down pairs); lock-free DDL discipline (`CREATE INDEX CONCURRENTLY`, Expand-Contract pattern); initial production seed baseline. |

---

## 7. Stage 6: `/prag-tasks` (`docs/06-tasks.md`)
**Template Reference**: `templates/06-tasks.template.md`  
**Objective**: Decompose implementation into phased sequential blocks and parallel `[P]` tasks, enforcing Test-First discipline and 6-point Definition of Done (DoD).

| Milestone | Headings / Sections in Template | Technical Details & Acceptance Criteria |
| :--- | :--- | :--- |
| **Milestone 1** | **`## 1. Task Format & Traceability Conventions`**<br>**`## 2. Definition of Done (DoD) - Mandatory Completion Checklist`**<br>**`## Phase 1: Setup & Shared Infrastructure`** | • Task syntax conventions: `- [ ] [TaskID] [P?] [StoryTag] [RequirementRef] [TargetFile] Description`.<br>• Establish mandatory 6-point Definition of Done (DoD).<br>• Project initialization tasks: Go module / runtime init, linter configuration, strict environment config loader, structured JSON logger, test runner harness. |
| **Milestone 2** | **`## Phase 2: Foundational Infrastructure (Blocking Prerequisites)`** | • **Mandatory Blocking Gate** before implementing business features.<br>• Foundational tasks: DB connection pool init, migration runner, seed loader, core entity domain structs, HTTP router with CORS, request context & RFC 7807 error middleware. |
| **Milestone 3** | **`## Phase 3: User Story 1 - [MVP Core Feature]`**<br>• `### Tests for User Story 1 (Write First - Test-Driven)`<br>• `### Implementation for User Story 1` | • Deconstruct User Story 1 (core MVP feature) following mandatory Test-First discipline:<br>1. Write unit & integration tests<br>2. Implement DB repository queries<br>3. Implement service business logic<br>4. Implement controller / HTTP handlers & routes<br>5. Verification checkpoint: 100% test pass. |
| **Milestone 4** | **`## Phase 4+: User Story 2+ - [Secondary & Integration Features]`**<br>• `### Tests for User Story N (Write First)`<br>• `### Implementation for User Story N` | • Incrementally deconstruct remaining User Stories, applying parallel `[P]` flags to independent repository/service/controller tasks to optimize execution throughput. |
| **Milestone 5** | **`## Phase 5: Hardening, Polish & Operational Verification`** | • Comprehensive verification tasks:<br>1. Full test suite pass with race detector (`go test -race -cover ./...`)<br>2. Zero linter warnings/errors<br>3. Dependency vulnerability scan (`govulncheck`)<br>4. Docker build & compose smoke test<br>5. Verify all 6 DoD criteria and transition pipeline to `IN_REVIEW`. |

---

## 8. Stage 7: `/prag-implement` (Source Code Execution)
**Objective Reference**: Execute real source code implementation per `docs/06-tasks.md`  
**Objective**: Safely realize code, honor parallel `[P]` markers, enforce Test-First, run automated terminal tests, and verify 6-point DoD.  
**Execution Characteristic**: *Continuous Task Execution Stepper* (Executes task-by-task or phase-by-phase; mass unattended auto-coding is strictly prohibited).

| Execution Segment | Technical Objective | Detailed Agent Behavior |
| :--- | :--- | :--- |
| **Segment 1: Interactive Scope Gate** | Confirm execution scope | Scans open tasks (`- [ ]`) in earliest incomplete phase. Prompts engineer to confirm target Task or Phase. **Never writes code before confirmation**. |
| **Segment 2: Targeted Retrieval** | Token context conservation | **DO NOT read all docs/ 01 through 05**. Opens only exact API lines (`04-api.md`) or DB tables (`05-database.md`) referenced in task tag. |
| **Segment 3: Test-First Cycle** | Red-Green-Refactor discipline | 1. Write Unit/Integration test first in `*_test.go` or stack equivalent.<br>2. Run test to confirm failure (Red).<br>3. Write minimal implementation at `[TargetFile]` to pass (Green).<br>4. Refactor clean. |
| **Segment 4: Terminal Automated Verification** | Automated testing & Circuit Breaker | Agent executes test command directly in terminal (`go test -race ./...`, linter). If tests fail twice consecutively, **activates Circuit Breaker to stop and report**, never guessing fixes. |
| **Segment 5: 6-Point DoD Sign-off** | Completion sign-off | Validates all 6 DoD criteria (Compile, Race pass, Error wrapped, Clean linter, Zero secrets, Contract fidelity) before checking `- [ ]` to `- [x]`. |

---

## 9. Master Orchestration Matrix (Comprehensive 8-Stage Lifecycle)

| Stage | Skill Command | Target Artifact File | Milestones / Steps | Required Upstream Context | Prerequisite Unlocking Gate |
| :---: | :--- | :--- | :---: | :--- | :--- |
| **0** | `/prag-constitution` | `docs/constitution.md`<br>`docs/00-pipeline.md` | 4 Sequential Steps | Workspace root descriptors | Project start (No blockers) |
| **1** | `/prag-brd` | `docs/01-brd.md` | 5 Milestones | `docs/constitution.md` | Stage 0 marked `APPROVED` |
| **2** | `/prag-srs` | `docs/02-srs.md` | 6 Milestones | `docs/constitution.md`<br>`docs/01-brd.md` | Stage 1 marked `APPROVED` or `N/A` |
| **3** | `/prag-arch` | `docs/03-architecture.md`<br>`docs/adr/ADR-*.md` | 6 Milestones | `docs/constitution.md`<br>`docs/01-brd.md`<br>`docs/02-srs.md` | Stage 2 marked `APPROVED` or `N/A` |
| **4** | `/prag-api` | `docs/04-api.md` | 5 Milestones | `docs/02-srs.md`<br>`docs/03-architecture.md` | Stage 3 marked `APPROVED` or `N/A` |
| **5** | `/prag-db` | `docs/05-database.md` | 5 Milestones | `docs/02-srs.md`<br>`docs/03-architecture.md`<br>`docs/04-api.md` | Stage 3 marked `APPROVED` or `N/A` |
| **6** | `/prag-tasks` | `docs/06-tasks.md` | 5 Milestones | `docs/constitution.md` -> `docs/05-database.md` | Stage 5 marked `APPROVED` or `N/A` |
| **7** | `/prag-implement` | Source Code (`internal/...`) | Phased Tasks | `docs/06-tasks.md` + Targeted Slice Lookup | Stage 6 marked `APPROVED` |
