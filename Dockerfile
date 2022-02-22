FROM maven:3.8.4-openjdk-8-slim

RUN apt update
RUN apt install -y git

WORKDIR /jitsi-meet-torture
RUN git clone https://github.com/jitsi/jitsi-meet-torture .

ENV SELENIUM_HUB "selenium-hub"
ENV SELENIUM_PORT "4444"

ENTRYPOINT ./scripts/malleus.sh --hub-url="http://$SELENIUM_HUB:$SELENIUM_PORT/wd/hub"
