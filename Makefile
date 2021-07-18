.PHONY: install app api migrate
SHELL := /bin/bash
CONCURRENTLY := ./app/node_modules/.bin/concurrently
MIX := cd server; mix

install:
	$(MIX) deps.get
	cd app; npm install
	$(MIX) ecto.create
	$(MIX) test

dev:
	$(CONCURRENTLY) \
		-n api,app \
		"$(MIX) phx.server" \
		"npm run dev --prefix ./app" \
		-c "bgGreen.bold,bgCyan.bold"

app:
	cd app; npm run dev

api:
	$(MIX) phx.server

migrate:
	$(MIX) ecto.migrate

test:
	$(MIX) test

coverage:
	$(MIX) test --cover
