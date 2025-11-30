#!/usr/bin/env bash

echo "🚀 Setting up SmartResume Application..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"

# Build and start services
echo "🔨 Building Docker containers..."
docker-compose build

echo "🚀 Starting services..."
docker-compose up -d postgres python_service

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 10

# Setup Rails database
echo "📊 Setting up Rails database..."
docker-compose run --rm rails_app rails db:create db:migrate db:seed

# Start Rails
echo "🌐 Starting Rails application..."
docker-compose up -d rails_app

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Access the application:"
echo "   Rails App: http://localhost:3000"
echo "   Python Service: http://localhost:8000"
echo "   Python API Docs: http://localhost:8000/docs"
echo ""
echo "🔧 Useful commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop services: docker-compose down"
echo "   Restart: docker-compose restart"
echo ""
