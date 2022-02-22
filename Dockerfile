FROM maven:3.8.4-openjdk-8-slim

RUN apt update
RUN apt install -y git

WORKDIR /jitsi-meet-torture
RUN git clone https://github.com/jitsi/jitsi-meet-torture .

ENTRYPOINT ["./scripts/malleus.sh", "--use-load-test"]
