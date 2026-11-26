# Moshi — Docker Fork & Rust Deployment

This fork makes it easier to deploy and configure [**moshi-server**](https://github.com/kyutai-labs/moshi) by kyutai-labs (Rust server) in containerized environments using **Docker** and **Docker Compose**, while allowing you to override key settings (API route path, batch size, and model/tokenizer file paths) via environment variables without editing the `.toml` file.

---

## Quickstart — Deploy `moshi-server` (Rust) with Docker

### 1. Prerequisites
* [**Docker**](https://docs.docker.com/engine/) and [**Docker Compose**](https://docs.docker.com/compose/) installed with [Nvidia container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).
* For NVIDIA GPU usage (CUDA runtime `12.4.1`): up-to-date NVIDIA drivers.

### 2. Download STT models

Create `models` folder and get the model from [Hugging Face](https://huggingface.co/kyutai/stt-1b-en_fr-candle):

```bash
mkdir -p models/stt-1b-en_fr-candle

# If you don't have hf CLI
curl -LsSf https://hf.co/cli/install.sh | bash

# Download all the models
hf download kyutai/stt-1b-en_fr-candle --local-dir models/stt-1b-en_fr-candle
```


### 3. Configure environment variables
Create a `.env` file at the root of the repository (or set the variables in `compose.yaml` or your shell):

```env
# Optional ASR module overrides (falls back to .toml values when unset)
MOSHI_ASR_PATH=/api/asr-streaming
MOSHI_ASR_BATCH_SIZE=8
MOSHI_LM_MODEL_FILE=/models/stt-1b-en_fr-candle/model.safetensors
MOSHI_TEXT_TOKENIZER_FILE=/models/stt-1b-en_fr-candle/tokenizer_en_fr_audio_8000.model
MOSHI_AUDIO_TOKENIZER_FILE=/models/stt-1b-en_fr-candle/mimi-pytorch-e351c8d8@125.safetensors
```

### 4. Launch moshi-server

```bash
make build && make up

# To get your server logs
make logs

# To stop your server
make down
```