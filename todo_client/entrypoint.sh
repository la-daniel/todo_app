#!/bin/bash
# Docker entrypoint script.


#exec mix ecto.migrate

#exec mix run priv/repo/seeds.exs

exec mix phx.server
