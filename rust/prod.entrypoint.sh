#!/bin/sh
set -e

CONFIG_PATH="${MOSHI_CONFIG_PATH:-/configs/stt-1b-en_fr.toml}"
HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8080}"

exec /usr/local/bin/moshi-server worker --config "$CONFIG_PATH" --addr "$HOST" --port "$PORT"