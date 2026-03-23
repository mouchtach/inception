
all : up

up : 
	@mkdir -p ./wordpress_data
	@mkdir -p ./mariadb_data
	@docker-compose -f ./srcs/docker-compose.yml up 

down : 
	@docker-compose -f ./srcs/docker-compose.yml down

stop : 
	@docker-compose -f ./srcs/docker-compose.yml stop

restart : clean down up
	
build : 
	@docker-compose -f ./srcs/docker-compose.yml build
	
start : 
	@docker-compose -f ./srcs/docker-compose.yml start

clean : 
	@rm -rf ./wordpress_data
	@rm -rf ./mariadb_data

status : 
	@docker ps