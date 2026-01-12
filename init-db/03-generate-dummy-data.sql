-- 더미 진동 데이터 생성 (1일치, 1분 간격)
-- 실행: docker exec -i postgres psql -U postgres -d vibration_db < init-db/03-generate-dummy-data.sql

-- 기존 데이터 삭제 (선택사항)
-- TRUNCATE vibration_data;

-- 1일치 데이터 생성 (1분 간격)
-- 5개 센서 × 24시간 × 60분 = 7,200개 레코드

DO $$
DECLARE
    start_time TIMESTAMP := NOW() - INTERVAL '1 day';
    current_ts TIMESTAMP;
    sensor_list TEXT[] := ARRAY['SENSOR_001', 'SENSOR_002', 'SENSOR_003', 'SENSOR_004', 'SENSOR_005'];
    sensor_id TEXT;
    base_rms DECIMAL;
    sensor_idx INT;
    rms_val DECIMAL;
    accel_x DECIMAL;
    accel_y DECIMAL;
    accel_z DECIMAL;
    freq_1 DECIMAL;
    freq_2 DECIMAL;
    freq_3 DECIMAL;
    temp_val DECIMAL;
    status_val TEXT;
    time_offset_minutes INT;
BEGIN
    -- 각 센서별로 데이터 생성
    FOREACH sensor_id IN ARRAY sensor_list
    LOOP
        sensor_idx := array_position(sensor_list, sensor_id);
        -- 센서별 기본 RMS 값 증가 (일부 센서는 alert/fault 범위에 도달하도록)
        -- SENSOR_001: 5-8 (normal), SENSOR_002: 8-11 (normal-alert)
        -- SENSOR_003: 11-14 (alert), SENSOR_004: 14-17 (alert-fault), SENSOR_005: 17-20 (fault)
        base_rms := 5.0 + sensor_idx * 3.0;
        current_ts := start_time;

        -- 1일치 데이터 생성 (1분 간격)
        WHILE current_ts <= NOW() LOOP
            -- 시간 오프셋 계산 (분 단위)
            time_offset_minutes := EXTRACT(EPOCH FROM (current_ts - start_time))::INT / 60;

            -- RMS 값 계산 (사인파 기반, 더 큰 변동폭)
            rms_val := base_rms +
                       2.0 * SIN(2 * PI() * 1 * time_offset_minutes / 60.0) +
                       1.5 * SIN(2 * PI() * 2 * time_offset_minutes / 60.0) +
                       1.0 * SIN(2 * PI() * 3 * time_offset_minutes / 60.0) +
                       (RANDOM() - 0.5) * 0.5;

            -- 일부 센서는 시간대별로 alert/fault 상태가 나타나도록 추가 변동
            IF sensor_idx >= 2 THEN
                rms_val := rms_val + SIN(EXTRACT(HOUR FROM current_ts)::numeric / 24.0 * 2 * PI()) * 5.0;
            END IF;

            rms_val := GREATEST(0, rms_val);

            -- 가속도 값 생성
            accel_x := rms_val * (0.8 + RANDOM() * 0.4);
            accel_y := rms_val * (0.8 + RANDOM() * 0.4);
            accel_z := rms_val * (0.8 + RANDOM() * 0.4);

            -- 주파수 성분
            freq_1 := ABS(2.0 * SIN(2 * PI() * 1 * time_offset_minutes / 60.0));
            freq_2 := ABS(1.5 * SIN(2 * PI() * 2 * time_offset_minutes / 60.0));
            freq_3 := ABS(1.0 * SIN(2 * PI() * 3 * time_offset_minutes / 60.0));

            -- 온도
            temp_val := 20 + sensor_idx * 2 + (RANDOM() * 5);

            -- 상태 결정 (기준: normal 0-10, warning/alert 10-15, critical/fault 15+)
            IF rms_val >= 15.0 THEN
                status_val := 'critical';  -- fault
            ELSIF rms_val >= 10.0 THEN
                status_val := 'warning';   -- alert
            ELSE
                status_val := 'normal';
            END IF;

            -- 데이터 삽입
            INSERT INTO vibration_data (
                sensor_id, timestamp, acceleration_x, acceleration_y, acceleration_z,
                rms_value, frequency_1, frequency_2, frequency_3, temperature, status
            ) VALUES (
                sensor_id, current_ts,
                ROUND(accel_x::numeric, 4), ROUND(accel_y::numeric, 4), ROUND(accel_z::numeric, 4),
                ROUND(rms_val::numeric, 4),
                ROUND(freq_1::numeric, 4), ROUND(freq_2::numeric, 4), ROUND(freq_3::numeric, 4),
                ROUND(temp_val::numeric, 2), status_val
            );

            -- 다음 시간으로 이동
            current_ts := current_ts + INTERVAL '1 minute';

            -- 진행 상황 출력 (1000개마다)
            IF EXTRACT(EPOCH FROM (current_ts - start_time))::INT % 60000 = 0 THEN
                RAISE NOTICE '센서 %: % 분 데이터 생성 완료', sensor_id, time_offset_minutes;
            END IF;
        END LOOP;

        RAISE NOTICE '✅ 센서 % 데이터 생성 완료', sensor_id;
    END LOOP;

    RAISE NOTICE '🎉 모든 더미 데이터 생성 완료!';
END $$;

-- 생성된 데이터 확인
SELECT
    sensor_id,
    COUNT(*) as record_count,
    MIN(timestamp) as first_record,
    MAX(timestamp) as last_record,
    ROUND(AVG(rms_value)::numeric, 2) as avg_rms,
    ROUND(MAX(rms_value)::numeric, 2) as max_rms
FROM vibration_data
GROUP BY sensor_id
ORDER BY sensor_id;

