# --- Étape 1 : Compilation ---
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


# --- Étape 2 : Runtime de production ---
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl3 \
    python3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/rust/target/release/moshi-server /usr/local/bin/moshi-server
COPY rust/ /app/rust/

ENV HF_HOME=/data/hf-cache
VOLUME ["/data/hf-cache"]

ENTRYPOINT ["moshi-server"]
CMD ["--help"]