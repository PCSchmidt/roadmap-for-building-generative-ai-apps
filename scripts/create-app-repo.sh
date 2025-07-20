#!/bin/bash

# Script to create a new app repository from template
# Usage: ./create-app-repo.sh [app-name]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if app name is provided
if [ -z "$1" ]; then
    print_error "Please provide an app name"
    echo "Usage: $0 [app-name]"
    echo "Example: $0 journal-summarizer"
    exit 1
fi

APP_NAME="$1"
REPO_NAME="generative-ai-$APP_NAME"
TEMPLATE_DIR="$(dirname "$0")/../templates"

print_status "Creating new app repository: $REPO_NAME"

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

# Create repository on GitHub
print_status "Creating GitHub repository..."
gh repo create "$REPO_NAME" --public --clone --description "AI-powered mobile app: part of 10 Generative AI Apps portfolio"

# Navigate to the repository
cd "$REPO_NAME"

print_status "Setting up repository structure..."

# Create directory structure
mkdir -p frontend/{src,assets,components,screens,services}
mkdir -p backend/{app,tests,models,routers,services}
mkdir -p docs/{api,deployment,tutorials}
mkdir -p demos/{screenshots,videos}
mkdir -p .github/{workflows,ISSUE_TEMPLATE,PULL_REQUEST_TEMPLATE}
mkdir -p deployment/{docker,kubernetes,render}

# Copy template files
print_status "Copying template files..."

# Copy and customize README
if [ -f "$TEMPLATE_DIR/README-template.md" ]; then
    cp "$TEMPLATE_DIR/README-template.md" README.md
    
    # Replace placeholders
    APP_NAME_TITLE=$(echo "$APP_NAME" | sed 's/-/ /g' | sed 's/\b\w/\U&/g')
    sed -i "s/\[APP_NAME\]/$APP_NAME_TITLE/g" README.md
    sed -i "s/\[app-name\]/$APP_NAME/g" README.md
    
    print_success "README.md created and customized"
else
    print_warning "README template not found, creating basic README"
    echo "# $REPO_NAME" > README.md
fi

# Copy other template files
for file in package-template.json requirements-template.txt .gitignore-template .env.example LICENSE; do
    if [ -f "$TEMPLATE_DIR/$file" ]; then
        cp "$TEMPLATE_DIR/$file" "${file%-template}"
        print_success "Copied $file"
    fi
done

# Create frontend package.json
cat > frontend/package.json << EOF
{
  "name": "$REPO_NAME-frontend",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "web": "expo start --web",
    "build": "expo build",
    "test": "jest"
  },
  "dependencies": {
    "expo": "~49.0.0",
    "react": "18.2.0",
    "react-native": "0.72.0",
    "axios": "^1.5.0",
    "react-navigation": "^6.0.0"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0",
    "jest": "^29.6.0"
  }
}
EOF

# Create backend requirements.txt
cat > backend/requirements.txt << EOF
fastapi>=0.100.0
uvicorn[standard]>=0.23.0
langchain>=0.1.0
python-multipart>=0.0.6
python-dotenv>=1.0.0
pydantic>=2.0.0
requests>=2.31.0
pytest>=7.4.0
EOF

# Create backend main.py
cat > backend/app/main.py << EOF
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(
    title="$APP_NAME_TITLE API",
    description="Backend API for $APP_NAME_TITLE mobile app",
    version="1.0.0"
)

# CORS middleware for React Native
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class HealthResponse(BaseModel):
    status: str
    message: str

@app.get("/", response_model=HealthResponse)
@app.get("/health", response_model=HealthResponse)
async def health_check():
    return HealthResponse(
        status="healthy",
        message="$APP_NAME_TITLE API is running"
    )

# Add your app-specific endpoints here
EOF

# Create GitHub Actions workflow
cat > .github/workflows/ci.yml << EOF
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test-backend:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up Python
      uses: actions/setup-python@v3
      with:
        python-version: '3.9'
    - name: Install dependencies
      run: |
        cd backend
        pip install -r requirements.txt
    - name: Run tests
      run: |
        cd backend
        pytest

  test-frontend:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    - name: Install dependencies
      run: |
        cd frontend
        npm install
    - name: Run tests
      run: |
        cd frontend
        npm test
EOF

# Create issue template
cat > .github/ISSUE_TEMPLATE/bug_report.md << EOF
---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
 - OS: [e.g. iOS]
 - App version [e.g. 1.0.0]
 - Device [e.g. iPhone 12]

**Additional context**
Add any other context about the problem here.
EOF

# Create contributing guidelines
cat > CONTRIBUTING.md << EOF
# Contributing to $APP_NAME_TITLE

Thank you for your interest in contributing! Please read our guidelines below.

## Getting Started

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Run the test suite
6. Submit a pull request

## Development Setup

See README.md for detailed setup instructions.

## Code Style

- Follow existing code patterns
- Use meaningful variable names
- Add comments for complex logic
- Update documentation as needed

## Pull Request Process

1. Update the README.md with details of changes if applicable
2. Update version numbers following semantic versioning
3. Ensure all tests pass
4. Request review from maintainers
EOF

# Initialize git and make initial commit
print_status "Creating initial commit..."
git add .
git commit -m "Initial commit: $APP_NAME_TITLE app structure

- Added complete project structure
- Configured frontend (React Native) and backend (FastAPI)
- Set up GitHub Actions CI/CD
- Added comprehensive documentation
- Part of 10 Generative AI Apps portfolio"

# Push to GitHub
print_status "Pushing to GitHub..."
git push origin main

print_success "Repository $REPO_NAME created successfully!"
print_status "Repository URL: https://github.com/$(gh api user --jq .login)/$REPO_NAME"

echo ""
echo "Next steps:"
echo "1. Edit README.md to add app-specific details"
echo "2. Configure environment variables in .env"
echo "3. Implement app-specific functionality"
echo "4. Add to the main roadmap repository"
echo ""
echo "Happy coding! 🚀"
