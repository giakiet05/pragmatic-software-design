<!--
[AI AGENT DIRECTIVE: PRAGMATIC TEMPLATE ADAPTATION]
1. DOMAIN FIDELITY: This document is a structural and semantic guide. You MUST adapt all entities, terminology, state transitions, and architectures strictly to the USER'S ACTUAL SYSTEM DOMAIN. NEVER copy placeholder examples (e.g., e-commerce orders, payments) unless they are genuinely required by the user's domain.
2. PRAGMATIC PRUNING (YAGNI): Tailor depth and complexity to the project's scale. If a specific advanced architectural pattern (e.g., Table Partitioning, WebSockets, Circuit Breakers, Complex Multi-region DR) is demonstrably over-engineered for the current scope, explicitly mark it as "N/A - Omitted because [concrete technical reason]" rather than fabricating unnecessary complexity.
3. ZERO PLACEHOLDER LEAKS: Replace all [BRACKETED_PLACEHOLDERS] with real, concrete project data. Never leave unpopulated template tags in the final generated document.
-->

# Project Engineering Pipeline & Governance Dashboard

> **Document Identifier**: PIPE-[PROJECT]-001  
> **Project Name**: [PROJECT / PRODUCT NAME]  
> **Target Tech Stack**: [Go 1.24+ | Python 3.12+ | TypeScript / Node.js LTS | TBD - To be selected in Stage 3 Architecture]  
> **Project Profile**: [Enterprise Core | Lean Microservice | CLI Tool / Worker / PoC]  
> **Last Synchronized**: [YYYY-MM-DD HH:MM:SS]  
> **Lead Architect / Approver**: [ENGINEER NAME / @giakiet05]  

---

## 1. Pipeline State Machine & Transition Rules

To eliminate "vibe coding" and enforce strict **Architecture-First** engineering discipline while remaining **Pragmatic and Scalable**, every engineering artifact in this project adheres to a finite state machine:

```
[LOCKED] ──(Prerequisite Approved or N/A)──> [READY] ──(Command Triggered)──> [IN_PROGRESS]
   │                                                                               │
   ├──(Bypassed with Rationale)──> [N/A] ──────────────────────────────────────────┼──(Unlocks Next: READY)
   │                                                                               │
[APPROVED] <──(Human Sign-off / Review Pass)── [IN_REVIEW] <──(Draft Saved)────────┘
   │
   └──(Unlocks Next Stage)──> [Next Stage: READY]
```

### State Definitions
1. **`LOCKED`**: Stage is strictly prohibited from execution. Its preceding prerequisite stage has not achieved `APPROVED` or `N/A` status. Any attempt by AI or human to generate artifacts in this stage will trigger an immediate **Gate Violation Halt**.
2. **`READY`**: Upstream prerequisites are 100% verified and approved (or bypassed as `N/A`). The stage is eligible to be triggered via its designated `/prag-*` skill command.
3. **`IN_PROGRESS`**: The designated skill is actively drafting or incrementally updating the stage's target artifact.
4. **`IN_REVIEW`**: Artifact draft has been generated and validated against its master template. Execution is **HALTED**. Awaiting explicit human inspection and sign-off.
5. **`APPROVED`**: Human engineer has formally signed off on the artifact. The artifact is now a ratified baseline. Unlocks the subsequent stage.
6. **`N/A - [Technical Rationale]`**: Stage is intentionally bypassed based on the project's concrete profile (e.g., CLI tools / event workers bypassing Stage 4 API; stateless utilities bypassing Stage 5 Database). Marking a stage `N/A` automatically satisfies the prerequisite gate for the subsequent stage without requiring artifact creation.

---

## 2. Master Governance Dashboard

