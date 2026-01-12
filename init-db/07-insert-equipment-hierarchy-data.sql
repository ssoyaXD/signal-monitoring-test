-- 설비 계층 구조 더미 데이터 삽입
-- 제공된 SQL 스크립트를 참고하여 Grafana 네비게이션에 최적화된 형태로 구성

-- 1. 발전소 단지 (Power Complex) - Level 1
INSERT INTO equipment_hierarchy (level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata) VALUES
('power_complex', '충주 2댐', 'Chung Ju Power Complex', 'CJ', '충주 2댐 발전소 단지', '3370', 'CJ', '/d/power-complex-cj', 'building', 1, 1, '{"type": "hydro", "capacity_mw": 400}'),
('power_complex', '영천 발전소', 'Yeongcheon Power Plant', 'YC', '영천 발전소 단지', '3380', 'YC', '/d/power-complex-yc', 'building', 1, 2, '{"type": "thermal", "capacity_mw": 500}');

-- 2. 호기 (Plant) - Level 2
INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'plant', '1호기', 'Plant #1', 'PL #1', '충주 2댐 1호기', '3370-01', 'CJ.PL #1', '/d/plant-cj-1', 'cog', 2, 1, '{"unit_number": 1, "status": "operational"}'
FROM equipment_hierarchy WHERE abbreviation = 'CJ' AND level_name = 'power_complex';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'plant', '2호기', 'Plant #2', 'PL #2', '충주 2댐 2호기', '3370-02', 'CJ.PL #2', '/d/plant-cj-2', 'cog', 2, 2, '{"unit_number": 2, "status": "operational"}'
FROM equipment_hierarchy WHERE abbreviation = 'CJ' AND level_name = 'power_complex';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'plant', '1호기', 'Plant #1', 'PL #1', '영천 발전소 1호기', '3380-01', 'YC.PL #1', '/d/plant-yc-1', 'cog', 2, 1, '{"unit_number": 1, "status": "operational"}'
FROM equipment_hierarchy WHERE abbreviation = 'YC' AND level_name = 'power_complex';

-- 3. 계통 (Area System) - Level 3
INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'area_system', '계통 #1 (터빈)', 'Area #1 (TBN)', 'AR #1', '충주 2댐 1호기 계통 #1(TBN)', '3370-01-AS1', 'CJ.PL #1.AR #1', '/d/area-cj-1-1', 'sitemap', 3, 1, '{"system_type": "turbine", "equipment_count": 2}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1' AND level_name = 'plant';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'area_system', '계통 #2 (발전기)', 'Area #2 (GEN)', 'AR #2', '충주 2댐 1호기 계통 #2(GEN)', '3370-01-AS2', 'CJ.PL #1.AR #2', '/d/area-cj-1-2', 'sitemap', 3, 2, '{"system_type": "generator", "equipment_count": 1}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1' AND level_name = 'plant';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'area_system', '계통 #1 (터빈)', 'Area #1 (TBN)', 'AR #1', '충주 2댐 2호기 계통 #1(TBN)', '3370-02-AS1', 'CJ.PL #2.AR #1', '/d/area-cj-2-1', 'sitemap', 3, 1, '{"system_type": "turbine", "equipment_count": 1}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #2' AND level_name = 'plant';

-- 4. 설비 (Equipment) - Level 4
INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'equipment', '터빈 설비 #1', 'Turbine Equipment #1', 'EQ #1', '충주 2댐 1호기 계통 #1 터빈 설비', '3370-01-AS1-001', 'CJ.PL #1.AR #1.EQ #1', '/d/equipment-cj-1-1-1', 'cogs', 4, 1, '{"equipment_type": "turbine", "measurement_type": "VMS", "cycle_seconds": 300}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #1' AND level_name = 'area_system';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'equipment', '발전기 설비 #2', 'Generator Equipment #2', 'EQ #2', '충주 2댐 1호기 계통 #2 발전기 설비', '3370-01-AS2-001', 'CJ.PL #1.AR #2.EQ #2', '/d/equipment-cj-1-2-2', 'bolt', 4, 1, '{"equipment_type": "generator", "measurement_type": "VMS", "cycle_seconds": 300}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #2' AND level_name = 'area_system';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'equipment', '터빈 설비 #3', 'Turbine Equipment #3', 'EQ #3', '충주 2댐 2호기 계통 #1 터빈 설비', '3370-02-AS1-001', 'CJ.PL #2.AR #1.EQ #3', '/d/equipment-cj-2-1-3', 'cogs', 4, 1, '{"equipment_type": "turbine", "measurement_type": "VMS", "cycle_seconds": 300}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #2.AR #1' AND level_name = 'area_system';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'equipment', '1호 변압기', 'Transformer #1', 'TR #1', '변압기 #1', '3370-01-AS1-TR001', 'CJ.PL #1.AR #1.TR #1', '/d/equipment-cj-1-1-tr1', 'plug', 4, 2, '{"equipment_type": "transformer", "voltage_kv": 22.9, "capacity_kva": 5000, "is_transformer": true}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #1' AND level_name = 'area_system';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'equipment', '2호 변압기', 'Transformer #2', 'TR #2', '변압기 #2', '3370-01-AS1-TR002', 'CJ.PL #1.AR #1.TR #2', '/d/equipment-cj-1-1-tr2', 'plug', 4, 3, '{"equipment_type": "transformer", "voltage_kv": 22.9, "capacity_kva": 3000, "is_transformer": true}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #1' AND level_name = 'area_system';

