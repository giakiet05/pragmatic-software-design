# Real-World Simulation Scenario: Pragmatic Software Design Suite

> **Simulated Project**: `flash-order` — High-Throughput Order & Payment Processing Service.  
> **Target Technology Stack**: Go 1.24+, PostgreSQL 16 (`pgxpool`), RabbitMQ (DLX), Redis 7 (Cache & Idempotency).  
> **Personas**:
> - **Human (Alex)**: Senior Backend / Distributed Systems Engineer. Decisive, pragmatic, challenges technical assumptions and probes edge cases.
> - **Agent (AI)**: Staff System Architect & Pair Programmer. Distributed systems expert, strict stage gate discipline, zero fluff, evidence-based reasoning.

---

## 🎬 Act 0: Project Initiation & Constitution (`/prag-constitution`)

*Context: Directory `~/programming/pet/flash-order/` has just been created and is completely empty. Stage 0 enforces a 4-step ratification gate.*

**Human:**
> `/prag-constitution` I want to build an order and payment processing service called `flash-order`. Target runtime is Go 1.24+.

**Agent:**
> Scanning workspace... Root directory is empty. Initiating **Stage 0: Project Constitution & Pipeline Initialization**.
> 
> ### Step 1: Clarification Gate
> - **Project Name**: `flash-order` (High-Throughput Order & Payment Core).
> - **Governance Profile**: `Standard Business Project` (Full BRD, SRS, Architecture, API, DBDD, Tasks required).
> - **Primary Runtime Constraint**: Go 1.24+ (standard library + `net/http` enhanced routing, `go test -race`, `golangci-lint`, `log/slog`). Infrastructure components (DB, Cache, Broker) will be formally ratified in Stage 3 (Architecture).
> 
> ### Step 2: Ratification of 7 Core Articles
> Tailoring non-negotiable articles for Go 1.24+:
> 1. *Strict 4-Tier Boundary*: `Router` -> `Controller` -> `Service` -> `Repository`. Zero circular imports.
> 2. *Modern Runtime Standard*: Idiomatic Go 1.24+ conventions, table-driven unit tests, standard error wrapping (`%w`).
> 3. *Zero-Secrets Discipline*: No plaintext secrets in code or git. Strict environment variable loading via `internal/config`.
> 4. *Structured Logging*: High-performance JSON logging via `log/slog` with contextual request tracing (`traceparent`).
> 5. *Testing & Docker First*: Mandatory unit & integration tests; race detector enabled (`go test -race ./...`).
> 6. *Clean Code & Interface Decoupling*: Interface-driven design for DB and third-party gateways to enable deterministic unit mocking.
> 7. *KISS & YAGNI Over Over-Engineering*: No speculative microservices or bloated abstractions.

**Human:**
> Hold on. Why are you mandating the standard library `net/http` router instead of popular frameworks like Gin or Fiber? Is the native router in Go 1.22+ actually mature enough for wildcards, path variables, and method-based dispatching in production?

**Agent:**
> Yes. Since Go 1.22, `net/http.ServeMux` natively supports HTTP method matching and path wildcards (e.g., `GET /api/v1/orders/{id}`).
> By sticking to standard library `net/http`:
> 1. We eliminate heavy third-party routing dependencies and avoid reflection/custom context overhead.
> 2. Standard `http.Handler` and `http.HandlerFunc` remain 100% compatible with universal middleware patterns.
> 3. In benchmarks under Go 1.24, native routing allocation overhead is negligible for 2,000+ RPS. Gin or Fiber would add third-party supply-chain surface area for zero tangible architectural benefit.

**Human:**
> Fair enough, standard library keeps maintenance clean. Proceed with Step 3 and Step 4.

