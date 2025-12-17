import { Injectable } from '@nestjs/common';
import { MetricsService } from './metrics/metrics.service';

@Injectable()
export class AppService {
  constructor(private readonly metricsService: MetricsService) {}

  getHello(): object {
    this.metricsService.incrementApiCalls('hello');
    return { 
      message: 'Hello from NestJS!',
      timestamp: new Date().toISOString()
    };
  }

  testApi(): object {
    this.metricsService.incrementApiCalls('test');
    
    // 랜덤하게 성공/실패 처리
    const isSuccess = Math.random() > 0.3;
    
    if (isSuccess) {
      this.metricsService.incrementSuccessCounter();
      return { 
        status: 'success',
        message: 'Test API call succeeded',
        timestamp: new Date().toISOString()
      };
    } else {
      this.metricsService.incrementErrorCounter();
      return { 
        status: 'error',
        message: 'Test API call failed',
        timestamp: new Date().toISOString()
      };
    }
  }

  getData(): object {
    this.metricsService.incrementApiCalls('data');
    
    // 랜덤 데이터 생성
    const randomValue = Math.floor(Math.random() * 100);
    this.metricsService.setRandomValue(randomValue);
    
    return {
      value: randomValue,
      timestamp: new Date().toISOString()
    };
  }
}

