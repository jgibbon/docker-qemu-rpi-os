# This Dockerfile is based on the last image from dockerpi
# It's just the VM image with a different compressed Raspbian fs img file
# https://github.com/lukechilds/dockerpi/blob/6c1ac8edab988dca8bb36dddc5388e8c4123c824/Dockerfile

# The current lukechilds/dockerpi:vm has an issue uncompressing fs images
# larger than 1 GB, so it has been temporarily forked with the fix
# More info: https://github.com/lukechilds/dockerpi/pull/48
# FROM lukechilds/dockerpi:vm
FROM ghcr.io/carlosperate/dockerpi:vm-fix

LABEL org.opencontainers.image.authors="Carlos Pereira Atencio <carlosperate@embeddedlog.com>"
LABEL org.opencontainers.image.description="Docker image with Raspberry Pi OS running on QEMU."
LABEL org.opencontainers.image.source="https://github.com/carlosperate/docker-qemu-rpi-os"

# Select the GitHub tag from the release that hosts the OS files
# https://github.com/carlosperate/rpi-os-custom-image/releases/
ARG GH_TAG="bullseye-2022-01-28"

# To build a different image type from the release the FILE_SUFFIX variable
# can be overwritten with the `docker build --build-arg` flag
ARG FILE_SUFFIX="autologin-ssh-expanded"

# This only needs to be changed if the releases filename format changes
ARG FILE_PREXIF="raspberry-pi-os-lite-"${GH_TAG}"-"

ARG FILESYSTEM_IMAGE_URL="https://github.com/carlosperate/rpi-os-custom-image/releases/download/"${GH_TAG}"/"${FILE_PREXIF}${FILE_SUFFIX}".zip"
ADD $FILESYSTEM_IMAGE_URL /filesystem.zip

COPY custom_entrypoint.sh /custom_entrypoint.sh
RUN ["chmod", "+x", "/custom_entrypoint.sh"]

# entrypoint.sh has been added in the parent lukechilds/dockerpi:vm
ENTRYPOINT ["/custom_entrypoint.sh"]
