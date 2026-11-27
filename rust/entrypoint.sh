#!/bin/sh
set -e

CONFIG_PATH="${MOSHI_CONFIG_PATH:-/configs/stt-1b-en_fr.toml}"
HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8080}"

cd /app/rust
exec cargo run --features cuda --bin moshi-server -r -- worker --config "$CONFIG_PATH" --addr "$HOST" --port "$PORT"