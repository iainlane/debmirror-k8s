FROM ubuntu:jammy-20231004 AS ubuntu

FROM debian:12.2-slim

RUN apt update
RUN apt install -y debmirror gpg xz-utils python3 python3-distro-info ${keyring_package} && rm -rf /var/lib/apt/lists/*

ENV HOST=deb.debian.org
ENV DIST=debian
ENV SECTIONS=main,contrib,non-free
ENV ARCHES=amd64,arm64,armhf
ENV METHOD=http
ENV KEYRING_FILE=/usr/share/keyrings/${DIST}-archive-keyring.gpg

ENV DIST=debian

COPY run-debmirror /usr/local/bin/
COPY dists /usr/local/bin/
COPY --from=ubuntu /usr/share/keyrings/ubuntu-archive-keyring.gpg /usr/share/keyrings/

ENTRYPOINT ["run-debmirror"]
