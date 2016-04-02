FROM ubuntu

# INSTALL NECESSARY PACKAGES
RUN apt-get update
RUN apt-get install -y autossh
RUN apt-get install -y default-jre
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y python-setuptools
RUN apt-get install -y screen
RUN easy_install supervisor
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash
RUN apt-get install -y nodejs

# ENTER ROOT DIRECTORY
WORKDIR /root

# CREATE EASY MOUNT LOCATION FROM OUTSIDE
VOLUME /data
RUN ln -s /data /root/data

# API.NINERMINERS.COM ENVIRONMENT VARIABLES
ENV   API_PORT  80
ENV   API_DIR   /root/api
ENV   NODE_ENV  production

# MINECRAFT ENVIRONMENT VARIABLES
ENV   MINECRAFT_DIR   /root/data/minecraft
ENV   MINECRAFT_ID    niner-miners-server
ENV   MINECRAFT_JAR   spigot.jar
ENV   MINECRAFT_MIN   1024M
ENV   MINECRAFT_MAX   3072M

# SSH TUNNEL ENVIRONMENT VARIABLES
ENV   PORT_MAP_SERVER   "8101:localhost:25565"
ENV   PORT_MAP_API      "8102:localhost:$API_PORT"
ENV   PORT_MAP_DYNMAP   "8103:localhost:8123"
ENV   TUNNEL_MONITOR    "8100"
ENV   TUNNEL_USER       "guest"
ENV   TUNNEL_HOST       "ninerminers.com"
ENV   SSH_PRIVATE_KEY   "/root/data/.ssh/id_rsa"

# DOWNLOAD API FILES
RUN git clone https://github.com/niner-miners/api.ninerminers.com $API_DIR
RUN cd $API_DIR && npm install && cd /root

# COPY LOCAL CONFIG FILES
COPY  ./docker .

# START SUPERVISOR AT RUNTIME
CMD   ["supervisord", "-c", "supervisord.conf"]
