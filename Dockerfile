# to run this container you need to add --cap-add=sys_nice

FROM ubuntu:22.04 as builder
RUN apt update \
    && apt install -y apt-utils \
    git net-tools wget curl sudo \
    time ncat build-essential cmake \
    autoconf automake flex gawk m4 libtool \
    libcap2-bin libbz2-dev zlib1g-dev \
    && useradd -ms /bin/bash hercules \
    && adduser hercules sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER hercules
WORKDIR /home/hercules
RUN cd ~ \
    && git clone https://github.com/wrljet/hercules-helper.git \
    && mkdir herctest && cd herctest \
    && ~/hercules-helper/hercules-buildall.sh --auto

FROM ubuntu:22.04
RUN apt update \
    && apt install -y libcap2-bin \
    && useradd -ms /bin/bash hercules
USER hercules
WORKDIR /home/hercules
ENV PATH="/home/hercules/herctest/herc4x/bin:${PATH}"
ENV LD_LIBRARY_PATH="/home/hercules/herctest/herc4x/lib"
COPY --from=builder /home/hercules/herctest/herc4x/ /home/hercules/herctest/herc4x