**Agent:**
> ### Step 3 & 4: Master Dashboard Initialization & Delivery
> Initialized foundational documents on disk:
> - [`docs/constitution.md`](file:///docs/constitution.md): Persisted 7 ratified articles.
> - [`docs/00-pipeline.md`](file:///docs/00-pipeline.md): Initialized Master Governance Dashboard. Stage 0 marked `APPROVED` (`SIG-001`). Stage 1 (BRD) transitioned to `READY`.
> 
> Ratification complete. Type `/prag-brd` to begin business requirements elicitation.

---

## 🎬 Act 1: Business Requirements (`/prag-brd`) — 5-Milestone Section Stepper

*Context: Alex initiates Stage 1. Agent enters Collaborative Section Stepper mode, debating trade-offs milestone by milestone.*

**Human:**
> `/prag-brd` Let's start the BRD.

**Agent:**
> Stage 0 is `APPROVED`. Transitioning Stage 1 to `IN_PROGRESS`. Entering Collaborative Section Stepper mode across 5 milestones.
> 
> ### Milestone 1 Discussion: Business Context & Strategic Vision
> Proposed quantitative SMART Business Objectives (`BO`):
> - `BO-001`: Reduce duplicate order processing rate to **0.00%** via real-time distributed idempotency locks.
> - `BO-002`: Order submission to checkout confirmation response latency must be **<= 200ms** at p99 under 1,500 orders/sec peak load.
> 
> Do these objectives capture your core business targets?

**Human:**
> Add `BO-003`: payment failures caused by third-party gateway timeouts must trigger automated background retries within 15 minutes without requiring customer re-ordering.
> 
> But question on `BO-003`: Why cap the retry window at 15 minutes? If Stripe or VNPay suffers an extended outage, why not extend retries up to 2 hours?

**Agent:**
> Because of **inventory holding costs (Lockout Risk)**:
> While an order is in retry status, the reserved inventory remains locked (`status = PAYMENT_PENDING`).
> If we hold stock for 2 hours during a gateway outage, other paying customers cannot purchase those SKUs, causing artificial "out-of-stock" deadlocks across peak sales campaigns. 15 minutes is the sweet spot balancing customer retry convenience against inventory velocity. If a gateway is still down after 15 minutes, we release the stock and notify the user to re-attempt checkout.

**Human:**
> Good catch on inventory lockout. Lock milestone 1 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 2 into [`docs/01-brd.md`](file:///docs/01-brd.md) with `BO-001`, `BO-002`, and `BO-003`.
> 
> ### Milestone 2 Discussion: Stakeholders & Scope Boundaries
> Proposed scope boundaries for MVP Release:
> - **In-Scope**:
>   1. Cart total calculation and order entity lifecycle.
>   2. Payment gateway integration (Stripe / VNPay mock) with asynchronous webhook processing.
>   3. Real-time inventory reservation and locking.
> - **Strict Out-of-Scope (Deferred to Phase 2)**:
>   1. AI-driven personalized product recommendations.
>   2. Electronic VAT invoicing (e-invoice).
>   3. Multi-currency support (VND only).
> 
> Do you approve this scope boundary?

**Human:**
> Add complex promo/voucher discounting engines to Out-of-Scope as well; Phase 1 is strictly direct deduction. Lock milestone 2 and write to file.

**Agent:**
> Checkpoint saved. Updated Sections 3 & 4 in [`docs/01-brd.md`](file:///docs/01-brd.md) including the RACI matrix and voucher restriction.
> 
> ### Milestone 3 Discussion: Operational Concepts & User Scenarios (US)
> Simulating core operational user story `US-01`:
> ```gherkin
> Scenario: Customer successfully checks out an order (US-01)
>   Given Customer has an active cart and sufficient account balance
>   When Customer submits checkout request with Idempotency-Key
>   Then System reserves inventory items
>   And Transitions order state to PAYMENT_PROCESSING
>   And Returns transaction ID and payment redirect URL within 150ms
> ```

**Human:**
> What about cart abandonment tracking? Shouldn't we have a user story for notifying customers who drop off before completing payment?

**Agent:**
> Cart abandonment email/push notification is a CRM/Marketing automation concern. In `flash-order`, our boundary is the high-throughput transactional checkout engine. Tracking behavioral drop-offs belongs in an event-driven analytics or marketing pipeline. Adding it here introduces feature creep into the MVP transaction boundary. We should classify it as Out-of-Scope.
> 
> For the core engine, the critical missing scenario is:
> `US-02`: Customer double-clicks checkout button due to UI/network lag -> system must reject duplicate submission and return original transaction response.

**Human:**
> Agreed, keep the core transaction boundary lean. Add `US-02`. Lock milestone 3 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 5 in [`docs/01-brd.md`](file:///docs/01-brd.md) with AS-IS vs TO-BE process flow and stories `US-01`, `US-02`.
> 
> ### Milestone 4 Discussion: High-Level Business Requirements & Business Rules
> Proposed invariant business rules:
> - `BU-R-001` *(Threshold)*: Inventory reservation TTL is strictly 15 minutes; unconfirmed orders auto-expire and restore stock.
> - `BU-R-002` *(Idempotency)*: `Idempotency-Key` TTL is strictly 24 hours.
> - `BU-R-003` *(State Invariant)*: Once an order reaches `PAID`, no manual cancellation or refund is permitted without an authorized supervisor audit token.
> 
> How do these rules look?

**Human:**
> Spot on. Lock milestone 4 and write to file.

**Agent:**
> Checkpoint saved. Appended Sections 6 & 7 in [`docs/01-brd.md`](file:///docs/01-brd.md).
> 
> ### Milestone 5 Discussion: Constraints, Assumptions & Traceability Matrix
> Synthesizing Section 8:
> - Regulatory Constraint: ISO 27001 & PCI-DSS tokenization compliance (zero raw PAN card storage).
> - Bidirectional Traceability Matrix linking `BO` <-> `US` <-> `BR` <-> `BU-R`.
> 
> Lock Milestone 5 to finalize BRD?

**Human:**
> Lock milestone 5 and write to file.

**Agent:**
> All 5 milestones complete. Finalized [`docs/01-brd.md`](file:///docs/01-brd.md) on disk. Pipeline status updated to `IN_REVIEW`.
> Type `approve brd` to sign off and unlock Stage 2.

**Human:**
> approve brd

**Agent:**
> Confirmed: **Stage 1 (BRD)** formally `APPROVED` (`SIG-002` recorded in [`docs/00-pipeline.md`](file:///docs/00-pipeline.md)).  
> **Stage 2 (SRS)** unlocked and set to `READY`. Type `/prag-srs` to begin software specification.

---

## 🎬 Act 2: Software Requirements Specification (`/prag-srs`) — 6-Milestone Stepper

*Context: Alex initiates Stage 2 to translate business requirements into rigorous EARS syntax, Cockburn Use Cases, and ATAM utility trees.*

**Human:**
> `/prag-srs` Let's step through the SRS.

**Agent:**
> Stage 1 is `APPROVED`. Setting Stage 2 to `IN_PROGRESS`. Entering 6-Milestone Stepper for **Software Requirements Specification (SRS)**.
> 
> ### Milestone 1 Discussion: System Overview & External Interfaces
> Context Boundary defined:
> - Client Interfaces: Web SPA & Mobile Client via HTTPS / JSON REST API.
> - External Systems: Payment Gateway Webhooks (TLS 1.3), SMTP Notification Service.
> - Network Protocols: HTTP/2 transport with TLS 1.3 and mandatory Mutual TLS for internal backchannel calls.
> 
> Does this cover all external connection vectors?

**Human:**
> Yes. Lock milestone 1 and write to file.

**Agent:**
> Checkpoint saved. Written Sections 1 & 2 to [`docs/02-srs.md`](file:///docs/02-srs.md).
> 
> ### Milestone 2 Discussion: Domain Model & State Machine Lifecycles
> Domain entities identified: `Order`, `OrderItem`, `PaymentTransaction`, `IdempotencyRecord`.
> 
> Finite state machine lifecycle for `Order`:
> `CREATED` -> `PAYMENT_PENDING` -> `PAID` -> `FULFILLED` (or `EXPIRED`, `CANCELLED`, `REFUNDED`).
> 
> Modeled state transitions with strict illegal mutation guards (e.g., transition from `EXPIRED` to `PAID` is prohibited).
> 
> Lock Milestone 2?

**Human:**
> Generate the Mermaid `stateDiagram-v2` showing valid transitions and explicit error guards. Lock milestone 2 and write to file.

**Agent:**
> Checkpoint saved. Written Section 3 to [`docs/02-srs.md`](file:///docs/02-srs.md) including the inline Mermaid state diagram.
> 
> ### Milestone 3 Discussion: System Use Cases & Scenario Specifications (UC)
> Formulating **Use Case Catalog (Table 4.1)** and formal Cockburn specifications:
> - `UC-01`: Create Order & Reserve Inventory (Primary Actor: Customer).
> - `UC-02`: Process Inbound Payment Webhook (Primary Actor: Payment Gateway).
> 
> Detailed specification draft for `UC-01`:
> - *Preconditions*: Valid session JWT, cart contains >= 1 active SKU.
> - *Main Success Scenario (Happy Path)*: 
>   1. Client submits order payload with `Idempotency-Key`.
>   2. System validates payload and checks duplicate idempotency lock.
>   3. System reserves inventory stock in DB transaction.
>   4. System creates order record in `PAYMENT_PENDING` state.
>   5. System generates payment redirect URL and returns HTTP 201 Created.
> - *Extensions / Exception Flows*:
>   - `2a. Duplicate request detected`: Return cached response from original request within 20ms.
>   - `3a. Insufficient stock`: Release lock, return HTTP 422 Unprocessable Entity with error code `ERR_INSUFFICIENT_STOCK`.

**Human:**
> Question on `UC-01`: In step `3a`, why did you categorize "Insufficient stock" as an **Exception Flow** rather than an **Alternative Flow**? What is the architectural difference according to Cockburn standards?

**Agent:**
> In Alistair Cockburn's Use Case methodology:
> - An **Alternative Flow** represents an alternate route that still **achieves the primary actor's goal** (e.g., customer selects Credit Card instead of E-Wallet, but checkout still succeeds).
> - An **Exception Flow** represents an event that **prevents the goal from being achieved** (a Failure Guarantee).
> When inventory is depleted, the order cannot be created, and the checkout goal fails. Hence, it is strictly an Exception Flow (`3a`), resulting in transaction rollback and an explicit RFC 7807 error contract.

**Human:**
> Crystal clear. That level of rigor prevents QA and developers from confusing edge cases. Lock milestone 3 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 4 in [`docs/02-srs.md`](file:///docs/02-srs.md) with Table 4.1 and detailed Cockburn Use Cases.
> 
> ### Milestone 4 Discussion: Functional Requirements (EARS Syntax & I/O Contracts)
> Deriving formal requirements directly from Use Cases using 5 EARS syntactic patterns:
> - `FR-UBI-001` *(Ubiquitous)*: *The Order Subsystem SHALL log all state transition events with ISO 8601 timestamps and W3C traceparent IDs.*
> - `FR-EVT-001` *(Event-Driven)*: *WHEN a valid payment webhook is received, the Order Subsystem SHALL transition order status to PAID within 100ms.*
> - `FR-STA-001` *(State-Driven)*: *WHILE an order is in PAYMENT_PENDING state, the System SHALL reject cancellation requests.*
> - `FR-ERR-001` *(Unwanted/Error)*: *IF inventory decrement fails due to stock exhaustion, THEN the System SHALL abort the transaction and return HTTP 422.*
> - `FR-OPT-001` *(Optional)*: *WHERE customer opts into SMS receipt, the System SHALL dispatch a notification event to the notification queue.*

**Human:**
> Why do we strictly require EARS patterns here instead of standard Agile user stories like "As a user I want..."?

**Agent:**
> User stories are designed for business conversation, but they lack formal precision for backend engineering:
> 1. User stories rarely specify what happens during unexpected state conditions or system errors.
> 2. EARS (Easy Approach to Requirements Syntax) explicitly categorizes requirements into 5 testable clauses: Ubiquitous, Event-driven (`WHEN`), State-driven (`WHILE`), Unwanted behavior (`IF...THEN`), and Optional (`WHERE`).
> 3. Each EARS statement maps directly to a deterministic unit test case or assertion in Go. No ambiguity for developers or QA.

**Human:**
> Exactly what I need for automated test coverage. Lock milestone 4 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 5 to [`docs/02-srs.md`](file:///docs/02-srs.md) with full EARS inventory and I/O contracts.
> 
> ### Milestone 5 Discussion: Non-Functional Requirements (ATAM Utility Tree) & Data Retention
> Constructing ATAM Utility Tree Matrix:
> - `(H, H)`: Performance Under Peak Load — 1,500 orders/sec peak, p99 response time < 200ms.
> - `(H, H)`: Data Invariant Integrity — Zero duplicate deductions under concurrent network retry storms.
> - `(H, M)`: Recovery Time Objective — System RTO < 60s, RPO = 0 (zero loss of confirmed transactions).
> - Retention Policy: Operational order records kept in hot storage for 90 days; cold archival to object storage after 1 year.
> 
> Lock Milestone 5?

**Human:**
> Lock milestone 5 and write to file.

**Agent:**
> Checkpoint saved. Appended Sections 6 & 7 to [`docs/02-srs.md`](file:///docs/02-srs.md).
> 
> ### Milestone 6 Discussion: Verification Framework & Traceability Matrix
> Synthesizing Section 8 (CMMI `T/D/I/A` methods) and Section 9 (Full Traceability Matrix: `BO` <-> `BR` <-> `US` <-> `UC` <-> `FR` <-> `NFR`).
> 
> Lock Milestone 6 to finalize SRS?

**Human:**
> Lock milestone 6 and write to file.

**Agent:**
> Finalized [`docs/02-srs.md`](file:///docs/02-srs.md) on disk. Pipeline status updated to `IN_REVIEW`.
> Type `approve srs` to unlock Stage 3 (Architecture).

**Human:**
> approve srs

**Agent:**
> Confirmed: **Stage 2 (SRS)** formally `APPROVED` (`SIG-003` recorded in pipeline).  
> **Stage 3 (Architecture)** is now `READY`. Type `/prag-arch` to begin system design.

---

## 🎬 Act 3: System Architecture Design (`/prag-arch`) — 6-Milestone Stepper & Discrete ADRs

*Context: Architecture is the system backbone. Agent enforces the Architecture Discovery Gate before any blueprints or ADRs are written.*

**Human:**
> `/prag-arch`

**Agent:**
> Stage 2 is `APPROVED`. Transitioning Stage 3 to `IN_PROGRESS`.
> 
> 🛑 **Milestone 1 Discussion: Architecture Discovery Gate & Technology Stack Matrix**  
> Before drafting any blueprints, we must resolve core architectural trade-offs based on SRS SLA targets:
> 
> - **Pattern Option 1 (Recommended): Modular Monolith (Go 1.24+ standard library)**.
>   - *Trade-offs*: Single static binary, zero inter-service network serialization overhead, direct database transactions for inventory locking, simplest deployment and debugging. Easily sustains 2,000 RPS via Go goroutines.
> - **Pattern Option 2: Distributed Microservices (Order Service + Payment Service + Inventory Service)**.
>   - *Trade-offs*: Independent scaling, but introduces 2-Phase Commit or Saga Orchestration across services, requiring Kafka and complex compensation logic. Overkill for current volume, violating YAGNI.
> 
> Technology Stack Proposals:
> 1. Runtime: Go 1.24+ (standard library `net/http` router, `log/slog`).
> 2. Primary Database: PostgreSQL 16 with native `jackc/pgx/v5` connection pool (no ORMs).
> 3. Message Broker: For async order events and payment retry workflows: **RabbitMQ** (AMQP 0-9-1 with Dead-Letter Exchange) vs **Redis Streams**.
> 
> Which architectural path do you select?

**Human:**
> Hold on. We already have Redis 7 in the stack for caching and distributed idempotency locks. Adding RabbitMQ introduces another cluster to monitor, configure, and maintain in production. Why can't we just use **Redis Streams** with consumer groups for order events and payment retries?

**Agent:**
> Valid operational pushback! Let's examine the trade-offs:
> 1. **Dead-Letter Handling (DLX)**: RabbitMQ provides native Dead-Letter Exchanges. When a payment retry fails 3 times, AMQP automatically routes the poison message to `order.dlx` with zero custom code. Redis Streams does not have native dead-lettering; we would have to write custom Go worker logic to inspect PEL (Pending Entries List), calculate retry counts, and manually transfer failed messages.
> 2. **Flexible Routing Keys**: RabbitMQ topic exchanges (`order.created`, `order.paid`, `payment.failed`) allow adding new consumer services (e.g., analytics, email notifications) without touching publisher code. Redis Streams requires consumers to read the stream and filter manually.
> 3. **Memory Backpressure vs Persistence**: Redis stores streams primarily in RAM. During unexpected downstream consumer halts, unconsumed messages consume RAM and risk OOM eviction. RabbitMQ pages excess messages to disk safely.
> 
> Given that payment processing involves monetary transactions and resilient dead-letter workflows, RabbitMQ's out-of-the-box reliability heavily outweighs the overhead of managing a lightweight 3-node RabbitMQ cluster.

**Human:**
> Good technical justification. The native DLX and disk paging save us from writing custom retry queue engines in Go. Let's go with Modular Monolith and RabbitMQ. Lock milestone 1 and write to file.

**Agent:**
> Architectural style and tech matrix ratified. Saved Sections 1 & 2 in [`docs/03-architecture.md`](file:///docs/03-architecture.md).
> 
> ### Milestone 2 Discussion: Architecture Style & Boundary Rules
> Establishing 4-tier layer boundaries and repository directory layout:
> 1. `Router` (`internal/router/`): HTTP route bindings, CORS, rate limiting, request parsing.
> 2. `Controller` (`internal/controller/`): Request validation, DTO mapping, HTTP status translation.
> 3. `Service` (`internal/service/`): Business logic, domain rules, transaction coordination.
> 4. `Repository` (`internal/repository/`): SQL queries, `pgxpool` execution, database mapping.
> - *Guardrail*: Lower tiers SHALL NEVER import or call upper tiers. All cross-tier dependencies injected via interfaces.
> - Directory layout: `cmd/server/main.go`, `internal/{router,controller,service,repository,model,config}/`.
> 
> Lock Milestone 2?

**Human:**
> Looks clean. Lock milestone 2 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 3 in [`docs/03-architecture.md`](file:///docs/03-architecture.md).
> 
> ### Milestone 3 Discussion: Structural Views (C4 Model)
> Generating C4 System Context (Level 1) and Container View (Level 2) using inline Mermaid diagrams:
> - *C4 Level 1*: Shows Web/Mobile clients, External Payment Gateway, and the FlashOrder System boundary.
> - *C4 Level 2*: Models Go Web API Server, PostgreSQL 16 primary instance, Redis 7 instance, and RabbitMQ broker cluster.

**Human:**
> Do we need to author C4 Level 3 Component views for every internal package?

**Agent:**
> No! C4 Level 3 component diagrams should be authored **strictly selectively** for high-complexity, mission-critical modules (such as the Payment Webhook Reconciliation engine). Authoring Level 3 for standard CRUD components produces diagram bloat and rots quickly as code evolves. We keep it focused on Level 1 and Level 2.

**Human:**
> Exactly right, KISS over diagram bloat. Lock milestone 3 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 4 in [`docs/03-architecture.md`](file:///docs/03-architecture.md) with complete C4 diagrams.
> 
> ### Milestone 4 Discussion: Dynamic, Data & Event Flow View
> Modeling asynchronous message flows via RabbitMQ:
> - Exchange `order.events` (Topic) -> Queue `order.payment.process`.
> - DLX `order.dlx` (Direct) -> Queue `order.payment.retry` with TTL exponential backoff (1m, 5m, 15m).
> - Inline Mermaid sequence diagram detailing end-to-end checkout and payment confirmation.
> 
> Lock Milestone 4?

**Human:**
> Lock milestone 4 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 5 in [`docs/03-architecture.md`](file:///docs/03-architecture.md).
> 
> ### Milestone 5 Discussion: Capacity Planning & Scalability Sizing
> Rigorous arithmetic calculations:
> - Peak Throughput: 1,500 RPS.
> - Ingestion Volume: 1,500 * 3,600 * 8 hrs/day ≈ 43.2M records/day.
> - Storage Growth: 400 bytes/order -> ≈ 17.2 GB/day ≈ 516 GB/month.
> - Sizing Recommendation: Monthly table partitioning on `orders` and `order_items` tables; 64 GB RAM, 16 vCPU, NVMe SSD server profile.
> 
> Lock Milestone 5?

**Human:**
> Lock milestone 5 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 6 in [`docs/03-architecture.md`](file:///docs/03-architecture.md).
> 
> ### Milestone 6 Discussion: Tactics, HA/DR, Zero-Downtime Rollout & Discrete ADRs
> Synthesizing Section 7 (Circuit Breakers, Idempotency), Section 8 (Canary Zero-Downtime deployment), and Section 9:
> - Generating **4 discrete ADR files** in `docs/adr/` following MADR 3.0:
>   - [`ADR-0001-architectural-style.md`](file:///docs/adr/ADR-0001-architectural-style.md): Adopt Modular Monolith over Microservices.
>   - [`ADR-0002-backend-runtime.md`](file:///docs/adr/ADR-0002-backend-runtime.md): Adopt Go 1.24+ with standard library HTTP routing.
>   - [`ADR-0003-persistence-engine.md`](file:///docs/adr/ADR-0003-persistence-engine.md): Adopt PostgreSQL 16 with `jackc/pgx/v5`.
>   - [`ADR-0004-message-broker.md`](file:///docs/adr/ADR-0004-message-broker.md): Adopt RabbitMQ AMQP 0-9-1 with DLX over Redis Streams.
> 
> Lock Milestone 6 to finalize Architecture?

**Human:**
> Lock milestone 6 and write to file.

**Agent:**
> Finalized [`docs/03-architecture.md`](file:///docs/03-architecture.md) and created all 4 discrete ADR files. Pipeline status set to `IN_REVIEW`.
> Type `approve arch` to proceed to API design.

**Human:**
> approve arch

**Agent:**
> Confirmed: **Stage 3 (Architecture)** formally `APPROVED` (`SIG-004` recorded in pipeline).  
> **Stage 4 (API Specification)** is now `READY`. Type `/prag-api` to author API contracts.

---

## 🎬 Act 4: API Contract Specification (`/prag-api`) — 5-Milestone Stepper

*Context: Alex initiates Stage 4 to define OpenAPI 3.1 contracts, RFC 7807 error envelopes, and ETag optimistic locking.*

**Human:**
> `/prag-api` Let's step through the API specification.

**Agent:**
> Stage 3 is `APPROVED`. Setting Stage 4 to `IN_PROGRESS`. Entering 5-Milestone Stepper for **API Specification**.
> 
> ### Milestone 1 Discussion: Global Conventions & Querying Standards
> Standards proposed:
> - Base URL: `https://api.flashorder.internal/api/v1`
> - Security: TLS 1.3, `Authorization: Bearer <jwt>`, strict CORS origin whitelist.
> - Pragmatic JSON:API Querying: Cursor pagination (`?cursor=...&limit=50`), sorting (`?sort=-created_at,id`), field filtering (`?status=eq:PAID`).
> 
> Lock Milestone 1?

**Human:**
> Lock milestone 1 and write to file.

**Agent:**
> Checkpoint saved. Written Sections 1 & 2 to [`docs/04-api.md`](file:///docs/04-api.md).
> 
> ### Milestone 2 Discussion: Envelopes & Custom Error Dictionary (RFC 7807)
> Standard envelopes:
> - Success: `{"success": true, "data": {...}, "meta": {...}}`
> - Error: Strict RFC 7807 `application/problem+json` format with fields: `type`, `title`, `status`, `detail`, `instance`, `invalid_params`.
> - Custom Application Error Dictionary:
>   - `ERR_INSUFFICIENT_STOCK` (422 Unprocessable Entity): Warehouse stock depleted.
>   - `ERR_IDEMPOTENCY_CONFLICT` (409 Conflict): Request currently executing under concurrent worker.
>   - `ERR_VERSION_CONFLICT` (412 Precondition Failed): Resource mutated concurrently.

**Human:**
> Why use RFC 7807 problem details instead of a simple JSON error like `{"error": "string"}`? Isn't RFC 7807 overly verbose?

**Agent:**
> Simple `{"error": "msg"}` structures cause massive client-side fragility:
> 1. Frontend and mobile clients need machine-readable parameter maps (`invalid_params: [{name: "quantity", reason: "must be >= 1"}]`) to highlight specific input fields in form UIs without string parsing.
> 2. RFC 7807 provides a canonical `type` URI linking directly to API documentation for that exact error code.
> 3. Standardized error shapes allow frontend API client wrappers to handle errors uniformly across web and mobile.

**Human:**
> Good rationale. Lock milestone 2 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 3 to [`docs/04-api.md`](file:///docs/04-api.md).
> 
> ### Milestone 3 Discussion: Concurrency Control (ETag) & API Lifecycle
> Concurrency invariants:
> - Fetching: `GET /api/v1/orders/{id}` returns `ETag: "w/\"<version-hash>\""`.
> - Mutating: `PUT/PATCH /api/v1/orders/{id}` requires mandatory `If-Match: "w/\"<version-hash>\""`. If version mismatch occurs, server rejects with HTTP 412 Precondition Failed.
> - Deprecation: Header `Deprecation: @<timestamp>` and `Sunset: <date>`.

**Human:**
> Wait! What happens if a client sends a `PUT /api/v1/orders/{id}` request without any `If-Match` header at all? Do we allow an unsafe blind overwrite, or do we reject it?

**Agent:**
> Outstanding edge case!
> We must **never** permit unsafe blind overwrites on mutable order resources.
> If a mutation request arrives without an `If-Match` header, the server MUST reject it with **HTTP 428 Precondition Required** (RFC 6585) and error code `ERR_PRECONDITION_REQUIRED`. This guarantees that lost-update bugs are impossible, even if third-party client developers forget to include the header.

**Human:**
> Excellent catch. Include HTTP 428 in the concurrency contract. Lock milestone 3 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 4 to [`docs/04-api.md`](file:///docs/04-api.md) with HTTP 428 and ETag validation rules.
> 
> ### Milestone 4 Discussion: Endpoint Specifications (OpenAPI 3.1 & JSON Schema 2020-12)
> Documenting resource endpoints:
> - `POST /api/v1/orders`: Mandatory `Idempotency-Key: <UUIDv4>` header.
> - Request body schema fully validated via JSON Schema Draft 2020-12:
>   ```json
>   {
>     "type": "object",
>     "required": ["items", "payment_method"],
>     "properties": {
>       "items": {
>         "type": "array",
>         "minItems": 1,
>         "items": {
>           "type": "object",
>           "required": ["product_id", "quantity"],
>           "properties": {
>             "product_id": { "type": "string", "format": "uuid" },
>             "quantity": { "type": "integer", "minimum": 1 }
>           }
>         }
>       }
>     }
>   }
>   ```
> - `POST /api/v1/orders/batch`: Long-running async bulk order batching returning HTTP 202 Accepted.
> 
> Lock Milestone 4?

**Human:**
> Lock milestone 4 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 5 to [`docs/04-api.md`](file:///docs/04-api.md).
> 
> ### Milestone 5 Discussion: File Transfer, Webhooks & Streaming Protocols
> - Pre-signed URL flow: `POST /api/v1/attachments/pre-signed` -> direct upload to S3.
> - Inbound/Outbound Webhooks: Signed with `X-Signature: sha256=<HMAC-SHA256(secret, body)>`.
> - Real-Time Streaming: Server-Sent Events (SSE) on `GET /api/v1/orders/{id}/events` for live checkout status updates.
> 
> Lock Milestone 5 to finalize API spec?

**Human:**
> Lock milestone 5 and write to file.

**Agent:**
> Finalized [`docs/04-api.md`](file:///docs/04-api.md) on disk. Pipeline status updated to `IN_REVIEW`.
> Type `approve api` to unlock Database design.

**Human:**
> approve api

**Agent:**
> Confirmed: **Stage 4 (API Specification)** formally `APPROVED` (`SIG-005` recorded in pipeline).  
> **Stage 5 (Database Design)** is now `READY`. Type `/prag-db` to design the database.

---

## 🎬 Act 5: Database Design (`/prag-db`) — 5-Milestone Stepper

*Context: Alex initiates Stage 5 to calculate connection pool math, model physical schemas, and establish ESR indexing.*

**Human:**
> `/prag-db` Let's step through the database design.

**Agent:**
> Stage 4 is `APPROVED`. Transitioning Stage 5 to `IN_PROGRESS`. Entering 5-Milestone Stepper for **Database Design Document (DBDD)**.
> 
> ### Milestone 1 Discussion: Engine Configuration & Connection Pool Math
> Database Engine: PostgreSQL 16 on Linux.
> Sizing Connection Pool for 4-core, 16GB RAM instance:
> - Standard PostgreSQL formula: `max_conns = (CPU Cores * 2) + Disk Spindles` = (4 * 2) + 1 = 9.
> - Setting application pool budget: `max_conns = 15`, `min_conns = 4`, `max_conn_idle_time = 5m`.
> - Timeout protection: `statement_timeout = 2500ms`, `idle_in_transaction_session_timeout = 3000ms`.

**Human:**
> Question on that pool formula: My production server runs on high-speed NVMe SSDs. Why does PostgreSQL calculation still count disk spindles as 1? And why not set `max_conns = 100` so we never hit pool exhaustion?

**Agent:**
> Great question! Here is the mechanical reality:
> 1. **PostgreSQL Process Model**: PostgreSQL allocates a dedicated OS process (not a lightweight thread or goroutine) for every active client connection.
> 2. **Context Switching & Cache Thrashing**: If 100 active connections execute concurrent queries on a 4-core CPU, the Linux scheduler spends more time context-switching process registers and flushing L1/L2/L3 CPU caches than actually executing SQL. Throughput collapses under thread contention.
> 3. **NVMe Concurrency vs CPU Cores**: While NVMe drives execute high parallel IOPS, query execution still requires CPU cycles to parse SQL, acquire lock tables, and serialize tuple buffers.
> 4. Setting `max_conns = 15` creates a tight, highly efficient queue where queries execute and commit in < 2ms, maximizing overall RPS without CPU starvation.

**Human:**
> Deep explanation. That makes complete sense. Lock milestone 1 and write to file.

**Agent:**
> Checkpoint saved. Written Section 1 to [`docs/05-database.md`](file:///docs/05-database.md).
> 
> ### Milestone 2 Discussion: Logical Data Model (Mermaid ERD)
> Synthesizing comprehensive Mermaid ERD:
> - Entities: `orders`, `order_items`, `payments`, `idempotency_records`.
> - Cardinalities: `orders` 1:N `order_items`, `orders` 1:N `payments`, `orders` 1:1 `idempotency_records`.
> 
> Lock Milestone 2?

**Human:**
> Lock milestone 2 and write to file.

**Agent:**
> Checkpoint saved. Appended Section 2 to [`docs/05-database.md`](file:///docs/05-database.md).
> 
> ### Milestone 3 Discussion: Physical Data Dictionary & Integrity Rules
> Strict physical typing specifications:
> 1. Monetary columns: `BIGINT` (fractional cents/VND) — strictly avoiding floating point inaccuracies.
> 2. Primary Keys: `UUIDv7` (time-ordered sequential UUIDs).
> 3. Concurrency column: `version INT NOT NULL DEFAULT 1`.
> 4. Cascade rules: Foreign keys configured with `ON DELETE RESTRICT`.
> 5. Soft-deletion: Standardized `deleted_at TIMESTAMPTZ NULL`.

**Human:**
> Why are you recommending `UUIDv7` instead of standard `BIGSERIAL` auto-increment or `UUIDv4`?

**Agent:**
> 1. **`BIGSERIAL` drawbacks**: Exposes sequential business numbers in URLs (vulnerable to enumeration attacks e.g., competitor scraping order count) and creates centralized sequence contention.
> 2. **`UUIDv4` drawbacks**: 100% random. When inserting millions of rows into PostgreSQL, random UUID keys cause massive B-Tree index fragmentation and random page I/O page thrashing.
> 3. **`UUIDv7` advantages**: Embeds a 48-bit UNIX timestamp in the most significant bits followed by random entropy. It is monotonically time-ordered, appending cleanly to the right side of the B-Tree index just like an integer, while remaining globally unique and non-enumerable.

**Human:**
> Perfect choice for high-throughput order insertion. Lock milestone 3 and write to file.

**Agent:**
> Checkpoint saved. Appended Sections 3 & 7 to [`docs/05-database.md`](file:///docs/05-database.md).
> 
> ### Milestone 4 Discussion: Locking Strategy & ESR Indexing
> - Locking Strategy: Concurrency control uses `SELECT ... FOR UPDATE` scoped strictly to inventory deduction; background worker queue processing uses `FOR UPDATE SKIP LOCKED`.
> - Composite Index on orders:
>   `CREATE INDEX idx_orders_customer_status_created ON orders (customer_id, status, created_at DESC);`

**Human:**
> On that composite index: Why did you order the columns as `(customer_id, status, created_at DESC)`? Why not put `created_at` first since users query recent orders?

**Agent:**
> Because of the **ESR Rule (Equality -> Sort -> Range)** for composite B-Tree indexes:
> 1. **Equality (`E`)**: `customer_id = ?` and `status = ?` narrow down the index lookup to a tiny leaf page slice immediately.
> 2. **Sort (`S`)**: Once the candidate rows are filtered by equality, PostgreSQL scans the index in `created_at DESC` order directly, satisfying the `ORDER BY created_at DESC` clause without requiring an expensive in-memory sort (`filesort`).
> If `created_at` were placed first, any range filter or sort on it would prevent PostgreSQL from using the remaining index columns for equality filtering, degrading to a broad index range scan.

**Human:**
> Textbook ESR rule application. Lock milestone 4 and write to file.

**Agent:**
> Checkpoint saved. Appended Sections 4 & 5 to [`docs/05-database.md`](file:///docs/05-database.md).
> 
> ### Milestone 5 Discussion: Partitioning & Zero-Downtime Migration Discipline
> - Declarative Range Partitioning: Monthly partitions on `orders` by `created_at` (`orders_y2026m01`, `orders_y2026m02`...).
> - Zero-Downtime Migration Protocol: Mandatory Expand-and-Contract rule (`CREATE INDEX CONCURRENTLY`, no locking DDL).
> - Seeding Baseline: Initial system fixtures and enum lookup tables.
> 
> Lock Milestone 5 to finalize DBDD?

**Human:**
> Lock milestone 5 and write to file.

**Agent:**
> Finalized [`docs/05-database.md`](file:///docs/05-database.md) on disk. Pipeline status updated to `IN_REVIEW`.
> Type `approve db` to unlock Task breakdown.

**Human:**
> approve db

**Agent:**
> Confirmed: **Stage 5 (Database Design)** formally `APPROVED` (`SIG-006` recorded in pipeline).  
> **Stage 6 (Tasks Breakdown)** is now `READY`. Type `/prag-tasks` to decompose tasks.

---

## 🎬 Act 6: Phased Work Breakdown (`/prag-tasks`) — 5-Milestone Stepper

*Context: Alex initiates Stage 6 to decompose the ratified architecture and contracts into an actionable checklist adhering to Test-First and 6-point DoD.*

**Human:**
> `/prag-tasks` Let's step through the task breakdown.

**Agent:**
> Stage 5 is `APPROVED`. Setting Stage 6 to `IN_PROGRESS`. Entering 5-Milestone Stepper for **Implementation Tasks Breakdown**.
> 
> ### Milestone 1 Discussion: Format Conventions, 6-Point DoD & Phase 1 Setup
> - Task Syntax: `- [ ] [TaskID] [P?] [StoryTag] [RequirementRef] [TargetFile] Description`.
> - Definition of Done (DoD) Criteria: (1) Clean Compile, (2) Race Detector Pass, (3) Errors Wrapped, (4) Zero Linter Warnings, (5) Zero Secrets, (6) Contract Fidelity.
> - Phase 1 Setup Tasks:
>   - `- [ ] [T001] [Setup] [docs/constitution.md] [go.mod] Initialize Go 1.24 module and install golangci-lint`
>   - `- [ ] [T002] [Setup] [docs/constitution.md] [internal/config/config.go] Implement typed environment config loader`
> 
> Lock Milestone 1?

**Human:**
> Lock milestone 1 and write to file.

**Agent:**
> Checkpoint saved. Written Sections 1, 2, and Phase 1 to [`docs/06-tasks.md`](file:///docs/06-tasks.md).
> 
> ### Milestone 2 Discussion: Phase 2 Foundational Infrastructure (Blocking Gate)
> Tasks for mandatory foundation:
> - `- [ ] [T003] [Foundation] [docs/05-database.md] [internal/database/postgres.go] Setup pgxpool with pool limits and ping check`
> - `- [ ] [T004] [Foundation] [docs/05-database.md] [migrations/000001_init.sql] Write initial DDL migration for orders, items, and payments`
> - `- [ ] [T005] [Foundation] [docs/04-api.md] [internal/router/router.go] Scaffold net/http router with CORS and RFC 7807 error middleware`

**Human:**
> Why is Phase 2 designated as a **Mandatory Blocking Gate**? Why not mark tasks in User Story 1 with `[P]` and let developers implement business features in parallel with setting up the database connection pool?

**Agent:**
> Allowing feature implementation before foundational infrastructure is in place causes massive rework:
> 1. If developers code the Order service before the `pgxpool` abstraction and RFC 7807 error middleware exist, they will invent bespoke mock database layers or custom error return shapes.
> 2. Once the real foundation lands, all premature business code must be refactored to conform to the shared pool, transaction context, and error wrappers.
> 3. The Blocking Gate guarantees that shared foundational primitives exist before any domain logic is authored.

**Human:**
> Spot on. That prevents speculative glue code. Lock milestone 2 and write to file.

**Agent:**
> Checkpoint saved. Appended Phase 2 to [`docs/06-tasks.md`](file:///docs/06-tasks.md).
> 
> ### Milestone 3 Discussion: Phase 3 User Story 1 (Core Order Creation - Test-First)
> Decomposing `US-01` into Test-First order:
> - `- [ ] [T006] [US1] [API: POST /api/v1/orders] [internal/repository/order_test.go] Unit test for order insertion and optimistic version counter`
> - `- [ ] [T007] [P] [US1] [DB: orders] [internal/repository/order.go] Implement order repository query with UUIDv7`
> - `- [ ] [T008] [P] [US1] [API: Idempotency-Key] [internal/middleware/idempotency.go] Implement Redis idempotency middleware`
> - `- [ ] [T009] [US1] [API: POST /api/v1/orders] [internal/controller/order.go] Implement Order creation HTTP handler and DTO validation`
> 
> Lock Milestone 3?

**Human:**
> Lock milestone 3 and write to file.

**Agent:**
> Checkpoint saved. Appended Phase 3 to [`docs/06-tasks.md`](file:///docs/06-tasks.md).
> 
> ### Milestone 4 Discussion: Phase 4 User Story 2+ (Secondary & Integration Features)
> Tasks for payment webhooks, retry worker, and DLX consumers:
> - `- [ ] [T010] [US2] [API: Webhook] [internal/service/payment_test.go] Unit test for HMAC-SHA256 webhook signature validation`
> - `- [ ] [T011] [P] [US2] [API: Webhook] [internal/service/payment.go] Implement payment webhook service with transaction rollback on error`
> - `- [ ] [T012] [P] [US2] [Queue: DLX] [internal/worker/retry_consumer.go] Implement RabbitMQ dead-letter retry consumer with backoff`
> 
> Lock Milestone 4?

**Human:**
> Lock milestone 4 and write to file.

**Agent:**
> Checkpoint saved. Appended Phase 4 to [`docs/06-tasks.md`](file:///docs/06-tasks.md).
> 
> ### Milestone 5 Discussion: Phase 5 Hardening, Polish & Operational Verification
> Final verification tasks:
> - `- [ ] [T013] [Hardening] [Full Test Suite] Execute go test -race -cover ./... and verify zero data races`
> - `- [ ] [T014] [Hardening] [Linter] Run golangci-lint run and verify zero warnings`
> - `- [ ] [T015] [Hardening] [Security] Run govulncheck ./... to verify zero known CVEs`
> - `- [ ] [T016] [Hardening] [Docker] Build container image and execute smoke test via docker compose up`
> 
> Lock Milestone 5 to finalize Tasks checklist?

**Human:**
> Lock milestone 5 and write to file.

**Agent:**
> Finalized [`docs/06-tasks.md`](file:///docs/06-tasks.md) on disk. Pipeline status updated to `IN_REVIEW`.
> Type `approve tasks` to unlock implementation.

**Human:**
> approve tasks

**Agent:**
> Confirmed: **Stage 6 (Tasks Breakdown)** formally `APPROVED` (`SIG-007` recorded in pipeline).  
> **Stage 7 (Implementation)** is now **UNLOCKED**. Type `/prag-implement` to begin writing code!

---

## 🎬 Act 7: Real-World Source Code Implementation (`/prag-implement`) — 5 Execution Segments

*Context: Implementation begins. The Agent never codes blindly or in bulk. It follows the 5 execution segments: Scope Gate -> Targeted Slice -> Test-First -> Terminal Verification -> DoD Sign-off.*

**Human:**
> `/prag-implement`

**Agent:**
> 🛡️ **Segment 1: Interactive Scope Gate Active**  
> All design specifications are signed off. Scanning `docs/06-tasks.md` for open tasks...  
> **Phase 2: Foundational Infrastructure** is the blocking prerequisite gate (`T003` -> `T005`).  
> Do you want to execute **all of Phase 2** or proceed task by task?

**Human:**
> Execute all of Phase 2. Run automated tests and race detection in terminal.
> 
> But question before you start: What happens if your automated test runs fail in the terminal? Does your agent loop endlessly trying random fixes?

**Agent:**
> Absolutely not! We enforce a strict **Circuit Breaker for Debugging**:
> 1. If an automated test command fails, the agent reads the exact stack trace and applies an evidence-based surgical fix.
> 2. If the test fails a **second consecutive time**, the Circuit Breaker trips immediately:
>    - The agent stops modifying files.
>    - Preserves existing Git state (or reverts to last known green commit).
>    - Summarizes the exact root cause and presents technical options to you in chat.
>    - Zero endless trial-and-error loops. Zero phantom code churn.

**Human:**
> That is how senior engineering should work. Proceed with Phase 2 implementation.

**Agent:**
> 🔍 **Segment 2: Targeted Retrieval**  
> Ingesting only targeted slices:
> - DB pool config from Section 1.2 of [`docs/05-database.md`](file:///docs/05-database.md) (`max_conns = 15`, timeouts).
> - Schema DDL from Section 3 of [`docs/05-database.md`](file:///docs/05-database.md) (UUIDv7, version integer).
> - Router requirements from Section 3 of [`docs/04-api.md`](file:///docs/04-api.md) (RFC 7807 error envelopes).
> 
> ⚙️ **Segment 3: Test-First Cycle (Red-Green-Refactor)**  
> 1. *Red Test*: Authored `internal/database/postgres_test.go` asserting pool connectivity and limits. (Test failed initially as expected).
> 2. *Green Implementation*: Authored `internal/database/postgres.go` using `jackc/pgx/v5/pgxpool` with configured limits. Authored `migrations/000001_init.sql`. Authored `internal/router/router.go`.
> 3. *Refactor*: Extracted clean configuration mapping into `internal/config/config.go`.
> 
> 🧪 **Segment 4: Terminal Automated Verification**  
> Executed automated test suite directly in terminal:
> ```bash
> $ go test -race -v ./internal/database/...
> === RUN   TestPostgresConnectionPool
> === RUN   TestPostgresConnectionPool/ping_success
> === RUN   TestPostgresConnectionPool/pool_limits_enforced
> --- PASS: TestPostgresConnectionPool (0.04s)
> PASS
> coverage: 87.5% of statements
> ok      flash-order/internal/database    0.052s
> ```
> 
> *Circuit Breaker Verification*: 0 test failures, 0 race conditions. Circuit breaker remains green.
> 
> ✅ **Segment 5: 6-Point Definition of Done (DoD) Sign-off**  
> 1. [x] Clean Compilation: 0 compile errors.
> 2. [x] Race-Detector Pass: `go test -race` passed cleanly.
> 3. [x] Error Handling: Every DB error explicitly wrapped via `fmt.Errorf("db pool ping failed: %w", err)`.
> 4. [x] Linter Cleanliness: `golangci-lint run` passed with 0 warnings.
> 5. [x] Zero Secrets: Database connection string loaded via environment variables in `internal/config`.
> 6. [x] Contract Fidelity: Schema matches [`docs/05-database.md`](file:///docs/05-database.md) 100%.
> 
> Updated [`docs/06-tasks.md`](file:///docs/06-tasks.md): marked `[x] [T003]`, `[x] [T004]`, `[x] [T005]`.  
> Phase 2 Foundational Infrastructure is complete. Ready to proceed to Phase 3 (US-01 Order Creation).

---

## 💡 Summary: Master Skill Suite Capabilities

| Design Principle | Practical Realization in Scenario |
| :--- | :--- |
| **Collaborative Stepper (Discussion First)** | The agent guides the engineer milestone by milestone across all stages, debating trade-offs before writing a single byte. |
| **Human Inquiries & Technical Pushback** | Senior engineer actively challenges architectural proposals (e.g., standard library vs Gin, RabbitMQ vs Redis Streams, UUIDv7 vs BIGSERIAL, ESR indexing order). |
| **Single Source of Truth** | All updates edit canonical documents directly in `docs/` in-place. Zero versioned junk files (`brd-v1.md`, `1-brd/`). |
| **Strict Gate Enforcement** | Downstream stages remain locked until upstream prerequisites are formally ratified (`SIG-001` through `SIG-007`). |
| **Targeted Context Slices** | During implementation, the agent retrieves only specific lines from API and DBDD documents, preserving context window tokens. |
| **Test-First Discipline & Circuit Breaker** | Tests are written before implementation code; terminal tests run automatically; repeated failures trigger immediate pause rather than guessing. |
| **Senior Engineering Fidelity** | 100% English specifications, dummy generic personas, zero sycophancy, clean math formatting, and adherence to enterprise standards. |
