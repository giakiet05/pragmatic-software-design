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
- `<project-root>/docs/03-architecture.md`
- Initial ADR at `<project-root>/docs/adr/0001-initial-tech-stack.md`
- Updating stage metadata in `<project-root>/docs/00-pipeline.md`

You **MUST NOT** generate detailed API endpoint contracts (`04-api.md`), database schemas (`05-database.md`), task checklists (`06-tasks.md`), or application source code.
**NEVER SKIP GATES**: You MUST NOT proceed to Stage 4 (`/prag-api`) until the human engineer explicitly signs off on `docs/03-architecture.md`.
Immediately after completing the architecture blueprint, you **MUST STOP** and yield control back to the user for review.

---

## Pre-Execution Gatekeeper Verification

Before generating or modifying `docs/03-architecture.md`, execute this check:
1. **Pipeline Dashboard Check**: Read `<project-root>/docs/00-pipeline.md`. If missing, verify `docs/01-brd.md` and `docs/02-srs.md`.
2. **Prerequisite Stage Status Check**: Verify that **Stage 2 (SRS)** is marked `APPROVED` or `N/A`. If Stage 2 is in `IN_REVIEW`, `IN_PROGRESS`, or `LOCKED`, **REJECT & HALT**:
   > *"GATE VIOLATION: Cannot execute /prag-arch. Prerequisite Stage 2 (SRS) has not been signed off or bypassed as N/A (current status: [STATUS]). Please review `docs/02-srs.md` or mark as N/A before proceeding to Architecture."*
3. **Set Stage Status**: Update `docs/00-pipeline.md`: set **Stage 3 (Architecture)** to `IN_PROGRESS`.

---

## Target Files & Master Templates

- Target Document: `<project-root>/docs/03-architecture.md`
- Governance Dashboard: `<project-root>/docs/00-pipeline.md`
- Master Template: `resources/template.md` (or `templates/03-architecture.template.md`)
- Tactics Reference: `resources/quality-tactics.md`
- ADR Template: `templates/adr.template.md`
- Standards: **ISO/IEC/IEEE 42010**, **SEI Attribute-Driven Design (ADD)**, and **C4 Model**

---

## Execution Workflow

### Step 1: Upstream Alignment
Read `constitution.md`, `01-brd.md`, and `02-srs.md`. Map functional requirements (`FR-xxx`) and ATAM quality attribute scenarios to architectural mechanisms.

### Step 2: Content Generation / Delta Update
Load `resources/template.md` and populate all sections:
1. **Document Control**: Identifier `SAD-[PROJECT]-001`, revision history, approver sign-off.
2. **Consolidated Technology Stack & Selection Matrix**: 8-column matrix defending every technology choice against alternatives and standard-library options.
3. **4-Tier Layered Architecture**: Boundary: `Router / Transport` $\rightarrow$ `Controller / Handler` $\rightarrow$ `Service / Domain` $\rightarrow$ `Repository / Data Access`.
4. **C4 Model Architecture Diagrams**: Level 1 (System Context) and Level 2 (Container) diagrams authored directly as inline ````mermaid` fenced code blocks inside `docs/03-architecture.md` (no external .mmd/.svg files needed; native vector rendering on GitHub, GitLab, and Obsidian).
5. **Dynamic & Event Flows**: Selective Technical Sequence Diagrams (White-Box) authored directly as inline ````mermaid` fenced code blocks for failure-critical or multi-component flows (>= 3 components).
6. **Capacity Planning & Sizing**: Storage velocity calculation, cache RAM sizing, scaling horizon triggers.
7. **Cross-Cutting Concerns & HA/DR Runbooks**: Cache-aside, circuit breaker, token bucket, traceparent, SPOF analysis, RTO/RPO targets.
8. **Rollout & Zero-Downtime Migration Strategy**: Rolling update topology, expand-and-contract database migration discipline.
9. **ADR Initialization**: Create or update `docs/adr/0001-initial-tech-stack.md` using `templates/adr.template.md`.
10. **Complexity Tracking**: Defend any non-standard pattern against KISS and YAGNI.

### Step 3: Post-Generation Gate Hook & Stop
1. Save `<project-root>/docs/03-architecture.md` and `docs/adr/0001-initial-tech-stack.md`.
2. Update `<project-root>/docs/00-pipeline.md`: set **Stage 3 (Architecture)** status to `IN_REVIEW`.
3. Output a brief architectural summary highlighting:
   - Selected tech stack and primary trade-off rationale.
   - High-level container topology and capacity sizing highlights.
4. **STOP** and instruct the user: *"Architecture blueprint saved to `docs/03-architecture.md` (Stage 3: IN_REVIEW). Please review the document and diagrams. Once satisfied, type 'duyệt arch' or 'approve arch' to formally sign off and unlock Stage 4 (/prag-api)."*
