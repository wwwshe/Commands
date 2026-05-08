#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

SOURCE_FILE="$REPO_ROOT/skill-list/skill-list.md"
REMOTE_SOURCE_URL="${COMMAND_SOURCE_URL:-https://raw.githubusercontent.com/wwwshe/Commands/main/skill-list/skill-list.md}"
TMP_SOURCE_FILE=""

if [[ ! -f "$SOURCE_FILE" ]]; then
  TMP_SOURCE_FILE="$(mktemp)"
  if ! curl -fsSL "$REMOTE_SOURCE_URL" -o "$TMP_SOURCE_FILE"; then
    echo "Error: source command file not found locally and remote download failed." >&2
    echo "Local: $SOURCE_FILE" >&2
    echo "Remote: $REMOTE_SOURCE_URL" >&2
    rm -f "$TMP_SOURCE_FILE"
    exit 1
  fi
  SOURCE_FILE="$TMP_SOURCE_FILE"
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
rm -f "$TMP_SOURCE_FILE"

echo "Installed: $TARGET_FILE"
echo "Done. You can run /skill-list in Cursor."
