#!/usr/bin/env bash
#
# vibe-check.sh — automated vibe assessment for RFV documents
#
# Usage: vibe-check.sh <file-list>
#   where <file-list> is a file containing one RFV document path per line
#

set -euo pipefail

FILE_LIST="$1"
WARNINGS=0
ERRORS=0
NOTES=()

overall_status="GOOD"

while IFS= read -r rfv_file; do
  [ -f "$rfv_file" ] || continue

  content=$(cat "$rfv_file")

  # ── Metadata checks ──────────────────────────────────────────────

  if ! grep -qiE '^\*?\*?RFV ID:' "$rfv_file"; then
    NOTES+=("⚠️  \`$rfv_file\`: Missing **RFV ID**. Every RFV needs an identity. Even the bad ones.")
    WARNINGS=$((WARNINGS + 1))
  fi

  if ! grep -qiE '^\*?\*?(Author|Raised by):' "$rfv_file"; then
    NOTES+=("⚠️  \`$rfv_file\`: Missing **Author**. Someone wrote this. Probably.")
    WARNINGS=$((WARNINGS + 1))
  fi

  if ! grep -qiE '^\*?\*?(Date|Created|Date raised):' "$rfv_file"; then
    NOTES+=("⚠️  \`$rfv_file\`: Missing **Date**. Vibes are timeless, but paperwork is not.")
    WARNINGS=$((WARNINGS + 1))
  fi

  # ── Severity check ──────────────────────────────────────────────

  severity=""
  if grep -qiE 'RFV-4|Critical' "$rfv_file"; then
    severity="RFV-4"
  elif grep -qiE 'RFV-3|High' "$rfv_file"; then
    severity="RFV-3"
  elif grep -qiE 'RFV-2|Medium' "$rfv_file"; then
    severity="RFV-2"
  elif grep -qiE 'RFV-1|Low' "$rfv_file"; then
    severity="RFV-1"
  fi

  if [ -z "$severity" ]; then
    NOTES+=("⚠️  \`$rfv_file\`: No **severity level** detected. How are the vibes? We cannot tell.")
    WARNINGS=$((WARNINGS + 1))
  else
    NOTES+=("📋 \`$rfv_file\`: Severity classified as **$severity**.")
  fi

  # ── Vibe Interview required for RFV-3+ ─────────────────────────

  if [[ "$severity" == "RFV-3" || "$severity" == "RFV-4" ]]; then
    if ! grep -qiE 'Vibe Interview|What does this code do' "$rfv_file"; then
      NOTES+=("❌ \`$rfv_file\`: Severity is **$severity** but no **Vibe Interview** section found. The standard requires one. (RFV-0001, Section 3.2)")
      ERRORS=$((ERRORS + 1))
    fi
  fi

  # ── Suspicion: was this RFV itself vibe coded? ──────────────────

  vibe_coded_hints=0
  declare -a sus_phrases=()

  if echo "$content" | grep -qiE 'I hope this helps'; then
    vibe_coded_hints=$((vibe_coded_hints + 1))
    sus_phrases+=("\"I hope this helps\"")
  fi

  if echo "$content" | grep -qiE 'certainly!|of course!|absolutely!'; then
    vibe_coded_hints=$((vibe_coded_hints + 1))
    sus_phrases+=("enthusiastic affirmations")
  fi

  if echo "$content" | grep -qiE 'delve into|deep dive|let'\''s explore'; then
    vibe_coded_hints=$((vibe_coded_hints + 1))
    sus_phrases+=("AI vocabulary")
  fi

  if echo "$content" | grep -qiE 'robust|seamless|leverage|utilize'; then
    vibe_coded_hints=$((vibe_coded_hints + 1))
    sus_phrases+=("corporate AI filler")
  fi

  if echo "$content" | grep -qiE 'game.changer|groundbreaking|innovative solution'; then
    vibe_coded_hints=$((vibe_coded_hints + 1))
    sus_phrases+=("marketing language")
  fi

  if echo "$content" | grep -qiE 'in conclusion|to summarize|in summary'; then
    vibe_coded_hints=$((vibe_coded_hints + 1))
    sus_phrases+=("summary phrases")
  fi

  if echo "$content" | grep -qiE 'not only.*but also|it'\''s not just about'; then
    vibe_coded_hints=$((vibe_coded_hints + 1))
    sus_phrases+=("negative parallelisms")
  fi

  if echo "$content" | grep -cE '^- \*\*[A-Z].*:\*\*' "$rfv_file" 2>/dev/null | grep -qE '^[3-9]|^[0-9]{2}'; then
    vibe_coded_hints=$((vibe_coded_hints + 1))
    sus_phrases+=("bolded inline-header list pattern")
  fi

  if [ "$vibe_coded_hints" -ge 3 ]; then
    NOTES+=("🤖 \`$rfv_file\`: **This RFV appears to have been vibe coded.** Detected: ${sus_phrases[*]}. The irony is noted. The RFV is still rejected.")
    ERRORS=$((ERRORS + 1))
  elif [ "$vibe_coded_hints" -ge 1 ]; then
    NOTES+=("🔍 \`$rfv_file\`: Mild AI scent detected (${sus_phrases[*]}). Could be coincidence. Could be vibes. Proceeding with caution.")
    WARNINGS=$((WARNINGS + 1))
  fi

  # ── Trigger check ───────────────────────────────────────────────

  if ! grep -qiE 'Trigger|condition|raised because|raised when' "$rfv_file"; then
    NOTES+=("⚠️  \`$rfv_file\`: No **trigger** documented. What prompted this RFV? Something must have felt off.")
    WARNINGS=$((WARNINGS + 1))
  fi

  # ── Outcome check ───────────────────────────────────────────────

  if ! grep -qiE 'Outcome|Result|Approved|Rejected|Pairing required' "$rfv_file"; then
    NOTES+=("⚠️  \`$rfv_file\`: No **outcome** section. An RFV without a resolution is just a complaint.")
    WARNINGS=$((WARNINGS + 1))
  fi

