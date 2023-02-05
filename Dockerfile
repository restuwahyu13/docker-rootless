###############################
# START STAGE 1
###############################
FROM node:16.19-bullseye-slim as start
LABEL MAINTENER='Restu Wahyu Saputra'
ARG USER_ACCOUNT='express'
ARG DEFAULT_USER_ACCOUNT='node'
ARG USER_GID=999
ARG USER_UID=666
COPY ./package.*json ./home/$USER_ACCOUNT/
COPY ./ ./home/$USER_ACCOUNT/

###############################
# SET ENVIRONMENT STAGE 2
###############################
FROM start as environment
ENV HOME=/home/$USER_ACCOUNT \
  NODE_OPTIONS=--max_old_space_size=32768 \
  PM2_HOME=/var/tmp

###############################
# COPY ASSET STAGE 3
###############################
FROM environment as asset
WORKDIR /home/$USER_ACCOUNT
COPY --from=start --chown=$DEFAULT_USER_ACCOUNT:$DEFAULT_USER_ACCOUNT ./home/$USER_ACCOUNT/ ./

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
  && npm i pm2 -g \
  && npm i --loglevel verbose

###############################
# PERMISSION STAGE 6
###############################
FROM install as permission
RUN groupdel -f $DEFAULT_USER_ACCOUNT && userdel -f $DEFAULT_USER_ACCOUNT \
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
CMD npm run start:pm2