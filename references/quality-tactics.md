# Architectural Tactics Catalog (ADD Reference)

## 1. Overview

In Attribute-Driven Design (ADD), architectural tactics are design decisions that directly control the response of a quality attribute (Performance, Availability, Security, Modifiability).

Instead of generic buzzwords ("high performance", "scalable"), every High-priority scenario in the **Utility Tree** MUST be mapped to one or more concrete architectural tactics from this catalog.

---

## 2. Performance Tactics

Goal: Control latency and throughput within acceptable boundaries under specified load.

| Tactic | Description | Typical Realization in Go/Python/TS |
| :--- | :--- | :--- |
| **Cache-Aside (Lazy Loading)** | Cache reads in fast in-memory store; refresh on cache miss or TTL expiry. | Redis, `sync.Map`, Go-Cache, Memcached. |
| **Index Tuning** | Use B-Tree, GIN, or Hash indexes on query filter and join keys. | PostgreSQL composite index, SQLite index. |
| **Connection Pooling** | Reuse persistent TCP connections to databases and HTTP upstreams. | `sql.DB.SetMaxOpenConns()`, `http.Transport.MaxIdleConns`. |
| **Batch Processing** | Combine multiple discrete write operations into single bulk operations. | `COPY` command, multi-row `INSERT`, buffered channel flush. |
| **Asynchronous Offloading** | Offload non-blocking operations from the request-response thread to background workers. | Goroutines + worker pool, Celery, BullMQ, Redis streams. |
| **Data Projection (Sparse Queries)** | Select only required fields rather than full entity tables (`SELECT *`). | Explicit SQL column projections, GraphQL field resolvers. |

---

## 3. Availability & Fault Tolerance Tactics

Goal: Prevent local faults from becoming system-wide outages and ensure graceful degradation.

| Tactic | Description | Typical Realization |
| :--- | :--- | :--- |
| **Circuit Breaker** | Automatically halt requests to a failing dependency to allow recovery and prevent thread pool exhaustion. | Sony/gobreaker, Resilience4j, PyBreaker. |
| **Transactional Outbox** | Atomically persist domain events in database transaction before publishing to message brokers. | Outbox table polled by worker or CDC (Debezium). |
| **Exponential Backoff & Jitter** | Retry transient failures with increasing delays and random jitter to avoid thundering herds. | Custom retry loop with `math/rand`, Tenacity (Python). |
| **Idempotency Keys** | Use unique client request tokens to prevent duplicate mutations on retries. | Header `Idempotency-Key` stored in Redis with TTL. |
| **Graceful Shutdown** | Catch `SIGINT`/`SIGTERM`, stop accepting new traffic, and wait for in-flight requests to complete. | Go `signal.NotifyContext()` + `http.Server.Shutdown()`. |
| **Health Check Probes** | Expose liveness and readiness endpoints for orchestrators. | `/healthz` (shallow ping), `/readyz` (deep dependency check). |

---

## 4. Security & Data Integrity Tactics

Goal: Resist attacks, enforce authorization, and maintain data invariants across mutations.

| Tactic | Description | Typical Realization |
| :--- | :--- | :--- |
| **Defense in Depth** | Validate inputs at API gateway, service boundary, and database constraint levels. | Schema validator + domain entity invariants + DB foreign keys. |
| **Least Privilege** | Grant entities only the minimum access permissions necessary to perform their role. | Scoped RBAC, DB users with restricted permissions. |
| **Cryptographic Storage** | Store sensitive secrets with salted, memory-hard hashing algorithms. | Argon2id, bcrypt, PBKDF2 (never MD5/SHA256 for passwords). |
| **Audit Logging** | Record all security-sensitive events with immutable context. | Structured JSON log containing ActorID, Action, Resource, Timestamp. |
| **Safe Error Masking** | Mask internal database or stack trace details in public API responses. | Custom HTTP error handler returning sanitized RFC 7807 problem details. |

---

## 5. Modifiability & Maintainability Tactics

Goal: Allow changes to business logic or technology stack with minimal ripple effects.

| Tactic | Description | Typical Realization |
| :--- | :--- | :--- |
| **Interface Segregation (Loose Coupling)**| Program to abstract interfaces rather than concrete implementations. | Go interfaces defined at consumer side, Python Protocols. |
| **Layered Decoupling** | Enforce strict separation of concerns across linear application layers (`router` → `controller` → `service` → `repository`). | Package-by-layer layout (`internal/router`, `internal/controller`, `internal/service`, `internal/repository`). |
| **Configuration Externalization** | Separate configuration from code; read from environment variables. | 12-factor app model (`os.Getenv`, Viper, Pydantic Settings). |
