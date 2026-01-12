-- 네비게이션 메뉴 테이블 생성
CREATE TABLE IF NOT EXISTS navigation_menu (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES navigation_menu(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    url VARCHAR(500),
    icon VARCHAR(100),
    category VARCHAR(100),
    description TEXT,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_nav_parent_id ON navigation_menu(parent_id);
CREATE INDEX IF NOT EXISTS idx_nav_category ON navigation_menu(category);
CREATE INDEX IF NOT EXISTS idx_nav_order ON navigation_menu(display_order);

-- 뷰 생성: 계층 구조를 포함한 네비게이션 메뉴
CREATE OR REPLACE VIEW navigation_tree AS
WITH RECURSIVE nav_hierarchy AS (
    -- 최상위 메뉴 (parent_id가 NULL인 항목)
    SELECT
        id,
        parent_id,
        title,
        url,
        icon,
        category,
        description,
        display_order,
        is_active,
        0 as level,
        ARRAY[display_order] as path
    FROM navigation_menu
    WHERE parent_id IS NULL AND is_active = true

    UNION ALL

    -- 하위 메뉴
    SELECT
        n.id,
        n.parent_id,
        n.title,
        n.url,
        n.icon,
        n.category,
        n.description,
        n.display_order,
        n.is_active,
        nh.level + 1,
        nh.path || n.display_order
    FROM navigation_menu n
    INNER JOIN nav_hierarchy nh ON n.parent_id = nh.id
    WHERE n.is_active = true
)
SELECT * FROM nav_hierarchy
ORDER BY path;

COMMENT ON TABLE navigation_menu IS 'Grafana 네비게이션 메뉴 테이블';
COMMENT ON COLUMN navigation_menu.parent_id IS '부모 메뉴 ID (NULL이면 최상위 메뉴)';
COMMENT ON COLUMN navigation_menu.url IS '대시보드 URL 또는 외부 링크';
COMMENT ON COLUMN navigation_menu.display_order IS '표시 순서';

