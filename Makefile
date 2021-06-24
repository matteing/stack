.PHONY: install app api migrate
SHELL := /bin/bash
CONCURRENTLY := ./app/node_modules/.bin/concurrently

install:
	mix deps.get
	[ -f ./boilerplate.exs ] && mix run boilerplate.exs
	mix setup
	cd app; npm install
	mix test

dev:
	$(CONCURRENTLY) \
		-n api,app \
		"mix phx.server" \
		"npm run dev --prefix ./app" \
		-c "bgBlue.bold,bgMagenta.bold"

app:
	cd app; npm run dev

api:
	mix phx.server

migrate:
	mix ecto.migrate

test:
	mix test

coverage:
	mix test --cover