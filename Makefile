.PHONY: install craft build dev dev-mysql postgres cms-postgres cms-mysql ssh stop

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

install: craft build dev

build:
	docker build -t $(COMPANY)/$(PROJECT) .

cms-mysql:
	docker run --rm \
	-d -p 80:80 \
	-e DB_DRIVER=mysql \
	-e DB_SERVER=$(PROJECT)-mysql \
	-e DB_USER=$(DB_USER) \
	-e DB_PASSWORD=$(DB_PASSWORD) \
	-e DB_DATABASE=$(DB_PREFIX)_$(PROJECT) \
	--link $(PROJECT)-mysql \
	--volume $(PWD)craft:/var/www \
	--name $(PROJECT)-craftcms $(COMPANY)/$(PROJECT)

cms-postgres:
	docker run --rm \
	-d -p 80:80 \
	-e DB_DRIVER=pgsql \
	-e DB_SERVER=$(PROJECT)-postgres \
	-e DB_USER=$(DB_USER) \
	-e DB_PASSWORD=$(DB_PASSWORD) \
	-e DB_DATABASE=$(DB_PREFIX)_$(PROJECT) \
	-e DB_SCHEMA=public \
	--link $(PROJECT)-postgres \
	--volume $(PWD)craft:/var/www \
	--name $(PROJECT)-craftcms $(COMPANY)/$(PROJECT)

craft:
	composer create-project craftcms/craft craft -s beta \
	&& rm craft/.env \
	&& mv craft/web craft/html

dev: mysql cms-mysql

dev-postgres: postgres cms-postgres

mysql:
	docker run --rm \
	-d -p 3306:3306 \
	-e MYSQL_USER=$(DB_USER) \
	-e MYSQL_ROOT_PASSWORD=$(DB_PASSWORD) \
	-e MYSQL_PASSWORD=$(DB_PASSWORD) \
	-e MYSQL_DATABASE=$(DB_PREFIX)_$(PROJECT) \
	-v $(PWD)craft/storage/mysql:/var/lib/mysql/ \
	--name $(PROJECT)-mysql mysql:$(MYSQL_VERSION)

postgres:
	docker run --rm \
	-d -p 5432:5432 \
	-e POSTGRES_USER=$(DB_USER) \
	-e POSTGRES_PASSWORD=$(DB_PASSWORD) \
	-e POSTGRES_DB=$(DB_PREFIX)_$(PROJECT) \
	-v $(PWD)craft/storage/postgres:/var/lib/postgresql/data \
	--name $(PROJECT)-postgres postgres:$(POSTGRES_VERSION)

ssh:
	docker exec -it $(PROJECT)-craftcms bash

stop:
	docker stop $(PROJECT)-craftcms $(PROJECT)-mysql $(PROJECT)-postgres
