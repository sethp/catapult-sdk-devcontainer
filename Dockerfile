# syntax=docker/dockerfile:1
FROM scratch AS sdk

# Get BuildKit to download (concurrently) and cache this file for us by ADDing it
ADD https://github.com/imgtec-riscv/catapult-sdk/releases/download/v2024.2.1/catapult-sdk_2024.2.1.deb /catapult-sdk.deb

# TODO the catapult-studio extension says this doesn't match the version its expecting (?)
# ADD https://github.com/imgtec-riscv/catapult-sdk/releases/download/v1.10.0/catapult-sdk_1.10.0.deb catapult-sdk.deb

# FROM ubuntu:24.10@sha256:c62f1babc85f8756f395e6aabda682acd7c58a1b0c3bea250713cd0184a93efa
# FROM ubuntu:24.04@sha256:b359f1067efa76f37863778f7b6d0e8d911e3ee8efa807ad01fbf5dc1ef9006b

# TODO: neither of these ^ work with
#   - catapult-sdk_1.10
#   - catapult-sdk_2024.2.1

FROM ubuntu:22.04@sha256:58b87898e82351c6cf9cf5b9f3c20257bb9e2dcf33af051e12ce532d7f94e3fe

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# cf. https://github.com/docker-library/buildpack-deps/blob/3e18c3af1f5dce6a48abf036857f9097b6bd79cc/ubuntu/jammy/curl/Dockerfile
ARG TZ=Etc/UTC
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    ca-certificates \
    curl \
    netbase \
    tzdata

# "D. Install tools used by the simulators"
# (note the addition of `cmake`)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    autoconf \
    bison \
    cmake \
    flex \
    g++ \
    git \
    libcairo2-dev \
    libfl-dev \
    libfl2 \
    make

# Sets up the pre-requisites for multiple simulators
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    libgtk-3-dev \
    gtkwave \
    libwebsockets-dev \
    verilator

# Installs the catapult SDK we downloaded
RUN --mount=type=bind,from=sdk,target=/opt/sdk \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    /opt/sdk/catapult-sdk.deb

# Additional utilities
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    ninja-build \
    usbutils
