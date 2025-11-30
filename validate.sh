#!/usr/bin/env bash

echo "🔍 SmartResume Project Validation"
echo "=================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter
passed=0
failed=0

# Check function
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((passed++))
    else
        echo -e "${RED}✗${NC} $1"
        ((failed++))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/"
        ((passed++))
    else
        echo -e "${RED}✗${NC} $1/"
        ((failed++))
    fi
}

echo "📄 Documentation Files"
check_file "README.md"
check_file "GETTING_STARTED.md"
check_file "DEVELOPMENT.md"
check_file "PROJECT_SUMMARY.md"
check_file "LICENSE"

echo ""
echo "🔧 Configuration Files"
check_file ".gitignore"
check_file "docker-compose.yml"
check_file "setup.sh"
check_file "run_tests.sh"
check_file "deploy.sh"

echo ""
echo "🐍 Python Service"
check_dir "python_service"
check_file "python_service/app.py"
check_file "python_service/test_app.py"
check_file "python_service/requirements.txt"
check_file "python_service/Dockerfile"
check_file "python_service/pyproject.toml"

echo ""
echo "💎 Rails Application"
check_dir "rails_app"
check_file "rails_app/Gemfile"
check_file "rails_app/Dockerfile"

echo ""
echo "   📁 Controllers"
check_dir "rails_app/app/controllers"
check_file "rails_app/app/controllers/application_controller.rb"
check_file "rails_app/app/controllers/home_controller.rb"
check_file "rails_app/app/controllers/jobs_controller.rb"
check_file "rails_app/app/controllers/resumes_controller.rb"
check_file "rails_app/app/controllers/matches_controller.rb"
check_file "rails_app/app/controllers/pwa_controller.rb"

echo ""
echo "   📁 Models"
check_dir "rails_app/app/models"
check_file "rails_app/app/models/job.rb"
check_file "rails_app/app/models/resume.rb"
check_file "rails_app/app/models/skill.rb"
check_file "rails_app/app/models/match.rb"
check_file "rails_app/app/models/job_skill.rb"
check_file "rails_app/app/models/resume_skill.rb"

echo ""
echo "   📁 Services"
check_dir "rails_app/app/services"
check_file "rails_app/app/services/python_skill_extraction_service.rb"
check_file "rails_app/app/services/job_matching_service.rb"

echo ""
echo "   📁 Views"
check_dir "rails_app/app/views/layouts"
check_file "rails_app/app/views/layouts/application.html.erb"
check_file "rails_app/app/views/home/index.html.erb"
check_dir "rails_app/app/views/jobs"
check_dir "rails_app/app/views/resumes"
check_dir "rails_app/app/views/matches"
check_dir "rails_app/app/views/pwa"

echo ""
echo "   📁 Config"
check_dir "rails_app/config"
check_file "rails_app/config/routes.rb"
check_file "rails_app/config/database.yml"
check_file "rails_app/config/application.rb"

echo ""
echo "   📁 Migrations"
check_dir "rails_app/db/migrate"
check_file "rails_app/db/migrate/20231130000001_create_jobs.rb"
check_file "rails_app/db/migrate/20231130000002_create_resumes.rb"
check_file "rails_app/db/migrate/20231130000003_create_skills.rb"
check_file "rails_app/db/migrate/20231130000006_create_matches.rb"

echo ""
echo "   📁 Tests"
check_dir "rails_app/spec"
check_file "rails_app/spec/rails_helper.rb"
check_file "rails_app/spec/spec_helper.rb"
check_dir "rails_app/spec/models"
check_dir "rails_app/spec/services"
check_dir "rails_app/spec/factories"

echo ""
echo "=================================="
echo "📊 Validation Summary"
echo "=================================="
echo -e "${GREEN}Passed: $passed${NC}"
if [ $failed -gt 0 ]; then
    echo -e "${RED}Failed: $failed${NC}"
else
    echo -e "${GREEN}Failed: 0${NC}"
fi

total=$((passed + failed))
echo "Total checks: $total"

echo ""
if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ All validation checks passed!${NC}"
    echo "🚀 Project is ready to use!"
    exit 0
else
    echo -e "${RED}❌ Some validation checks failed.${NC}"
    exit 1
fi
