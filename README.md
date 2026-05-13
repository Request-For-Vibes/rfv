# RFV: Request for Vibes

> A structured review process for code of uncertain provenance.

[![Vibe Check](https://img.shields.io/badge/vibe%20check-pending-yellow)](#)
[![Standard](https://img.shields.io/badge/standard-RFV--0001-blue)](#)
[![Vibes](https://img.shields.io/badge/vibes-questionable-orange)](#)

---

## What is this?

The software industry has RFC for protocol design and RFP for procurement. It did not have a formal mechanism for establishing whether anyone actually understands the code they are shipping.

Now it does.

RFV (Request for Vibes) is a review process for vibe coded software. It provides severity levels, a structured interview for authors who may not be able to explain their own code, compliance metrics, and an emergency protocol for teams whose vibe ratio has exceeded safe limits.

Read the full proposal: [RFV-0001](rfv-0001.md)

---

## Quick Start

### Submitting an RFV

1. Copy the [template](template.md)
2. Fill it in honestly (this is the hard part)
3. Open a pull request against this repo
4. The **Vibe Check** workflow will run automatically and assess your submission
5. A human reviewer will follow up (assuming one is available and has not been replaced by a model)

### Severity Levels

| Level | Vibes | Action |
|---|---|---|
| RFV-1 | Good | Document and move on |
| RFV-2 | Mixed | Senior review of unexplained sections |
| RFV-3 | Off | Full review, written explanation required |
| RFV-4 | Catastrophic | PR closed. Earl Grey offered. |

---

## The Vibe Check CI

Every pull request that adds or modifies an RFV document (`rfv-*.md`) is automatically checked by the Vibe Check workflow. It validates:

- Required metadata fields are present (ID, author, date, severity)
- Severity level is a recognised classification
- The Vibe Interview section exists for RFV-3 and above
- The document does not contain phrases that suggest the RFV itself was vibe coded

The check will pass, warn, or fail. A failure does not block the merge (we are not monsters). It does leave a comment on your PR explaining what the vibes are and why.

---

## Repository Structure

```
rfv-0001.md       # The founding proposal
template.md       # Blank RFV submission template
submissions/      # Submitted RFVs (via pull request)
.github/
  workflows/
    vibe-check.yml  # The CI that checks your vibes
  scripts/
    vibe-check.sh   # The vibe assessment engine
```

---

## Contributing

Contributions are welcome. If you are submitting a new RFV standard proposal (RFV-NNNN), please ensure:

1. It follows the format established in RFV-0001
2. It was written by a human (the irony of vibe coding an RFV submission would not be lost on us, but we would still reject it)
3. It includes a severity classification and at least one concrete example

If you are submitting an RFV against code in another repository, use the [template](template.md) and place it in `submissions/`.

---

## FAQ

**Is this serious?**
The format is satirical. The problem is not.

**Can I use this at work?**
You can and you should. The Vibe Interview questions are genuinely useful for any code review where the provenance is uncertain.

**What if my entire codebase is vibe coded?**
See Section 5 of RFV-0001: Vibe Emergency Protocol. You will need a copy of "Code Complete" and some time to reflect.

**Was this README vibe coded?**
No comment. (See: Section 6, Exemptions.)

---

## License

[Unlicense](LICENSE). Public domain. The vibes are free.
