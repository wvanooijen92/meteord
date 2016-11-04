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

RUN ["npm", "install", "--global", "npm@3"]

RUN lib/cleanup.sh

# The preferred port to use is port 3000.
ENV PORT ${PORT:-3000}
EXPOSE $PORT

ENTRYPOINT ./run_app.sh
