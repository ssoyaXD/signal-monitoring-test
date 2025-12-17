import { Controller, Get, Post } from '@nestjs/common';
import { AppService } from './app.service';

@Controller('api')
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('hello')
  getHello(): object {
    return this.appService.getHello();
  }

  @Post('test')
  testApi(): object {
    return this.appService.testApi();
  }

  @Get('data')
  getData(): object {
    return this.appService.getData();
  }
}

