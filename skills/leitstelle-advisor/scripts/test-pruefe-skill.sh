#!/usr/bin/env bash
# Tests für pruefe-skill.sh. Jeder Fall baut einen eigenen Fixture-Ordner unter einem mktemp-Ordner.
set -u

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CHECKER="$SCRIPT_DIR/pruefe-skill.sh"
readonly FENCE='```'

base_dir="$(mktemp -d)" || exit 1
passed=0
total=0

remove_base_dir() {
  # Löscht nur den eigenen mktemp-Ordner, nie einen leeren oder fremden Pfad.
  case "$base_dir" in
    "${TMPDIR:-/tmp}"/tmp.* | "${TMPDIR%/}"/tmp.*) rm -rf "$base_dir" ;;
  esac
}
trap remove_base_dir EXIT

write_fixture() {
  local case_dir="$1" relative_path="$2" content="$3"
  mkdir -p "$(dirname "$case_dir/$relative_path")"
  printf '%s\n' "$content" > "$case_dir/$relative_path"
}

expect_result() {
  local case_name="$1" folder_arg="$2" expected_exit="$3" expected_output="$4"
  local actual_output actual_exit
  total=$((total + 1))
  actual_output="$(bash "$CHECKER" "$folder_arg" 2>&1)"
  actual_exit=$?
  if [ "$actual_exit" -eq "$expected_exit" ] && [ "$actual_output" = "$expected_output" ]; then
    passed=$((passed + 1))
    echo "PASS $case_name"
  else
    echo "FAIL $case_name: exit $actual_exit (erwartet $expected_exit), Ausgabe: '$actual_output' (erwartet '$expected_output')"
  fi
}

test_clean_folder() {
  local dir="$base_dir/clean"
  write_fixture "$dir" "SKILL.md" "Ein sauberer Text ohne Einschub."
  write_fixture "$dir" "references/nachrichten.md" "$(printf '## Frage\n\n%stext\nADVISOR-FRAGE F-S1-01\n%s' "$FENCE" "$FENCE")"
  expect_result test_clean_folder "$dir" 0 ""
}

test_dash_aside() {
  local dir="$base_dir/dash"
  write_fixture "$dir" "SKILL.md" "$(printf 'Zeile eins\nZeile zwei\nDas ist – wie gesagt – falsch.')"
  expect_result test_dash_aside "$dir" 1 "SKILL.md:3: strich"
}

test_dash_with_space_after_only() {
  local dir="$base_dir/space-after"
  write_fixture "$dir" "SKILL.md" "Ein Wort– danach weiter."
  expect_result test_dash_with_space_after_only "$dir" 1 "SKILL.md:1: strich"
}

test_dash_at_line_end() {
  local dir="$base_dir/line-end"
  write_fixture "$dir" "SKILL.md" "Am Ende kommt –"
  expect_result test_dash_at_line_end "$dir" 1 "SKILL.md:1: strich"
}

test_em_dash_without_spaces() {
  local dir="$base_dir/em-dash"
  write_fixture "$dir" "SKILL.md" "$(printf 'Zeile eins\nWort—Wort')"
  expect_result test_em_dash_without_spaces "$dir" 1 "SKILL.md:2: strich"
}

test_empty_table_cell() {
  local dir="$base_dir/table"
  write_fixture "$dir" "SKILL.md" "$(printf '| a | b | c |\n|---|---|---|\n| a | – | b |\n| x | — | y |')"
  expect_result test_empty_table_cell "$dir" 0 ""
}

test_number_range() {
  local dir="$base_dir/range"
  write_fixture "$dir" "SKILL.md" "Schreib 2–5 Zeilen."
  expect_result test_number_range "$dir" 0 ""
}

test_format_outside_owner() {
  local dir="$base_dir/format-outside"
  write_fixture "$dir" "references/session.md" "$(printf '# Session\n\nFormat:\n%stext\nADVISOR-FRAGE F-S1-01\n%s' "$FENCE" "$FENCE")"
  expect_result test_format_outside_owner "$dir" 1 "references/session.md:5: format"
}

test_indented_fence_without_language() {
  local dir="$base_dir/indented"
  write_fixture "$dir" "references/advisor.md" "$(printf -- '- Antwort:\n   %s\nADVISOR-ANTWORT F-S1-01: x\n   %s' "$FENCE" "$FENCE")"
  expect_result test_indented_fence_without_language "$dir" 1 "references/advisor.md:3: format"
}

test_scripts_excluded() {
  local dir="$base_dir/scripts"
  write_fixture "$dir" "scripts/x.sh" "Das ist – falsch."
  write_fixture "$dir" "SKILL.md" "Sauber."
  expect_result test_scripts_excluded "$dir" 0 ""
}

test_trailing_slash() {
  local dir="$base_dir/trailing-slash"
  write_fixture "$dir" "SKILL.md" "$(printf 'Zeile eins\nZeile zwei\nDas ist – wie gesagt – falsch.')"
  expect_result test_trailing_slash "$dir/" 1 "SKILL.md:3: strich"
}

test_double_trailing_slash() {
  local dir="$base_dir/double-slash"
  write_fixture "$dir" "SKILL.md" "$(printf 'Zeile eins\nZeile zwei\nDas ist – wie gesagt – falsch.')"
  expect_result test_double_trailing_slash "$dir//" 1 "SKILL.md:3: strich"
}

test_blank_line_before_format() {
  local dir="$base_dir/blank-line"
  write_fixture "$dir" "references/session.md" "$(printf '%stext\n\nADVISOR-FRAGE F-S1-01\n%s' "$FENCE" "$FENCE")"
  expect_result test_blank_line_before_format "$dir" 1 "references/session.md:3: format"
}

test_folder_without_markdown() {
  local dir="$base_dir/no-markdown"
  write_fixture "$dir" "scripts/x.sh" "echo"
  expect_result test_folder_without_markdown "$dir" 2 "Keine Markdown-Datei in $dir"
}

test_missing_folder() {
  expect_result test_missing_folder "$base_dir/does-not-exist" 2 "Ordner fehlt: $base_dir/does-not-exist"
}

test_clean_folder
test_dash_aside
test_dash_with_space_after_only
test_double_trailing_slash
test_blank_line_before_format
test_folder_without_markdown
test_missing_folder
test_dash_at_line_end
test_em_dash_without_spaces
test_empty_table_cell
test_number_range
test_format_outside_owner
test_indented_fence_without_language
test_scripts_excluded
test_trailing_slash

echo "$passed/$total bestanden"
[ "$passed" -eq "$total" ]
