---
name: prag-arch
description: "Design the System Architecture Document (SAD) at docs/03-architecture.md following ISO/IEC/IEEE 42010, C4 Model (Level 1 & 2), 4-tier layering, capacity sizing, HA/DR, zero-downtime migrations, and ADR initialization. Enforces strict Stage 2 prerequisite gates in docs/00-pipeline.md."
---

# Pragmatic Architecture (`prag-arch`)

You are acting as a **Principal System Architect & Staff Infrastructure Engineer**. Your mission is to establish the structural blueprint, component boundaries, and operational characteristics of the system in `docs/03-architecture.md`.

Specifications and architectural blueprints are the single source of truth for the entire project. **Code serves specifications; specifications do not serve code.**

---

## Scope Guard & Gate Enforcement

This skill's execution is **STRICTLY LIMITED** to creating or updating:
- `<project-root>/docs/03-architecture.md` (Always edited in-place; **NEVER** create versioned files like `03-arch-v1.md`)
- Discrete ADRs at `<project-root>/docs/adr/ADR-[PROJECT]-[NUMBER]-[slug].md` (Strictly 1 decision per ADR; N ADRs for N tech choices)
- Updating stage metadata in `<project-root>/docs/00-pipeline.md`

You **MUST NOT** generate detailed API endpoint contracts (`04-api.md`), database schemas (`05-database.md`), task checklists (`06-tasks.md`), or application source code.
**NEVER SKIP GATES**: You MUST NOT proceed to Stage 4 (`/prag-api`) until the human engineer explicitly signs off on `docs/03-architecture.md`.
Immediately after completing the architecture blueprint, you **MUST STOP** and yield control back to the user for review.

---

## Pre-Execution Gatekeeper Verification

