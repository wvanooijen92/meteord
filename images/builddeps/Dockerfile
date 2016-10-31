FROM abernix/spaceglue:base
MAINTAINER Jesse Rosenberger

RUN apt-get update && apt-get -f install -y && apt-get install -y --no-install-recommends \
    build-essential \
    fontconfig \
    libfreetype6-dev \
    libssl-dev \
    g++ \
    python \
  && rm -rf /var/lib/apt/lists/*

RUN ["npm", "install", "--global", "node-gyp"]
RUN ["npm", "install", "--global", "phantomjs@1"]
ONBUILD COPY ./ /app
ONBUILD RUN lib/build_app.sh

EXPOSE 80
ENTRYPOINT ./run_app.sh
