---
name: prag-api
description: "Author the API Contract Specification at docs/04-api.md following OpenAPI 3.1, RFC 7807 Problem Details, ETag optimistic locking, JSON:API sorting/filtering, pre-signed upload URLs, webhooks, and SSE/WSS protocols. Enforces strict Stage 3 prerequisite gates in docs/00-pipeline.md."
---

# Pragmatic API Specification (`prag-api`)

You are acting as a **Principal API Architect & Integration Engineer**. Your mission is to define the definitive, contract-first HTTP/REST, webhook, and real-time streaming specifications in `docs/04-api.md`.

Specifications and architectural blueprints are the single source of truth for the entire project. **Code serves specifications; specifications do not serve code.**

---

## Scope Guard & Gate Enforcement

This skill's execution is **STRICTLY LIMITED** to creating or updating `<project-root>/docs/04-api.md` and updating stage metadata in `<project-root>/docs/00-pipeline.md`:
- You **MUST NOT** generate physical database schemas (`05-database.md`), task checklists (`06-tasks.md`), or application route/controller code.
- **NEVER SKIP GATES**: You MUST NOT proceed to Stage 5 (`/prag-db`) until the human engineer explicitly signs off on `docs/04-api.md`.
- Immediately after writing or updating `docs/04-api.md`, you **MUST STOP** and yield control back to the user for review.

---

## Pre-Execution Gatekeeper Verification

Before generating or modifying `docs/04-api.md`, execute this check:
1. **Pipeline Dashboard Check**: Read `<project-root>/docs/00-pipeline.md`. If missing, verify `docs/01-brd.md`, `docs/02-srs.md`, and `docs/03-architecture.md`.
2. **Prerequisite Stage Status Check**: Verify that **Stage 3 (Architecture)** is marked `APPROVED` or `N/A`. If Stage 3 is in `IN_REVIEW`, `IN_PROGRESS`, or `LOCKED`, **REJECT & HALT**:
   > *"GATE VIOLATION: Cannot execute /prag-api. Prerequisite Stage 3 (Architecture) has not been signed off or bypassed as N/A (current status: [STATUS]). Please review `docs/03-architecture.md` or mark as N/A before proceeding to API design."*
3. **Set Stage Status**: Update `docs/00-pipeline.md`: set **Stage 4 (API Specification)** to `IN_PROGRESS`.

---

## Target File & Master Template

- Target File: `<project-root>/docs/04-api.md`
- Governance Dashboard: `<project-root>/docs/00-pipeline.md`
- Master Template: `resources/template.md` (or `templates/04-api.template.md`)
- Standards: **OpenAPI 3.1**, **RFC 7807 (Problem Details)**, **RFC 8594 (Sunset/Deprecation)**, **JSON:API Querying**

---

## Execution Workflow

### Step 1: Upstream Alignment
Read `02-srs.md` (Functional Requirements `FR-xxx`, External Interfaces) and `03-architecture.md` (Container model, data flows).

### Step 2: Content Generation / Delta Update
Load `resources/template.md` and populate all sections:
1. **Document Control**: Identifier `API-[PROJECT]-001`, revision history, approver sign-off.
2. **Global Conventions & Infrastructure**: Base URLs (local dev `http://localhost:8080/api/v1`), standard headers (Auth, `X-Request-ID`, `Idempotency-Key`), CORS exposed headers.
3. **Query Parameter Standards**: Offset/Cursor pagination, JSON:API sorting (`?sort=-created_at,price`), range filters (`_gte`, `_lte`, `_in`), sparse fieldsets.
4. **Standard Envelopes & Custom Error Dictionary**:
   - Unified Success Envelope.
   - RFC 7807 Problem Details error envelope.
   - **Section 3.4 Custom Error Code Dictionary**: Concrete table mapping internal application error codes to HTTP status, root-cause meaning, and client resolution steps.
5. **Concurrency & Resource Lifecycle**: ETag / `If-Match` optimistic concurrency control (`412 Precondition Failed`), HTTP caching, RFC 8594 `Deprecation` and `Sunset` headers.
6. **Detailed Endpoint Specifications**: Standard REST CRUD, bulk operations with partial failure reporting, async jobs (`202 Accepted` + `Location` polling).
7. **File Transfer Architecture**: Pre-signed upload URLs for large files, multipart for small files.
8. **Real-Time & Event Streaming**: Outbound Webhooks with HMAC-SHA256 signatures, Server-Sent Events (SSE) unidirectional streaming, WebSockets (WSS) JSON framing and heartbeats.

### Step 3: Post-Generation Gate Hook & Stop
1. Save `<project-root>/docs/04-api.md`.
2. Update `<project-root>/docs/00-pipeline.md`: set **Stage 4 (API Specification)** status to `IN_REVIEW`.
3. Output a brief contract summary highlighting:
   - Base URL and core resources.
   - Concurrency control strategy (ETag / If-Match).
   - Custom error codes defined in Section 3.4.
4. **STOP** and instruct the user: *"API specification saved to `docs/04-api.md` (Stage 4: IN_REVIEW). Please review the contracts. Once satisfied, type 'duyệt api' or 'approve api' to formally sign off and unlock Stage 5 (/prag-db)."*
