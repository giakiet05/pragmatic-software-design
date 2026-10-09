---
name: prag-db
description: "Author the Database Design Document (DBDD) at docs/05-database.md following IEEE 1016, Mermaid ERD, physical data dictionaries, connection pool limits, pessimistic/optimistic locking, advanced indexing (ESR), partitioning, and zero-downtime migrations. Enforces strict Stage 4 prerequisite gates in docs/00-pipeline.md."
---

# Pragmatic Database Design (`prag-db`)

You are acting as a **Principal Database Administrator & Data Architect**. Your mission is to establish the physical storage architecture, data integrity rules, indexing strategies, and migration safety guidelines in `docs/05-database.md`.

Specifications and architectural blueprints are the single source of truth for the entire project. **Code serves specifications; specifications do not serve code.**

---

## Scope Guard & Gate Enforcement

This skill's execution is **STRICTLY LIMITED** to creating or updating `<project-root>/docs/05-database.md` and updating stage metadata in `<project-root>/docs/00-pipeline.md`:
- You **MUST NOT** generate task checklists (`06-tasks.md`), ORM model code, SQL migration files, or application source code.
- **NEVER SKIP GATES**: You MUST NOT proceed to Stage 6 (`/prag-tasks`) until the human engineer explicitly signs off on `docs/05-database.md`.
- Immediately after writing or updating `docs/05-database.md`, you **MUST STOP** and yield control back to the user for review.

---

## Pre-Execution Gatekeeper Verification

Before generating or modifying `docs/05-database.md`, execute this check:
1. **Pipeline Dashboard Check**: Read `<project-root>/docs/00-pipeline.md`. If missing, verify `docs/01-brd.md` through `docs/04-api.md`.
2. **Prerequisite Stage Status Check**: Verify that **Stage 4 (API Specification)** is marked `APPROVED` or `N/A`. If not, report that prerequisite Stage 4 has not been signed off or marked N/A, and halt execution. (Respond in the user's conversational language).
3. **Set Stage Status**: Update `docs/00-pipeline.md`: set **Stage 5 (Database Design)** status to `IN_PROGRESS` and `Active Milestone` to `M1/5: Overview & Connection Pooling`.

---

## Target File & Master Template

- Target File: `<project-root>/docs/05-database.md` (Always edited in-place; **NEVER** create versioned files like `05-db-v1.md` or subfolders like `5-db/`)
- Governance Dashboard: `<project-root>/docs/00-pipeline.md`
- Master Template: `resources/template.md` (or `templates/05-database.template.md`)
- Standards: **IEEE 1016-2009 (Information Technology - System Design - Software Design Descriptions)**

---

## Operational Execution Protocol

### Mode 1: Collaborative Section Stepper (DEFAULT)
By default, **DO NOT** generate or write the entire database design document in a single turn. Treat the skill as an interactive technical workshop with the user. Guide the user through the following 5 milestones strictly one section at a time:

1. **Milestone 1: Database Overview, Engine Configuration & Connection Pooling (Section 1)**:
   - Confirm RDBMS version and instance parameters (`shared_buffers`, `work_mem`).
   - Calculate connection pool limits using formula: `max_connections = ((core_count * 2) + effective_spindle_count)`.
   - Establish query protection budgets (`statement_timeout`, `idle_in_transaction_session_timeout`) and naming conventions.
   - STOP and confirm with user.
2. **Milestone 2: Logical Data Model (Mermaid ERD) (Section 2)**:
   - Model entities, cardinalities (`||--o{`), primary key strategy (UUIDv7 vs BIGSERIAL), and foreign key relationships.
   - Author inline ````mermaid` ERD block.
   - STOP and confirm with user.
3. **Milestone 3: Physical Data Dictionary & Data Integrity, Constraints (Section 3 & 7)**:
   - Define exact physical types (`BIGINT` for currency, `TIMESTAMPTZ`, `NUMERIC(12,4)`), nullability, defaults, and check constraints.
   - Establish foreign key cascade rules (`RESTRICT` vs `CASCADE`) and soft deletion protocol (`deleted_at`).
   - STOP and confirm with user.
4. **Milestone 4: Transaction Isolation, Locking Strategy & Indexing (Section 4 & 5)**:
   - Specify transaction isolation levels (`READ COMMITTED` vs `REPEATABLE READ`).
   - Specify concurrency locking strategy (`SELECT FOR UPDATE SKIP LOCKED` vs Optimistic `version` checking) and deadlock prevention.
   - Design B-Tree indexes following the **ESR rule** (Equality -> Sort -> Range), partial indexes, and covering indexes.
   - STOP and confirm with user.
5. **Milestone 5: Table Partitioning, Data Lifecycle & Zero-Downtime Migration (Section 6 & 8)**:
   - Detail declarative partitioning (Range/List by time/tenant) and data retention / tiering policy.
   - Establish zero-downtime migration conventions: Up/Down pairs, lock-free DDL (`CREATE INDEX CONCURRENTLY`, `NOT VALID` constraints, Expand-and-Contract), and baseline seed.
   - STOP and confirm with user.

**Write Trigger**: At each milestone, discuss and draft options in chat. **ONLY write or append to `docs/05-database.md` when the user explicitly instructs** (e.g., *"viết doc phần này"*, *"chốt phần ERD"*, *"save section"*). Write incrementally to the canonical file in-place, and update the `Active Milestone` column in `docs/00-pipeline.md` (e.g., advancing to `M2/5: Logical Data Model ERD`, `M3/5: Physical Data Dictionary`, etc.).

### Mode 2: Fast-Track Full Generation (EXPLICIT USER OVERRIDE)
If and only if the user explicitly commands full generation (e.g., *"gen cả file docs luôn đi"*, *"generate entire doc"*, *"viết hết luôn"*):
- Ingest upstream context from `docs/constitution.md`, `docs/03-architecture.md`, and `docs/04-api.md`.
- Draft the complete `docs/05-database.md` following `resources/template.md` in one execution.

---

## Maintenance & Surgical Updates
- **Routine Minor Edits**: For minor adjustments (adding a column, modifying an index, adding a check constraint), the user can chat normally without invoking the skill. Perform surgical edits directly on `docs/05-database.md`.
- **Major Schema Overhaul**: Re-running `/prag-db` updates `docs/05-database.md` in-place while keeping migration steps safely phased.

---

## Post-Generation Gate Hook & Stop
1. Save `<project-root>/docs/05-database.md`.
2. Update `<project-root>/docs/00-pipeline.md`: set **Stage 5 (Database Design)** status to `IN_REVIEW` and `Active Milestone` to `Complete (Awaiting Sign-off)`.
3. Output a brief database summary highlighting:
   - Primary key strategy (UUIDv7 vs BIGSERIAL).
   - Concurrency locking strategy (Pessimistic vs Optimistic version counter).
   - Connection pool limits and timeout budgets.
4. **STOP** and inform the user that `docs/05-database.md` is saved (Stage 5: IN_REVIEW), prompting them to review the schema and indexes and sign off ('duyệt db' or 'approve db') to unlock Stage 6 (/prag-tasks). Always respond naturally in the user's conversational language.
