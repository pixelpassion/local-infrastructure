.PHONY: help

POSTGRES_SERVICE=postgres
REDIS_SERVICE=redis

help: # This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


##########################
### Database           ###
##########################

db-reset: ## Resets database
	@echo "\033[92m(1/6) Resetting the database...\033[0m"
	./bin/reset_db.sh
	@echo "\033[92mDone!\033[0m"

db-export: ## Resets database
	@echo "\033[92m(1/6) Exporting the database...\033[0m"
	./bin/export_db.sh
	@echo "\033[92mDone!\033[0m"

db-shell: ## Starts psql
	@echo "\033[92mStarting psql, copied '\q' into clipboard ...\033[0m"
	echo "\q" | pbcopy || true
	psql -h localhost -U postgres -d postgres

db-logs: ## shows logs of Postgres container
	docker logs $(docker ps -a -q -f name="$POSTGRES_SERVICE")

##########################
### Redis              ###
##########################

redis-reset-cache: ## Reset Redis cache
	redis-cli FLUSHALL
	redis-cli FLUSHDB

redis-mon: ## Redis Monitor for Default Cache
	redis-cli -n 1 monitor

redis-logs: ## Show logs of Redis container
	docker logs -f $(docker ps -a -q -f name="$REDIS_SERVICE")

##########################
### Docker             ###
##########################

up: ## Start the Docker containers
	docker-compose up

down: ## Stop the Docker containers
	docker-compose down

up-build: ## Start the Docker container
	docker-compose up --build redis postgres

docker-events: ## Show events from Docker
	docker events --since 60m

docker-info: ## Get an Docker overview
	@echo "\033[92mCONTAINERS: \033[0m"
	docker ps
	@echo ""
	@echo "\033[92mIMAGES: \033[0m"
	docker images
	@echo ""
	@echo "\033[92mVOLUMES: \033[0m"
	docker volume ls

docker-prune: ## clean all that is not actively used
	docker system prune -af

docker-clean: ## Clean Docker images, containers, volumes
	@echo "\033[92mFull Clean up of Docker... \033[0m"
	./bin/clean_docker.sh


##########################
### Support            ###
##########################

debug: ## Prints debug informations
	@echo "\033[92mCollecting debug information...\033[0m"
	./bin/debug.sh

tmate: ## Prints debug informations
	@echo "\033[92mSlack username to receive the link (e.g. jens)?\033[0m"
	./bin/tmate.sh


###################
### Internal    ###
###################

colors:
	@echo "\033[92mGreen!\033[0m"
	@echo "\x1b[33;01mYellow!\033[0m"
	@echo "\x1b[31;01mRed!\033[0m"

dirs:
	@echo $prog

%:
    @: