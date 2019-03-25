FROM alpine:latest as builder

ARG TOXCORE_VERSION=v0.2.9

WORKDIR /src

# install build deps
RUN apk add --no-cache build-base cmake git libsodium-dev libconfig-dev yasm \
    linux-headers

# download toxcore
RUN git clone https://github.com/TokTok/c-toxcore.git .
RUN git checkout ${TOXCORE_VERSION}

# build and install
RUN cmake . \
  -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_SHARED=ON \
  -DENABLE_STATIC=OFF \
  -DBUILD_TOXAV=OFF \
  -DBOOTSTRAP_DAEMON=ON -DUSE_STDERR_LOGGER=ON
RUN make -j$(nproc) && make install
RUN strip /usr/local/bin/tox-bootstrapd


FROM alpine:latest

# add tox-bootstrapd user to run as
RUN adduser -h /var/lib/tox-bootstrapd -S -s /sbin/nologin tox-bootstrapd

# install run deps
RUN apk add --no-cache libsodium libconfig bash jq curl

# add empty config
RUN touch /etc/tox-bootstrapd.conf \
    && chown tox-bootstrapd /etc/tox-bootstrapd.conf

# copy binaries
COPY --from=builder /usr/local/bin/tox-bootstrapd /usr/local/bin/
COPY --from=builder /usr/local/lib64/libtoxcore.so.2 /usr/local/lib/

WORKDIR /var/lib/tox-bootstrapd
VOLUME /var/lib/tox-bootstrapd
USER tox-bootstrapd

COPY get-nodes.sh /usr/local/bin/
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--config","/etc/tox-bootstrapd.conf", \
     "--log-backend", "stdout", \
     "--foreground"]

EXPOSE 443/tcp 3389/tcp 33445/tcp 33445/udp
