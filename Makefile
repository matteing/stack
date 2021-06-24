.PHONY: install app api migrate
SHELL := /bin/bash
CONCURRENTLY := ./app/node_modules/.bin/concurrently

install:
	[ -f ./boilerplate.exs ] && elixir boilerplate.exs
	mix deps.get
	cd app; npm install
	mix ecto.create
	mix test

dev:
	$(CONCURRENTLY) \
		-n api,app \
		"mix phx.server" \
		"npm run dev --prefix ./app" \
		-c "bgGreen.bold,bgCyan.bold"

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