| Stage | Artifact Name | Primary Target Path | Prerequisite Stage | Current Status | Sign-off Date | Approved By | Gate Enforcement Rules |
| :---: | :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| **0** | **Constitution** | `constitution.md` | None | `[APPROVED/READY]` | [YYYY-MM-DD] | [Engineer] | 7 Non-Negotiable Articles ratified; Stack tooling initialized. |
| **1** | **Business Requirements (BRD)** | `docs/01-brd.md` | Stage 0 | `[LOCKED/APPROVED]` | [YYYY-MM-DD] | [Engineer] | SMART BOs, Scope (In/Out), RACI, AS-IS vs TO-BE, Business Rules. |
| **2** | **Software Requirements (SRS)** | `docs/02-srs.md` | Stage 1 | `[LOCKED/APPROVED]` | [YYYY-MM-DD] | [Engineer] | EARS Syntax, I/O Contracts, ATAM Utility Tree (H,H) Scenarios. |
| **3** | **System Architecture (SAD)** | `docs/03-architecture.md` | Stage 2 | `[LOCKED/APPROVED]` | [YYYY-MM-DD] | [Engineer] | Inline C4 Diagrams, ADD Tactics, Capacity Sizing, ADR-0001. |
| **4** | **API Specification** | `docs/04-api.md` | Stage 3 | `[LOCKED/APPROVED/N/A]` | [YYYY-MM-DD] | [Engineer] | OpenAPI 3.1, RFC 7807 Error Dictionary, ETag Concurrency. (Or N/A for CLI/Worker). |
| **5** | **Database Design (DBDD)** | `docs/05-database.md` | Stage 4 | `[LOCKED/APPROVED/N/A]` | [YYYY-MM-DD] | [Engineer] | Inline Mermaid ERD, DBDD Data Dictionary, ESR Indexing. (Or N/A for Stateless). |
| **6** | **Tasks Checklist (WBS)** | `docs/06-tasks.md` | Stage 5 | `[LOCKED/APPROVED]` | [YYYY-MM-DD] | [Engineer] | Phased `[P]` Parallel Breakdown, 6-Point DoD, Blocking Foundation Gate. |
| **7** | **Implementation** | `Application Source` | Stage 6 | `[LOCKED/APPROVED]` | [YYYY-MM-DD] | [Engineer] | Interactive Scope Confirmation, Test-First, Race Detector Pass (`-race`). |

*Note: `docs/adr/*` records are generated concurrently during Stage 3+ for consequential architectural decisions.*

---

## 3. Pre-Execution Gate Verification Protocol

Every `/prag-*` skill MUST execute this 3-layer verification algorithm prior to modifying or writing any artifact:

```
Step 1: Check existence of docs/00-pipeline.md
        ├── NOT FOUND: If current command is /prag-constitution -> Initialize pipeline.
        └── NOT FOUND: If current command is NOT /prag-constitution -> REJECT & HALT.

Step 2: Read docs/00-pipeline.md and inspect Prerequisite Stage Status:
        ├── Prerequisite is "APPROVED" or "N/A" -> Set Current Stage to "IN_PROGRESS". Proceed.
        └── Prerequisite is neither "APPROVED" nor "N/A" -> REJECT with GATE VIOLATION error. STOP.

Step 3: Post-Generation Hook:
        ├── Update Current Stage Status to "IN_REVIEW".
        ├── Log generation timestamp.
        └── STOP and prompt human engineer for explicit review & sign-off.
```

---

## 4. Formal Sign-off & Bypass Audit Trail

Record every state transition (`IN_REVIEW` $\rightarrow$ `APPROVED` or `LOCKED` $\rightarrow$ `N/A`) in this log:

| Log ID | Stage | Artifact | Transition | Timestamp | Approver | Verification Evidence / Technical Rationale |
| :--- | :---: | :--- | :---: | :--- | :--- | :--- |
| `SIG-001` | 0 | `constitution.md` | `IN_REVIEW` $\rightarrow$ `APPROVED` | [Timestamp] | [Approver] | Ratified 7 core articles for Go 1.24+ runtime. |
| `SIG-002` | 1 | `docs/01-brd.md` | `IN_REVIEW` $\rightarrow$ `APPROVED` | [Timestamp] | [Approver] | Reviewed SMART BOs, scope boundary, and business rules. |
| `SIG-003` | 4 | `docs/04-api.md` | `LOCKED` $\rightarrow$ `N/A` | [Timestamp] | [Approver] | Bypassed: System is an asynchronous Kafka consumer with no public HTTP endpoints. |
