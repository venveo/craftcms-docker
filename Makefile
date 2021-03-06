.PHONY: craft build run ssh stop

# Project information

COMPANY := venveo
PROJECT := docker-demo

# Database information

DB_USER := craftcms
DB_PREFIX := dev
DB_PASSWORD := CraftCMS1!
MYSQL_VERSION := 5.7
POSTGRES_VERSION := 9.5

# Helpers

MAKEPATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PWD := $(dir $(MAKEPATH))

craft:
	composer create-project craftcms/craft craft -s beta \
	&& rm craft/.env \
	&& mv craft/web craft/html

build:
	docker build -t $(COMPANY)/$(PROJECT) .

run:
	docker run --rm \
	-d -p 3306:3306 \
	-e MYSQL_USER=$(DB_USER) \
	-e MYSQL_ROOT_PASSWORD=$(DB_PASSWORD) \
	-e MYSQL_PASSWORD=$(DB_PASSWORD) \
	-e MYSQL_DATABASE=$(DB_PREFIX)_$(PROJECT) \
	-v $(PWD)storage/mysql:/var/lib/mysql/ \
	--name $(PROJECT)-mysql mysql:$(MYSQL_VERSION) \
	&& docker run --rm \
	-d -p 80:80 \
	-e DB_DRIVER=mysql \
	-e DB_SERVER=$(PROJECT)-mysql \
	-e DB_USER=$(DB_USER) \
	-e DB_PASSWORD=$(DB_PASSWORD) \
	-e DB_DATABASE=$(DB_PREFIX)_$(PROJECT) \
	-e DB_SCHEMA=public \
	--link $(PROJECT)-mysql \
	--volume $(PWD)craft:/var/www \
	--name $(PROJECT)-craftcms $(COMPANY)/$(PROJECT)

ssh:
	docker exec -it $(PROJECT)-craftcms bash

stop:
	docker stop $(PROJECT)-craftcms $(PROJECT)-mysql
