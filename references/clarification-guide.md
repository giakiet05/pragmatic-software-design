# Interactive Clarification & Elicitation Guide

## 1. Overview

Before generating or updating technical specifications, the agent MUST resolve critical ambiguities. Jumping directly to code or assumptions creates rework, misaligned architectures, and phantom bugs.

This guide defines the **Sequential Clarification Protocol** adapted from advanced Spec-Driven Development principles.

---

## 2. Core Protocol Rules

1.  **Maximum 5 Questions Total**: Never overwhelm the user. A session must ask at most 5 highly targeted questions.
2.  **Strictly ONE Question at a Time**: Never dump multiple questions in a single turn. Wait for the user to answer the active question before presenting the next one.
3.  **Mandatory Stake Sentence ("Why it matters")**: Immediately following the question, explain in one plain-language sentence the architectural or operational risk if this remains unresolved.
4.  **Always Provide a Prominent Recommendation**: Based on senior engineering best practices, common industry patterns, and risk minimization, specify a recommended choice with a 1-sentence rationale.
5.  **Render an Options Table**: Give 2 to 4 discrete, mutually exclusive options (A, B, C) plus an optional Short Answer slot.
6.  **Direct Integration**: Immediately after the user responds (by selecting an option letter, saying "yes", or providing a short answer), encode the decision directly into the specification artifact under `## Clarifications`.

---

## 3. Ambiguity & Coverage Taxonomy

Scan user input and existing documents across these 6 categories to identify high-impact gaps:

### Category A: Functional Scope & Boundary
*   Core business goals vs secondary nice-to-haves.
*   Explicit out-of-scope declarations (what the system will NOT do in this phase).
*   User actor roles and permission boundaries.

### Category B: Domain & Data Integrity (Invariants)
*   Key entities, relationships, cardinality, and uniqueness constraints.
*   State machine lifecycle transitions (e.g., Draft -> Published -> Archived).
*   Data volume and scale assumptions (row counts, retention rules).

### Category C: Non-Functional Quality Attributes (Utility Tree Candidates)
*   Latency & Throughput: Expected RPS, P95/P99 response time targets.
*   Availability & Uptime: Recovery time objective (RTO), downtime tolerance.
*   Security & Compliance: AuthN/AuthZ mechanism, credential handling, token lifetimes.

### Category D: Concurrency & Edge Cases
*   Race condition handling (e.g., duplicate submissions, double spending, simultaneous updates).
*   Partial failure handling (e.g., database write succeeds but external webhook fails).
*   Empty states, rate limiting, and circuit breaking.

### Category E: Integration & External Dependencies
*   Third-party API reliability, timeout budgets, idempotency keys.
*   Database engine preference and driver constraints.

---

## 4. Question Format Standard

Every question presented to the user MUST adhere to this exact Markdown layout:

```markdown
**Question:** <Full interrogative ending with a question mark>?
*Why it matters:* <One sentence explaining technical/business risk or impact>.

**Recommended:** Option [A] - <Brief 1-sentence technical justification>.

| Option | Approach | Trade-offs / Description |
| :---: | :--- | :--- |
| **A** | <Option A Title> | <Pros and cons or description> |
| **B** | <Option B Title> | <Pros and cons or description> |
| **C** | <Option C Title> | <Pros and cons or description> |
| **Short** | Custom (< 5 words) | Provide your own short answer |

*Reply with the option letter (e.g., "A"), accept the recommendation with "yes", or type your own response.*
```

---

## 5. Early Exit Conditions

Stop asking questions immediately when:
*   All high-impact uncertainties (Impact × Uncertainty heuristic) are resolved.
*   User signals completion (*"done"*, *"enough"*, *"proceed"*, *"chơi luôn"*).
*   The 5-question limit is reached.
