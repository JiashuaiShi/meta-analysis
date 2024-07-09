# Dockerfile for Krona Visualization
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    perl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Krona
RUN git clone https://github.com/marbl/Krona.git \
    && cd Krona/KronaTools \
    && ./install.pl --prefix /usr/local

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/ktImportTaxonomy"]
