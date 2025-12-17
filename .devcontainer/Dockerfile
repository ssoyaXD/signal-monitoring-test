# Node.js 20 기반 개발 환경
FROM node:20-bullseye

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    zsh \
    sudo \
    # Docker CLI 설치를 위한 의존성
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# pnpm 설치
RUN corepack enable && corepack prepare pnpm@latest --activate

# node 사용자에게 sudo 권한 부여
RUN echo "node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 작업 디렉토리 설정
WORKDIR /workspace

# node 사용자로 전환
USER node

# Oh My Zsh 설치 (선택사항)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true

# 기본 쉘을 zsh로 설정
ENV SHELL=/usr/bin/zsh

# Git 안전 디렉토리 설정
RUN git config --global --add safe.directory /workspace

# pnpm 설정
ENV PNPM_HOME="/home/node/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# 작업 디렉토리 권한 설정
RUN sudo chown -R node:node /workspace

CMD ["/bin/zsh"]

