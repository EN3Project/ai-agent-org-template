#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"
failures=0

error() {
  printf 'Error: %s\n' "$*" >&2
  failures=$((failures + 1))
}

required_files=(
  ".gitattributes"
  "README.md"
  "START_HERE.md"
  "AGENTS.md"
  "CLAUDE.md"
  "setup-decision-guide.md"
  "daily-use-minimal-kit.md"
  "scaffold/README.md"
  "scaffold/AI_ORG/MANIFEST.md"
  "scaffold/AI_ORG/orchestrator.md"
  "scaffold/AI_ORG/Agents/worker.md"
  "scaffold/AI_ORG/Agents/critic.md"
  "scaffold/AI_ORG/Workflows/execute.md"
  "scaffold/AI_ORG/Runtime/BOOT.md"
  "scaffold/AI_ORG/Runtime/CONTEXT_INDEX.md"
  "scaffold/AI_ORG/Runtime/OBSERVATIONS.md"
  "scaffold/AI_ORG/Runtime/HEALTH.md"
  "scaffold/AI_ORG/Scratch/README.md"
  "scaffold/AI_ORG/Reports/dispatch-trace.md"
  "scaffold/AI_ORG/Reports/health-check.md"
  "scaffold/AI_ORG/Decisions/ADR-template.md"
  "scaffold/AI_ORG/Vault/README.md"
  "scripts/init-ai-org.ps1"
  "scripts/init-ai-org.sh"
  "scripts/validate-template.ps1"
  "scripts/validate-template.sh"
)

for relative in "${required_files[@]}"; do
  path="$root/$relative"
  if [ ! -f "$path" ]; then
    error "Missing required file: $relative"
  elif [ ! -s "$path" ]; then
    error "Required file is empty: $relative"
  fi
done

validate_utf8() {
  local file="$1"
  perl -MEncode=decode,FB_CROAK -0777 -e 'decode("UTF-8", <>, FB_CROAK);' "$file" >/dev/null
}

