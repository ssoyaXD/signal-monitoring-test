import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as net from 'net';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

// 포트가 사용 가능한지 확인하는 함수
function isPortAvailable(port: number): Promise<boolean> {
  return new Promise((resolve) => {
    const server = net.createServer();
    server.listen(port, () => {
      server.once('close', () => resolve(true));
      server.close();
    });
    server.on('error', () => resolve(false));
  });
}

// 포트를 사용 중인 프로세스 종료 시도
async function killProcessOnPort(port: number): Promise<boolean> {
  let killed = false;

  try {
    // 방법 1: lsof 사용
    try {
      const { stdout } = await execAsync(`lsof -ti :${port} 2>/dev/null`, { timeout: 5000 });
      const pids = stdout.trim().split('\n').filter(Boolean);
      for (const pid of pids) {
        if (pid && !isNaN(Number(pid))) {
          try {
            await execAsync(`kill -9 ${pid} 2>/dev/null`, { timeout: 3000 });
            console.log(`✅ 포트 ${port} 프로세스 종료: PID=${pid}`);
            killed = true;
          } catch (e) {
            // 무시
          }
        }
      }
      if (pids.length > 0) {
        await new Promise(resolve => setTimeout(resolve, 3000));
      }
    } catch (e) {
      // lsof가 없거나 프로세스를 찾지 못함
    }

    // 방법 2: fuser 사용
    try {
      const { stdout } = await execAsync(`fuser ${port}/tcp 2>/dev/null`, { timeout: 5000 });
      const match = stdout.match(/\d+/);
      if (match) {
        const pid = match[0];
        try {
          await execAsync(`kill -9 ${pid} 2>/dev/null`, { timeout: 3000 });
          console.log(`✅ 포트 ${port} 프로세스 종료 (fuser): PID=${pid}`);
          killed = true;
          await new Promise(resolve => setTimeout(resolve, 3000));
        } catch (e) {
          // 무시
        }
      }
    } catch (e) {
      // fuser가 없거나 프로세스를 찾지 못함
    }

    // 방법 3: Node.js 프로세스 중 포트를 사용할 가능성이 있는 것들
    try {
      const { stdout } = await execAsync(`ps aux | grep -E "node.*4000|nest.*4000" | grep -v grep | awk '{print $2}'`, { timeout: 5000 });
      const pids = stdout.trim().split('\n').filter(Boolean);
      for (const pid of pids) {
        if (pid && !isNaN(Number(pid))) {
          try {
            await execAsync(`kill -9 ${pid} 2>/dev/null`, { timeout: 3000 });
            console.log(`✅ Node.js 프로세스 종료: PID=${pid}`);
            killed = true;
          } catch (e) {
            // 무시
          }
        }
      }
      if (pids.length > 0) {
        await new Promise(resolve => setTimeout(resolve, 2000));
      }
    } catch (e) {
      // 무시
    }
  } catch (e) {
    // 무시
  }

  return killed;
}

async function bootstrap() {
  const port = 4000;

  // 최대 3번까지 재시도
  const maxRetries = 3;
  let available = false;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    console.log(`포트 ${port} 확인 중... (시도 ${attempt}/${maxRetries})`);

    // 포트를 사용 중인 프로세스 종료 시도
    const killed = await killProcessOnPort(port);

    // 대기 시간 (종료된 경우 더 길게)
    await new Promise(resolve => setTimeout(resolve, killed ? 3000 : 1000));

    // 포트가 사용 가능한지 확인
    available = await isPortAvailable(port);

    if (available) {
      console.log(`✅ 포트 ${port} 사용 가능`);
      break;
    } else {
      if (attempt < maxRetries) {
        console.log(`⚠️  포트 ${port}이 여전히 사용 중입니다. 재시도...`);
      }
    }
  }

  if (!available) {
    console.error(`❌ 포트 ${port}을 사용할 수 없습니다 (${maxRetries}번 시도 실패)`);
    console.error(`다음 명령어로 수동으로 종료해주세요:`);
    console.error(`  lsof -ti :${port} | xargs kill -9`);
    console.error(`  또는: ./force-kill-port-4000.sh`);
    process.exit(1);
  }

  const app = await NestFactory.create(AppModule);

  // CORS 설정 (Grafana용)
  app.enableCors({
    origin: '*', // Grafana에서 접근 가능하도록
    credentials: true,
  });

  await app.listen(port);
  console.log(`✅ Backend is running on http://localhost:${port}`);
}
bootstrap();

