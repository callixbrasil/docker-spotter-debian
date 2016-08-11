FROM debian:jessie

ENV GOLANG_VERSION 1.6.3
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 cdde5e08530c0579255d6153b08fdb3b8e47caabbe717bc7bcd7561275a87aeb
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      wget \
      git \
      g++ \
      gcc \
      libc6-dev \
      make \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz \
    && git clone https://github.com/discordianfish/docker-spotter.git \
    && cd docker-spotter \
    && go get -d -v \
    && go build -o /bin/docker-spotter \
    && cd .. \
    && rm -rf docker-spotter \
    && rm -rf /go/src \
    && apt-get purge -y git g++ gcc libc6-dev make curl wget \
    && apt-get autoremove -y

ENTRYPOINT [ "/bin/docker-spotter" ]