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
2. **Prerequisite Stage Status Check**: Verify that **Stage 4 (API Specification)** is marked `APPROVED` or `N/A`. If Stage 4 is in `IN_REVIEW`, `IN_PROGRESS`, or `LOCKED`, **REJECT & HALT**:
   > *"GATE VIOLATION: Cannot execute /prag-db. Prerequisite Stage 4 has not been signed off or bypassed as N/A (current status: [STATUS]). Please review Stage 4 or mark as N/A before proceeding to Database Design."*
3. **Set Stage Status**: Update `docs/00-pipeline.md`: set **Stage 5 (Database Design)** to `IN_PROGRESS`.

---

## Target File & Master Template

- Target File: `<project-root>/docs/05-database.md`
- Governance Dashboard: `<project-root>/docs/00-pipeline.md`
- Master Template: `resources/template.md` (or `templates/05-database.template.md`)
- Standards: **IEEE 1016-2009 (Information Technology - System Design - Software Design Descriptions)**

---

## Execution Workflow

### Step 1: Upstream Alignment
Read `02-srs.md` (Domain invariants, sizing), `03-architecture.md` (Database container, storage velocity), and `04-api.md` (Entity schemas, query filters, ETag versioning).

### Step 2: Content Generation / Delta Update
Load `resources/template.md` and populate all sections:
1. **Document Control**: Identifier `DBDD-[PROJECT]-001`, revision history, approver sign-off.
2. **Database Engine & Connection Pool Configuration**: RDBMS engine and version, naming conventions, mathematical pool sizing formula, statement timeout budgets.
3. **Logical Entity-Relationship Diagram (Mermaid ERD)**: Complete cardinalities (`||--o{`), PKs (UUIDv7/BIGSERIAL), FKs, UKs, optimistic locking `version INT` field authored directly as an inline ````mermaid` fenced code block inside `docs/05-database.md`.
4. **Physical Data Dictionary (DBDD Tables)**: Detailed column breakdown (types, nullability, defaults, constraints, invariant mapping).
5. **Transaction Isolation & Concurrency Control**: Default isolation level (`READ COMMITTED`), Pessimistic locking (`FOR UPDATE`, `FOR UPDATE SKIP LOCKED`), Optimistic locking (`version` field mapped to ETag).
6. **Advanced Indexing Strategy**: B-Tree with ESR rule, Partial Indexes (`WHERE status = 'PENDING'`), Covering Indexes (`INCLUDE`), GIN/JSONB indexes.
7. **Table Partitioning & Data Lifecycle**: Declarative range partitioning, Hot/Warm/Cold retention and archival.
8. **Data Integrity & Constraints**: Cascade policies (`ON DELETE RESTRICT`), check constraints, soft-delete with partial unique indexes.
9. **Zero-Downtime Migration Safety Checklist**: Sequential up/down migration files, production safety rules (`CREATE INDEX CONCURRENTLY`, Expand-and-Contract, `NOT VALID` constraint checks).

### Step 3: Post-Generation Gate Hook & Stop
1. Save `<project-root>/docs/05-database.md`.
2. Update `<project-root>/docs/00-pipeline.md`: set **Stage 5 (Database Design)** status to `IN_REVIEW`.
3. Output a brief database summary highlighting:
   - Primary key strategy (UUIDv7 vs BIGSERIAL).
   - Concurrency locking strategy (Pessimistic vs Optimistic version counter).
   - Connection pool limits and timeout budgets.
4. **STOP** and instruct the user: *"Database design saved to `docs/05-database.md` (Stage 5: IN_REVIEW). Please review the schema and indexes. Once satisfied, type 'duyệt db' or 'approve db' to formally sign off and unlock Stage 6 (/prag-tasks)."*
