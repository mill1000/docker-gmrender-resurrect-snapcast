# Build image
FROM alpine:3.22 AS build
ARG UUID
RUN apk add --update build-base autoconf automake libtool pkgconfig gstreamer-dev uuidgen
WORKDIR /pupnp
COPY pupnp .
RUN ./bootstrap && ./configure --enable-ipv6 --enable-reuseaddr --disable-blocking-tcp-connections
RUN make && make install && make install DESTDIR=/pupnp-install
WORKDIR /gmrender-resurrect
COPY gmrender-resurrect .
RUN ./autogen.sh && ./configure CPPFLAGS="-DGMRENDER_UUID='\"${UUID:-`uuidgen`}\"'"
RUN make && make install DESTDIR=/gmrender-resurrect-install

# Run image
FROM alpine:3.22
COPY --from=build /pupnp-install /
COPY --from=build /gmrender-resurrect-install /
RUN apk add --update tini gstreamer gstreamer-tools gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
RUN adduser -D -H gmediarender
USER gmediarender
ENV FRIENDLY_NAME=
ENV UUID=
ENV OPTIONS=
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/sh", "-c", "eval /usr/local/bin/gmediarender --logfile=stdout ${FRIENDLY_NAME:+-f \"$FRIENDLY_NAME\"} ${UUID:+--uuid \"$UUID\"} $OPTIONS"]
