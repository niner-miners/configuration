FROM ubuntu

# INSTALL UBUNTU PACKAGES
RUN   apt-get update
RUN   apt-get install -y autossh
RUN   apt-get install -y default-jre
RUN   apt-get install -y curl
RUN   apt-get install -y git
RUN   apt-get install -y python-setuptools
RUN   apt-get install -y screen
RUN   apt-get install -y unzip wget

# INSTALL SUPERVISOR
RUN   easy_install supervisor

# INSTALL NODE
RUN   curl -sL https://deb.nodesource.com/setup_5.x | bash
RUN   apt-get install -y nodejs

# INSTALL RCLONE
RUN   wget http://downloads.rclone.org/rclone-v1.28-linux-amd64.zip -O /tmp/rclone.zip
RUN   unzip /tmp/rclone.zip -d /tmp
RUN   mv /tmp/*/rclone /bin

# ENTER ROOT DIRECTORY
WORKDIR /root

# CREATE MOUNT LOCATION
VOLUME /data

# API.NINERMINERS.COM ENVIRONMENT VARIABLES
ENV   API_PORT  "80"
ENV   API_DIR   "/root/api"
ENV   NODE_ENV  "production"

# BACKUP ENVIRONMENT VARIABLES
ENV   BACKUP_LOG      "/data/local/backup.log"
ENV   BACKUP_IGNORE   "/data/local**"

# MINECRAFT ENVIRONMENT VARIABLES
ENV   MINECRAFT_DIR   "/data/minecraft"
ENV   MINECRAFT_ID    "niner-miners-server"
ENV   MINECRAFT_JAR   "spigot.jar"
ENV   MINECRAFT_MIN   "1024M"
ENV   MINECRAFT_MAX   "3072M"

# SSH TUNNEL ENVIRONMENT VARIABLES
ENV   PORT_MAP_SERVER   "8101:localhost:25565"
ENV   PORT_MAP_API      "8102:localhost:$API_PORT"
ENV   PORT_MAP_DYNMAP   "8103:localhost:8123"
ENV   TUNNEL_MONITOR    "8100"
ENV   TUNNEL_USER       "guest"
ENV   TUNNEL_HOST       "ninerminers.com"
ENV   SSH_PRIVATE_KEY   "/data/keys/id_rsa"
ENV   RCLONE_CONFIG     "/data/keys/rclone.conf"

# SAVE ENVIRONMENT VARIABLES TO TEMPORARY FILE
RUN   env > /tmp/env

# DOWNLOAD API FILES
RUN   git clone https://github.com/niner-miners/api.ninerminers.com $API_DIR
RUN   npm --prefix $API_DIR install $API_DIR

# COPY LOCAL CONFIG FILES
COPY  ./docker .

# ENABLE CRON
RUN   crontab /root/crontab

# START SUPERVISOR AT RUNTIME
CMD   ["supervisord", "-c", "supervisord.conf"]
