FROM ubuntu:20.04
LABEL "MAINTAINER"="NETINT Support"

ENV REFRESHED_AT=2024-03-28 \
    NI_RELEASE_VERSION=4.8.2 \
    GST_VER=1.22.2 \
    NI_INSTALL_DIR="/NI_Release" \
    DEBIAN_FRONTEND=noninteractive

ARG NI_PACKAGE_NAME="Quadra_V${NI_RELEASE_VERSION}.zip"
ARG NI_PACKAGE_FOLDER="Quadra_V${NI_RELEASE_VERSION}"

SHELL ["/bin/bash", "-c"]

# Copy NETINT SDK to docker $NI_INSTALL_DIR directory
COPY $NI_PACKAGE_NAME $NI_INSTALL_DIR/

# Install required packages and clean up
RUN apt-get update && apt-get install -y \
    nvme-cli yasm pkg-config git gcc make g++ sudo wget uuid-runtime udev unzip python3-pip \
    flex bison libpng-dev zlib1g-dev gnutls-bin uuid-dev libglib2.0-dev libxml2 libxml2-dev \
    && python3 -m pip install meson ninja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Unzip NETINT SDK
WORKDIR $NI_INSTALL_DIR
RUN set -e && unzip "$NI_PACKAGE_NAME"

# Install libxcoder
RUN set -e && mv ${NI_INSTALL_DIR}/${NI_PACKAGE_FOLDER}/Quadra_SW_V*/libxcoder ${NI_INSTALL_DIR}
WORKDIR ${NI_INSTALL_DIR}/libxcoder
RUN set -e && bash ./build.sh

# Clone GStreamer repo
WORKDIR $NI_INSTALL_DIR
RUN set -e && git clone --depth 1 --branch ${GST_VER} https://gitlab.freedesktop.org/gstreamer/gstreamer.git

# GStreamer patch & install
RUN set -e && cp $NI_INSTALL_DIR/${NI_PACKAGE_FOLDER}/Quadra_SW_V*/gstreamer-*.diff ${NI_INSTALL_DIR}/gstreamer/
WORKDIR ${NI_INSTALL_DIR}/gstreamer
RUN set -e && patch -t -p 1 < gstreamer-*.diff
RUN set -e && bash ./build_gstreamer.sh --install
RUN set -e && export LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu/
RUN set -e && ldconfig

# Create entrypoint script to initialize NETINT VPUs on startup
USER root
RUN set -e && echo -e '#!/bin/bash\ninit_rsrc\nexec "$@"' > /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
