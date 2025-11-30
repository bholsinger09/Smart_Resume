#!/usr/bin/env bash

echo "🧪 Running Tests for SmartResume..."
echo ""

# Test Python Service
echo "================================"
echo "🐍 Testing Python Service"
echo "================================"
cd python_service
if [ -d "venv" ]; then
    source venv/bin/activate
else
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    python -m spacy download en_core_web_sm
fi

pytest -v
python_exit_code=$?
deactivate
cd ..

echo ""
echo "================================"
echo "💎 Testing Rails Application"
echo "================================"
cd rails_app
if [ ! -d "vendor/bundle" ]; then
    bundle install
fi

bundle exec rspec
rails_exit_code=$?
cd ..

echo ""
echo "================================"
echo "📊 Test Summary"
echo "================================"
if [ $python_exit_code -eq 0 ]; then
    echo "✅ Python tests passed"
else
    echo "❌ Python tests failed (exit code: $python_exit_code)"
fi

if [ $rails_exit_code -eq 0 ]; then
    echo "✅ Rails tests passed"
else
    echo "❌ Rails tests failed (exit code: $rails_exit_code)"
fi

# Exit with error if any tests failed
if [ $python_exit_code -ne 0 ] || [ $rails_exit_code -ne 0 ]; then
    exit 1
fi

echo ""
echo "🎉 All tests passed!"
