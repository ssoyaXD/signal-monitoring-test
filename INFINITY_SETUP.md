# Infinity 데이터소스 네비게이션 설정 가이드

## ✅ 완료된 작업

1. **Infinity 플러그인 설치 완료**
   - 플러그인: `yesoreyeram-infinity-datasource` v3.6.0
   - 설치 위치: `/var/lib/grafana/plugins/yesoreyeram-infinity-datasource`

2. **데이터소스 프로비저닝 설정**
   - 파일: `grafana-provisioning/datasources/infinity.yml`
   - 자동으로 Infinity 데이터소스가 생성됩니다

3. **네비게이션 대시보드 생성**
   - 파일: `infinity-navigation-dashboard.json`
   - Infinity 데이터소스를 사용하여 설비 계층 구조를 표시

## 📋 사용 방법

### 1. Grafana 접속
```
http://localhost:3000
```
- Username: `admin`
- Password: `admin`

### 2. 데이터소스 확인
- **Configuration → Data Sources**에서 "Infinity" 데이터소스가 생성되어 있는지 확인
- PostgreSQL 연결 설정이 필요할 수 있습니다

### 3. 대시보드 Import
1. **Dashboards → Import** 클릭
2. `infinity-navigation-dashboard.json` 파일 업로드
3. 또는 대시보드를 `grafana-provisioning/dashboards/` 폴더에 복사하여 자동 프로비저닝

### 4. Infinity 데이터소스 설정 (PostgreSQL 연결)

Infinity 데이터소스에서 PostgreSQL을 사용하려면:

1. **Configuration → Data Sources → Infinity** 클릭
2. **Query Type**을 **PostgreSQL**로 선택
3. PostgreSQL 연결 정보 입력:
   - Host: `postgres` (Docker 네트워크 내)
   - Port: `5432`
   - Database: `vibration_db`
   - Username: `postgres`
   - Password: `postgres`
   - SSL Mode: `disable`

### 5. 대시보드 사용

대시보드에는 다음 패널이 포함되어 있습니다:

1. **Infinity 데이터소스 네비게이션 테이블**
   - 설비 계층 구조를 트리 형태로 표시
   - 계층별 색상 구분
   - 클릭 가능한 대시보드 링크

2. **계층별 설비 수 (Bar Gauge)**
   - PostgreSQL 쿼리를 사용하여 통계 표시

3. **계층별 통계 (JSON 예제)**
   - Infinity의 JSON 인라인 기능 예제

## 🔧 Infinity 데이터소스의 주요 기능

Infinity 데이터소스는 다음 데이터 소스를 지원합니다:

1. **PostgreSQL** - SQL 쿼리 실행
2. **JSON** - 인라인, URL, 파일
3. **CSV** - 인라인, URL, 파일
4. **REST API** - HTTP 엔드포인트
5. **GraphQL** - GraphQL 쿼리

## 📝 참고사항

- Infinity 플러그인은 Docker Compose 재시작 시 자동으로 설치됩니다 (환경 변수 설정)
- PostgreSQL 연결은 Docker 네트워크 내에서 `postgres` 호스트명을 사용합니다
- 외부에서 접근하려면 `localhost:5432`를 사용해야 합니다

## 🚀 다음 단계

1. Infinity 데이터소스에서 PostgreSQL 연결 테스트
2. 대시보드에서 데이터가 정상적으로 표시되는지 확인
3. 필요시 쿼리 수정 및 커스터마이징

