FROM alpine/bombardier:latest

# COPY ./stop-russia /stop-russia
WORKDIR /stop-russia

# ENTRYPOINT ["sh"]
# CMD ["stop.sh"]

FROM monstrenyatko/alpine


RUN apk update && \
    apk add iptables ip6tables wireguard-tools && \
    # clean-up
    rm -rf /root/.cache && mkdir -p /root/.cache && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# remove sysctls call from the wg-quick script to avoid `--privilege` option
# required run option `--sysctls net.ipv4.conf.all.src_valid_mark=1` to keep same functionality
COPY wg-quick.patch /
RUN buildDeps='patch'; \
    apk add $buildDeps && \
    patch --verbose -p0 < /wg-quick.patch && \
    # clean-up
    apk del $buildDeps && \
    rm -rf /root/.cache && mkdir -p /root/.cache && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

ENV APP_NAME="vpnc-app"

COPY run.sh /app/
RUN apk --no-cache add curl && \
    apk --no-cache add nano && \
    apk --no-cache add iputils && \
    apk --no-cache add git && \
    git clone https://github.com/abagayev/stop-russia.git /stop-russia && \
    cp -r stop-russia/strategies/ / && \
    cp /stop-russia/resources.txt /resources.txt && \
    rm -rf /root/.cache && mkdir -p /root/.cache && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

    # apk --no-cache add python3 && \
    # apk --no-cache add py3-pip && \

RUN mkdir -p /gopath

# COPY --from=0 /stop-russia /stop-russia
COPY --from=0 /gopath/bin/bombardier /usr/local/bin/
RUN cp /stop-russia/resources.txt /resources.txt
    
RUN chown -R root:root /app
RUN chmod -R 0644 /app
RUN find /app -type d -exec chmod 0755 {} \;
RUN find /app -type f -name '*.sh' -exec chmod 0755 {} \;

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
    CMD curl -L 'https://api.ipify.org'

ENTRYPOINT ["/app/run.sh"]
CMD ["vpnc-app"]
