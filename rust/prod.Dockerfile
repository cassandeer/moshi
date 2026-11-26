FROM nvidia/cuda:12.4.1-devel-ubuntu22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    clang \
    pkg-config \
    libssl-dev \
    curl \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app/rust
COPY rust/ .
RUN cargo build --release --bin moshi-server --features cuda


FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl3 \
    python3 \
    libpython3.10 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/rust/target/release/moshi-server /usr/local/bin/moshi-server
COPY rust/ /app/rust/

RUN mkdir /configs
COPY ./rust/configs/stt-1b-en_fr.toml /configs/stt-1b-en_fr.toml
COPY ./rust/prod.entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]