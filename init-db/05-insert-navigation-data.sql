-- 네비게이션 메뉴 더미 데이터 삽입

-- 최상위 메뉴 항목들
INSERT INTO navigation_menu (title, url, icon, category, description, display_order) VALUES
('대시보드 홈', '/d/home', 'home', 'main', '메인 대시보드로 이동', 1),
('시스템 모니터링', '/d/system', 'server', 'monitoring', '시스템 리소스 모니터링', 2),
('센서 데이터', '/d/sensors', 'database', 'data', '센서 데이터 조회', 3),
('알림 설정', '/d/alerts', 'bell', 'settings', '알림 규칙 관리', 4),
('리포트', '/d/reports', 'file-alt', 'reports', '리포트 생성 및 조회', 5);

-- 시스템 모니터링 하위 메뉴
INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, 'CPU 모니터링', '/d/system-cpu', 'microchip', 'monitoring', 'CPU 사용률 및 성능 모니터링', 1
FROM navigation_menu WHERE title = '시스템 모니터링';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '메모리 모니터링', '/d/system-memory', 'memory', 'monitoring', '메모리 사용량 모니터링', 2
FROM navigation_menu WHERE title = '시스템 모니터링';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '디스크 모니터링', '/d/system-disk', 'hdd', 'monitoring', '디스크 I/O 및 사용량 모니터링', 3
FROM navigation_menu WHERE title = '시스템 모니터링';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '네트워크 모니터링', '/d/system-network', 'network-wired', 'monitoring', '네트워크 트래픽 모니터링', 4
FROM navigation_menu WHERE title = '시스템 모니터링';

-- 센서 데이터 하위 메뉴
INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '진동 데이터', '/d/vibration', 'wave-square', 'data', '진동 센서 데이터 조회', 1
FROM navigation_menu WHERE title = '센서 데이터';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '온도 데이터', '/d/temperature', 'thermometer-half', 'data', '온도 센서 데이터 조회', 2
FROM navigation_menu WHERE title = '센서 데이터';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '압력 데이터', '/d/pressure', 'tachometer-alt', 'data', '압력 센서 데이터 조회', 3
FROM navigation_menu WHERE title = '센서 데이터';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '센서 목록', '/d/sensor-list', 'list', 'data', '등록된 센서 목록 조회', 4
FROM navigation_menu WHERE title = '센서 데이터';

-- 알림 설정 하위 메뉴
INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '알림 규칙', '/d/alert-rules', 'exclamation-triangle', 'settings', '알림 규칙 생성 및 관리', 1
FROM navigation_menu WHERE title = '알림 설정';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '알림 이력', '/d/alert-history', 'history', 'settings', '발생한 알림 이력 조회', 2
FROM navigation_menu WHERE title = '알림 설정';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '알림 채널', '/d/alert-channels', 'envelope', 'settings', '알림 전송 채널 설정', 3
FROM navigation_menu WHERE title = '알림 설정';

-- 리포트 하위 메뉴
INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '일일 리포트', '/d/report-daily', 'calendar-day', 'reports', '일일 리포트 생성', 1
FROM navigation_menu WHERE title = '리포트';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '주간 리포트', '/d/report-weekly', 'calendar-week', 'reports', '주간 리포트 생성', 2
FROM navigation_menu WHERE title = '리포트';

INSERT INTO navigation_menu (parent_id, title, url, icon, category, description, display_order)
SELECT id, '월간 리포트', '/d/report-monthly', 'calendar', 'reports', '월간 리포트 생성', 3
FROM navigation_menu WHERE title = '리포트';

-- 외부 링크 (최상위)
INSERT INTO navigation_menu (title, url, icon, category, description, display_order) VALUES
('Prometheus', 'http://localhost:9090', 'external-link-alt', 'external', 'Prometheus 메트릭 조회', 6),
('PostgreSQL', 'http://localhost:5432', 'database', 'external', 'PostgreSQL 데이터베이스 접속', 7),
('문서', 'https://grafana.com/docs', 'book', 'external', 'Grafana 공식 문서', 8);

