FROM ubuntu:24.04
LABEL org.opencontainers.image.authors="NETINT Technologies" \
      org.opencontainers.image.description="Docker file example for NETINT VPU using the public Repos"

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

## Install Packages
RUN apt-get update && \
    apt-get install -y pkg-config git gcc make g++ sudo wget uuid-runtime udev unzip yasm nvme-cli autoconf libtool \
    ninja-build python3 \
    python3-pip flex bison libpng-dev zlib1g-dev gnutls-bin  \
    uuid-dev libglib2.0-dev libxml2 libxml2-dev meson
## Install libxcoder
WORKDIR /NI_Release
RUN git clone https://github.com/NETINT-Technologies/netint_libxcoder.git
WORKDIR /NI_Release/netint_libxcoder
RUN bash build.sh

## Install ffmpeg
WORKDIR /NI_Release
RUN git clone https://github.com/r-arpitgupta/netint_ffmpeg.git
WORKDIR /NI_Release/netint_ffmpeg
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/
RUN echo 'y' | bash ./build_ffmpeg.sh --ffprobe --shared && \
    make install
ENV LD_LIBRARY_PATH=/usr/local/lib/
RUN ldconfig

## Create entrypoint script to initialize NETINT VPUs on startup
USER root
COPY entrypoint.sh /usr/local/bin/
RUN set -e && chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
