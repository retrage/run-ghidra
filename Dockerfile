FROM ghcr.io/blacktop/ghidra:latest

# Install dependencies
RUN apt-get update \
  && apt-get -yq upgrade \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    wget \
    unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]