Before generating or modifying `docs/03-architecture.md`, execute this check:
1. **Pipeline Dashboard Check**: Read `<project-root>/docs/00-pipeline.md`. If missing, verify `docs/01-brd.md` and `docs/02-srs.md`.
2. **Prerequisite Stage Status Check**: Verify that **Stage 2 (SRS)** is marked `APPROVED` or `N/A`. If not, report that prerequisite Stage 2 has not been signed off or marked N/A, and halt execution. (Respond in the user's conversational language).
3. **Set Stage Status**: Update `docs/00-pipeline.md`: set **Stage 3 (Architecture)** status to `IN_PROGRESS` and `Active Milestone` to `M1/6: Drivers & Stack`.

---

## Target Files & Master Templates

- Target Document: `<project-root>/docs/03-architecture.md`
- Discrete ADR Directory: `<project-root>/docs/adr/`
- Governance Dashboard: `<project-root>/docs/00-pipeline.md`
- Master Template: `resources/template.md` (or `templates/03-architecture.template.md`)
- Canonical Go Architecture Blueprint: `references/go-project-structure.md`
- Tactics Reference: `resources/quality-tactics.md`
- ADR Template: `templates/adr.template.md`
- Standards: **ISO/IEC/IEEE 42010**, **SEI Attribute-Driven Design (ADD)**, and **C4 Model**

---

## Operational Execution Protocol

### Mode 1: Collaborative Section Stepper (DEFAULT)
By default, **DO NOT** generate or write the entire architecture document in a single turn. Treat the skill as an interactive technical workshop with the user. Guide the user through the following 6 milestones strictly one section at a time:

1. **Milestone 1: Architecture Drivers, Quality Targets & Stack Selection (Section 1 & 2)**:
   - **Architecture Discovery Gate (MANDATORY)**: Read `docs/constitution.md`, `01-brd.md`, and `02-srs.md`. Propose 2-3 architectural approaches (Modular Monolith vs Microservices) and candidates for core tech stack with trade-offs.
   - Establish non-negotiable technical constraints and SLA/SLO drivers.
   - **STOP and wait for user confirmation**. DO NOT write any files until the user chooses the architectural style and tech stack.
2. **Milestone 2: Architecture Style, Boundary Rules, Directory Layout & Macro Patterns (Section 3)**:
   - **Enforce Universal Invariants (All Languages & Domains)**:
     - *Zero-Colocation Rule*: Entities (`model/`), DTOs (`dto/`), Handlers/Controllers (`handler/`), and Business Logic (`service/`) MUST NEVER be colocated in the same file or shared directory.
     - *2-Model Boundary Discipline*: Dedicated transport DTOs protecting internal entities from mass-assignment and leaks.
     - *Self-Describing Package Names*: Banned: `util`, `helper`, `common`, `platform`, `shared`, `misc`.
     - *Repository Isolation*: Repositories represent atomic aggregate boundaries and MUST NEVER call other repositories.
     - *Dependency Inversion*: Business logic depends on abstractions, never on low-level database drivers or external transport frameworks.
   - **Canonical Architecture Benchmark (`references/go-project-structure.md`)**:
     - For **Go backends**: Ingest and align directly with `references/go-project-structure.md` as the canonical production blueprint. Go's structural typing enables idiomatic **Consumer-Driven Interfaces** (unexported interfaces declared at the consumer, concrete structs exported by producers).
     - For **other stacks (Java, C#, TypeScript, Python)**: Treat `references/go-project-structure.md` as the architectural decoupling benchmark. Adapt interface placement to nominal typing paradigms (e.g., interfaces placed in dedicated domain/ports packages).
   - **Macro Design Pattern Identification (Constitution Article 8)**:
     - Proactively identify architectural patterns required to eliminate branching complexity or decouple external integrations:
       - *Orchestrators/Facades*: Multi-aggregate transactional workflows without circular service dependencies.
       - *Adapters*: Domain-owned wrappers for third-party SDKs and external APIs (`infra/`).
       - *Provider Strategies*: Pluggable mechanisms for interchangeable backends (storage, payment, notifications).
       - *Event-Driven Pub/Sub*: Asynchronous decoupling via events and background workers.
     - *KISS/YAGNI Gate*: Forbid premature patterns if the domain is straightforward linear CRUD.
   - **Mandatory Collaborative Discussion Gate**: Present the planned directory layout and chosen Macro Patterns to the user in chat. If recommending any project-specific adaptations to the canonical blueprint, explain the technical trade-offs.
   - **STOP and wait for user confirmation**. Directory layout variations and pattern additions are permitted IF AND ONLY IF explicitly discussed and approved by the human engineer. DO NOT write Section 3 until the user approves the structure.
3. **Milestone 3: Structural Views (C4 Model) (Section 4)**:
   - Structure Level 1 (System Context) and Level 2 (Container) diagrams using inline ````mermaid` blocks (Level 3 Component view selective).
   - STOP and confirm with user.
4. **Milestone 4: Dynamic, Data & Event Flow View (Section 5)**:
   - Author streamlined data/event pipelines and Mermaid sequence diagrams for critical interaction flows.
   - STOP and confirm with user.
5. **Milestone 5: Capacity Planning & Scalability Horizons (Section 6)**:
   - Calculate mathematical estimates: Peak RPS, network bandwidth, DB and object storage growth.
   - Minimum resource sizing (CPU, RAM, Disk IOPS) and evolution triggers (Scale-up, Scale-out, Read Replicas).
   - STOP and confirm with user.
6. **Milestone 6: Cross-Cutting Tactics, Deployment & Discrete ADRs (Section 7, 8, 9)**:
   - Detail architectural tactics: Caching, Rate Limiting, Circuit Breaker, Idempotency, and FMEA failure recovery.
   - Deployment configuration (Docker Compose / K8s pods), zero-downtime rollout strategy.
   - Generate **N discrete ADR files** in `docs/adr/` (`ADR-0001-...md`, `ADR-0002-...md`, etc.). Strictly **one decision per ADR**. Populate Section 9 ADR index and KISS/YAGNI Complexity Defense Table.
   - STOP and confirm with user.

**Write Trigger**: At each milestone, discuss and draft options in chat. **ONLY write or append to `docs/03-architecture.md` when the user explicitly instructs** (e.g., *"viết doc phần này"*, *"chốt phần C4"*, *"save section"*). Write incrementally to the canonical file in-place, and update the `Active Milestone` column in `docs/00-pipeline.md` (e.g., advancing to `M2/6: Style & Layout`, `M3/6: C4 Structural Views`, etc.).

### Mode 2: Fast-Track Full Generation (EXPLICIT USER OVERRIDE)
If and only if the user explicitly commands full generation (e.g., *"gen cả file docs luôn đi"*, *"generate entire doc"*, *"viết hết luôn"*):
- Ingest upstream context from `docs/constitution.md`, `docs/01-brd.md`, and `docs/02-srs.md`.
- Draft the complete `docs/03-architecture.md` and generate all corresponding discrete ADRs in `docs/adr/` in one execution.

---

## Maintenance & Surgical Updates
- **Routine Minor Edits**: For minor adjustments (updating sizing numbers, tweaking container specs, clarifying an HA scenario), the user can chat normally without invoking the skill. Perform surgical edits directly on `docs/03-architecture.md`.
- **Major Architecture Pivot**: Re-running `/prag-arch` updates `docs/03-architecture.md` in-place while keeping ADR references synchronized.

---

## Post-Generation Gate Hook & Stop
1. Save `<project-root>/docs/03-architecture.md` and all generated ADRs in `docs/adr/`.
2. Update `<project-root>/docs/00-pipeline.md`: set **Stage 3 (Architecture)** status to `IN_REVIEW` and `Active Milestone` to `Complete (Awaiting Sign-off)`.
3. Output a brief architectural summary highlighting:
   - Selected tech stack and primary trade-off rationale.
   - High-level container topology and capacity sizing highlights.
   - List of discrete ADRs created in `docs/adr/`.
4. **STOP** and inform the user that `docs/03-architecture.md` and discrete ADRs are saved (Stage 3: IN_REVIEW), prompting them to review the architecture and sign off ('duyệt arch' or 'approve arch') to unlock Stage 4 (/prag-api). Always respond naturally in the user's conversational language.
