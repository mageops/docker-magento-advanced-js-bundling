FROM node:10-alpine

COPY entrypoint.sh /bin/cs-bundle-js

RUN mkdir /workdir && \
    npm i -g magepack && \
    npm cache clean

VOLUME /workdir
WORKDIR /workdir

ENTRYPOINT ['bin/cs-bundle-js']