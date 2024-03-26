FROM ubuntu:20.04
LABEL "MAINTAINER"="NETINT Support"

ENV REFRESHED_AT=2024-02-13
ARG NI_RELEASE_VERSION=4.8.2
ARG NI_PACKAGE_NAME="Quadra_V${NI_RELEASE_VERSION}.zip"
ARG NI_PACKAGE_FOLDER="Quadra_V${NI_RELEASE_VERSION}"
ARG RC=RC4

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

#packages install
RUN apt-get update
RUN apt-get install -y nvme-cli yasm pkg-config git gcc make g++ sudo wget uuid-runtime udev unzip python3-pip flex bison libpng-dev zlib1g-dev gnutls-bin uuid-dev libglib2.0-dev libxml2 libxml2-dev
RUN python3 -m pip install meson ninja

#copy ni release package to docker /NI_Release directory
COPY $NI_PACKAGE_NAME /NI_Release/
WORKDIR /NI_Release
RUN unzip "$NI_PACKAGE_NAME"

#clone GStreamer v1.22
RUN git clone --depth 1 --branch 1.22 https://gitlab.freedesktop.org/gstreamer/gstreamer.git

#install libxcoder
RUN mv /NI_Release/"$NI_PACKAGE_FOLDER"/Quadra_SW_V"$NI_RELEASE_VERSION"_"$RC"/libxcoder /NI_Release
WORKDIR /NI_Release/libxcoder
RUN bash ./build.sh

#gstreamer install
RUN cp /NI_Release/"$NI_PACKAGE_FOLDER"/Quadra_SW_V"$NI_RELEASE_VERSION"_"$RC"/gstreamer-1.22.2_netint_v"$NI_RELEASE_VERSION"_"$RC".diff /NI_Release/gstreamer/
WORKDIR /NI_Release/gstreamer
RUN patch -t -p 1 < gstreamer-1.22.2_netint_v"$NI_RELEASE_VERSION"_"$RC".diff
RUN bash ./build_gstreamer.sh --install
RUN export LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu/
RUN ldconfig

#every time docker is run please run this command inside docker first: init_rsrc
