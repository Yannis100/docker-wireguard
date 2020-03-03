FROM debian:buster-slim

# base on: https://github.com/masipcat/wireguard-go-docker
# need --cap-add=NET_ADMIN and --device=/dev/net/tun

# debian install
# https://www.wireguard.com/install/
RUN echo "deb http://deb.debian.org/debian/ unstable main" | tee /etc/apt/sources.list.d/unstable-wireguard.list && \
    printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' | tee /etc/apt/preferences.d/limit-unstable && \
    apt update && \
    apt -y install vim git wget curl make busybox qrencode iptables && \
    apt -y --no-install-recommends install wireguard-tools && \
    wget https://dl.google.com/go/go1.13.8.linux-amd64.tar.gz && \
    tar -xvf go1.13.8.linux-amd64.tar.gz && \
    mv go /usr/local && \
	export PATH=$PATH:/usr/local/go/bin

# wireguard-go
# https://git.zx2c4.com/wireguard-go/about/
RUN cd /root && \
    git clone https://git.zx2c4.com/wireguard-go && \
    cd wireguard-go && \
    make && \
    cp wireguard-go /usr/bin/

# tools: https://github.com/faicker/wg_config
RUN cd /root && \
    git clone https://github.com/adrianmihalko/wg_config

CMD wireguard-go -f wg0
