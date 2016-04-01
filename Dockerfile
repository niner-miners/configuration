FROM ubuntu

# INSTALL NECESSARY PACKAGES
RUN apt-get update
RUN apt-get install -y default-jre
RUN apt-get install -y git
RUN apt-get install -y screen
RUN apt-get install -y python-setuptools
RUN apt-get install -y autossh
RUN easy_install supervisor

# ENTER ROOT DIRECTORY
WORKDIR /root

# CREATE EASY MOUNT LOCATION FROM OUTSIDE
VOLUME /data
RUN ln -s /data /root/data

# MINECRAFT ENVIRONMENT VARIABLES
ENV   MINECRAFT_DIR   /root/data/minecraft
ENV   MINECRAFT_ID    niner-miners-server
ENV   MINECRAFT_JAR   spigot.jar
ENV   MINECRAFT_MIN   1024M
ENV   MINECRAFT_MAX   3072M

# SSH TUNNEL ENVIRONMENT VARIABLES
ENV   PORT_MAP_SSH      "22:60122"
ENV   PORT_MAP_API      "XX:50100"
ENV   PORT_MAP_DYNMAP   "8123:50200"
ENV   PORT_MAP_SERVER   "25565:60100"

# COPY LOCAL CONFIG FILES
ADD   ./docker .

# START SUPERVISOR AT RUNTIME
CMD   ["bin/server"]
