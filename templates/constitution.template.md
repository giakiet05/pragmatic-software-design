<!--
[AI AGENT DIRECTIVE: PRAGMATIC TEMPLATE ADAPTATION]
1. DOMAIN FIDELITY: This document is a structural and semantic guide. You MUST adapt all entities, terminology, state transitions, and architectures strictly to the USER'S ACTUAL SYSTEM DOMAIN. NEVER copy placeholder examples (e.g., e-commerce orders, payments) unless they are genuinely required by the user's domain.
2. PRAGMATIC PRUNING (YAGNI): Tailor depth and complexity to the project's scale. If a specific advanced architectural pattern (e.g., Table Partitioning, WebSockets, Circuit Breakers, Complex Multi-region DR) is demonstrably over-engineered for the current scope, explicitly mark it as "N/A - Omitted because [concrete technical reason]" rather than fabricating unnecessary complexity.
3. ZERO PLACEHOLDER LEAKS: Replace all [BRACKETED_PLACEHOLDERS] with real, concrete project data. Never leave unpopulated template tags in the final generated document.
-->

# Project Constitution: [PROJECT_NAME]

> **Document Identifier**: CONST-[PROJECT]-001  
> **Document Version**: 1.0.0  
> **Standard Compliance**: Zero-Fluff Pragmatic Architecture & Strict Engineering Governance  
> **Status**: [Draft | Ratified | In Progress]  
> **Lead Architect / Custodian**: [Name / Role]  
> **Last Updated**: [YYYY-MM-DD]  

---

### Document Control & Revision History

| Version | Release Date | Author / Contributor | Summary of Changes | Approval Status |
| :---: | :---: | :--- | :--- | :---: |
| **0.1** | [YYYY-MM-DD] | [Lead Architect / Custodian] | Initial draft of non-negotiable architectural articles | Draft |
| **1.0** | [YYYY-MM-DD] | [Lead Architect / Custodian] | Constitution ratified and locked as immutable project baseline | Ratified |

---

> **Note for AI Agent**: When generating `docs/constitution.md` for a project via `/prag-constitution`, specialize the `Standards` lines to the project's **target tech stack** if pre-mandated by the user or detected from the workspace. If specific technology choices (such as runtime, database, storage, or frameworks) are not yet determined, mark them as `TBD - Deferred to Stage 3 (Architecture)` to prevent premature architectural decisions.

---

