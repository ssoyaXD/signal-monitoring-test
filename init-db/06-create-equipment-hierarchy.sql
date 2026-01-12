-- 설비 계층 구조 네비게이션 테이블 생성
-- Grafana 네비게이션에 최적화된 구조

CREATE TABLE IF NOT EXISTS equipment_hierarchy (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES equipment_hierarchy(id) ON DELETE CASCADE,
    level_name VARCHAR(50) NOT NULL,  -- 'power_complex', 'plant', 'area_system', 'equipment', 'component', 'measurement_point'
    name VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    abbreviation VARCHAR(50),
    description TEXT,
    functional_location VARCHAR(100),
    system_asset_id VARCHAR(100),
    dashboard_url VARCHAR(500),  -- Grafana 대시보드 URL
    icon VARCHAR(50),  -- 아이콘 이름
    level_order INTEGER NOT NULL,  -- 계층 레벨 (1=최상위)
    display_order INTEGER DEFAULT 0,  -- 같은 레벨 내 정렬 순서
    is_active BOOLEAN DEFAULT true,
    metadata JSONB,  -- 추가 메타데이터 (설비 타입, 상태 등)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_eq_hierarchy_parent ON equipment_hierarchy(parent_id);
CREATE INDEX IF NOT EXISTS idx_eq_hierarchy_level ON equipment_hierarchy(level_name);
CREATE INDEX IF NOT EXISTS idx_eq_hierarchy_level_order ON equipment_hierarchy(level_order, display_order);
CREATE INDEX IF NOT EXISTS idx_eq_hierarchy_system_asset ON equipment_hierarchy(system_asset_id);
CREATE INDEX IF NOT EXISTS idx_eq_hierarchy_active ON equipment_hierarchy(is_active);

-- 계층 구조 뷰 (재귀 CTE 사용)
CREATE OR REPLACE VIEW equipment_hierarchy_tree AS
WITH RECURSIVE hierarchy_path AS (
    -- 최상위 노드
    SELECT
        id,
        parent_id,
        level_name,
        name,
        name_en,
        abbreviation,
        description,
        functional_location,
        system_asset_id,
        dashboard_url,
        icon,
        level_order,
        display_order,
        ARRAY[display_order] as path,
        0 as depth,
        name::TEXT as full_path
    FROM equipment_hierarchy
    WHERE parent_id IS NULL AND is_active = true

    UNION ALL

    -- 하위 노드
    SELECT
        e.id,
        e.parent_id,
        e.level_name,
        e.name,
        e.name_en,
        e.abbreviation,
        e.description,
        e.functional_location,
        e.system_asset_id,
        e.dashboard_url,
        e.icon,
        e.level_order,
        e.display_order,
        h.path || e.display_order,
        h.depth + 1,
        (h.full_path || ' > ' || e.name)::TEXT
    FROM equipment_hierarchy e
    INNER JOIN hierarchy_path h ON e.parent_id = h.id
    WHERE e.is_active = true
)
SELECT * FROM hierarchy_path
ORDER BY path;

COMMENT ON TABLE equipment_hierarchy IS '설비 계층 구조 네비게이션 테이블';
COMMENT ON COLUMN equipment_hierarchy.level_name IS '계층 레벨 이름: power_complex, plant, area_system, equipment, component, measurement_point';
COMMENT ON COLUMN equipment_hierarchy.level_order IS '계층 순서 (1=발전소단지, 2=호기, 3=계통, 4=설비, 5=구성요소, 6=측정포인트)';
COMMENT ON COLUMN equipment_hierarchy.dashboard_url IS 'Grafana 대시보드 URL';

