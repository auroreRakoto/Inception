build_solo:
	docker build -t inception .

build:
	docker compose -f srcs/docker-compose.yml build

up:
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down

start:
	docker compose -f srcs/docker-compose.yml start

stop:
	docker compose -f srcs/docker-compose.yml stop

ps:
	docker compose -f srcs/docker-compose.yml ps

image:
	docker images

run:
	docker run -it inception
