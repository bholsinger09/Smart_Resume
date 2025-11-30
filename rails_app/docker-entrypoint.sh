#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for postgres to be ready (parse DATABASE_URL if available)
if [ -n "$DATABASE_URL" ]; then
  echo "Waiting for PostgreSQL (from DATABASE_URL)..."
  
  # Extract host from DATABASE_URL (format: postgres://user:pass@host:port/db)
  DB_HOST=$(echo $DATABASE_URL | sed -E 's/.*@([^:]+):.*/\1/')
  DB_PORT=$(echo $DATABASE_URL | sed -E 's/.*:([0-9]+)\/.*/\1/')
  
  echo "Checking connection to $DB_HOST:$DB_PORT..."
  
  # Wait up to 30 seconds for database
  for i in {1..30}; do
    if pg_isready -h "$DB_HOST" -p "$DB_PORT" > /dev/null 2>&1; then
      echo "PostgreSQL is up!"
      break
    fi
    echo "PostgreSQL is unavailable - sleeping (attempt $i/30)"
    sleep 1
  done
else
  echo "No DATABASE_URL found, skipping database wait check"
fi

# Run database migrations (create will fail if db exists, that's ok)
echo "Running database setup..."
bin/rails db:create 2>/dev/null || echo "Database already exists"
bin/rails db:migrate

# Seed database if needed (in production, you may want to skip this)
if [ "$RAILS_ENV" != "production" ]; then
  bin/rails db:seed
fi

echo "Starting Rails server..."

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
