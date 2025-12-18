# Grafana Node Exporter 대시보드 - 더미 데이터 연동

이 프로젝트는 11074_rev9.json Grafana 대시보드에 실제 더미 데이터를 연결하여 그래프를 확인할 수 있도록 구성되었습니다.

## 📋 구성 요소

- **Prometheus**: 메트릭 수집 및 저장
- **Node Exporter**: 시스템 메트릭 생성 (CPU, 메모리, 디스크, 네트워크 등)
- **Grafana**: 대시보드 시각화

## 🚀 빠른 시작

### 1. Docker Compose 실행

```bash
docker-compose up -d
```

### 2. 서비스 확인

```bash
docker-compose ps
```

모든 서비스가 `Up` 상태인지 확인하세요:
- prometheus (포트 9090)
- node-exporter (포트 9100)
- grafana (포트 3000)

### 3. Grafana 접속

브라우저에서 다음 주소로 접속:
```
http://localhost:3000
```

**로그인 정보:**
- Username: `admin`
- Password: `admin`

### 4. 대시보드 확인

Grafana에 로그인하면 자동으로 다음이 설정됩니다:
- 데이터소스: VictoriaMetrics (Prometheus)
- 대시보드: Node Exporter Dashboard EN 20201010

메뉴에서 **Dashboards → Browse**로 이동하여 대시보드를 확인하세요!

## 📊 대시보드 기능

대시보드에는 다음 메트릭들이 표시됩니다:

### Resource Overview
- 서버 리소스 전체 개요 테이블
- CPU, 메모리, 디스크 사용률
- 네트워크 트래픽
- TCP 연결 상태

### 상세 메트릭
- **CPU**: 사용률, 시스템/유저 시간, iowait
- **메모리**: 총량, 사용량, 사용률
- **디스크**:
  - 읽기/쓰기 속도
  - 파일시스템 사용률
  - IOPS
  - I/O 대기 시간
- **네트워크**:
  - 인터페이스별 트래픽
  - 시간당 데이터 전송량
  - Socket 상태 (TCP, UDP)
- **시스템**:
  - Load average
  - Uptime
  - File descriptors
  - Context switches

## 🔧 트러블슈팅

### 대시보드에 "No data" 표시되는 경우

1. **Prometheus가 데이터를 수집하고 있는지 확인:**
```bash
curl http://localhost:9090/api/v1/targets
```

2. **Node Exporter가 메트릭을 생성하고 있는지 확인:**
```bash
curl http://localhost:9100/metrics | head -20
```

3. **Grafana 데이터소스 연결 확인:**
   - Grafana → Configuration → Data Sources
   - VictoriaMetrics 클릭
   - "Save & Test" 버튼으로 연결 테스트

### 데이터가 보이지 않는 경우

대시보드의 시간 범위를 확인하세요:
- 우측 상단의 시간 선택기에서 "Last 5 minutes" 또는 "Last 15 minutes" 선택
- 데이터가 쌓이는 데 1-2분 정도 소요될 수 있습니다

### 컨테이너 로그 확인

```bash
# Prometheus 로그
docker-compose logs prometheus

# Node Exporter 로그
docker-compose logs node-exporter

# Grafana 로그
docker-compose logs grafana
```

## 🔄 서비스 관리

### 서비스 중지
```bash
docker-compose stop
```

### 서비스 재시작
```bash
docker-compose restart
```

### 서비스 완전 제거 (데이터 포함)
```bash
docker-compose down -v
```

### 개별 서비스 재시작
```bash
docker-compose restart grafana
docker-compose restart prometheus
docker-compose restart node-exporter
```

## 📱 접속 URL

- **Grafana UI**: http://localhost:3000
- **Prometheus UI**: http://localhost:9090
- **Node Exporter Metrics**: http://localhost:9100/metrics

## 🎯 대시보드 커스터마이징

### 변수 (Variables) 설정

대시보드 상단에서 다음 변수들을 설정할 수 있습니다:
- **Origin_prom**: Prometheus 인스턴스 선택
- **JOB**: Node Exporter job 선택
- **Host**: 호스트명 선택
- **Instance**: 모니터링할 인스턴스 선택
- **NIC**: 네트워크 인터페이스 선택
- **Interval**: 메트릭 수집 간격 (30s ~ 30m)

### 새로운 패널 추가

1. 대시보드 우측 상단의 설정 아이콘 클릭
2. "Add panel" → "Add new panel"
3. 쿼리 작성 (PromQL 사용)
4. 시각화 타입 선택
5. "Apply" 클릭

## 📝 파일 구조

```
.
├── docker-compose.yml                 # Docker Compose 설정
├── prometheus.yml                     # Prometheus 설정
├── 11074_rev9.json                   # 원본 대시보드 JSON
├── prepare_dashboard.py              # 대시보드 변환 스크립트
├── grafana-provisioning/
│   ├── datasources/
│   │   └── prometheus.yml           # Grafana 데이터소스 자동 설정
│   └── dashboards/
│       ├── dashboard.yml            # 대시보드 프로비저닝 설정
│       └── node-exporter-dashboard.json  # 변환된 대시보드
└── README.md                         # 이 파일
```

## 🎨 추가 개선 사항

### 더 많은 더미 데이터 생성

여러 Node Exporter 인스턴스를 추가하려면:

```yaml
# docker-compose.yml에 추가
  node-exporter-2:
    image: prom/node-exporter:latest
    container_name: node-exporter-2
    ports:
      - "9101:9100"
    networks:
      - monitoring
```

그리고 `prometheus.yml`에 타겟 추가:
```yaml
  - job_name: 'node-exporter'
    static_configs:
      - targets:
          - 'node-exporter:9100'
          - 'node-exporter-2:9100'
```

### Alert 설정

Prometheus alert rule을 추가하여 임계값 초과 시 알림을 받을 수 있습니다.

## ❓ 도움말

문제가 발생하면:
1. 로그를 먼저 확인하세요
2. 모든 컨테이너가 실행 중인지 확인하세요
3. 포트 충돌이 없는지 확인하세요 (3000, 9090, 9100)

## 📚 참고 자료

- [Prometheus 문서](https://prometheus.io/docs/)
- [Grafana 문서](https://grafana.com/docs/)
- [Node Exporter](https://github.com/prometheus/node_exporter)
- [원본 대시보드](https://grafana.com/grafana/dashboards/11074)

---

**즐거운 모니터링 되세요! 🎉**
