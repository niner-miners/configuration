FROM ubuntu

RUN apt-get update
RUN apt-get install -y default-jre
RUN apt-get install -y git
RUN apt-get install -y screen
RUN apt-get install -y python-setuptools
RUN easy_install supervisor

WORKDIR /root

ENV   MINECRAFT_DIR   /root/minecraft
ENV   MINECRAFT_ID    niner-miners-server
ENV   MINECRAFT_JAR   mcserver.jar
ENV   MINECRAFT_MIN   1024M
ENV   MINECRAFT_MAX   3072M

ADD   ./docker .

CMD   ["supervisord", "-c", "supervisord.conf"]
