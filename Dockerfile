FROM node:10-alpine

### Pre-setup needed for installing npm stuff

USER root

ENV NODE_HOME=/home/node
ENV NPM_CONFIG_PREFIX="${NODE_HOME}/.npm-global"
ENV PATH="${NPM_CONFIG_PREFIX}/bin:${PATH}"

COPY entrypoint.sh /bin/cs-bundle-js
COPY node-global-deps /home/node/node-global-deps

RUN chmod +x /bin/cs-bundle-js

RUN mkdir /workdir && \
    apk update && \
    apk add python make g++

### Install node deps / magepack

USER node

RUN cd ${NODE_HOME} && \
    npm config set puppeteer_skip_chromium_download true -g && \
    < node-global-deps xargs npm install -g && \
    npm cache clean --force

### Cleanup as root

USER root

RUN apk del \
        binutils \
        gmp \
        isl \
        libgomp \
        libatomic \
        mpfr3 \
        mpc1 \
        gcc \
        musl-dev \
        libc-dev \
        g++ \
        make \
        libbz2 \
        expat \
        libffi \
        gdbm \
        ncurses-terminfo-base \
        ncurses-terminfo \
        ncurses-libs \
        readline \
        sqlite-libs \
        python2 \
        && \
        rm -rf /var/cache/apk/*

### Container meta config

VOLUME /workdir
WORKDIR /workdir

ENTRYPOINT ["/bin/cs-bundle-js"]

