#!/bin/bash

# Setup script for the Generative AI Mobile Apps project
# This script sets up the development environment on Windows (using Git Bash)

set -e  # Exit on any error

echo "🚀 Setting up Generative AI Mobile Apps Development Environment"
echo "============================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Node.js installation
check_nodejs() {
    print_status "Checking Node.js installation..."
    
    if command_exists node; then
        NODE_VERSION=$(node --version)
        print_success "Node.js found: $NODE_VERSION"
        
        # Check if version is 18 or higher
        NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [ "$NODE_MAJOR" -ge 18 ]; then
            print_success "Node.js version is compatible (18+)"
        else
            print_warning "Node.js version should be 18 or higher. Please update."
        fi
    else
        print_error "Node.js not found. Please install Node.js 18+ from https://nodejs.org/"
        exit 1
    fi
    
    if command_exists npm; then
        NPM_VERSION=$(npm --version)
        print_success "npm found: v$NPM_VERSION"
    else
        print_error "npm not found. Please reinstall Node.js."
        exit 1
    fi
}

# Check Python installation
check_python() {
    print_status "Checking Python installation..."
    
    if command_exists python; then
        PYTHON_VERSION=$(python --version 2>&1)
        print_success "Python found: $PYTHON_VERSION"
        
        # Check if version is 3.9 or higher
        PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d' ' -f2 | cut -d'.' -f1)
        PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d' ' -f2 | cut -d'.' -f2)
        
        if [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -ge 9 ]; then
            print_success "Python version is compatible (3.9+)"
        else
            print_warning "Python version should be 3.9 or higher. Please update."
        fi
    else
        print_error "Python not found. Please install Python 3.9+ from https://python.org/"
        exit 1
    fi
    
    if command_exists pip; then
        PIP_VERSION=$(pip --version)
        print_success "pip found: $PIP_VERSION"
    else
        print_error "pip not found. Please reinstall Python."
        exit 1
    fi
}

# Check Git installation
check_git() {
    print_status "Checking Git installation..."
    
    if command_exists git; then
        GIT_VERSION=$(git --version)
        print_success "Git found: $GIT_VERSION"
    else
        print_error "Git not found. Please install Git from https://git-scm.com/"
        exit 1
    fi
}

# Create Python virtual environment
setup_python_env() {
    print_status "Setting up Python virtual environment..."
    
    if [ ! -d "ai-apps-env" ]; then
        python -m venv ai-apps-env
        print_success "Created virtual environment: ai-apps-env"
    else
        print_warning "Virtual environment already exists"
    fi
    
    print_status "Activating virtual environment..."
    
    # Activate virtual environment (Windows Git Bash)
    if [ -f "ai-apps-env/Scripts/activate" ]; then
        source ai-apps-env/Scripts/activate
        print_success "Virtual environment activated"
    else
        print_error "Failed to find virtual environment activation script"
        exit 1
    fi
    
    # Upgrade pip
    print_status "Upgrading pip..."
    python -m pip install --upgrade pip
    print_success "pip upgraded"
}

# Install Python dependencies
install_python_deps() {
    print_status "Installing Python dependencies..."
    
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
        print_success "Python dependencies installed"
    else
        print_warning "requirements.txt not found. Skipping Python dependencies."
    fi
}

# Install Node.js dependencies
install_nodejs_deps() {
    print_status "Installing Node.js dependencies..."
    
    if [ -f "package.json" ]; then
        npm install
        print_success "Node.js dependencies installed"
    else
        print_warning "package.json not found. Skipping Node.js dependencies."
    fi
}

# Install global tools
install_global_tools() {
    print_status "Installing global development tools..."
    
    # React Native CLI
    if ! command_exists react-native; then
        npm install -g @react-native-community/cli
        print_success "React Native CLI installed"
    else
        print_success "React Native CLI already installed"
    fi
    
    # Expo CLI
    if ! command_exists expo; then
        npm install -g @expo/cli
        print_success "Expo CLI installed"
    else
        print_success "Expo CLI already installed"
    fi
}

# Create environment file
setup_env_file() {
    print_status "Setting up environment file..."
    
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            cp .env.example .env
            print_success "Created .env file from .env.example"
            print_warning "Please edit .env file with your actual API keys"
        else
            print_warning ".env.example not found. Please create .env file manually."
        fi
    else
        print_success ".env file already exists"
    fi
}

# Create necessary directories
create_directories() {
    print_status "Creating project directories..."
    
    directories=("logs" "uploads" "downloads" "cache" "vector_store")
    
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            print_success "Created directory: $dir"
        fi
    done
}

# Verify installation
verify_installation() {
    print_status "Verifying installation..."
    
    # Test Python imports
    print_status "Testing Python packages..."
    python -c "
import sys
packages = ['langchain', 'fastapi', 'chromadb', 'sentence_transformers']
failed = []

for package in packages:
    try:
        __import__(package)
        print(f'✓ {package}')
    except ImportError:
        print(f'✗ {package}')
        failed.append(package)

if failed:
    print(f'Failed to import: {failed}')
    sys.exit(1)
else:
    print('All Python packages imported successfully!')
" || print_warning "Some Python packages may not be properly installed"

    # Test Node.js tools
    print_status "Testing Node.js tools..."
    if command_exists expo; then
        print_success "✓ Expo CLI"
    else
        print_warning "✗ Expo CLI"
    fi
    
    if command_exists react-native; then
        print_success "✓ React Native CLI"
    else
        print_warning "✗ React Native CLI"
    fi
}

# Generate setup completion report
generate_report() {
    echo ""
    echo "🎉 Setup Complete!"
    echo "=================="
    echo ""
    echo "✅ Development environment is ready"
    echo "✅ Dependencies installed"
    echo "✅ Project structure created"
    echo ""
    echo "Next Steps:"
    echo "1. Edit .env file with your API keys"
    echo "2. Choose your first app to build (recommend: Journal Summarizer)"
    echo "3. Follow the app-specific README for detailed instructions"
    echo ""
    echo "Useful Commands:"
    echo "  npm run dev          # Start development mode"
    echo "  source ai-apps-env/Scripts/activate  # Activate Python env (Git Bash)"
    echo "  cd apps/app-name     # Navigate to specific app"
    echo ""
    echo "Documentation:"
    echo "  📖 Main README: ./README.md"
    echo "  🛠️ Setup Guide: ./docs/setup-guide.md"
    echo "  📚 Model Guide: ./docs/model-selection.md"
    echo ""
    echo "Happy coding! 🚀"
}

# Main execution
main() {
    echo ""
    print_status "Starting setup process..."
    echo ""
    
    # Check prerequisites
    check_nodejs
    check_python
    check_git
    
    echo ""
    print_status "Prerequisites verified. Setting up environment..."
    echo ""
    
    # Setup environment
    setup_python_env
    install_python_deps
    install_nodejs_deps
    install_global_tools
    setup_env_file
    create_directories
    
    echo ""
    print_status "Verifying installation..."
    echo ""
    
    verify_installation
    
    echo ""
    generate_report
}

# Run main function
main "$@"
