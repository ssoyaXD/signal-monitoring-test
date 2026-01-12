-- 진동 데이터베이스 스키마 초기화

-- 센서 정보 테이블
CREATE TABLE IF NOT EXISTS sensors (
    sensor_id VARCHAR(50) PRIMARY KEY,
    sensor_name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    machine_type VARCHAR(100),
    installation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 진동 데이터 테이블
CREATE TABLE IF NOT EXISTS vibration_data (
    id BIGSERIAL PRIMARY KEY,
    sensor_id VARCHAR(50) NOT NULL REFERENCES sensors(sensor_id),
    timestamp TIMESTAMP NOT NULL,
    -- 진동 값 (가속도, 단위: m/s²)
    acceleration_x DECIMAL(10, 4) NOT NULL,
    acceleration_y DECIMAL(10, 4) NOT NULL,
    acceleration_z DECIMAL(10, 4) NOT NULL,
    -- 진동 크기 (RMS)
    rms_value DECIMAL(10, 4) NOT NULL,
    -- 주파수 도메인 데이터 (주요 주파수 성분)
    frequency_1 DECIMAL(10, 4),  -- 1차 고조파
    frequency_2 DECIMAL(10, 4),  -- 2차 고조파
    frequency_3 DECIMAL(10, 4),  -- 3차 고조파
    -- 온도 (센서 주변 온도)
    temperature DECIMAL(5, 2),
    -- 상태 정보
    status VARCHAR(20) DEFAULT 'normal',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성 (쿼리 성능 향상)
CREATE INDEX IF NOT EXISTS idx_vibration_sensor_time ON vibration_data(sensor_id, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_vibration_timestamp ON vibration_data(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_vibration_status ON vibration_data(status);

-- 센서별 통계 뷰
CREATE OR REPLACE VIEW sensor_statistics AS
SELECT
    s.sensor_id,
    s.sensor_name,
    s.location,
    COUNT(v.id) as total_readings,
    MIN(v.timestamp) as first_reading,
    MAX(v.timestamp) as last_reading,
    AVG(v.rms_value) as avg_rms,
    MAX(v.rms_value) as max_rms,
    MIN(v.rms_value) as min_rms,
    AVG(v.temperature) as avg_temperature
FROM sensors s
LEFT JOIN vibration_data v ON s.sensor_id = v.sensor_id
GROUP BY s.sensor_id, s.sensor_name, s.location;

-- 최근 진동 데이터 뷰 (최근 1시간)
CREATE OR REPLACE VIEW recent_vibration_data AS
SELECT
    v.*,
    s.sensor_name,
    s.location,
    s.machine_type
FROM vibration_data v
JOIN sensors s ON v.sensor_id = s.sensor_id
WHERE v.timestamp >= NOW() - INTERVAL '1 hour'
ORDER BY v.timestamp DESC;

COMMENT ON TABLE sensors IS '진동 센서 정보 테이블';
COMMENT ON TABLE vibration_data IS '진동 측정 데이터 테이블';
COMMENT ON COLUMN vibration_data.acceleration_x IS 'X축 가속도 (m/s²)';
COMMENT ON COLUMN vibration_data.acceleration_y IS 'Y축 가속도 (m/s²)';
COMMENT ON COLUMN vibration_data.acceleration_z IS 'Z축 가속도 (m/s²)';
COMMENT ON COLUMN vibration_data.rms_value IS 'RMS 진동값 (m/s²)';



