# We're no longer using openjdk:17-slim as a base due to several unpatched vulnerabilities.
# The results from basing off of alpine are a smaller (by 47%) and faster (by 17%) image.
# Even with bash installed.     -Corbe
FROM alpine:latest

# Environment variables
ENV MC_VERSION="1.19.4" \
    FOLIA_BUILD="latest" \
    EULA="false" \
    MC_RAM="" \
    JAVA_OPTS=""

COPY folia.sh .
RUN apk update \
    && apk add openjdk17-jre \
    && apk add bash \
    && apk add wget \
    && apk add jq \
    && mkdir /folia

# Start script
CMD ["bash", "./folia.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /folia
