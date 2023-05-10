FROM node:lts-bullseye

ENV WORK_DIR /data
WORKDIR $WORK_DIR

RUN apt-get update \
    && apt-get install -y --no-install-recommends cron ca-certificates fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 \
    && apt-get install -y --no-install-recommends libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 \
    && apt-get install -y --no-install-recommends libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 \
    && apt-get install -y --no-install-recommends libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 \
    && apt-get install -y --no-install-recommends libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils \
    && /etc/init.d/cron start \
    && apt-get install -y --no-install-recommends vim \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

RUN git clone https://github.com/kingbird/FT-seed.git
WORKDIR FT-seed
RUN npm config set registry http://mirrors.cloud.tencent.com/npm/
RUN npm install

# If running Docker >= 1.13.0 use docker run's --init arg to reap zombie processes, otherwise
# uncomment the following lines to have `dumb-init` as PID 1
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_x86_64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["dumb-init", "--"]

RUN (crontab -l -u root; echo "0 */6 * * * /usr/local/bin/node /data/FT-seed/index.js -w >> /data/FT-seed/log 2>&1") | crontab

CMD ["tail", "-f", "/data/FT-seed/logs.log"]