FROM debian:latest
RUN apt-get update && apt-get install -yq apt-utils git net-tools wget curl sudo time ncat build-essential cmake autoconf automake flex gawk m4 libtool libcap2-bin libbz2-dev zlib1g-dev
# Create our user
RUN useradd -ms /bin/bash hercules && adduser hercules sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER hercules
WORKDIR /home/hercules

RUN cd ~
RUN git clone https://github.com/wrljet/hercules-helper.git
RUN mkdir herctest && cd herctest && ~/hercules-helper/hyperion-buildall.sh --auto