check_markdown_links() {
  local file line target target_path candidate relative

  while IFS= read -r -d '' file; do
    relative="${file#"$root"/}"
    if ! validate_utf8 "$file"; then
      error "Invalid UTF-8: $relative"
      continue
    fi
    if grep -Fq 'CONDITIONAL PASS' "$file"; then
      error "Use machine-readable verdict enum CONDITIONAL_PASS, not CONDITIONAL PASS: $relative"
    fi
    if grep -Fq 'Workflows/OrgDesign.md' "$file"; then
      error "OrgDesign.md is a factory-side reference, not Workflows/OrgDesign.md: $relative"
    fi
    if grep -Fq 'Agents/org_designer.md' "$file"; then
      error "org_designer.md is a factory-side reference, not Agents/org_designer.md: $relative"
    fi

    while IFS=$'\t' read -r line target; do
      [ -n "${target:-}" ] || continue

      case "$target" in
        \#*|http://*|https://*|mailto:*|tel:*) continue ;;
      esac

      target_path="${target%%#*}"
      [ -n "$target_path" ] || continue
      target_path="${target_path//%20/ }"

      if [[ "$target_path" = /* ]]; then
        candidate="$target_path"
      else
        candidate="$(dirname "$file")/$target_path"
      fi

      if [ ! -e "$candidate" ]; then
        error "Broken markdown link in $relative: $target"
      fi
    done < <(perl -ne 'while (/(?<!!)\[[^\]]+\]\(([^)\s]+)(?:\s+"[^"]*")?\)/g) { print "$.\t$1\n" }' "$file")
  done < <(find "$root" -type f -name '*.md' -not -path '*/.git/*' -print0)
}

check_markdown_links

if [ -f "$root/AGENTS.md" ] && [ -f "$root/CLAUDE.md" ]; then
  if ! cmp -s <(tail -n +2 "$root/AGENTS.md") <(tail -n +2 "$root/CLAUDE.md"); then
    error "AGENTS.md and CLAUDE.md are out of sync except for the heading."
  fi
fi

manifest="$root/scaffold/AI_ORG/MANIFEST.md"
if [ -f "$manifest" ]; then
  purpose_count="$( (grep -F -o '[用途を書く]' "$manifest" || true) | wc -l | tr -d ' ' )"
  if [ "$purpose_count" != "1" ]; then
    error "scaffold/AI_ORG/MANIFEST.md must keep exactly one required purpose placeholder for initialization."
  fi
  if ! grep -Eq 'improvement_suggestions:[[:space:]]*end_of_task' "$manifest"; then
    error "MANIFEST default improvement_suggestions should be end_of_task."
  fi
  if ! grep -Eq 'health_check:[[:space:]]*manual' "$manifest"; then
    error "MANIFEST default health_check should be manual."
  fi
fi

context="$root/scaffold/AI_ORG/Runtime/CONTEXT_INDEX.md"
if [ -f "$context" ] && ! grep -Eq '^\[template path\]\r?$' "$context"; then
  error "Runtime/CONTEXT_INDEX.md must keep the optional template source codeblock line."
fi

development_manifest="$root/presets/development/AI_ORG/MANIFEST.md"
if [ -f "$development_manifest" ]; then
  purpose_count="$( (grep -F -o '[用途を書く]' "$development_manifest" || true) | wc -l | tr -d ' ' )"
  if [ "$purpose_count" != "1" ]; then
    error "Development preset MANIFEST.md must keep exactly one required purpose placeholder for initialization."
  fi
fi

temp_root="$(mktemp -d "${TMPDIR:-/tmp}/ai-org-template-validate.XXXXXX")"
cleanup() {
  case "$temp_root" in
    /tmp/ai-org-template-validate.*|*/Temp/ai-org-template-validate.*) rm -rf "$temp_root" ;;
  esac
}
trap cleanup EXIT

init_script="$root/scripts/init-ai-org.sh"
dry_parent="$temp_root/dry"
real_parent="$temp_root/real"
mkdir "$dry_parent" "$real_parent"

dry_destination="$dry_parent/AI_ORG"
bash "$init_script" \
  --destination "$dry_destination" \
  --purpose "validation dry run" \
  --template-path "$root" \
  --dry-run >/dev/null
if [ -e "$dry_destination" ]; then
  error "Init dry run created a destination directory."
fi

real_destination="$real_parent/AI_ORG"
bash "$init_script" \
  --destination "$real_destination" \
  --purpose "validation actual copy" \
  --template-path "$root" >/dev/null

copied_manifest="$real_destination/MANIFEST.md"
if [ ! -f "$copied_manifest" ]; then
  error "Init copy did not produce AI_ORG/MANIFEST.md."
else
  if grep -Fq '[用途を書く]' "$copied_manifest"; then
    error "Init copy left the required purpose placeholder in MANIFEST.md."
  fi
  if ! grep -Fq "validation actual copy" "$copied_manifest"; then
    error "Init copy did not write the supplied purpose to MANIFEST.md."
  fi
fi

copied_context="$real_destination/Runtime/CONTEXT_INDEX.md"
if [ -f "$copied_context" ]; then
  if grep -Eq '^\[template path\]\r?$' "$copied_context"; then
    error "Init copy left the optional template source codeblock line after --template-path was supplied."
  fi
  if ! grep -Fq "$root" "$copied_context"; then
    error "Init copy did not write the supplied template path to Runtime/CONTEXT_INDEX.md."
  fi
fi

if bash "$init_script" --destination "$real_destination" --purpose "overwrite attempt" >/dev/null 2>&1; then
  error "Init script allowed an existing destination to be reused."
fi

development_overlay="$root/presets/development/AI_ORG"
if [ -d "$development_overlay" ]; then
  development_destination="$temp_root/development/AI_ORG"
  mkdir -p "$(dirname "$development_destination")"
  bash "$init_script" \
    --preset development \
    --destination "$development_destination" \
    --purpose "validation development copy" \
    --template-path "$root" >/dev/null

  required_development_files=(
    "MANIFEST.md"
    "orchestrator.md"
    "Agents/architect.md"
    "Agents/developer.md"
    "Agents/worker.md"
    "Agents/critic.md"
    "Agents/tester.md"
    "Agents/reviewer.md"
    "Workflows/dev-cycle.md"
    "Workflows/execute.md"
    "Runtime/BOOT.md"
    "Runtime/CONTEXT_INDEX.md"
    "Runtime/HEALTH.md"
    "Reports/dispatch-trace.md"
    "Decisions/ADR-template.md"
    "Vault/README.md"
  )

  for relative in "${required_development_files[@]}"; do
    if [ ! -f "$development_destination/$relative" ]; then
      error "Development preset init did not produce required file: $relative"
    fi
  done

  development_copied_manifest="$development_destination/MANIFEST.md"
  if [ -f "$development_copied_manifest" ]; then
    if grep -Fq '[用途を書く]' "$development_copied_manifest"; then
      error "Development preset init left the required purpose placeholder in MANIFEST.md."
    fi
    if ! grep -Fq "validation development copy" "$development_copied_manifest"; then
      error "Development preset init did not write the supplied purpose to MANIFEST.md."
    fi
  fi
fi

if [ "$failures" -gt 0 ]; then
  printf 'Template validation failed with %s issue(s).\n' "$failures" >&2
  exit 1
fi

printf 'Template validation passed.\n'
