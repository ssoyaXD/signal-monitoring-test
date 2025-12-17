# 빠른 시작 가이드 🚀

## 방법 1: Docker Compose 사용 (가장 간단!)

```bash
# Docker Compose로 전체 스택 실행
docker-compose up -d

# 또는
pnpm docker:up
```

완료! 다음 URL로 접속하세요:
- Frontend: http://localhost:3000
- Backend: http://localhost:4000
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3001 (admin/admin)

## 방법 2: pnpm으로 로컬 개발

### 1단계: pnpm 설치 (아직 없다면)

```bash
npm install -g pnpm
```

### 2단계: 의존성 설치

```bash
pnpm install
```

pnpm workspace가 자동으로 `backend`와 `frontend`의 모든 의존성을 설치합니다.

### 3단계: 개발 서버 실행

```bash
# Frontend와 Backend를 동시에 실행
pnpm dev
```

또는 개별 실행:

```bash
# 터미널 1: Backend 실행
pnpm dev:backend

# 터미널 2: Frontend 실행
pnpm dev:frontend
```

### 4단계: Prometheus와 Grafana는 Docker로 실행

로컬 개발 시 모니터링 도구들만 Docker로 실행:

```bash
# docker-compose.yml에서 backend와 frontend를 주석 처리하고
docker-compose up -d prometheus grafana
```

## pnpm workspace 장점

✅ **한 번에 설치**: 루트에서 `pnpm install` 한 번이면 모든 패키지 설치  
✅ **디스크 효율**: 공통 의존성은 한 번만 저장  
✅ **빠른 속도**: npm/yarn보다 3배 빠른 설치 속도  
✅ **통합 관리**: 루트에서 모든 스크립트 실행 가능  
✅ **타입 안정성**: workspace 간 타입 공유 가능

## 자주 사용하는 명령어

```bash
# 개발
pnpm dev                 # 전체 개발 모드
pnpm dev:frontend        # Frontend만
pnpm dev:backend         # Backend만

# 빌드
pnpm build               # 전체 빌드
pnpm build:frontend      # Frontend만
pnpm build:backend       # Backend만

# Docker
pnpm docker:up           # 시작
pnpm docker:down         # 중지
pnpm docker:logs         # 로그 보기
pnpm docker:rebuild      # 재빌드

# 패키지 추가
pnpm --filter backend add express
pnpm --filter frontend add axios
pnpm --filter backend add -D @types/express

# 정리
pnpm clean               # 빌드 파일 삭제
```

## 테스트 시나리오

1. **Frontend 접속**: http://localhost:3000
2. **버튼 클릭**: API 호출 여러 번 실행
3. **Prometheus 확인**: http://localhost:9090
   - 검색: `api_calls_total`
4. **Grafana 확인**: http://localhost:3001
   - 로그인: admin/admin
   - 대시보드에서 실시간 차트 확인

## 문제 해결

### pnpm을 찾을 수 없다고 나올 때
```bash
npm install -g pnpm
```

### 포트가 이미 사용 중일 때
`docker-compose.yml`에서 포트 변경

### 캐시 문제
```bash
pnpm store prune
pnpm install
```

### Docker 재빌드
```bash
docker-compose down -v
docker-compose up -d --build
```

즐거운 개발 되세요! 🎉

