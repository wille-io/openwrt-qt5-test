#FROM ubuntu:18.04
FROM ubuntu:latest

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install libncurses-dev zlib1g-dev gawk subversion python build-essential ccache git unzip wget -y

RUN useradd build -m
USER build
WORKDIR /home/build

#RUN wget https://downloads.openwrt.org/releases/19.07.6/targets/sunxi/cortexa7/openwrt-sdk-19.07.6-sunxi-cortexa7_gcc-7.5.0_musl_eabi.Linux-x86_64.tar.xz
RUN wget https://downloads.openwrt.org/releases/18.06.5/targets/sunxi/cortexa7/openwrt-sdk-18.06.5-sunxi-cortexa7_gcc-7.3.0_musl_eabi.Linux-x86_64.tar.xz
#COPY OpenWrt-SDK-ramips-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2 /home/build/
#COPY openwrt-sdk-18.06.5-sunxi-cortexa7_gcc-7.3.0_musl_eabi.Linux-x86_64.tar.xz /home/build/
RUN tar -xf *.tar.*

## grrr....
USER root
RUN rm *.tar.*
USER build

RUN mv openwrt-* openwrt

#ENV thedir="/home/build/OpenWrt-*"
#ENV thedir="/home/build/openwrt-*"
ENV thedir="/home/build/openwrt"
RUN cd ${thedir}/package && git clone https://github.com/pauldeng/qt5-openwrt-package

COPY .config /home/build/
RUN mv .config ${thedir}/

COPY Makefile /home/build/
RUN mv Makefile ${thedir}/package/qt5-openwrt-package/

RUN cd ${thedir} && make package/qt5-openwrt-package/compile V=s
RUN cd ${thedir} && make -C scripts/config/ clean
RUN cd ${thedir} && make V=s


USER root

#RUN cd ${thedir}/build_dir/target-*/qt-*/ && make install
#RUN cd ${thedir} && make install V=s
