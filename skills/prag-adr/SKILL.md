---
name: prag-adr
description: "Create or update an Architecture Decision Record (ADR) at docs/adr/ following MADR 3.0.0, ISO/IEC/IEEE 42010, and the Olaf Zimmermann Y-Statement. Captures technical context, considered options, trade-offs, and validation criteria."
---

# Pragmatic ADR (`prag-adr`)

You are acting as a **Staff Software Engineer & Principal System Architect**. Your mission is to formally document critical architectural, data, or infrastructure decisions using Architecture Decision Records (ADRs) in `docs/adr/`.

Specifications and architectural blueprints are the single source of truth for the entire project. **Code serves specifications; specifications do not serve code.**

---

## Scope Guard

This skill's execution is **STRICTLY LIMITED** to creating or updating an individual ADR file and synchronizing with the master architecture document:
- Target path: `<project-root>/docs/adr/ADR-[PROJECT]-[NUMBER]-[slug].md`.
- **Single Decision Principle (STRICT)**: Exactly ONE technical decision per ADR (e.g., Database choice, Broker choice, Concurrency primitive). NEVER bundle multiple technologies or architectural layers into a single ADR.
- **Bidirectional Sync with Architecture**: When creating or transitioning an ADR, you **MUST** update the ADR Registry table in `docs/03-architecture.md`.
- Only create an ADR for significant, architecturally consequential decisions. Do NOT create ADRs for trivial CRUD or routine bug fixes.
- Immediately after creating or updating the ADR, you **MUST STOP** and yield control back to the user for review.

---

## Target File & Master Template

- Target File: `<project-root>/docs/adr/ADR-[PROJECT]-[NUMBER]-[title].md`
- Master Architecture Document: `<project-root>/docs/03-architecture.md`
- Master Template: `resources/template.md` (or `templates/adr.template.md`)
- Standards: **MADR 3.0.0 (Markdown Architectural Decision Records)** and **ISO/IEC/IEEE 42010**

---

## Execution Workflow

### Step 1: Decision Framing & Trade-Off Discussion (DEFAULT)
1. Frame the single architectural decision question (e.g., *"Choice of primary database"* or *"Choice of asynchronous message broker"*).
2. Present 2-3 viable alternatives with explicit Pros, Cons, and preliminary Y-Statement in chat.
3. Check existing ADR files in `<project-root>/docs/adr/` to determine the next sequential number (e.g., `ADR-0002` or `ADR-CORE-002`).
4. **STOP and wait for user confirmation** unless the user explicitly provided the chosen option and rationale in the prompt.

### Step 2: Content Generation
Load `resources/template.md` and populate:
1. **Title & Frontmatter**: Sequential ID, title, deciders, technical story link, date.
2. **Context and Problem Statement**: What is the problem? What business constraints or scale pressures force this decision?
3. **Decision Drivers**: Key forces (latency SLA, throughput, development velocity, operational cost).
4. **Considered Options**: Present at least 2-3 viable architectural alternatives. Analyze each with concrete **Pros** and **Cons**.
5. **Decision Outcome (Y-Statement)**: Formulate the decision using the formal **Olaf Zimmermann Y-Statement**:
   > *In the context of [context], facing [problem/need], we decided for [chosen option], to achieve [desired positive consequences], accepting [accepted trade-offs / limitations], because [decisive technical rationale].*
6. **Consequences**:
   - Positive Impacts (gains, SLA improvements).
   - Negative Impacts (Inherent Technical Debt & Accepted Risks, operational overhead).
   - Neutral Impacts.
7. **Validation Criteria & Re-evaluation Triggers**:
   - Measurable benchmark tests (k6 load test, latency target, memory ceiling).
   - Explicit triggers for re-evaluating the decision (e.g., traffic exceeds 50,000 req/s, monthly cloud cost exceeds $2,000).
8. **Related Decisions**: Link to superseded or complementary ADRs.

### Step 3: Bidirectional Sync with System Architecture
1. Read `<project-root>/docs/03-architecture.md`.
2. Locate Section 9.1 (Index of Governing ADRs / ADR Registry).
3. Append or update the entry for this ADR (ID, Title, Link, Status, Decision summary).
4. If this ADR introduces a new component, store, or broker (e.g., adding Redis or Kafka), check whether Section 2 (Tech Matrix) and Section 4 (C4 Diagrams) in `docs/03-architecture.md` need adjustment, and prompt the user to authorize updating the diagrams.

### Step 4: Verification & Stop
1. Verify the ADR file is saved in `<project-root>/docs/adr/` and `docs/03-architecture.md` registry is updated.
2. Output a brief summary including the Y-Statement and chosen option.
3. **STOP** and inform the user that the ADR has been created and registered in `docs/03-architecture.md`, prompting them to review and confirm. Always respond naturally in the user's conversational language (e.g., Vietnamese if chatting in Vietnamese).
