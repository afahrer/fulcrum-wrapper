FROM debian:bookworm as builder

ARG MAKEFLAGS

RUN apt update -y && \
    apt install -y openssl git build-essential pkg-config zlib1g-dev libbz2-dev libjemalloc-dev libzmq3-dev qtbase5-dev qt5-qmake

WORKDIR /build

COPY ./fulcrum .

RUN qmake -makefile PREFIX=/usr Fulcrum.pro && \
    make $MAKEFLAGS install

FROM debian:bookworm-slim AS final

RUN apt-get update -qqy && \
    apt-get upgrade -qqy && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
    bash \
    curl \
    tini \
    netcat-openbsd \
    ca-certificates \
    librocksdb7.8 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

ARG ARCH
ARG PLATFORM
RUN curl -sLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${PLATFORM} && chmod +x /usr/local/bin/yq

COPY --from=builder /build/Fulcrum /usr/local/bin/Fulcrum

ADD ./configurator/target/${ARCH}-unknown-linux-musl/release/configurator /usr/local/bin/configurator
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

#ADD ./check-electrum.sh /usr/local/bin/check-electrum.sh
#RUN chmod a+x /usr/local/bin/check-electrum.sh
#ADD ./check-synced.sh /usr/local/bin/check-synced.sh
#RUN chmod a+x /usr/local/bin/check-synced.sh

WORKDIR /data

# Electrum RPC
EXPOSE 50001 50002

STOPSIGNAL SIGINT

ENTRYPOINT ["docker_entrypoint.sh"]
