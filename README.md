# Commands

Cursor용 커맨드 모음 저장소입니다.

## 포함된 커맨드

- `skill-list/skill-list.md`: `/skill-list`

## 설치

### 로컬 저장소에서 설치

#### Cursor

```bash
bash install.sh "$HOME/.cursor/commands"
```

#### Claude (예시 경로)

```bash
bash install.sh "$HOME/.claude/commands"
```

> Claude의 commands 디렉터리 경로는 사용 환경에 따라 다를 수 있습니다.
> 실제 사용하는 경로에 맞게 두 번째 인자를 변경해서 설치하세요.

### 대화형 설치(경로 직접 입력)

```bash
bash install.sh
```

설치 경로는 실행 중에 직접 입력합니다.

### 원격 저장소에서 원라인 설치

#### Cursor

```bash
curl -fsSL https://raw.githubusercontent.com/wwwshe/Commands/main/install.sh | bash -s -- "$HOME/.cursor/commands"
```

#### Claude (예시 경로)

```bash
curl -fsSL https://raw.githubusercontent.com/wwwshe/Commands/main/install.sh | bash -s -- "$HOME/.claude/commands"
```

원라인 설치 시 `install.sh`가 원격에서 `skill-list/skill-list.md`를 자동으로 내려받아 설치합니다.

## 제거

설치한 commands 경로에서 `skill-list.md` 파일을 직접 삭제하면 됩니다.

## 사용자 지정 경로

환경변수 `CURSOR_COMMANDS_DIR`로 설치 경로를 바꿀 수 있습니다.

```bash
CURSOR_COMMANDS_DIR="$HOME/.cursor/commands" bash install.sh
```

또는 인자로 경로를 넘길 수 있습니다.

```bash
bash install.sh "$HOME/.cursor/commands"
```

원격 소스 URL을 바꾸고 싶으면 `COMMAND_SOURCE_URL`을 지정할 수 있습니다.

```bash
COMMAND_SOURCE_URL="https://raw.githubusercontent.com/wwwshe/Commands/main/skill-list/skill-list.md" bash install.sh
```

