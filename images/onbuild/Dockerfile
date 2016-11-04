FROM abernix/spaceglue:builddeps
MAINTAINER Jesse Rosenberger

COPY scripts .

USER root
RUN ["npm", "install", "--global", "node-gyp"]
RUN ["npm", "install", "--global", "phantomjs@1"]
ONBUILD COPY ./ /app
ONBUILD RUN lib/build_app.sh

USER node
