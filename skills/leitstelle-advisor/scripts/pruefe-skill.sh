#!/usr/bin/env bash
# Prüft die Markdown-Dateien eines Skill-Ordners auf zwei Regeln:
#   strich: kein Gedankenstrich als Einschub (leere Tabellenzellen und 2–5 ohne Leerzeichen sind erlaubt)
#   format: Format-Codeblöcke mit erster Zeile ADVISOR- stehen nur in references/nachrichten.md
# Ausgabe je Verstoß: <datei>:<zeile>: <regel>. Exit 1 bei mindestens einem Verstoß.
set -u

readonly FORMAT_OWNER="references/nachrichten.md"

usage_error() {
  echo "Aufruf: pruefe-skill.sh <skill-ordner>" >&2
  exit 2
}

collect_markdown_files() {
  local root="$1"
  find "$root" -type f -name '*.md' -print0 | sort -z
}

check_files() {
  local prefix="$1"
  shift
  awk -v prefix="$prefix" -v owner="$FORMAT_OWNER" '
    function strip_empty_cells(text) {
      while (sub(/\| *— *\|/, "| |", text) || sub(/\| *– *\|/, "| |", text)) {}
      return text
    }
    function has_dash_aside(text) {
      return index(text, "—") > 0 || text ~ / –/ || text ~ /– /
    }
    function report(rule) {
      print substr(FILENAME, length(prefix) + 1) ":" FNR ": " rule
      violations++
    }
    FNR == 1 { in_block = 0; awaiting_first_line = 0 }
    has_dash_aside(strip_empty_cells($0)) { report("strich") }
    /^[ \t]*(```|~~~)/ {
      in_block = !in_block
      awaiting_first_line = in_block
      next
    }
    awaiting_first_line && /^[ \t]*$/ { next }
    awaiting_first_line {
      awaiting_first_line = 0
      relative_name = substr(FILENAME, length(prefix) + 1)
      if ($0 ~ /^[ \t]*ADVISOR-/ && relative_name != owner) { report("format") }
    }
    END { exit violations > 0 ? 1 : 0 }
  ' "$@"
}

fail() {
  echo "$1" >&2
  exit 2
}

strip_trailing_slashes() {
  local path="$1"
  while [ "${path%/}" != "$path" ] && [ "$path" != "/" ]; do
    path="${path%/}"
  done
  printf '%s' "$path"
}

main() {
  [ $# -eq 1 ] || usage_error
  [ -d "$1" ] || fail "Ordner fehlt: $1"
  local root
  root="$(strip_trailing_slashes "$1")"
  local files=()
  local file
  while IFS= read -r -d '' file; do
    files+=("$file")
  done < <(collect_markdown_files "$root")
  [ ${#files[@]} -gt 0 ] || fail "Keine Markdown-Datei in $root"
  check_files "$root/" "${files[@]}"
}

main "$@"
