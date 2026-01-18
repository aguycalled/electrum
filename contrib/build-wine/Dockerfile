FROM ubuntu:20.04@sha256:c95a8e48bf88e9849f3e0f723d9f49fa12c5a00cfc6e60d2bc99d87555295e4c

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update -q && \
    apt-get install -qy \
        wget=1.20.3-1ubuntu2.1 \
        gnupg2=2.2.19-3ubuntu2.5 \
        dirmngr=2.2.19-3ubuntu2.5 \
        python3-software-properties=0.99.9.12 \
        software-properties-common=0.99.9.12 \
        && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN apt-get update -q && \
    apt-get install -qy \
        git=1:2.25.1-1ubuntu3.14 \
        p7zip-full=16.02+dfsg-7build1 \
        make=4.2.1-1.2 \
        mingw-w64=7.0.0-2 \
        mingw-w64-tools=7.0.0-2 \
        win-iconv-mingw-w64-dev=0.0.8-3 \
        autotools-dev=20180224.1 \
        autoconf=2.69-11.1 \
        autopoint=0.19.8.1-10build1 \
        libtool=2.4.6-14 \
        gettext=0.19.8.1-10build1 \
        && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - || echo "Warning: Could not add GPG key" && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' && \
    apt-get update -q && \
    apt-get install -qy --allow-unauthenticated \
        wine-stable-amd64:amd64=6.0.0~focal-1 \
        wine-stable-i386:i386=6.0.0~focal-1 \
        wine-stable:amd64=6.0.0~focal-1 \
        winehq-stable:amd64=6.0.0~focal-1 \
        && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean
