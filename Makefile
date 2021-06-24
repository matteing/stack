.PHONY: install app api migrate
SHELL := /bin/bash
CONCURRENTLY := ./app/node_modules/.bin/concurrently

install:
	mix deps.get
	mix setup
	cd app; npm install
	mix test
	[ -f ./boilerplate.exs ] && elixir boilerplate.exs

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