-- 5. 설비 구성요소 (Equipment Component) - Level 5
INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'component', '터빈 구동부', 'Turbine Driver', 'TBN', '수력 터빈 구동부', '3370-01-AS1-001-TBN', 'CJ.PL #1.AR #1.EQ #1.TBN', '/d/component-cj-1-1-1-tbn', 'cog', 5, 1, '{"component_type": "driver", "manufacture": "Doosan", "model": "GM 445-400"}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #1.EQ #1' AND level_name = 'equipment';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'component', '제너레이터 #1', 'Generator #1', 'GEN1', '수력 터빈 피구동부', '3370-01-AS2-001-GEN1', 'CJ.PL #1.AR #2.EQ #2.GEN1', '/d/component-cj-1-2-2-gen1', 'bolt', 5, 1, '{"component_type": "driven", "manufacture": "Alstom", "model": "KSVH-450", "rated_power_mw": 5.5}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #2.EQ #2' AND level_name = 'equipment';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'component', '제너레이터 #2', 'Generator #2', 'GEN2', '수력 터빈 피구동부', '3370-02-AS1-001-GEN2', 'CJ.PL #2.AR #1.EQ #3.GEN2', '/d/component-cj-2-1-3-gen2', 'bolt', 5, 1, '{"component_type": "driven", "manufacture": "Alstom", "model": "KSVH-450", "rated_power_mw": 5.5}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #2.AR #1.EQ #3' AND level_name = 'equipment';

-- 6. 측정 포인트 (Measurement Point) - Level 6
INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'measurement_point', '측정포인트 MIX', 'MPT MIX', 'MIX', '터빈 구동부 Motor Inner X 방향', '3370-01-AS1-001-TBN-MIX', 'CJ.PL #1.AR #1.EQ #1.TBN.MIX', '/d/mpt-cj-1-1-1-tbn-mix', 'dot-circle', 6, 1, '{"direction": "I", "axis": "X", "sensor_type": "ACC"}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #1.EQ #1.TBN' AND level_name = 'component';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'measurement_point', '측정포인트 MIY', 'MPT MIY', 'MIY', '터빈 구동부 Motor Inner Y 방향', '3370-01-AS1-001-TBN-MIY', 'CJ.PL #1.AR #1.EQ #1.TBN.MIY', '/d/mpt-cj-1-1-1-tbn-miy', 'dot-circle', 6, 2, '{"direction": "I", "axis": "Y", "sensor_type": "ACC"}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #1.EQ #1.TBN' AND level_name = 'component';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'measurement_point', '측정포인트 MIA', 'MPT MIA', 'MIA', '터빈 구동부 Motor Inner A 방향', '3370-01-AS1-001-TBN-MIA', 'CJ.PL #1.AR #1.EQ #1.TBN.MIA', '/d/mpt-cj-1-1-1-tbn-mia', 'dot-circle', 6, 3, '{"direction": "I", "axis": "A", "sensor_type": "ACC"}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #1.EQ #1.TBN' AND level_name = 'component';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'measurement_point', '측정포인트 GX', 'MPT GX', 'GX', '제너레이터 #1 X 방향', '3370-01-AS2-001-GEN1-GX', 'CJ.PL #1.AR #2.EQ #2.GEN1.GX', '/d/mpt-cj-1-2-2-gen1-gx', 'dot-circle', 6, 1, '{"direction": "O", "axis": "X", "sensor_type": "ACC"}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #2.EQ #2.GEN1' AND level_name = 'component';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'measurement_point', '측정포인트 GY', 'MPT GY', 'GY', '제너레이터 #1 Y 방향', '3370-01-AS2-001-GEN1-GY', 'CJ.PL #1.AR #2.EQ #2.GEN1.GY', '/d/mpt-cj-1-2-2-gen1-gy', 'dot-circle', 6, 2, '{"direction": "O", "axis": "Y", "sensor_type": "ACC"}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #2.EQ #2.GEN1' AND level_name = 'component';

-- 변압기는 component를 건너뛰고 직접 measurement_point 연결
INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'measurement_point', '측정포인트 TR1-X', 'MPT TR1-X', 'TR1-X', '1호 변압기 X 방향', '3370-01-AS1-TR001-X', 'CJ.PL #1.AR #1.TR #1.TR1-X', '/d/mpt-cj-1-1-tr1-x', 'dot-circle', 6, 1, '{"direction": "O", "axis": "X", "sensor_type": "ACC", "is_transformer": true}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #1.TR #1' AND level_name = 'equipment';

INSERT INTO equipment_hierarchy (parent_id, level_name, name, name_en, abbreviation, description, functional_location, system_asset_id, dashboard_url, icon, level_order, display_order, metadata)
SELECT id, 'measurement_point', '측정포인트 TR1-Y', 'MPT TR1-Y', 'TR1-Y', '1호 변압기 Y 방향', '3370-01-AS1-TR001-Y', 'CJ.PL #1.AR #1.TR #1.TR1-Y', '/d/mpt-cj-1-1-tr1-y', 'dot-circle', 6, 2, '{"direction": "O", "axis": "Y", "sensor_type": "ACC", "is_transformer": true}'
FROM equipment_hierarchy WHERE system_asset_id = 'CJ.PL #1.AR #1.TR #1' AND level_name = 'equipment';

