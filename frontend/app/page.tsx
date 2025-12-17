'use client';

import { useState } from 'react';
import styles from './page.module.css';

interface ApiResponse {
  message?: string;
  status?: string;
  value?: number;
  timestamp?: string;
}

export default function Home() {
  const [response, setResponse] = useState<ApiResponse | null>(null);
  const [loading, setLoading] = useState(false);

  const API_BASE_URL = 'http://localhost:4000/api';

  const callApi = async (endpoint: string, method: string = 'GET') => {
    setLoading(true);
    try {
      const res = await fetch(`${API_BASE_URL}/${endpoint}`, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
      });
      const data = await res.json();
      setResponse(data);
    } catch (error) {
      setResponse({ message: 'API 호출 실패', status: 'error' });
      console.error('API Error:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={styles.container}>
      <main className={styles.main}>
        <h1 className={styles.title}>
          모니터링 테스트 대시보드 📊
        </h1>

        <p className={styles.description}>
          Prometheus와 Grafana 연동 테스트를 위한 페이지입니다
        </p>

        <div className={styles.grid}>
          <div className={styles.card}>
            <h2>API 테스트 버튼</h2>
            <div className={styles.buttonGroup}>
              <button
                className={styles.button}
                onClick={() => callApi('hello')}
                disabled={loading}
              >
                Hello API 호출
              </button>
              <button
                className={styles.button}
                onClick={() => callApi('test', 'POST')}
                disabled={loading}
              >
                Test API 호출
              </button>
              <button
                className={styles.button}
                onClick={() => callApi('data')}
                disabled={loading}
              >
                Data API 호출
              </button>
            </div>
          </div>

          <div className={styles.card}>
            <h2>API 응답</h2>
            {loading ? (
              <div className={styles.loading}>로딩 중...</div>
            ) : response ? (
              <pre className={styles.response}>
                {JSON.stringify(response, null, 2)}
              </pre>
            ) : (
              <p className={styles.noData}>버튼을 클릭하여 API를 호출하세요</p>
            )}
          </div>
        </div>

        <div className={styles.links}>
          <a href="http://localhost:9090" target="_blank" rel="noopener noreferrer" className={styles.link}>
            Prometheus 🔍
          </a>
          <a href="http://localhost:3001" target="_blank" rel="noopener noreferrer" className={styles.link}>
            Grafana 📈
          </a>
          <a href="http://localhost:4000/metrics" target="_blank" rel="noopener noreferrer" className={styles.link}>
            Metrics 엔드포인트 📊
          </a>
        </div>

        <div className={styles.info}>
          <h3>사용 방법:</h3>
          <ol>
            <li>위 버튼들을 클릭하여 API를 호출하세요</li>
            <li>Prometheus에서 메트릭이 수집되는지 확인하세요</li>
            <li>Grafana에서 시각화된 데이터를 확인하세요</li>
          </ol>
        </div>
      </main>
    </div>
  );
}

