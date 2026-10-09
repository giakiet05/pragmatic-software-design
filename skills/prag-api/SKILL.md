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
2. **Prerequisite Stage Status Check**: Verify that **Stage 3 (Architecture)** is marked `APPROVED` or `N/A`. If not, report that prerequisite Stage 3 has not been signed off or marked N/A, and halt execution. (Respond in the user's conversational language).
3. **Set Stage Status**: Update `docs/00-pipeline.md`: set **Stage 4 (API Specification)** status to `IN_PROGRESS` and `Active Milestone` to `M1/5: Global Conventions & Querying`.

---

## Target File & Master Template

- Target File: `<project-root>/docs/04-api.md` (Always edited in-place; **NEVER** create versioned files like `04-api-v1.md` or subfolders like `4-api/`)
- Governance Dashboard: `<project-root>/docs/00-pipeline.md`
- Master Template: `resources/template.md` (or `templates/04-api.template.md`)
- Standards: **OpenAPI 3.1**, **JSON Schema (Draft 2020-12)**, **RFC 7807 (Problem Details)**, **RFC 7232 / RFC 9110 (ETag Conditional Requests)**, **RFC 8594 (Sunset/Deprecation)**, **Pragmatic JSON:API Querying**

---

## Technical Contract Foundations

### 1. Request Body & Payload Standards (JSON Schema / OpenAPI 3.1)
All request payloads MUST be modeled using strict **JSON Schema (Draft 2020-12)** compatible with OpenAPI 3.1:
- Casing: Uniform casing across all request/response keys (`snake_case` or `camelCase` aligned with `docs/constitution.md`).
- Validation keywords: Explicitly declare `type`, `required`, `minimum`/`maximum`, `minLength`/`maxLength`, `format` (e.g. `uuid`, `date-time`, `email`), and `example`.
- Enforce clean flat objects; avoid unnecessarily deeply nested JSON unless representing genuine 1-to-N relationships.

### 2. Pragmatic Querying Standards (JSON:API Style)
- Filtering: `?filter[status]=active&filter[category]=electronics`
- Sorting: `?sort=-created_at,price` (minus `-` prefix denotes DESC; comma denotes precedence)
- Pagination: `?page[number]=1&page[size]=20` (or cursor-based `?page[after]=<cursor_token>`)
- Sparse Fieldsets: `?fields[orders]=id,order_number,status`

### 3. ETag Standards: Caching & Optimistic Locking
ETag (Entity Tag) is an entity hash or version identifier used for two critical backend purposes:
1. **HTTP Caching (Bandwidth Optimization)**:
   - Server returns `ETag: "v1-a8f5c2"` in `GET /{resource}/{id}` responses.
   - Client sends `If-None-Match: "v1-a8f5c2"`. If unchanged, server returns **`304 Not Modified`** (empty body).
2. **Optimistic Locking / Concurrency Control (Lost-Update Prevention)**:
   - Mutating operations (`PUT`, `PATCH`, `DELETE`) require client to send `If-Match: "v1-a8f5c2"`.
   - If another client updated the record in the interim, the ETag in DB will have changed. Server immediately rejects the mutation with **`412 Precondition Failed`**, protecting data integrity.

---

## Operational Execution Protocol

### Mode 1: Collaborative Section Stepper (DEFAULT)
By default, **DO NOT** generate or write the entire API specification in a single turn. Treat the skill as an interactive technical workshop with the user. Guide the user through the following 5 milestones strictly one section at a time:

1. **Milestone 1: Global Conventions, Transport, Security & Querying Standards (Section 1 & 2)**:
   - Establish base URLs, TLS, authentication headers, `Idempotency-Key` requirements, CORS policy, and content negotiation.
   - Standardize JSON:API querying: pagination (cursor vs offset), multi-field sorting (`sort=-created_at,id`), filtering syntax, and sparse fieldsets.
   - STOP and confirm with user.
2. **Milestone 2: Standard Envelopes & Custom Error Code Dictionary (Section 3)**:
   - Define unified Success envelope and RFC 7807 Problem Details error envelope (`type`, `title`, `status`, `detail`, `instance`, `invalid_params`).
   - Establish HTTP status code matrix and Section 3.4 Custom Error Code Dictionary.
   - STOP and confirm with user.
3. **Milestone 3: Concurrency Control, HTTP Caching & API Lifecycle (Section 4)**:
   - Define resources requiring ETag optimistic concurrency (`If-Match` -> `412 Precondition Failed`) vs standard caching (`If-None-Match` -> `304 Not Modified`).
   - Define versioning, breaking changes policy, and RFC 8594 Sunset/Deprecation timelines.
   - STOP and confirm with user.
4. **Milestone 4: Detailed Endpoint Specifications by Resource (Section 5)**:
   - Model endpoints grouped by domain resource (Auth, Core domain resources, Bulk/batch operations, Async jobs with `202 Accepted`).
   - Specify strict JSON Schema (Draft 2020-12) / OpenAPI 3.1 request and response schemas, validation rules, and examples.
   - STOP and confirm with user.
5. **Milestone 5: File Transfer Architecture & Real-Time Event Streaming (Section 6 & 7)**:
   - Detail direct-to-storage via S3 Pre-signed URL pattern and multipart fallback.
   - Establish outbound Webhooks with HMAC-SHA256 signature and retry policy.
   - Specify Server-Sent Events (SSE) and WebSockets protocol contracts.
   - STOP and confirm with user.

**Write Trigger**: At each milestone, discuss and draft options in chat. **ONLY write or append to `docs/04-api.md` when the user explicitly instructs** (e.g., *"viết doc phần này"*, *"chốt phần endpoint"*, *"save section"*). Write incrementally to the canonical file in-place, and update the `Active Milestone` column in `docs/00-pipeline.md` (e.g., advancing to `M2/5: Envelopes & Errors`, `M3/5: Concurrency & Caching`, etc.).

### Mode 2: Fast-Track Full Generation (EXPLICIT USER OVERRIDE)
If and only if the user explicitly commands full generation (e.g., *"gen cả file docs luôn đi"*, *"generate entire doc"*, *"viết hết luôn"*):
- Ingest upstream context from `docs/constitution.md`, `docs/02-srs.md`, and `docs/03-architecture.md`.
- Draft the complete `docs/04-api.md` following `resources/template.md` in one execution.

---

## Maintenance & Surgical Updates
- **Routine Minor Edits**: For minor adjustments (adding a field to a request body, adding a custom error code, tweaking a query filter), the user can chat normally without invoking the skill. Perform surgical edits directly on `docs/04-api.md`.
- **Major API Overhaul**: Re-running `/prag-api` updates `docs/04-api.md` in-place while keeping breaking changes versioned cleanly.

---

## Post-Generation Gate Hook & Stop
1. Save `<project-root>/docs/04-api.md`.
2. Update `<project-root>/docs/00-pipeline.md`: set **Stage 4 (API Specification)** status to `IN_REVIEW` and `Active Milestone` to `Complete (Awaiting Sign-off)`.
3. Output a brief contract summary highlighting:
   - Base URL and core resources.
   - Concurrency control strategy (ETag / If-Match).
   - Custom error codes defined in Section 3.4.
4. **STOP** and inform the user that `docs/04-api.md` is saved (Stage 4: IN_REVIEW), prompting them to review the contracts and sign off ('duyệt api' or 'approve api') to unlock Stage 5 (/prag-db). Always respond naturally in the user's conversational language.
