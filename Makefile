COMPOSE := docker-compose -f ./srcs/docker-compose.yml
DATA_DIRS := ./wordpress_data ./mariadb_data ./portainer_data

all: up

up:
	@mkdir -p $(DATA_DIRS)
	@$(COMPOSE) up -d --build

down:
	@$(COMPOSE) down 

stop:
	@$(COMPOSE) stop 

re: clean down up
	
build:
	@$(COMPOSE) build 
	
start:
	@$(COMPOSE) start 

clean:
	@rm -rf $(DATA_DIRS)
	
fclean:
	@rm -rf $(DATA_DIRS)
	@$(COMPOSE) down -v --rmi all --remove-orphans
	@docker system prune -f --volumes

logs:
	@$(COMPOSE) logs -f

status:
	@docker ps

.PHONY: all up down stop restart build start clean status 
