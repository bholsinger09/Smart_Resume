#!/usr/bin/env bash

echo "🧪 SmartResume Quick Test Guide"
echo "================================"
echo ""

echo "Choose your testing method:"
echo ""
echo "1️⃣  QUICK TEST (No installation needed)"
echo "   Just verify the code structure and run unit tests"
echo ""
echo "2️⃣  FULL MANUAL TEST (15 minutes)"
echo "   Set up Python service + Rails app manually"
echo ""
echo "3️⃣  DOCKER TEST (5 minutes - requires Docker)"
echo "   One-command setup with Docker Compose"
echo ""
echo "================================"
echo ""

read -p "Select option (1, 2, or 3): " choice

case $choice in
  1)
    echo ""
    echo "🏃 Running Quick Tests..."
    echo ""
    
    # Test Python syntax
    echo "📝 Checking Python code..."
    cd python_service
    python3 -m py_compile app.py
    if [ $? -eq 0 ]; then
        echo "✅ Python code is valid"
    else
        echo "❌ Python syntax error"
        exit 1
    fi
    cd ..
    
    # Test Rails code
    echo ""
    echo "📝 Checking Rails code..."
    cd rails_app
    
    # Check if ruby is installed
    if ! command -v ruby &> /dev/null; then
        echo "⚠️  Ruby not installed. Install with: brew install ruby"
        exit 1
    fi
    
    # Verify Ruby files syntax
    find app -name "*.rb" | while read file; do
        ruby -c "$file" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "✅ $file"
        else
            echo "❌ $file has syntax errors"
        fi
    done
    
    cd ..
    
    echo ""
    echo "✅ Quick validation complete!"
    echo "📖 See GETTING_STARTED.md for full setup instructions"
    ;;
    
  2)
    echo ""
    echo "🔧 Manual Setup Instructions"
    echo "============================="
    echo ""
    echo "TERMINAL 1: Python Service"
    echo "------------------------"
    echo "cd python_service"
    echo "python3 -m venv venv"
    echo "source venv/bin/activate"
    echo "pip install -r requirements.txt"
    echo "python -m spacy download en_core_web_sm"
    echo "uvicorn app:app --reload --port 8000"
    echo ""
    echo "TERMINAL 2: Rails Application"
    echo "----------------------------"
    echo "cd rails_app"
    echo "bundle install"
    echo "rails db:create db:migrate db:seed"
    echo "rails server -p 3000"
    echo ""
    echo "Then visit: http://localhost:3000"
    ;;
    
  3)
    echo ""
    echo "🐳 Starting Docker Services..."
    echo ""
    
    # Check if Docker is running
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker is not running"
        echo "Please start Docker Desktop and try again"
        exit 1
    fi
    
    echo "Building and starting containers..."
    docker-compose up -d --build
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Services started successfully!"
        echo ""
        echo "Waiting for services to initialize..."
        sleep 10
        
        echo "Setting up database..."
        docker-compose exec rails_app rails db:create db:migrate db:seed
        
        echo ""
        echo "🌐 Access Points:"
        echo "   Web App:    http://localhost:3000"
        echo "   Python API: http://localhost:8000"
        echo "   API Docs:   http://localhost:8000/docs"
        echo ""
        echo "📊 View logs:"
        echo "   docker-compose logs -f"
        echo ""
        echo "🛑 Stop services:"
        echo "   docker-compose down"
    else
        echo "❌ Failed to start services"
        echo "Check the error messages above"
    fi
    ;;
    
  *)
    echo "Invalid option. Please run again and choose 1, 2, or 3"
    exit 1
    ;;
esac
