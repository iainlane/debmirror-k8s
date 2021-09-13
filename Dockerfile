ARG image=debian:stable
ARG keyring_package=debian-archive-keyring

FROM ${image}

RUN apt update
RUN apt install -y debmirror gpg ${keyring_package}

CMD [ "sh", "-c", \
    "debmirror /mirror/${DIST} --host=${HOST} --root=${ROOT} --dist=${DIST} --section=${SECTION} --dep11 --i18n --arch=${ARCH} --method=${METHOD} --progress ${OTHERARGS} ]
