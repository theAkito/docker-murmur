FROM debian:bookworm-slim AS build

ARG TAG="v1.4.287"
ARG BRANCH="master"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    qtbase5-dev \
    qtchooser \
    qt5-qmake \
    qtbase5-dev-tools \
    qttools5-dev \
    qttools5-dev-tools \
    libqt5svg5-dev \
    libboost-dev \
    libssl-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libprotoc-dev \
    libcap-dev \
    libxi-dev \
    libasound2-dev \
    libogg-dev \
    libsndfile1-dev \
    libspeechd-dev \
    libavahi-compat-libdnssd-dev \
    libxcb-xinerama0 \
    libzeroc-ice-dev \
    libpoco-dev \
    g++-multilib

WORKDIR /root/mumble

RUN git clone https://github.com/mumble-voip/mumble.git /root/mumble && \
    git fetch --all --tags --prune && \
    # https://github.com/mumble-voip/mumble/issues/4065#issuecomment-633082522
    # git checkout ${BRANCH} && \
    git checkout tags/${TAG} && \
    # https://github.com/mumble-voip/mumble/blob/master/docs/dev/build-instructions/build_linux.md#running-cmake
    mkdir build && cd build && \
    # https://github.com/mumble-voip/mumble/blob/master/docs/dev/build-instructions/cmake_options.md#available-options
    cmake -Dserver=ON -Dclient=OFF -DCMAKE_BUILD_TYPE=Release -Dice=ON -Dice=ON ..
    # qmake -recursive main.pro CONFIG+="no-client grpc" && \
    # make release

FROM debian:bookworm-slim

LABEL maintainer="Akito <the@akito.ooo>"
LABEL version="0.1.0"

# Not necessary, but the server log shows timestamps.
ARG TZ="Europe/Berlin"

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

ENV TZ=${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

EXPOSE 64738/tcp
EXPOSE 64738/udp
EXPOSE 50051

USER murmur

# Read murmur.ini and murmur.sqlite from /data/
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/murmurd", "-fg", "-v", "-ini", "/data/murmur.ini"]
