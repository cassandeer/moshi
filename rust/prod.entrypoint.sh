#!/bin/sh
set -e

cd /app/rust
exec cargo run --features cuda --bin moshi-server -r -- worker --config /configs/stt-1b-en_fr.toml