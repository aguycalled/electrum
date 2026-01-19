FROM ubuntu:20.04@sha256:c95a8e48bf88e9849f3e0f723d9f49fa12c5a00cfc6e60d2bc99d87555295e4c

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update -q && \
    apt-get install -qy \
        wget \
        gnupg2 \
        dirmngr \
        python3-software-properties \
        software-properties-common \
        && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN apt-get update -q && \
    apt-get install -qy \
        git \
        p7zip-full \
        make \
        mingw-w64 \
        mingw-w64-tools \
        win-iconv-mingw-w64-dev \
        autotools-dev \
        autoconf \
        autopoint \
        libtool \
        gettext \
        && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

# Add WineHQ repository using modern keyring approach
RUN mkdir -p /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources && \
    apt-get update -q && \
    apt-get install -qy --install-recommends \
        winehq-stable \
        && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean
