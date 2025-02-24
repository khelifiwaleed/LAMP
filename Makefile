# Load environment vars
include ${PWD}/etc/.env.dist
export $(shell sed 's/=.*//' ${PWD}/etc/.env.dist)

PROJECT_URL=https://${VIRTUAL_HOST}
MKCERT_HOME=$(HOME)/.local/share/mkcert
NPM_CACHE=$(HOME)/.npm
COMPOSER_HOME=$(HOME)/.composer
USER_NAME ?= $(shell id -u -n)
UID ?= $(shell id -u)
GID ?= $(shell id -g)
PWD ?= $(shell pwd)
PATH?=$(shell echo $PATH)
BASEURL=${PROJECT_URL}
FEATURE=all
KEEPALIVE=no

include etc/make/help.mk
include etc/make/command.mk
