# RFV Submission Template

> Copy this template when raising a Request for Vibes against a pull request or commit.

---

**RFV ID:** RFV-YYYY-NNN
**Date raised:** YYYY-MM-DD
**Raised by:** (your name)
**Author of code under review:** (their name, or "unclear")
**PR / Commit:** (link)
**Repository:** (repo name)

---

## Trigger

Which condition triggered this RFV? (check all that apply)

- [ ] Author cannot explain a function they committed without re-reading it first
- [ ] Honest answer to "why did you do it this way?" is "I did not"
- [ ] Commit message references a model by name
- [ ] PR opened within four minutes of ticket assignment
- [ ] Code works perfectly on the first attempt
- [ ] Other: _______________

## Severity

- [ ] **RFV-1 (Low)** — Vibes are good. Author understands the code.
- [ ] **RFV-2 (Medium)** — Vibes are mixed. Author understands most of it.
- [ ] **RFV-3 (High)** — Vibes are off. Author cannot explain significant portions.
- [ ] **RFV-4 (Critical)** — Vibes are catastrophic. Code touches auth, payments, or personal data.

## Scope

**Files affected:**

| File | Vibe coded? | Author can explain? |
|---|---|---|
| | Yes / No / Partially | Yes / No / With effort |

**Estimated vibe ratio for this PR:** _____ (0.0 to 1.0)

## The Vibe Interview

For RFV-3 and above. Author answers without consulting the model that wrote the code.

| # | Question | Answer | Confident? |
|---|---|---|---|
| 1 | What does this code do? | | Yes / No |
| 2 | Why this approach and not another? | | Yes / No |
| 3 | What happens when the input is null? | | Yes / No |
| 4 | What happens when the input is wrong in a way you have not considered? | | Yes / No |
| 5 | Where are the tests? | | Yes / No |
| 6 | Did the same model write both the code and the tests? | | Yes / No |

**Confident answers:** ___ / 6
**Result:** Pass (4+) / Fail (under 4) / Pairing required

## Evidence

Anything that prompted the RFV. Screenshots of suspiciously clean code, commit timestamps that defy human typing speed, comments that read like documentation, variable names that are inexplicably good.

## Outcome

- [ ] **Approved** — vibes verified, proceed to merge
- [ ] **Conditionally approved** — specific sections require human explanation before merge
- [ ] **Pairing required** — author must pair with a reviewer to walk through the code
- [ ] **Rejected** — PR closed, author asked to rewrite by hand (or at least read it this time)

**Reviewer:** (name)
**Date resolved:** YYYY-MM-DD
**Notes:**

---

*Template version 1.0. Part of the RFV-0001 standard.*
