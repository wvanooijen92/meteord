FROM buildpack-deps:jessie-curl
MAINTAINER Jesse Rosenberger

WORKDIR /opt/spaceglue
ONBUILD WORKDIR /opt/spaceglue
ADD apt-sources.list /etc/apt/sources.list
COPY scripts .

ARG NODE_VERSION
ENV NODE_VERSION ${NODE_VERSION:-4.6.1}

ENV NODESOURCE_DEBIAN_DIST jessie
ENV NODESOURCE_BASEURL https://deb.nodesource.com/node_4.x
ENV NODESOURCE_BASEPATH /pool/main/n/nodejs/
ENV NODESOURCE_DEB_PATH nodejs_${NODE_VERSION}-1nodesource1~${NODESOURCE_DEBIAN_DIST}1_amd64.deb

ADD "${NODESOURCE_BASEURL}${NODESOURCE_BASEPATH}${NODESOURCE_DEB_PATH}" node.deb

RUN (dpkg -i node.deb 2> /dev/null || true) && rm node.deb

RUN apt-get update && apt-get -f install -y \
  && rm -rf /var/lib/apt/lists/*

RUN ["which", "node"]

RUN ls -la /usr/bin

RUN readlink -f $(which node)

# Allow Node to bind to ports less than 1024 as unprivileged user.
RUN ["setcap", "cap_net_bind_service=+ep", "/usr/bin/nodejs"]

RUN ["npm", "install", "--global", "npm@3"]

RUN lib/cleanup.sh

# The preferred port to use is port 3000.
ENV PORT ${PORT:-3000}
EXPOSE $PORT

RUN groupadd -r node && useradd -r -g node node
USER node
ENTRYPOINT ./run_app.sh
