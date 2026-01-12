#!/usr/bin/env python3
"""
진동 데이터 더미 데이터 생성 스크립트
PostgreSQL에 시간별 진동 데이터를 생성합니다.
"""
import psycopg2
import random
import math
from datetime import datetime, timedelta
import time

# 데이터베이스 연결 설정
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'vibration_db',
    'user': 'postgres',
    'password': 'postgres'
}

# 센서 ID 목록
SENSOR_IDS = ['SENSOR_001', 'SENSOR_002', 'SENSOR_003', 'SENSOR_004', 'SENSOR_005']

def generate_vibration_value(base_value, time_offset, sensor_index):
    """
    진동 값을 생성합니다.
    실제 진동 패턴을 시뮬레이션 (사인파 + 노이즈)
    """
    # 기본 진동값 (센서마다 다름)
    base = base_value + sensor_index * 0.5

    # 주기적 진동 (1Hz, 2Hz, 3Hz 고조파)
    t = time_offset / 60.0  # 분 단위로 변환
    vibration = (
        base +
        2.0 * math.sin(2 * math.pi * 1 * t) +  # 1Hz 성분
        1.5 * math.sin(2 * math.pi * 2 * t) +  # 2Hz 성분
        1.0 * math.sin(2 * math.pi * 3 * t) +  # 3Hz 성분
        random.uniform(-0.5, 0.5)  # 노이즈
    )

    return max(0, vibration)  # 음수 방지

def generate_temperature(sensor_index):
    """온도 생성 (20-35도 범위)"""
    return round(random.uniform(20 + sensor_index * 2, 25 + sensor_index * 2), 2)

def insert_vibration_data(conn, sensor_id, timestamp, batch_size=100):
    """진동 데이터 삽입"""
    cursor = conn.cursor()

    sensor_index = SENSOR_IDS.index(sensor_id)
    # 센서별 기본 RMS 값 (일부 센서는 alert/fault 범위에 도달하도록)
    # SENSOR_001: 5-8 (normal)
    # SENSOR_002: 8-11 (normal-alert)
    # SENSOR_003: 11-14 (alert)
    # SENSOR_004: 14-17 (alert-fault)
    # SENSOR_005: 17-20 (fault)
    base_rms = 5.0 + sensor_index * 3.0  # 센서별 기본 RMS 값 증가

    # 시간 오프셋 계산 (타임스탬프를 초로 변환)
    time_offset = (timestamp - datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)).total_seconds()

    # 진동값 생성 (더 큰 변동폭으로 alert/fault 상태 생성)
    rms = generate_vibration_value(base_rms, time_offset, sensor_index)

    # 일부 센서는 시간대별로 alert/fault 상태가 나타나도록 추가 변동
    hour_factor = timestamp.hour / 24.0  # 시간에 따른 변동
    if sensor_index >= 2:  # SENSOR_003 이상
        rms += math.sin(hour_factor * 2 * math.pi) * 5.0  # ±5 범위 추가 변동

    accel_x = rms * random.uniform(0.8, 1.2)
    accel_y = rms * random.uniform(0.8, 1.2)
    accel_z = rms * random.uniform(0.8, 1.2)

    # 주파수 성분
    freq_1 = abs(2.0 * math.sin(2 * math.pi * 1 * time_offset / 60.0))
    freq_2 = abs(1.5 * math.sin(2 * math.pi * 2 * time_offset / 60.0))
    freq_3 = abs(1.0 * math.sin(2 * math.pi * 3 * time_offset / 60.0))

    # 상태 결정 (기준: normal 0-10, warning/alert 10-15, critical/fault 15+)
    if rms >= 15.0:
        status = 'critical'  # fault
    elif rms >= 10.0:
        status = 'warning'   # alert
    else:
        status = 'normal'

    temperature = generate_temperature(sensor_index)

    cursor.execute("""
        INSERT INTO vibration_data
        (sensor_id, timestamp, acceleration_x, acceleration_y, acceleration_z,
         rms_value, frequency_1, frequency_2, frequency_3, temperature, status)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (
        sensor_id, timestamp,
        round(accel_x, 4), round(accel_y, 4), round(accel_z, 4),
        round(rms, 4), round(freq_1, 4), round(freq_2, 4), round(freq_3, 4),
        temperature, status
    ))

    conn.commit()

def generate_historical_data(days=7, interval_minutes=1):
    """과거 데이터 생성"""
    print(f"📊 {days}일치 과거 진동 데이터 생성 중...")

    try:
        conn = psycopg2.connect(**DB_CONFIG)
        print("✅ 데이터베이스 연결 성공")

        # 시작 시간 (현재로부터 N일 전)
        start_time = datetime.now() - timedelta(days=days)
        start_time = start_time.replace(second=0, microsecond=0)

        # 각 센서별로 데이터 생성
        total_records = 0
        for sensor_id in SENSOR_IDS:
            current_time = start_time
            sensor_records = 0

            while current_time <= datetime.now():
                insert_vibration_data(conn, sensor_id, current_time)
                current_time += timedelta(minutes=interval_minutes)
                sensor_records += 1

                if sensor_records % 1000 == 0:
                    print(f"  {sensor_id}: {sensor_records}개 레코드 생성...")

            total_records += sensor_records
            print(f"✅ {sensor_id}: 총 {sensor_records}개 레코드 생성 완료")

        print(f"\n🎉 총 {total_records}개 진동 데이터 생성 완료!")

        # 통계 출력
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM vibration_data")
        count = cursor.fetchone()[0]
        print(f"📈 데이터베이스 총 레코드 수: {count}")

        conn.close()

    except psycopg2.Error as e:
        print(f"❌ 데이터베이스 오류: {e}")
        return False

    return True

def generate_realtime_data(duration_minutes=60, interval_seconds=10):
    """실시간 데이터 생성 (지속적으로 추가)"""
    print(f"🔄 실시간 진동 데이터 생성 시작 (간격: {interval_seconds}초)")

    try:
        conn = psycopg2.connect(**DB_CONFIG)
        print("✅ 데이터베이스 연결 성공")

        end_time = datetime.now() + timedelta(minutes=duration_minutes)
        record_count = 0

        while datetime.now() < end_time:
            timestamp = datetime.now().replace(microsecond=0)

            for sensor_id in SENSOR_IDS:
                insert_vibration_data(conn, sensor_id, timestamp)
                record_count += 1

            print(f"⏰ {timestamp.strftime('%Y-%m-%d %H:%M:%S')} - {len(SENSOR_IDS)}개 센서 데이터 추가 (총 {record_count}개)")

            time.sleep(interval_seconds)

        conn.close()
        print(f"\n✅ 실시간 데이터 생성 완료 (총 {record_count}개 레코드)")

    except KeyboardInterrupt:
        print("\n⏹️  사용자에 의해 중단됨")
    except psycopg2.Error as e:
        print(f"❌ 데이터베이스 오류: {e}")

if __name__ == '__main__':
    import sys

    if len(sys.argv) > 1 and sys.argv[1] == 'realtime':
        # 실시간 모드
        duration = int(sys.argv[2]) if len(sys.argv) > 2 else 60
        interval = int(sys.argv[3]) if len(sys.argv) > 3 else 10
        generate_realtime_data(duration, interval)
    else:
        # 과거 데이터 생성 모드
        days = int(sys.argv[1]) if len(sys.argv) > 1 else 7
        interval = int(sys.argv[2]) if len(sys.argv) > 2 else 1
        generate_historical_data(days, interval)


