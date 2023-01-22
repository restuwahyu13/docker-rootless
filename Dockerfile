###############################
# START STAGE 1
###############################
FROM node:16.19-bullseye-slim as start
LABEL MAINTENER='Restu Wahyu Saputra'
COPY ./package.*json ./home/node/
COPY ./ ./home/node/

###############################
# SET ENVIRONMENT STAGE 2
###############################
FROM start as environment
ARG ROOT='root'
ARG USER_ACCOUNT='node'
ARG USER_GID=1000
ARG USER_UID=1000
ENV HOME=/home/$USER_ACCOUNT \
  NODE_OPTIONS=--max_old_space_size=32768

###############################
# COPY ASSET STAGE 3
###############################
FROM environment as asset
WORKDIR /home/$USER_ACCOUNT
COPY --from=start --chown=$USER_GID:$USER_UID ./home/$USER_ACCOUNT/ ./

###############################
# UPGRADE SYSTEM STAGE 4
###############################
FROM asset as upgrade
RUN apt-get autoremove \
  && apt-get autoclean \
  && apt-get update \
  && apt-get upgrade -y

###############################
# INSTALLATION STAGE 5
###############################
FROM upgrade as install
RUN npm cache clean -f \
  && npm config delete proxy \
  && npm config delete https-proxy \
  && npm config delete proxy -g \
  && npm config delete https-proxy -g \
  && npm config set proxy null \
  && npm config set https-proxy null \
  && npm config set fetch-retries 15 \
  && npm config set fetch-retry-factor 30 \
  && npm config set fetch-retry-mintimeout 6000000 \
  && npm config set fetch-retry-maxtimeout 12000000 \
  && npm config set fetch-timeout 30000000 \
  && npm config set prefer-offline true \
  && npm i --loglevel verbose

###############################
# PERMISSION STAGE 6
###############################
FROM install as permission
RUN groupdel -f $USER_ACCOUNT && userdel -f $USER_ACCOUNT \
  && groupadd -r -g $USER_GID $USER_ACCOUNT \
  && useradd -r -u $USER_UID -g $USER_GID $USER_ACCOUNT -s /bin/false -d /home/$USER_ACCOUNT -M \
  && groupmod -g $USER_GID $USER_ACCOUNT \
  && usermod -u $USER_UID -g $USER_GID $USER_ACCOUNT \
  && chown -R $USER_UID:$USER_GID /home/$USER_ACCOUNT \
  && chsh -s /usr/sbin/nologin \
  && chmod -R 500 /home/$USER_ACCOUNT \
  && chmod -R 400 /bin/chmod \
  && chown -R 400 /bin/chown \
  && chown -R 400 /bin/chgrp
USER $USER_ACCOUNT

###############################
# FINAL STAGE 7
###############################
FROM permission as final
CMD npm start