<!--
[AI AGENT DIRECTIVE: PRAGMATIC TEMPLATE ADAPTATION]
1. DOMAIN FIDELITY: This document is a structural and semantic guide. You MUST adapt all entities, terminology, state transitions, and architectures strictly to the USER'S ACTUAL SYSTEM DOMAIN. NEVER copy placeholder examples (e.g., e-commerce orders, payments) unless they are genuinely required by the user's domain.
2. PRAGMATIC PRUNING (YAGNI): Tailor depth and complexity to the project's scale. If a specific advanced architectural pattern (e.g., Table Partitioning, WebSockets, Circuit Breakers, Complex Multi-region DR) is demonstrably over-engineered for the current scope, explicitly mark it as "N/A - Omitted because [concrete technical reason]" rather than fabricating unnecessary complexity.
3. ZERO PLACEHOLDER LEAKS: Replace all [BRACKETED_PLACEHOLDERS] with real, concrete project data. Never leave unpopulated template tags in the final generated document.
-->

# [NUMBER]. [SHORT TITLE OF ARCHITECTURAL DECISION]

> **Document Identifier**: ADR-[PROJECT]-[NUMBER]  
> **Document Version**: 1.0.0  
> **Status**: [Proposed | Accepted | Rejected | Deprecated | Superseded by ADR-XXXX]  
> **Standard Compliance**: MADR 3.0.0 (Markdown Architectural Decision Records) & ISO/IEC/IEEE 42010  
> **Deciders**: [Architect / Lead Engineer]  
> **Consulted**: [Domain Experts / Team Members]  
> **Date**: [YYYY-MM-DD]  
> **Governing Blueprint**: [`docs/03-architecture.md`](file:///docs/03-architecture.md)  
> **Related ADRs**: [e.g., Supersedes ADR-0001 / Complements ADR-0004]  

---

### Document Control & Revision History

| Version | Release Date | Author / Contributor | Summary of Changes | Approval Status |
| :---: | :---: | :--- | :--- | :---: |
| **0.1** | [YYYY-MM-DD] | [Lead Architect / Engineer] | Initial decision proposal and trade-off analysis | Proposed |
| **1.0** | [YYYY-MM-DD] | [Lead Architect / Engineer] | Architectural decision ratified with deciders | Accepted |

---

## Table of Contents
- [1. Context and Problem Statement](#1-context-and-problem-statement)
- [2. Decision Drivers (Key Evaluation Criteria)](#2-decision-drivers-key-evaluation-criteria)
- [3. Considered Options & Trade-off Analysis](#3-considered-options--trade-off-analysis)
- [4. Decision Outcome & Y-Statement](#4-decision-outcome--y-statement)
  - [4.1 The Y-Statement](#41-the-y-statement)
  - [4.2 Detailed Consequences & Mitigation](#42-detailed-consequences--mitigation)
- [5. Validation Criteria & Re-evaluation Triggers](#5-validation-criteria--re-evaluation-triggers)
  - [5.1 Validation Method](#51-validation-method)
  - [5.2 Re-evaluation Triggers](#52-re-evaluation-triggers-circuit-breaker-for-decisions)
- [6. Implementation Notes & Governing Links](#6-implementation-notes--governing-links)

---

## 1. Context and Problem Statement
<!--
  What is the specific architectural dilemma, technical requirement, or constraint we are addressing?
  Describe the technical context, current operational friction, and why a definitive decision is required now.
-->
[Describe the context and the problem in 2-4 concise sentences]

---

## 2. Decision Drivers (Key Evaluation Criteria)
<!--
  What specific quality attributes (NFRs), business constraints, or operational goals drive this choice?
  Link to the Utility Tree in 02-srs.md or SLA/SLO in 03-architecture.md where applicable.
-->
*   **Driver 1**: [e.g., P99 query latency must remain < 50ms under peak load of 2,000 RPS]
*   **Driver 2**: [e.g., Operational simplicity: zero external infrastructure dependencies for MVP deployment]
*   **Driver 3**: [e.g., Strict ACID guarantees and row-level locking for financial transactions]

---

## 3. Considered Options & Trade-off Analysis
<!--
  Detail each candidate technology or architectural pattern evaluated, along with its concrete pros and cons.
  Keep evaluations objective and evidence-based.
-->

### Option 1: [Option 1 Title - e.g., Embedded SQLite with WAL Mode]
*   **Overview**: [Brief description of how this option would be structured and deployed]
*   **Pros (Good, because)**:
    *   [Advantage 1: e.g., Zero network overhead; simplified single-binary deployment]
    *   [Advantage 2: e.g., Minimal memory footprint; zero external daemon management]
*   **Cons (Bad, because)**:
    *   [Disadvantage 1: e.g., Write concurrency is serialized to a single writer process]
    *   [Disadvantage 2: e.g., Horizontal scaling across multiple server instances requires complex replication tools]

### Option 2: [Option 2 Title - e.g., Client-Server PostgreSQL Cluster]
*   **Overview**: [Brief description of how this option would be structured and deployed]
*   **Pros (Good, because)**:
    *   [Advantage 1: e.g., High concurrent write throughput via connection pooling]
    *   [Advantage 2: e.g., Native JSONB indexing, robust streaming replication, and rich window functions]
    *   [Advantage 3: e.g., Strict ecosystem tooling compatibility with pgx and migration engines]
*   **Cons (Bad, because)**:
    *   [Disadvantage 1: e.g., Requires managing dedicated database daemon and persistent network volumes]
    *   [Disadvantage 2: e.g., Higher baseline memory footprint per connected client process]

### Option 3: [Option 3 Title - e.g., NoSQL / Managed Document Store]
*   **Overview**: [Brief description of how this option would be structured and deployed]
*   **Pros (Good, because)**:
    *   [Advantage 1: e.g., Flexible schema evolution without upfront database migrations]
*   **Cons (Bad, because)**:
    *   [Disadvantage 1: e.g., Lacks multi-table ACID transactions and enforces eventual consistency]

---

## 4. Decision Outcome & Y-Statement

### 4.1 The Y-Statement
<!--
  MANDATORY: Formal decision synthesis following the Olaf Zimmermann Y-Statement format.
  Do not evade trade-offs. Clearly articulate the sacrifice accepted in exchange for the chosen benefit.
-->
> In the context of **[Context / Problem Statement]**,  
> facing **[Decision Drivers / Constraints]**,  
> we decided for **[Chosen Option]**  
> and against **[Rejected Options]**,  
> to achieve **[Key Positive Consequences / Benefits]**,  
> accepting that **[Inherent Negative Consequences / Technical Debt]**.

### 4.2 Detailed Consequences & Mitigation
*   **Positive Impact**: [What improves? e.g., Unlocks sub-millisecond local reads, reduces monthly infrastructure cost to zero.]
*   **Negative Impact / Debt**: [What becomes harder? e.g., Background writes must be strictly batched to prevent database lock contention.]
*   **Mitigation Strategy**: [Concrete action to manage the negative impact: e.g., Implement busy-timeout retry handlers and establish automated alert threshold for SQLite file size.]

---

## 5. Validation Criteria & Re-evaluation Triggers

### 5.1 Validation Method
<!-- How will we mathematically or empirically prove that this decision was correct in practice? -->
*   **Verification Strategy**: [e.g., Execute load test using k6 with 500 concurrent virtual users; verify P99 latency remains < 40ms without lock timeouts].
*   **Success Metric**: [e.g., Zero database lock failures over 1,000,000 synthetic transaction cycles].

### 5.2 Re-evaluation Triggers (Circuit Breaker for Decisions)
<!-- Under what concrete operational conditions must this architectural decision be reopened and reconsidered? -->
*   **Trigger 1**: [e.g., If total concurrent write throughput consistently exceeds 500 write operations / second].
*   **Trigger 2**: [e.g., If database storage footprint exceeds 50 GB, triggering horizontal sharding evaluation].
*   **Trigger 3**: [e.g., If multi-region active-active deployment becomes an explicit business requirement in 01-brd.md].

---

## 6. Implementation Notes & Governing Links
*   **Governing Section in SAD**: Mapped to [`docs/03-architecture.md#section-2`](file:///docs/03-architecture.md).
*   **Execution Tasks**: Implementation work packages tracked under [`docs/06-tasks.md`](file:///docs/06-tasks.md).
*   **Relevant Technical Standards**: [Link to RFCs, official engine documentation, or benchmark logs].
