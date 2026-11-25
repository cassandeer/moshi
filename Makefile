.PHONY: help build up down logs build-prod prod down-prod ps

# Détection automatique de `docker compose` (v2) ou `docker-compose` (v1)
COMPOSE := $(shell command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1 && echo "docker compose" || echo "docker-compose")

# Fichiers Compose et variables d'environnement
DEV_COMPOSE   := compose.yaml
PROD_COMPOSE  := prod.compose.yaml

# Cible par défaut
help:
	@echo "Commandes disponibles :"
	@echo "  make build       - Construit les images de développement"
	@echo "  make up          - Démarre l'environnement de développement en arrière-plan"
	@echo "  make down        - Arrête et supprime les conteneurs de développement"
	@echo "  make logs        - Affiche les logs des services en temps réel"
	@echo "  make build-prod  - Construit les images de production (sans cache)"
	@echo "  make prod        - Démarre l'environnement de production"
	@echo "  make down-prod   - Arrête les conteneurs de production"
	@echo "  make ps          - Liste l'état des conteneurs"

# --- DÉVELOPPEMENT ---

build:
	$(COMPOSE) -f $(DEV_COMPOSE) build

up:
	$(COMPOSE) -f $(DEV_COMPOSE) up -d

down:
	$(COMPOSE) -f $(DEV_COMPOSE) down

logs:
	$(COMPOSE) -f $(DEV_COMPOSE) logs -f

# --- PRODUCTION ---

build-prod:
	$(COMPOSE) -f $(PROD_COMPOSE) build --no-cache --pull

prod:
	$(COMPOSE) -f $(PROD_COMPOSE) up -d --remove-orphans

down-prod:
	$(COMPOSE) -f $(PROD_COMPOSE) down

ps:
	$(COMPOSE) -f $(DEV_COMPOSE) ps