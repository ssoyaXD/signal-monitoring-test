-- 간단한 테스트 쿼리
SELECT
  level_name as "계층",
  name as "설비명",
  functional_location as "위치"
FROM equipment_hierarchy
WHERE is_active = true
ORDER BY level_order, display_order
LIMIT 10;

