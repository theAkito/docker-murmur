FROM debian:testing-slim AS build

LABEL maintainer="Akito <the@akito.ooo>"

ARG VERSION="1.3.1-rc1"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    pkg-config \
    qt5-default \
    libboost-dev \
    libasound2-dev \
    libssl-dev \
    libspeechd-dev \
    libzeroc-ice-dev \
    libpulse-dev \
    libcap-dev \
    libprotobuf-dev \
    protobuf-compiler \
    protobuf-compiler-grpc \
    libprotoc-dev \
    libogg-dev \
    libavahi-compat-libdnssd-dev \
    libsndfile1-dev \
    libgrpc++-dev \
    libxi-dev \
    libbz2-dev \
    qtcreator

WORKDIR /root/mumble

RUN mkdir /root/mumble && \
    git clone https://github.com/mumble-voip/mumble.git /root/mumble && \
    git fetch --all --tags --prune && \
    git checkout tags/${VERSION} && \
    qmake -recursive main.pro CONFIG+="no-client grpc" && \
    make release

FROM debian:testing-slim

RUN adduser murmur
RUN apt-get update && apt-get install -y \
    libcap2 \
    libzeroc-ice3.7 \
    '^libprotobuf[0-9]+$' \
    '^libgrpc[0-9]+$' \
    libgrpc++1 \
    libavahi-compat-libdnssd1 \
    libqt5core5a \
    libqt5network5 \
    libqt5sql5 \
    libqt5xml5 \
    libqt5dbus5 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /root/mumble/release/murmurd /usr/bin/murmurd

EXPOSE 64738/tcp 64738/udp 50051
USER murmur

# Read murmur.ini and murmur.sqlite from /data/
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/murmurd", "-fg", "-v"]
CMD ["-ini", "/data/murmur.ini", "|", "tee", "/data/murmur.log"]
