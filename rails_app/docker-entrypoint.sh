#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

echo "DATABASE_URL: ${DATABASE_URL:0:30}..." # Print first 30 chars for debugging
echo "RAILS_ENV: $RAILS_ENV"

# Run database migrations with retry logic
echo "Running database setup..."

MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  if bin/rails db:create 2>/dev/null || echo "Database already exists"; then
    echo "Database is accessible!"
    break
  fi
  
  RETRY_COUNT=$((RETRY_COUNT + 1))
  echo "Database not ready, attempt $RETRY_COUNT/$MAX_RETRIES..."
  sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
  echo "Failed to connect to database after $MAX_RETRIES attempts"
  exit 1
fi

# Run migrations
echo "Running migrations..."
bin/rails db:migrate

# Seed database if needed (skip in production)
if [ "$RAILS_ENV" != "production" ]; then
  echo "Seeding database..."
  bin/rails db:seed
fi

echo "Starting Rails server..."

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
