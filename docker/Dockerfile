# Download
FROM maven:3.8.4-openjdk-8-slim as build

RUN apt update
RUN apt install -y git

WORKDIR /jitsi-meet-torture
RUN git clone https://github.com/jitsi/jitsi-meet-torture .

RUN mvn test -Dmaven.test.skip=true


# Install
FROM maven:3.8.4-openjdk-8-slim

COPY --from=build /root/.m2 /root/.m2
COPY --from=build /jitsi-meet-torture /jitsi-meet-torture

WORKDIR /jitsi-meet-torture

ENTRYPOINT ["./scripts/malleus.sh", "--debug"]
