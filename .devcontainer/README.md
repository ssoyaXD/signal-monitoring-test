# 개발 컨테이너 (Dev Container)

이 디렉토리는 VS Code Dev Containers를 위한 설정 파일들을 포함하고 있습니다.

## 🚀 빠른 시작

### 사전 요구사항

1. **VS Code** 설치
2. **Docker Desktop** 설치 및 실행
3. **Dev Containers 확장** 설치
   - VS Code에서 `ms-vscode-remote.remote-containers` 확장 설치

### 사용 방법

1. VS Code에서 프로젝트 폴더를 엽니다
2. 명령 팔레트 열기 (`Ctrl+Shift+P` 또는 `Cmd+Shift+P`)
3. `Dev Containers: Reopen in Container` 선택
4. 컨테이너가 빌드되고 시작될 때까지 기다립니다

## 📦 포함된 기능

### 개발 도구
- **Node.js 20**: 최신 LTS 버전
- **pnpm**: 패키지 매니저 (latest)
- **Git**: 버전 관리
- **Docker-in-Docker**: 컨테이너 내에서 Docker 명령어 사용 가능
- **Zsh + Oh My Zsh**: 향상된 쉘 환경

### VS Code 확장 프로그램
자동으로 설치되는 확장 프로그램:
- ESLint
- Prettier
- Tailwind CSS IntelliSense
- Docker
- GitLens
- Git Graph
- Path Intellisense
- Error Lens
- EditorConfig

### 포트 포워딩
자동으로 포워딩되는 포트:
- **3000**: Next.js Frontend
- **4000**: NestJS Backend
- **9090**: Prometheus
- **3001**: Grafana

## 🔧 개발 시작하기

컨테이너에서 다음 명령어를 사용할 수 있습니다:

```bash
# 의존성은 자동으로 설치되지만, 수동으로도 가능합니다
pnpm install

# 개발 서버 실행
pnpm dev

# 또는 개별 실행
pnpm dev:frontend
pnpm dev:backend

# Docker Compose로 전체 스택 실행
pnpm docker:up

# Docker 로그 확인
pnpm docker:logs

# Docker 중지
pnpm docker:down
```

## 🐳 Docker-in-Docker

이 개발 컨테이너는 Docker-in-Docker를 지원합니다. 즉, 컨테이너 내부에서도 Docker 명령어를 사용할 수 있습니다:

```bash
# Docker 버전 확인
docker --version

# Docker Compose 버전 확인
docker-compose --version

# 프로젝트의 Docker Compose 실행
docker-compose up -d
```

## 📂 볼륨 마운트

다음 디렉토리들이 마운트됩니다:
- 프로젝트 루트 → `/workspace`
- pnpm 캐시 (성능 향상을 위해)
- Git 설정 (호스트의 설정 사용)

## ⚙️ 커스터마이징

### 추가 VS Code 확장 설치

`.devcontainer/devcontainer.json` 파일의 `extensions` 배열에 확장 ID를 추가하세요:

```json
"extensions": [
  "existing.extension",
  "new.extension-id"
]
```

### 추가 포트 포워딩

`.devcontainer/devcontainer.json` 파일의 `forwardPorts` 배열에 포트를 추가하세요:

```json
"forwardPorts": [3000, 4000, 9090, 3001, 5000]
```

### 환경 변수 추가

`.devcontainer/docker-compose.yml` 파일의 `environment` 섹션에 추가하세요:

```yaml
environment:
  - NODE_ENV=development
  - CUSTOM_VAR=value
```

## 🔍 문제 해결

### 컨테이너가 시작되지 않는 경우

1. Docker Desktop이 실행 중인지 확인
2. VS Code를 재시작
3. 명령 팔레트에서 `Dev Containers: Rebuild Container` 실행

### pnpm이 작동하지 않는 경우

```bash
# pnpm 재설치
corepack enable
corepack prepare pnpm@latest --activate
```

### Docker 명령어가 작동하지 않는 경우

Docker Desktop이 실행 중인지 확인하고, 컨테이너를 다시 빌드하세요:
- 명령 팔레트: `Dev Containers: Rebuild Container`

## 📚 추가 리소스

- [VS Code Dev Containers 문서](https://code.visualstudio.com/docs/devcontainers/containers)
- [Dev Containers 스펙](https://containers.dev/)
- [Docker-in-Docker 기능](https://github.com/devcontainers/features/tree/main/src/docker-in-docker)

