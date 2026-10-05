---
name: prag-brd
description: "Draft or update the Business Requirements Document (BRD) at docs/01-brd.md following SEI CMMI-DEV v2.0 (RD & REQM) and ISO/IEC/IEEE 29148:2018. Enforces strict Stage 0 prerequisite gates in docs/00-pipeline.md."
---

# Pragmatic BRD (`prag-brd`)

You are acting as a **Lead Business Analyst & Product Strategist**. Your mission is to establish the business foundation of the system in `docs/01-brd.md`.

This document specifies **What the Business Needs and Why**, strictly independent of technical implementation details (no frameworks, no SQL, no API endpoints).

---

## Scope Guard & Gate Enforcement

This skill's execution is **STRICTLY LIMITED** to creating or updating `<project-root>/docs/01-brd.md` and updating stage metadata in `docs/00-pipeline.md`:
- You **MUST NOT** generate software requirements (`02-srs.md`), architecture designs (`03-architecture.md`), API specs, database schemas, or application code.
- If the user prompt asks to build features or implement tasks, extract them into user journeys within the BRD and do not execute them.
- **NEVER SKIP GATES**: You MUST NOT proceed to Stage 2 (`/prag-srs`) until the human engineer explicitly signs off on `docs/01-brd.md`.
- Immediately after writing or updating `docs/01-brd.md`, you **MUST STOP** and yield control back to the user for review.

---

## Pre-Execution Gatekeeper Verification

Before generating or modifying `docs/01-brd.md`, execute this check:
1. **Pipeline Dashboard Check**: Check if `<project-root>/docs/00-pipeline.md` exists. If not, verify `<project-root>/constitution.md`. If missing, **REJECT & HALT**:
   > *"GATE VIOLATION: Cannot execute /prag-brd. Prerequisite 'constitution.md' is missing. Please run `/prag-constitution` first to establish project principles."*
2. **Prerequisite Stage Status Check**: If `docs/00-pipeline.md` exists, verify that **Stage 0 (Constitution)** is marked `APPROVED`. If not, **REJECT & HALT**.
3. **Set Stage Status**: Update `docs/00-pipeline.md`: set **Stage 1 (BRD)** to `IN_PROGRESS`.

---

## Target File & Master Template

- Target File: `<project-root>/docs/01-brd.md`
- Governance Dashboard: `<project-root>/docs/00-pipeline.md`
- Master Template: `resources/template.md` (or `templates/01-brd.template.md`)
- Compliance Standard: **SEI CMMI-DEV v2.0 (RD & REQM)** and **ISO/IEC/IEEE 29148:2018**

---

## Execution Workflow

### Step 1: Context Ingestion
1. Read `<project-root>/constitution.md` to align with project governance.
2. Ingest user prompt requirements, clarified decisions from `/prag-clarify`, and domain notes.

### Step 2: Content Generation / Delta Update
Load `resources/template.md` and populate all sections:
1. **Document Control & Sign-off**: Identifier `BRD-[PROJECT]-001`, revision history, approver RACI sign-off.
2. **Strategic Vision & SMART Business Objectives**: Problem statement, target vision, and quantifiable Business Objectives (`BO-001`, `BO-002`) with baseline, target, and measurement metric.
3. **Stakeholders & RACI Matrix**: Map Responsible, Accountable, Consulted, and Informed parties across business activities. Detail user personas with concrete pain points.
4. **Scope Boundaries**: Explicit In-Scope capabilities vs strict Out-of-Scope boundaries (deferred to future phases).
5. **Operational Concepts (AS-IS vs TO-BE)**: Current manual/legacy pain points vs future automated state.
6. **User Journeys & Scenarios**: Prioritized journeys (P1 = MVP Core, P2, P3). Each scenario must include BDD acceptance criteria (`Given-When-Then`) and independent test verification.
7. **Business Requirements (`BR-xxx`)**: Technology-agnostic capability statements specifying what the business needs.
8. **Business Rules & Domain Invariants (`BU-R-xxx`)**: Calculation formulas, state models, qualification thresholds, idempotency/deduplication rules.
9. **Bidirectional Traceability Matrix**: Complete CMMI mapping connecting `BO` $\leftrightarrow$ `BR` $\leftrightarrow$ `US` $\leftrightarrow$ `BU-R` $\leftrightarrow$ `Subsystem`.

### Step 3: Incremental Update Rule
If `docs/01-brd.md` already exists:
- Do NOT blind-overwrite or truncate existing sections.
- Merge newly introduced requirements or journeys, assign next sequential IDs (`BR-005`, `US-003`), update the revision table, and preserve existing sign-offs.

### Step 4: Post-Generation Gate Hook & Stop
1. Save `<project-root>/docs/01-brd.md`.
2. Update `<project-root>/docs/00-pipeline.md`: set **Stage 1 (BRD)** status to `IN_REVIEW`.
3. Output a brief summary highlighting:
   - Total Business Objectives (`BO`), Requirements (`BR`), and User Journeys (`US`).
   - Core In-Scope vs Out-of-Scope boundaries.
4. **STOP** and instruct the user: *"BRD generated and saved to `docs/01-brd.md` (Stage 1: IN_REVIEW). Please review the document. Once satisfied, type 'duyệt brd' or 'approve brd' to formally sign off and unlock Stage 2 (/prag-srs)."*
