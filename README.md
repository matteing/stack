# Stack

This is my boilerplate for new Elixir/Phoenix-based applications. It includes a fully functional authentication system, integration with Next.js and common utilities like a mailer and API routes.

I optimize for developer happiness and forward-looking (yet rock-solid) technology. The setup is structured as a monorepo for ease of development.

## Quick start

```
export FOLDER=folder; git --git-dir=/dev/null clone --depth=1 https://github.com/matteing/stack $FOLDER; cd $FOLDER; make install; rm -rf .git
```

## Methodology

I'm in the process of writing an article detailing my methodology to building new software. Stay tuned.

## Structure

- `.vscode`: project-specific editor configuration
- `app`: NextJS, Tailwind, Next-Auth boilerplate
- `server`: Phoenix boilerplate with additional components
- `.buildpacks`: PaaS deployment using heroku-buildpack-monorepo
- `Makefile`: management scripts

## Installation

To setup this boilerplate:

- Install the boilerplate by running `make install`
- Run `make dev` to start the development servers

Now you can visit [`localhost:3000`](http://localhost:3000) and [`localhost:4000`](http://localhost:4000) from your browser.

## Deploying

Deploying this repo is usually as simple as deploying any other Node or Elixir app, with a couple of caveats related mostly to the monorepo structure.

1. Create a two PaaS apps: one for the frontend and another for the API.
2. Set the APP_BASE environment variable depending on the PaaS app.
3. Deploy, the monorepo buildpack will take care of setting the PaaS container root.

For more deployment guides, please [check the Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Why this stack?

I like React. I've tried to go back to the good ol' days of server rendered multi-page apps, but React just spoiled me.

In terms of the API, Phoenix is the next logical step up from my previous stack (Django). Elixir is a very pleasaant language and the first-class support for realtime is awesome. You don't always need it, but when you do, you know you won't have major issues.

Deploying/scaling realtime Django was a big pain in the past and I don't want to go through that again. Elixir is concurrent and realtime by nature and that makes it dope.
