FROM debian:bookworm as builder

ARG MAKEFLAGS

RUN apt update -y && \
    apt install -y openssl git build-essential pkg-config zlib1g-dev libbz2-dev libjemalloc-dev libzmq3-dev qtbase5-dev qt5-qmake

WORKDIR /build

COPY ./fulcrum .

RUN qmake -makefile PREFIX=/usr Fulcrum.pro && \
    make $MAKEFLAGS install

FROM debian:bookworm-slim AS final

RUN apt update && \
    apt install -y openssl libqt5network5 zlib1g libbz2-1.0 libjemalloc2 libzmq5 bash curl tini python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG ARCH
ARG PLATFORM
RUN curl -sLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${PLATFORM} && chmod +x /usr/local/bin/yq

COPY --from=builder /build/Fulcrum /usr/local/bin/Fulcrum
COPY --from=builder /build/FulcrumAdmin /usr/local/bin/FulcrumAdmin

ADD ./configurator/target/${ARCH}-unknown-linux-musl/release/configurator /usr/local/bin/configurator
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ADD ./check-electrum.sh /usr/local/bin/check-electrum.sh
RUN chmod a+x /usr/local/bin/check-electrum.sh
ADD ./fulcrum-getinfo.sh /usr/local/bin/fulcrum-getinfo.sh
RUN chmod a+x /usr/local/bin/fulcrum-getinfo.sh

WORKDIR /data

# Electrum RPC
EXPOSE 50001 8080

STOPSIGNAL SIGINT

ENTRYPOINT ["docker_entrypoint.sh"]
