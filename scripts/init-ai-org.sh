#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/init-ai-org.sh [options]

Options:
  --destination PATH      Where to create AI_ORG (default: ./AI_ORG)
  --purpose TEXT         Purpose text used to replace [用途を書く]
  --preset NAME          minimal or development (default: minimal)
  --template-path PATH   Template source path for Runtime/CONTEXT_INDEX.md
  --dry-run              Show what would happen without writing files
  -h, --help             Show this help
EOF
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template_root="$(cd "$script_dir/.." && pwd)"
source_dir="$template_root/scaffold/AI_ORG"
destination="$(pwd)/AI_ORG"
purpose=""
preset="minimal"
template_path=""
dry_run=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --destination)
      [ "$#" -ge 2 ] || { echo "--destination requires a value" >&2; exit 2; }
      destination="$2"
      shift 2
      ;;
    --purpose)
      [ "$#" -ge 2 ] || { echo "--purpose requires a value" >&2; exit 2; }
      purpose="$2"
      shift 2
      ;;
    --preset)
      [ "$#" -ge 2 ] || { echo "--preset requires a value" >&2; exit 2; }
      preset="$2"
      shift 2
      ;;
    --template-path)
      [ "$#" -ge 2 ] || { echo "--template-path requires a value" >&2; exit 2; }
      template_path="$2"
      shift 2
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$preset" in
  minimal|development) ;;
  *)
    echo "Invalid preset: $preset" >&2
    exit 2
    ;;
esac

if [ ! -d "$source_dir" ]; then
  echo "Template scaffold not found: $source_dir" >&2
  exit 1
fi

if [ -z "$purpose" ] && [ "$dry_run" -eq 0 ]; then
  if [ -t 0 ]; then
    printf "Purpose for this AI_ORG: "
    IFS= read -r purpose
  fi
  if [ -z "$purpose" ]; then
    echo "Purpose is required for a real initialization. Pass --purpose or use --dry-run." >&2
    exit 1
  fi
fi

echo "AI_ORG initialization"
echo "  source:      $source_dir"
echo "  destination: $destination"
echo "  preset:      $preset"
[ -n "$purpose" ] && echo "  purpose:     $purpose"
[ -n "$template_path" ] && echo "  template:    $template_path"

if [ -e "$destination" ]; then
  echo "Destination already exists. Refusing to overwrite: $destination" >&2
  exit 1
fi

if [ "$preset" = "development" ]; then
  overlay="$template_root/presets/development/AI_ORG"
  if [ ! -d "$overlay" ]; then
    echo "Development preset overlay not found: $overlay" >&2
    exit 1
  fi
fi

file_count="$(find "$source_dir" -type f | wc -l | tr -d ' ')"
echo "  files:       $file_count"
find "$source_dir" -type f | sort | while IFS= read -r file; do
  relative="${file#"$source_dir"/}"
  echo "    $relative"
done

if [ "$dry_run" -eq 1 ]; then
  echo "Dry run only. No files were written."
  exit 0
fi

mkdir -p "$(dirname "$destination")"
cp -R "$source_dir" "$destination"

if [ "$preset" = "development" ]; then
  cp -R "$overlay"/. "$destination"/
fi

replace_text() {
  local file="$1"
  local from="$2"
  local to="$3"
  [ -f "$file" ] || return 0
  FROM_TEXT="$from" TO_TEXT="$to" perl -0pi -e 's/\Q$ENV{FROM_TEXT}\E/$ENV{TO_TEXT}/g' "$file"
}

[ -n "$purpose" ] && replace_text "$destination/MANIFEST.md" "[用途を書く]" "$purpose"

replace_exact_line() {
  local file="$1"
  local to="$2"
  [ -f "$file" ] || return 0
  TO_TEXT="$to" perl -0pi -e 's/^\[template path\]\r?$/$ENV{TO_TEXT}/m' "$file"
}

[ -n "$template_path" ] && replace_exact_line "$destination/Runtime/CONTEXT_INDEX.md" "$template_path"

if grep -Fq '[用途を書く]' "$destination/MANIFEST.md"; then
  echo "Required setup placeholder remains in copied MANIFEST.md." >&2
  exit 1
fi

echo "Created AI_ORG:"
find "$destination" -type f | sort | sed "s#^$destination/##" | sed 's#^#  #'
