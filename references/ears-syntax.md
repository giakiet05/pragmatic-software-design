# Easy Approach to Requirements Syntax (EARS) Reference Guide

## 1. Overview

EARS (Easy Approach to Requirements Syntax) is an industry-standard mechanism for formulating requirements without ambiguity. It eliminates passive voice, vague adjectives, and untestable claims.

Every functional requirement written in this framework MUST follow one of the 5 canonical EARS patterns.

---

## 2. The 5 Canonical Patterns

### Pattern 1: Ubiquitous Requirements
*   **Definition**: Applies continuously across the entire system; no trigger or specific state precondition.
*   **Syntax**: `The <system name> shall <system response>`
*   **Example**: `The Authentication Service shall encrypt all stored user tokens using AES-256-GCM.`

### Pattern 2: Event-Driven Requirements
*   **Definition**: Triggered when a discrete event occurs.
*   **Syntax**: `When <trigger>, the <system name> shall <system response>`
*   **Example**: `When a user submits a valid login form, the Authentication Service shall issue a signed JWT access token and refresh token pair.`

### Pattern 3: State-Driven Requirements
*   **Definition**: Active only while the system is in a specific operational state or mode.
*   **Syntax**: `While <precondition state>, the <system name> shall <system response>`
*   **Example**: `While the database is in read-only maintenance mode, the API Gateway shall reject state-mutating requests with HTTP 503 Service Unavailable.`

### Pattern 4: Unwanted Behavior / Error Requirements
*   **Definition**: Handles error conditions, exceptions, edge cases, and boundary violations.
*   **Syntax**: `If <unwanted condition / trigger>, then the <system name> shall <system response>`
*   **Example**: `If a client provides an expired refresh token, then the Authentication Service shall revoke the session and return HTTP 401 Unauthorized.`

### Pattern 5: Optional Feature Requirements
*   **Definition**: Active only when a specific feature flag, hardware capability, or optional module is enabled.
*   **Syntax**: `Where <optional feature is present>, the <system name> shall <system response>`
*   **Example**: `Where Redis cache is configured, the Query Service shall cache catalog lookups with a 5-minute TTL.`

---

## 3. Complex Combination Patterns

Real-world requirements often combine state preconditions, triggers, and error branches:

*   **State + Event**:
    `While <state>, when <trigger>, the <system name> shall <system response>`
    *Example*: `While an auction is active, when a higher bid is submitted, the Bidding Engine shall record the bid and notify the previous highest bidder.`

*   **State + Event + Error Handling**:
    `While <state>, when <trigger>, the <system name> shall <system response>, else if <unwanted condition>, then the <system name> shall <fallback response>`
    *Example*: `While order status is Draft, when Checkout button is pressed, the Order Service shall reserve inventory, else if inventory is insufficient, then the Order Service shall reject checkout with an OutOfStock error.`

---

## 4. Anti-Patterns to Avoid

| Anti-Pattern | Bad Example | Corrected EARS Form |
| :--- | :--- | :--- |
| **Vague Adjective** | "The system should be fast and responsive during search." | "When a user executes a search query, the Search Service shall return matching items within 50ms (P99)." |
| **Passive Voice** | "User accounts will be verified upon registration." | "When a new user registers, the User Service shall send an account verification email containing an HMAC-signed link." |
| **Missing Actor/Subject** | "Must validate password strength." | "The Authentication Service shall reject passwords with fewer than 10 characters or lacking uppercase, lowercase, and digits." |
| **Compound Confusion** | "When user clicks pay, process payment and update inventory and send email and log metrics." | Split into distinct event-driven requirements with clear single responsibility per requirement. |
