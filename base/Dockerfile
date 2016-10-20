FROM debian:jessie
MAINTAINER Jesse Rosenberger

ENV METEORD_DIR /opt/meteord
COPY scripts $METEORD_DIR

ARG NODE_VERSION
ENV NODE_VERSION ${NODE_VERSION:-4.6.1}
ONBUILD ENV NODE_VERSION ${NODE_VERSION:-4.6.1}

RUN apt-get update && apt-get install -y \
  bzip2 \
  build-essential \
  curl \
  libssl-dev \
  g++ \
  git \
  python \
&& rm -rf /var/lib/apt/lists/*

RUN $METEORD_DIR/lib/install_node.sh
RUN $METEORD_DIR/lib/install_phantomjs.sh
RUN $METEORD_DIR/lib/cleanup.sh

EXPOSE 80
ENTRYPOINT $METEORD_DIR/run_app.sh
