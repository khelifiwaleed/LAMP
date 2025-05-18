welcome:
	@echo " ${GREEN}  PPPP    RRRR    OOO   J   J   EEEEE   CCCC   TTTTT   ${RESET} "
	@echo " ${GREEN}  P   P   R   R  O   O  J   J   E       C        T     ${RESET} "
	@echo " ${GREEN}  PPPP    RRRR   O   O  JJJJJ   EEEE    C        T     ${RESET} "
	@echo " ${GREEN}  P       R  R   O   O  J   J   E       C        T     ${RESET} "
	@echo " ${GREEN}  P       R   R   OOO   J   J   EEEEE   CCCC     T     ${RESET} "
	@echo ''
	@echo '          version: ${PROJECT_VERSION}       '
	@echo '============================================'

## @Application Display application version
version: welcome
	@cat VERSION
	@printf "\n"

## @Make Install and Start application
start: build-env docker-up composer-install
	$(shell echo "INSTALL_DATE=$(shell date +%Y%m%d%H%M%S)" > .install)
	$(call notify,Successful install project\nWelcome !! now execute < make start > to launch all services in the project.)
	@printf " - Successful ${GREEN}start application${RESET} project\n"
	@printf " - Now Start Commande: ${GREEN}make console doctrine:migrations:migrate${RESET} \n"

## @Make Stop application
stop: docker-stop
	$(call notify,Successful stopping of application)
	@printf " - Successful ${GREEN}stopping${RESET} of the application\n"

## @Mysql Connect
mysql:
	docker exec -it mariadb-container bash -c "mariadb -u root -proot $(DATABASE_NAME)"

## @Build Build environment configuration
build-env:
	@printf " - Build ${GREEN}.env${RESET} \n"
	$(shell cat ${PWD}/etc/.env.dist > .env)
	$(shell echo "UID=$(UID)" >> .env)
	$(shell echo "GID=$(GID)" >> .env)
	$(shell echo "USER_NAME=$(USER_NAME)" >> .env)
	$(shell echo "LOCAL_USER=$(UID):$(GID)" >> .env)
	$(shell echo "PATH=$(PATH)" >> .env)
	$(shell echo "PWD=$(PWD)" >> .env)
	$(shell echo "COMPOSER_HOME=$(COMPOSER_HOME)" >> .env)
	$(shell echo "NPM_CACHE=$(NPM_CACHE)" >> .env)
	$(shell echo "MKCERT_HOME=$(MKCERT_HOME)" >> .env)
	$(shell echo "IMAGE_TAG=$(IMAGE_TAG)" >> .env)
	$(shell echo "DATABASE_URL=mysql://$(DATABASE_USER):$(DATABASE_PASSWORD)@db:$(DATABASE_PORT)/$(DATABASE_NAME)" >> .env)
	$(shell mkdir -p vendor > /dev/null 2>&1 )

## @Console All Console Commend "bin/console"
console:
	@printf " - ${GREEN}Symfony Command: $(wordlist 2, 99, $(MAKECMDGOALS))${RESET} \n"
	@docker exec -it php-fpm bash -c "bin/console $(wordlist 2, 99, $(MAKECMDGOALS))"

# Docker Pull all docker images
# Récupère les dernières images pour tous les services définis dans le fichier docker-compose.
# L'option --ignore-pull-failures permet de continuer même si certaines images ne peuvent pas être récupérées.
docker-up:
	chmod +x bin/docker-compose
	@bin/docker-compose

# @Docker Commande pour arrêter et supprimer tous les conteneurs Docker
docker-stop:
	@echo "Stopping and removing all Docker containers..."
	@if [ -n "$$(docker ps -aq)" ]; then \
		docker rm -f $$(docker ps -aq); \
		else \
			echo "No containers to remove."; \
		fi

# Install All Dependency Project
composer-install:
	@echo "Install All Dependency Project"
    $(shell composer install --no-scripts)

## @Composer All Composer Commend
composer:
	@printf " - ${GREEN}Symfony Command: $(wordlist 2, 99, $(MAKECMDGOALS))${RESET} \n"
	@docker exec -it php-fpm bash -c "composer $(wordlist 2, 99, $(MAKECMDGOALS))"

