# 모니터링 테스트 프로젝트 📊

Next.js, Nest.js, Prometheus, Grafana를 사용한 간단한 모니터링 테스트 환경입니다.

> 💡 **빠르게 시작하고 싶다면?** [QUICK_START.md](./QUICK_START.md)를 확인하세요!

## 🛠️ 기술 스택

- **Frontend**: Next.js 14 (TypeScript)
- **Backend**: Nest.js 10 (TypeScript)
- **Monitoring**: Prometheus + Grafana
- **Package Manager**: pnpm (workspace)
- **Containerization**: Docker & Docker Compose

## 📋 프로젝트 구조

```
signal-monitoring-test/
├── backend/                    # Nest.js 백엔드
│   ├── src/
│   │   ├── metrics/           # Prometheus 메트릭 모듈
│   │   ├── app.module.ts
│   │   ├── app.controller.ts
│   │   ├── app.service.ts
│   │   └── main.ts
│   ├── Dockerfile
│   └── package.json
├── frontend/                   # Next.js 프론트엔드
│   ├── app/
│   │   ├── page.tsx           # 메인 페이지
│   │   ├── layout.tsx
│   │   └── globals.css
│   ├── Dockerfile
│   └── package.json
├── prometheus/                 # Prometheus 설정
│   └── prometheus.yml
├── grafana/                    # Grafana 설정
│   └── provisioning/
│       ├── datasources/       # 데이터소스 설정
│       └── dashboards/        # 대시보드 설정
├── pnpm-workspace.yaml        # pnpm workspace 설정
├── package.json               # 루트 package.json (모노레포)
├── .npmrc                     # pnpm 설정
├── docker-compose.yml
└── README.md
```

## 🚀 실행 방법

### 1. 사전 요구사항

- Docker 및 Docker Compose 설치
- Node.js 20+ (로컬 개발 시)
- pnpm 8+ (로컬 개발 시)

### 2-1. Docker Compose로 전체 스택 실행 (추천)

```bash
# 프로젝트 루트 디렉토리에서 실행
docker-compose up -d

# 또는 pnpm 스크립트 사용
pnpm docker:up
```

### 2-2. 로컬 개발 환경 실행 (pnpm workspace)

```bash
# 1. 모든 의존성 설치
pnpm install

# 2. 개발 서버 실행 (frontend + backend 동시 실행)
pnpm dev

# 또는 개별 실행
pnpm dev:frontend  # Frontend만 실행
pnpm dev:backend   # Backend만 실행
```

**주의**: 로컬 개발 시에는 Prometheus와 Grafana를 별도로 실행해야 합니다.

### 3. 서비스 접속

실행 후 다음 URL로 접속할 수 있습니다:

- **Frontend (Next.js)**: http://localhost:3000
- **Backend (Nest.js)**: http://localhost:4000
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001
  - 기본 로그인 정보: `admin` / `admin`

## 🎯 사용 방법

### 1. Frontend에서 API 테스트

1. http://localhost:3000 접속
2. 페이지의 버튼들을 클릭하여 API 호출
   - **Hello API 호출**: 간단한 인사 메시지 반환
   - **Test API 호출**: 랜덤하게 성공/실패 응답 (메트릭 수집용)
   - **Data API 호출**: 랜덤 숫자 생성 (메트릭 수집용)

### 2. Prometheus에서 메트릭 확인

1. http://localhost:9090 접속
2. 상단 검색창에서 다음 메트릭 조회:
   - `api_calls_total`: 총 API 호출 횟수 (엔드포인트별)
   - `api_success_total`: 성공한 API 호출 횟수
   - `api_errors_total`: 실패한 API 호출 횟수
   - `random_value`: Data API가 생성한 랜덤 값
   - `process_cpu_user_seconds_total`: CPU 사용 시간
   - `process_resident_memory_bytes`: 메모리 사용량

### 3. Grafana에서 대시보드 확인

1. http://localhost:3001 접속
2. `admin` / `admin`으로 로그인
3. 좌측 메뉴에서 "Dashboards" 선택
4. "NestJS 모니터링 대시보드" 선택
5. 실시간으로 업데이트되는 차트 확인:
   - API 호출 속도 (엔드포인트별)
   - 총 API 호출 횟수
   - API 성공/에러 비율
   - 랜덤 값 변화
   - CPU 사용률
   - 메모리 사용량

## 📊 수집되는 메트릭

### 커스텀 메트릭

