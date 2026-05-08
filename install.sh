#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

SOURCE_FILE="$REPO_ROOT/skill-list/skill-list.md"

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Error: source command file not found: $SOURCE_FILE" >&2
  exit 1
fi

if [[ -n "${CURSOR_COMMANDS_DIR:-}" ]]; then
  TARGET_DIR="$CURSOR_COMMANDS_DIR"
else
  read -r -p "설치할 commands 디렉터리 경로를 입력하세요: " TARGET_DIR
fi

if [[ -z "${TARGET_DIR:-}" ]]; then
  echo "Error: target directory is required." >&2
  exit 1
fi

if [[ "$TARGET_DIR" == "~"* ]]; then
  TARGET_DIR="${TARGET_DIR/#\~/$HOME}"
fi

TARGET_FILE="$TARGET_DIR/skill-list.md"

mkdir -p "$TARGET_DIR"
cp "$SOURCE_FILE" "$TARGET_FILE"

echo "Installed: $TARGET_FILE"
echo "Done. You can run /skill-list in Cursor."
