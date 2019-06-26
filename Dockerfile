FROM node:10-alpine

USER root

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN mkdir /workdir && \
    apk update && \
    apk add python make g++

USER node

RUN npm config set puppeteer_skip_chromium_download true -g && \
    npm i -g magepack && \
    npm cache clean --force

USER root

RUN rm -rf /var/cache/apk/*

VOLUME /workdir
WORKDIR /workdir

COPY entrypoint.sh /bin/cs-bundle-js

ENTRYPOINT ['bin/cs-bundle-js']