# Customize the base upstream image

FROM node:10-alpine AS magesuite-node-base

USER root

ENV NODE_HOME=/opt/node
ENV NODE_HOME_GLOBAL="${NODE_HOME}/global"
ENV NPM_CONFIG_PREFIX="${NODE_HOME_GLOBAL}"
ENV PATH="${NPM_CONFIG_PREFIX}/bin:${PATH}"

RUN deluser --remove-home node


# Install node reqs separately in order to not store build-time system libs

FROM magesuite-node-base AS magesuite-node-reqs

COPY node-global-requirements "${NODE_HOME_GLOBAL}/requirements"

# Run as separate steps to reuse the build-time deps layer

RUN apk update && \
    apk add python make g++

RUN mkdir -p "${NPM_CONFIG_PREFIX}" && \
    cd ${NODE_HOME} && \
    npm config set puppeteer_skip_chromium_download true -g && \
    < "${NPM_CONFIG_PREFIX}/requirements" xargs npm install -g && \
    npm cache clean --force

RUN apk del python make g++ gcc && \
    rm -rf /var/cache/apk/*


# Build the final image

FROM magesuite-node-base

COPY --from=magesuite-node-reqs "${NODE_HOME_GLOBAL}" "${NODE_HOME_GLOBAL}"
COPY entrypoint.sh /bin/cs-bundle-js

RUN chmod +x /bin/cs-bundle-js && \
    mkdir -p /workdir

VOLUME /workdir
WORKDIR /workdir

ENTRYPOINT ["/bin/cs-bundle-js"]

