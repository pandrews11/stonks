#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /stonks/tmp/pids/server.pid

if [ "${1}" == "./bin/rails" ] && [ "${2}" == "server" ]; then
  ./bin/rails db:prepare
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "${@}"
