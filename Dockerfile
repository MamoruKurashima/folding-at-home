ARG CUDA="10.2"
ARG CUDNN="7"

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu16.04
SHELL ["/bin/bash", "-c"]

ENV CUDA_VER=10.2

ENV FAH_VERSION_MINOR=7.5.1
ENV FAH_VERSION_MAJOR=7.5

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i'' 's/archive\.ubuntu\.com/jp\.archive\.ubuntu\.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y \
        curl adduser bzip2 ca-certificates file ocl-icd-opencl-dev ocl-icd-libopencl1 clinfo lsb-core &&\
        curl -o /tmp/fah.deb https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${FAH_VERSION_MAJOR}/fahclient_${FAH_VERSION_MINOR}_amd64.deb &&\
        mkdir -p /etc/fahclient/ &&\
        touch /etc/fahclient/config.xml &&\
        dpkg --install /tmp/fah.deb &&\
        apt-get remove -y curl &&\
        apt-get autoremove -y &&\
        rm --recursive --verbose --force /tmp/* /var/log/* /var/lib/apt/

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# Web viewer
EXPOSE 7396

ENTRYPOINT ["FAHClient", "--web-allow=0/0:7396", "--allow=0/0:7396"]
CMD ["--user=Anonymous", "--team=0", "--gpu=true", "--smp=true", "--power=full"]
