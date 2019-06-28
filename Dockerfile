# Customize the base upstream image

FROM node:10-alpine AS magesuite-node-base

USER root

ENV NODE_HOME=/opt/node
ENV NODE_HOME_GLOBAL="${NODE_HOME}/global"
ENV NPM_CONFIG_PREFIX="${NODE_HOME_GLOBAL}"
ENV PATH="${NPM_CONFIG_PREFIX}/bin:${PATH}"

# We don't need this user so remove it to not confuse anyone later...
RUN deluser --remove-home node

# Install node reqs separately in order to not store build-time system libs

FROM magesuite-node-base AS magesuite-node-reqs

# Run as separate step to reuse this layer in case of node req changes
RUN apk update && \
    apk add python make g++

COPY node-global-requirements "${NODE_HOME_GLOBAL}/requirements"

RUN mkdir -p "${NPM_CONFIG_PREFIX}" && \
    cd ${NODE_HOME} && \
    npm config set puppeteer_skip_chromium_download true -g && \
    < "${NPM_CONFIG_PREFIX}/requirements" xargs npm install -g && \
    npm cache clean --force

# Actually this is not a real cleanup since a lot more deps are
# pulled in, we don't even need to do this because of the multistage
# build, however, let's make the subimage smaller ;)
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

LABEL maintainer="filip.sobalski@creativestyle.pl" \
      org.label-schema.name="magesuite/bundle-theme-js" \
      org.label-schema.url="https://github.com/magesuite/docker-bundle-theme-js" \
      org.label-schema.vendor="creativestyle" \
      org.label-schema.schema-version="1.0.0-rc1"

ENTRYPOINT ["/bin/cs-bundle-js"]