## Table of Contents
- [1. Project Tech Stack & Standards](#1-project-tech-stack--standards)
- [2. Core Principles (Non-Negotiable)](#2-core-principles-non-negotiable)
  - [Article 1: Standard Library First & Minimal Dependencies](#article-1-standard-library-first--minimal-dependencies)
  - [Article 2: Test-First Discipline & Concurrency Safety](#article-2-test-first-discipline--concurrency-safety)
  - [Article 3: Structured JSON Logging Only](#article-3-structured-json-logging-only-zero-console-policy)
  - [Article 4: Strict Explicit Error Handling](#article-4-strict-explicit-error-handling-zero-swallowing-policy)
  - [Article 5: Pragmatic Layered Architecture](#article-5-pragmatic-layered-architecture-kiss--yagni-first)
  - [Article 6: 12-Factor Configuration & Zero-Secrets Policy](#article-6-12-factor-configuration--zero-secrets-policy)
  - [Article 7: Codebase Hygiene, 100% English & Doc Discipline](#article-7-codebase-hygiene-100-english--doc-discipline)
- [3. Architecture Gates & Enforcement](#3-architecture-gates--enforcement)
- [4. Customization & Amendments](#4-customization--amendments)

---

## 1. Project Tech Stack & Standards

*   **Primary Runtime & Language**: [e.g., Go 1.24+ | Python 3.12+ | Node.js 22 LTS | TBD - Deferred to Stage 3 Architecture]
*   **Primary Database / Storage**: [e.g., PostgreSQL 16 | SQLite 3 | None / In-Memory | TBD - Deferred to Stage 3 Architecture]
*   **Architectural Model**: Layered 4-Tier (`Router` -> `Controller` -> `Service` -> `Repository`)
*   **Package Manager**: [e.g., `go modules` | `uv` / `poetry` | `pnpm` / `npm` | TBD]
*   **Test Runner**: [e.g., `go test -race ./...` | `pytest -v` | `node:test` / `vitest` | TBD]

---

## 2. Core Principles (Non-Negotiable)

### Article 1: Standard Library First & Minimal Dependencies
*   **Mandate**: Always exhaust the language standard library before introducing external packages or third-party frameworks. Adding external dependencies without explicit user consent is strictly prohibited.
*   **Standards**: [Use standard library: Go (`net/http`, `database/sql`, `log/slog`) | Python (`urllib`, `sqlite3`, `dataclasses`, `asyncio`) | TypeScript (`fetch`, `node:test`, `node:crypto`)].
*   **Exceptions**: Permissible only when standard implementations require > 50 lines of complex boilerplate or for essential low-level database drivers. Every external dependency MUST be defended in the *Complexity Tracking Table*.

### Article 2: Test-First Discipline & Concurrency Safety
*   **Mandate**: Core business workflows, domain invariants, and database access operations MUST be accompanied by automated tests before marking tasks as complete. Fragile over-mocking ("mocking the world") is strictly forbidden; favor realistic in-memory stores, test containers, or table-driven tests.
*   **Standards**: [Specify test runner and race detection: Go (`go test -race ./...`, table-driven) | Python (`pytest -v`, `pytest-asyncio`) | TypeScript (`node:test` or `vitest`)].
*   **Exceptions**: Rapid throwaway prototypes or CLI argument parsers, only when explicitly approved by the user.

### Article 3: Structured JSON Logging Only (Zero-Console Policy)
*   **Mandate**: Arbitrary console print statements (e.g., `fmt.Println`, `console.log`, `print()`, `System.out.println`) are strictly forbidden in production pathways. All application logs MUST emit machine-readable structured JSON with standard contextual keys: `timestamp`, `level`, `msg`, `error`, `duration_ms`, and `trace_id`.
*   **Standards**: [Specify JSON logger: Go (`log/slog`, `zerolog`) | Python (`structlog`, standard `logging` JSON formatter) | TypeScript (`pino`, `winston`)].
*   **Exceptions**: CLI tools where stdout is intentionally designed for human terminal consumption or shell piping (must support an optional `--json` flag).

### Article 4: Strict Explicit Error Handling (Zero-Swallowing Policy)
*   **Mandate**: Never swallow, discard, or silently ignore errors. Empty catch/except blocks or discarding error returns (`_ = err`) is grounds for immediate code rejection. Every error must be explicitly checked, wrapped with contextual breadcrumbs, and handled at the appropriate architectural boundary. Public API error responses must follow RFC 7807 (Problem Details) and never leak internal stack traces or raw database queries.
*   **Standards**: [Specify error pattern: Go (`if err != nil` with `fmt.Errorf("%w")`) | Python (custom domain exceptions, strictly no bare `except:`) | TypeScript (typed `Result<T, E>` or custom Error classes)].
*   **Exceptions**: None. Every error branch must be explicitly handled, logged, or propagated.

### Article 5: Pragmatic Layered Architecture (KISS & YAGNI First)
*   **Mandate**: The default structural model for all backend services is strictly **Layered Architecture (4 Tiers)**:
    `Router` -> `Controller` -> `Service` -> `Repository`
    *   **Router**: Route mapping, URL pattern matching, and middleware pipeline piping.
    *   **Controller**: Request DTO binding, schema validation, HTTP response encoding, and status codes.
    *   **Service**: Pure business logic, workflow coordination, domain rules, and invariant enforcement.
    *   **Repository**: Data persistence, interface-driven SQL queries, and transaction management.
*   **Standards**: Interfaces must be defined at consumer boundaries (client-side of the dependency). Do not create single-implementation interfaces without clear testing or substitution requirements.
*   **Exceptions**: Do NOT introduce premature abstractions, microservices, CQRS, or message brokers (Kafka/RabbitMQ) unless an explicit High-priority scenario in the Utility Tree mathematically justifies it (defended in the *Complexity Tracking Table*).

### Article 6: 12-Factor Configuration & Zero-Secrets Policy
*   **Mandate**: All operational parameters (ports, database credentials, external URLs, timeouts) must be loaded strictly from **Environment Variables**. Hardcoding credentials, API tokens, internal IP addresses, or magic configuration constants directly in source code is strictly prohibited. The repository MUST maintain a sanitized `.env.example`. Actual `.env` files must be ignored by version control.
*   **Standards**: [Specify env loader: Go (`os.Getenv` with typed parsing) | Python (`pydantic-settings`) | TypeScript (`zod` + `process.env`)].
*   **Exceptions**: Non-sensitive development defaults clearly documented in `.env.example`.

### Article 7: Codebase Hygiene, 100% English & Doc Discipline
*   **Mandate**: 100% of all source code, variable/type names, documentation comments, log messages, and git commit messages MUST be in **English**. Every exported class, interface, struct, and function must have a standardized doc comment immediately above it explaining its purpose, parameters, returns, and error conditions. Emojis and decorative icons are strictly banned in code, comments, log strings, and commit messages. Commits must follow 1-line Conventional Commits: `<type>(<scope>): <short summary in English>`.
*   **Standards**: [Specify doc standard: Go (GoDoc comments) | Python (PEP 257 Docstrings) | TypeScript (TSDoc / JSDoc)].
*   **Exceptions**: End-user UI strings (i18n) when localized display text is explicitly requested.

---

## 3. Architecture Gates & Enforcement

Before ANY implementation task is authorized, the feature plan MUST satisfy these gates:

1.  **Gate 1 (Scope Gate)**: In-Scope and Out-of-Scope boundaries clearly defined in `docs/01-brd.md` and functional requirements mapped in `docs/02-srs.md`.
2.  **Gate 2 (Quality Gate)**: Utility Tree scenarios in `docs/02-srs.md` quantified with concrete metrics (latency, RPS, recovery targets).
3.  **Gate 3 (Model Gate)**: Data models rendered with Mermaid ERD in `docs/03-architecture.md` and primary/foreign keys designated.
4.  **Gate 4 (Layering Gate)**: Code structure strictly conforms to `Router -> Controller -> Service -> Repository`.
5.  **Gate 5 (Complexity Gate)**: Any violation of Article 1 (new dependency) or Article 5 (added abstraction layer) must be justified in the *Complexity Tracking Table* in `docs/03-architecture.md`.

---

## 4. Customization & Amendments
To customize or amend this constitution for specific project needs:
*   Users can edit this file directly, or
*   Re-run `/prag-constitution [amendment details]` (e.g., `/prag-constitution allow Gin router and SQLite for lightweight CLI prototype`).

---

**Version**: 1.0.0 | **Ratified**: [DATE] | **Last Amended**: [DATE]
