# /skill-list

현재 AI Agent 환경에서 사용 가능한 Skill 목록을 동적으로 수집해서 보여준다.

## 목적

- 기본: 현재 사용 중인 Agent의 Skill만 보여준다.
- 확장: `--all` 옵션이 있으면 전체 Agent(Cursor, Claude, Codex, Gemini)를 모두 보여준다.
- 출력: `--json` 옵션이 있으면 JSON 형식으로 출력한다.

## 입력 인자

사용자 입력에서 아래 인자를 해석한다.

- `--all`
- `--json`
- `--agent <cursor|claude|codex|gemini>`

입력 예시:

- `/skill-list`
- `/skill-list --all`
- `/skill-list --agent claude`
- `/skill-list --all --json`

## 실행 절차

1. 입력 파싱 우선순위
   - `--all`이 있으면 전체 Agent를 대상으로 수집
   - 그 외 `--agent`가 있으면 해당 Agent만 수집
   - 둘 다 없으면 현재 Agent 자동 감지(best effort) 시도

1-1. 자동 감지 판별 우선순위(중요)
   - **최우선: 호스트 앱/실행 환경**
     - Cursor IDE/Agent 환경에서 실행 중이면 현재 Agent를 `cursor`로 판정한다.
     - Claude Code 환경에서 실행 중이면 현재 Agent를 `claude`로 판정한다.
   - **차순위: 명시적 환경 신호**
     - 환경변수/실행 컨텍스트에 `AI_AGENT` 같은 명시 신호가 있으면 사용한다.
   - **최후순위: 추론**
     - 위 신호가 전혀 없을 때만 보조 추론을 사용한다.
   - **금지 규칙**
     - 모델 이름(예: Codex, GPT, Sonnet, Gemini)을 현재 Agent 판별 근거로 사용하지 않는다.
     - 즉, Cursor에서 Codex 모델을 쓰더라도 현재 Agent는 `cursor`다.

2. 자동 감지 실패 시
   - 실패 사실을 안내
   - `--agent` 사용 예시를 함께 보여준다.
   - 가능한 경우 `--all` 사용도 안내한다.

3. 부분 실패 허용
   - 특정 경로 접근 실패/미존재는 경고로 누적
   - 전체 요청은 가능한 계속 진행한다.

4. 실제 수집 방식
   - 각 대상 Agent별 경로 후보를 순회한다.
   - 각 경로 아래에서 `SKILL.md` 파일을 찾는다.
   - 찾은 `SKILL.md`의 상위 디렉터리를 Skill로 기록한다.
   - 가능한 경우 `SKILL.md`의 `name:`/`description:` 메타데이터를 읽어 표시한다.
   - 메타데이터가 없으면 디렉터리명을 `name`으로 사용한다.
   - 각 Skill에 대해 설명 1줄(`summary`)을 생성한다.
     - 우선순위 1: frontmatter `description:`
     - 우선순위 2: 본문 첫 문장
     - 우선순위 3: `"설명 없음"`

## 플랫폼별 스캔 경로

아래 경로들을 대상으로 `SKILL.md` 파일을 탐색한다.

- Cursor
  - `~/.cursor/skills`
  - `~/.cursor/skills-cursor`
  - `~/.cursor/plugins/cache/cursor-public`

- Claude
  - `~/.claude/skills`

- Codex
  - `~/.codex/skills`

- Gemini
  - `~/.gemini/skills`

`SKILL.md`를 찾으면 해당 파일의 상위 디렉터리를 하나의 Skill로 간주한다.

## 출력 포맷

### 기본 텍스트 출력

- 단일 Agent 모드:
  - Agent 이름
  - Skill 개수
  - Skill 목록(이름, 설명 1줄, 경로)

- `--all` 모드:
  - Agent별 섹션으로 분리해 출력
  - 각 섹션에 개수/목록 표시

- 경고가 있으면 마지막에 `warnings` 섹션으로 출력
- 각 Agent 섹션 출력 예시:

```text
[cursor] 3 skills
- python - Python 비동기/타입힌트 패턴 안내 (/Users/me/.cursor/skills/python)
- create-rule - Cursor 룰 파일 생성/관리 (/Users/me/.cursor/skills-cursor/create-rule)

warnings:
- codex: /Users/me/.codex/skills 경로를 찾지 못함
```

### JSON 출력 (`--json`)

아래 구조를 따른다.

```json
{
  "results": [
    {
      "agent": "cursor",
      "skills": [
        {
          "name": "python",
          "summary": "Python 비동기/타입힌트 패턴 안내",
          "path": "/Users/me/.cursor/skills/python",
          "source": "user"
        }
      ],
      "warnings": []
    }
  ],
  "warnings": []
}
```

## Skill 정규화 규칙

- `name`: Skill 디렉터리명
- `path`: Skill 디렉터리 절대경로
- `summary`: Skill 설명 1줄 (`description` 우선, 없으면 본문 첫 문장)
- `source`:
  - 경로에 `/plugins/`가 포함되면 `plugin`
  - 경로에 `/.cursor/skills` 또는 `/.claude/skills` 등이면 `user`
  - 분류 불가 시 `unknown`
- 중복 제거 기준: `name + path`
- 정렬: `name` 오름차순

## 응답 스타일

- 한국어로 간결하게 답변
- 결과가 0건이어도 정상 케이스로 처리
- 실패를 "명령 실패"로 과장하지 말고, 감지/경로 상태를 분리해서 안내
- 사용자가 후속 액션을 바로 취할 수 있게 실행 예시를 함께 제시

## 후속 안내 템플릿

자동 감지 실패 시 아래 형식으로 안내한다.

```text
현재 Agent를 자동으로 감지하지 못했습니다.
아래처럼 명시해서 다시 실행해주세요:
- /skill-list --agent cursor
- /skill-list --agent claude

또는 전체 조회:
- /skill-list --all
```