- `api_calls_total{endpoint}`: 각 API 엔드포인트의 호출 횟수
- `api_success_total`: 성공한 API 요청 수
- `api_errors_total`: 실패한 API 요청 수
- `random_value`: Data API에서 생성한 랜덤 값 (0-100)

### 기본 메트릭 (Node.js)

- `process_cpu_user_seconds_total`: CPU 사용 시간
- `process_resident_memory_bytes`: 메모리 사용량
- `nodejs_eventloop_lag_seconds`: 이벤트 루프 지연
- 기타 Node.js 프로세스 메트릭

## 🛑 중지 방법

```bash
# 모든 컨테이너 중지 및 제거
docker-compose down
# 또는
pnpm docker:down

# 볼륨까지 함께 제거 (데이터 초기화)
docker-compose down -v
```

## 🔧 pnpm 명령어

이 프로젝트는 pnpm workspace를 사용합니다. 루트에서 다음 명령어를 사용할 수 있습니다:

### 개발

```bash
pnpm install           # 모든 의존성 설치
pnpm dev              # Frontend + Backend 동시 개발 모드 실행
pnpm dev:frontend     # Frontend만 개발 모드 실행
pnpm dev:backend      # Backend만 개발 모드 실행
```

### 빌드

```bash
pnpm build            # 전체 프로젝트 빌드
pnpm build:frontend   # Frontend만 빌드
pnpm build:backend    # Backend만 빌드
```

### 프로덕션 실행

```bash
pnpm start            # Frontend + Backend 동시 실행
pnpm start:frontend   # Frontend만 실행
pnpm start:backend    # Backend만 실행
```

### Docker 관리

```bash
pnpm docker:up        # Docker Compose 시작
pnpm docker:down      # Docker Compose 중지
pnpm docker:logs      # 로그 확인
pnpm docker:rebuild   # 재빌드 후 시작
```

### 정리

```bash
pnpm clean            # 빌드 결과물 삭제
```

### 특정 패키지에 의존성 추가

```bash
# Backend에 패키지 추가
pnpm --filter backend add [package-name]

# Frontend에 패키지 추가
pnpm --filter frontend add [package-name]

# Dev 의존성 추가
pnpm --filter backend add -D [package-name]
```

## 📝 API 엔드포인트

### Backend (http://localhost:4000)

- `GET /api/hello`: 인사 메시지 반환
- `POST /api/test`: 테스트 API (랜덤 성공/실패)
- `GET /api/data`: 랜덤 데이터 생성
- `GET /metrics`: Prometheus 메트릭 엔드포인트

## 🎨 커스터마이징

### 메트릭 추가

`backend/src/metrics/metrics.service.ts` 파일에서 새로운 메트릭을 추가할 수 있습니다.

### 대시보드 수정

1. Grafana UI에서 대시보드 편집
2. 저장 후 JSON 내보내기
3. `grafana/provisioning/dashboards/nestjs-dashboard.json` 파일 업데이트

### Prometheus 스크래핑 간격 변경

`prometheus/prometheus.yml` 파일에서 `scrape_interval` 값을 조정합니다.

## 🐛 문제 해결

### 컨테이너가 시작되지 않는 경우

```bash
# 로그 확인
docker-compose logs -f

# 특정 서비스 로그만 확인
docker-compose logs -f backend
```

### 포트가 이미 사용 중인 경우

`docker-compose.yml`에서 포트 매핑을 변경합니다:

```yaml
ports:
  - "다른포트:3000"  # 예: 3001:3000
```

### Grafana에 데이터가 표시되지 않는 경우

1. Prometheus가 정상 작동하는지 확인: http://localhost:9090
2. Prometheus에서 메트릭이 수집되는지 확인
3. Frontend에서 API를 여러 번 호출하여 데이터 생성

## 📚 추가 학습 자료

- [Prometheus 문서](https://prometheus.io/docs/)
- [Grafana 문서](https://grafana.com/docs/)
- [Next.js 문서](https://nextjs.org/docs)
- [Nest.js 문서](https://docs.nestjs.com/)
- [prom-client (Node.js Prometheus 클라이언트)](https://github.com/siimon/prom-client)
- [pnpm 문서](https://pnpm.io/)
- [pnpm workspace](https://pnpm.io/workspaces)

## 📄 라이선스

MIT License

## 🤝 기여

이슈나 풀 리퀘스트는 언제든지 환영합니다!

---

**즐거운 모니터링 테스트 되세요! 🎉**

