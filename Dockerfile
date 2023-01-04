ARG image=debian:stable-slim

FROM ${image}

ARG keyring_package=debian-archive-keyring
ARG keyring_file="/usr/share/keyrings/debian-archive-keyring.gpg"

RUN apt update
RUN apt install -y debmirror gpg xz-utils ${keyring_package}

ENV keyring_file_env ${keyring_file}

CMD  "/usr/bin/env" "GNUPGHOME=/nonexistent" \
     "/usr/bin/debmirror" \
     "--allow-dist-rename" \
     "--host" "${HOST}" \
     "--root" "${DIST}" \
     "--dist"  "${RELEASES}" \
     "--section" "${SECTIONS}" \
     "--i18n" \
     "--arch" "${ARCHES}" \
     "--method" "${METHOD}" \
     "--keyring" "${keyring_file_env}" \
     "--rsync-extra=none" \
     "--getcontents" \
     "--diff=none" \
     "--progress" \
     "/mirror/${DIST}"
