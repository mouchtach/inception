COMPOSE := docker-compose -f ./srcs/docker-compose.yml
DATA_DIRS := ./wordpress_data ./mariadb_data ./portainer_data

all: up

up:
	@mkdir -p $(DATA_DIRS)
	@$(COMPOSE) up -d 

down:
	@$(COMPOSE) down --volumes 

stop:
	@$(COMPOSE) stop 

restart: clean down up
	
build:
	@$(COMPOSE) build 
	
start:
	@$(COMPOSE) start 

clean:
	@rm -rf $(DATA_DIRS)

logs:
	@$(COMPOSE) logs -f

status:
	@docker ps

.PHONY: all up down stop restart build start clean status 
