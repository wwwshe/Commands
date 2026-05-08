#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${BASH_SOURCE[0]-}" ]]; then
  SCRIPT_SOURCE="${BASH_SOURCE[0]}"
else
  SCRIPT_SOURCE="$0"
fi

SCRIPT_DIR=""
if [[ "$SCRIPT_SOURCE" != "bash" && "$SCRIPT_SOURCE" != "-bash" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd)"
fi

REMOTE_SOURCE_URL="${COMMAND_SOURCE_URL:-https://raw.githubusercontent.com/wwwshe/Commands/main/skill-list/skill-list.md}"
TMP_SOURCE_FILE=""
SOURCE_FILE=""

if [[ -n "$SCRIPT_DIR" ]]; then
  LOCAL_SOURCE_FILE="$SCRIPT_DIR/skill-list/skill-list.md"
  if [[ -f "$LOCAL_SOURCE_FILE" ]]; then
    SOURCE_FILE="$LOCAL_SOURCE_FILE"
  fi
fi

if [[ -z "$SOURCE_FILE" ]]; then
  TMP_SOURCE_FILE="$(mktemp)"
  if ! curl -fsSL "$REMOTE_SOURCE_URL" -o "$TMP_SOURCE_FILE"; then
    echo "Error: source command file download failed." >&2
    if [[ -n "${LOCAL_SOURCE_FILE:-}" ]]; then
      echo "Local: $LOCAL_SOURCE_FILE" >&2
    fi
    echo "Remote: $REMOTE_SOURCE_URL" >&2
    rm -f "$TMP_SOURCE_FILE"
    exit 1
  fi
  SOURCE_FILE="$TMP_SOURCE_FILE"
fi

if [[ -n "${CURSOR_COMMANDS_DIR:-}" ]]; then
  TARGET_DIR="$CURSOR_COMMANDS_DIR"
elif [[ -n "${1:-}" ]]; then
  TARGET_DIR="$1"
else
  if [[ -t 0 ]]; then
    read -r -p "설치할 commands 디렉터리 경로를 입력하세요: " TARGET_DIR
  else
    echo "Error: target directory is required in non-interactive mode." >&2
    echo "Use one of:" >&2
    echo "  CURSOR_COMMANDS_DIR=\"\$HOME/.cursor/commands\" bash install.sh" >&2
    echo "  curl -fsSL <install.sh URL> | bash -s -- \"\$HOME/.cursor/commands\"" >&2
    exit 1
  fi
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
