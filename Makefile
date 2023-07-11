ifneq (,$(wildcard ./.env))
	include ./.env
endif


start-init: ## Создаёт локальные .env и docker-compose.yml файлы. Настройте их как вам удобно
	@echo "Копируем файлы окружения..."
	@if [ ! -f .env ]; then \
		cp .dev/init/.env.dist .env; \
	fi; \
	if [ ! -f docker-compose.yml ]; then \
		cp .dev/init/docker-compose.yml.dist docker-compose.yml; \
	fi;
	@echo "Файлы окружения скопированы."

up: docker-clear docker-start php-init install finished

docker-clear:
	@echo "Стираем все ранее созданные контейнеры...\n"
	docker-compose down -v --remove-orphans; \

docker-start:
	@echo "Запускаем контейнеры...\n"
	docker-compose up -d; \

php-init:
	@echo "Инициализируем среду разработки...\n"
	php init --silent=y --overwrite=All --env=Development; \

install:
	@echo "Устанавливаем зависимости...\n"
	composer install --prefer-dist --no-interaction; \

finished:
	@echo "-------------------------------------------------------------------------------------------"; \
	echo "Docker окружение запущено."; \
	echo "Эндпоинты окружения: "; \
	echo "1. Сайт: http://localhost:8010"; \
	echo "2. БД: http://localhost:8011 : user/password | ${DB_USER}/${DB_PASSWORD}";