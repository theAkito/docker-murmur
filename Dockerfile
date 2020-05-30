FROM debian:testing-slim AS build

ARG TAG="1.3.1-rc1"
ARG BRANCH="1.3.x"

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

RUN git clone https://github.com/mumble-voip/mumble.git /root/mumble && \
    git fetch --all --tags --prune && \
    # https://github.com/mumble-voip/mumble/issues/4065#issuecomment-633082522
    #git checkout tags/${TAG} && \
    git checkout ${BRANCH} && \
    qmake -recursive main.pro CONFIG+="no-client grpc" && \
    make release

FROM debian:testing-slim

LABEL maintainer="Akito <the@akito.ooo>"
LABEL version="0.1.0"

RUN useradd --user-group --system --no-log-init \
    --uid 800 --shell /bin/bash murmur
RUN mkdir /data && chown -R murmur:murmur /data
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

EXPOSE 64738/tcp
EXPOSE 64738/udp
EXPOSE 50051

USER murmur

# Read murmur.ini and murmur.sqlite from /data/
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/murmurd", "-fg", "-v", "-ini", "/data/murmur.ini"]
