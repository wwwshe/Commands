# Commands

Cursor용 커맨드 모음 저장소입니다.

## 포함된 커맨드

- `skill-list/skill-list.md`: `/skill-list`

## 설치

### 로컬 저장소에서 설치

```bash
bash install.sh
```

설치 경로는 실행 중에 직접 입력합니다.

### 원격 저장소에서 원라인 설치

```bash
curl -fsSL https://raw.githubusercontent.com/wwwshe/Commands/main/install.sh | bash
```

> 위 원라인 설치는 `install.sh`가 실행되는 위치에 `skill-list/skill-list.md`가 함께 있어야 정상 동작합니다.
> 즉, 단일 파일 파이프 실행보다는 레포 클론 후 `bash install.sh` 사용을 권장합니다.

## 제거

설치한 commands 경로에서 `skill-list.md` 파일을 직접 삭제하면 됩니다.

## 사용자 지정 경로

환경변수 `CURSOR_COMMANDS_DIR`로 설치 경로를 바꿀 수 있습니다.

```bash
CURSOR_COMMANDS_DIR="$HOME/.cursor/commands" bash install.sh
```

