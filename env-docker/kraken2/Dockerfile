# Dockerfile for Kraken2 Classification
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    perl \
    bzip2 \
    libncurses5-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Kraken2
RUN wget https://github.com/DerrickWood/kraken2/archive/v2.1.2.tar.gz \
    && tar -xzf v2.1.2.tar.gz \
    && cd kraken2-2.1.2 \
    && ./install_kraken2.sh /usr/local/bin

# Set the entrypoint
ENTRYPOINT ["kraken2"]
