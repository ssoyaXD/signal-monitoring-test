-- 센서 데이터 삽입
INSERT INTO sensors (sensor_id, sensor_name, location, machine_type, status) VALUES
('SENSOR_001', '모터 A 진동센서', '1층 제조라인 A', '모터', 'active'),
('SENSOR_002', '모터 B 진동센서', '1층 제조라인 B', '모터', 'active'),
('SENSOR_003', '펌프 진동센서', '2층 펌프실', '펌프', 'active'),
('SENSOR_004', '컴프레서 진동센서', '2층 압축기실', '컴프레서', 'active'),
('SENSOR_005', '팬 진동센서', '3층 환기실', '팬', 'active')
ON CONFLICT (sensor_id) DO NOTHING;


