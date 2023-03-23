# Quadra Docker Readme

## Instructions
The Dockerfile here can be used to create a docker image with Netint Quadra
libxcoder and FFmpeg installed.

1. Copy the Netint SW release package(eg. Quadra_SW_V4.2.0_RC3.tar.gz) to same
   folder as Dockerfile
2. Generate docker image:

       sudo docker build --tag ni_quadra_sw .
   Two --build-arg options are supported in Dockerfile:

       NI_RELEASE_VERSION=4.2.0_RC3    version number of Netint Quadra SW
                                       release package
       FFMPEG_VERSION=n5.0             version number of FFmpeg to use

3. Start docker targeting quadra NVMe device:
   
    sudo docker run -it --device=/dev/nvme0 --device=/dev/nvme0n1 ni_quadra_sw /bin/bash
   
   Please make sure you are targetting the correct Quadra NVMe device and block paths
   If you want to give the container sudo permission to control the device, you can add `--privileged` argurment 
4. Run the test program:

       cd /NI_Release/FFmpeg-n5.0
       bash run_ffmpeg.sh

To export docker image:

    sudo docker save ni_quadra_sw | gzip -c > Quadra_Docker.tar.gz

To import docker image:

    gunzip Quadra_Docker.tar.gz
    sudo docker load -i Quadra_Docker.tar

If you need to upgrade Quadra card firmware, use quadra_auto_upgrade.sh in the
Netint FW release tarball (Quadra_FW_V*.tar.gz)
