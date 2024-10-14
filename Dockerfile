FROM ubuntu:noble-20241009 AS ubuntu

# This is more likely to have up-to-date Ubuntu release info
RUN apt update && apt install -y distro-info-data && rm -rf /var/lib/apt/lists/*

FROM debian:stable-20240904-slim

RUN apt update && apt install -y debmirror gpg xz-utils python3 python3-distro-info && rm -rf /var/lib/apt/lists/*

ENV HOST=deb.debian.org
ENV DIST=debian
ENV SECTIONS=main,contrib,non-free
ENV ARCHES=amd64,arm64,armhf
ENV METHOD=http

COPY run-debmirror /usr/local/bin/
COPY dists /usr/local/bin/
COPY --from=ubuntu /usr/share/keyrings/ubuntu-archive-keyring.gpg /usr/share/keyrings/
COPY --from=ubuntu /usr/share/distro-info/ubuntu.csv /usr/share/distro-info/

ENTRYPOINT ["run-debmirror"]