done < "$FILE_LIST"

# ── Determine overall status ──────────────────────────────────────

if [ "$ERRORS" -gt 0 ]; then
  if grep -qliE 'RFV-4|Critical' $(cat "$FILE_LIST") 2>/dev/null; then
    overall_status="CATASTROPHIC"
  else
    overall_status="OFF"
  fi
elif [ "$WARNINGS" -gt 2 ]; then
  overall_status="MIXED"
elif [ "$WARNINGS" -gt 0 ]; then
  overall_status="MOSTLY GOOD"
fi

# ── Build report ──────────────────────────────────────────────────

case "$overall_status" in
  "GOOD")          emoji="✅"; verdict="The vibes are good. Proceed." ;;
  "MOSTLY GOOD")   emoji="🟡"; verdict="The vibes are mostly good. Minor concerns noted." ;;
  "MIXED")         emoji="🟠"; verdict="The vibes are mixed. Review the warnings before merge." ;;
  "OFF")           emoji="🔴"; verdict="The vibes are off. Significant issues found." ;;
  "CATASTROPHIC")  emoji="💀"; verdict="The vibes are catastrophic. Earl Grey is offered but not enforced." ;;
esac

cat <<EOF
## $emoji Vibe Check Report

**VIBE STATUS: $overall_status**

$verdict

---

### Findings

EOF

for note in "${NOTES[@]}"; do
  echo "$note"
  echo ""
done

cat <<EOF
---

### Summary

| Metric | Count |
|---|---|
| Errors | $ERRORS |
| Warnings | $WARNINGS |
| Documents checked | $(wc -l < "$FILE_LIST" | tr -d ' ') |

---

*Automated vibe assessment by [RFV-CI](https://github.com/Request-For-Vibes/rfv). Part of the RFV-0001 standard.*
*Remember: a passing vibe check does not mean the code is good. It means someone understood it well enough to fill in the form.*
EOF
