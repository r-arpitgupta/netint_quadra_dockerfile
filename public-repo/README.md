# Quadra Public Repo Dockerfile

## Instructions
The Dockerfile here can be used to create a docker image with Netint Quadra libxcoder and FFmpeg installed.

2. Generate docker image:

    ```
    sudo docker build --tag ni_quadra_sw .
    ```

3. Start docker targeting quadra NVMe device:
   
   ```
    sudo docker run -it --device=/dev/nvme0 --device=/dev/nvme0n1 ni_quadra_sw /bin/bash
   ```

   Please make sure you are targetting the correct Quadra NVMe device and block paths
   If you want to give the container sudo permission to control the device, you can add `--privileged` argurment 
   
4. Run the test program:

    ```
    cd /NI_Release/FFmpeg-* && \
    bash run_ffmpeg.sh
    ```

### Export Docker Image:

```
sudo docker save ni_quadra_sw | gzip -c > Quadra_Docker.tar.gz
```

### Import Docker Image:

```
gunzip Quadra_Docker.tar.gz && \
sudo docker load -i Quadra_Docker.tar
```

## GSTreamer Support

Currently only FFmpeg is supported with the public github repos. 