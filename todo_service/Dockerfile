# ./Dockerfile

# Extend from the official Elixir image.
FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client inotify-tools

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex package manager.
# By using `--force`, we don’t need to type “Y” to confirm the installation.
RUN mix local.hex --force

RUN mix local.rebar --force

RUN mix deps.get

# Compile the project.
RUN mix do compile

RUN ["chmod", "+x", "/app/entrypoint.sh"]

CMD ["/app/entrypoint.sh"]
