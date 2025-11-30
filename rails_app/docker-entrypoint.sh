#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for postgres to be ready
echo "Waiting for PostgreSQL..."
until pg_isready -h postgres -p 5432 -U smartresume_user; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done
echo "PostgreSQL is up!"

# Create and migrate database
bin/rails db:create db:migrate

# Seed database if needed
bin/rails db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
