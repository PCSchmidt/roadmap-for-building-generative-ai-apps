# Development Environment Setup Guide

This guide will help you set up a complete development environment for building generative AI mobile applications.

## 📋 Prerequisites

### System Requirements
- **Operating System**: Windows 10/11, macOS 10.15+, or Ubuntu 18.04+
- **RAM**: Minimum 8GB, recommended 16GB+
- **Storage**: At least 10GB free space
- **Internet**: Stable connection for API calls and downloads

## 🛠️ Core Tools Installation

### 1. Code Editor
**VS Code with Extensions**
```bash
# Download VS Code from https://code.visualstudio.com/

# Install essential extensions
code --install-extension ms-python.python
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension ms-vscode.vscode-json
code --install-extension GitHub.copilot
code --install-extension ms-python.black-formatter
code --install-extension ms-python.isort
```

### 2. Node.js and npm
```bash
# Install Node.js 18+ from https://nodejs.org/
# Verify installation
node --version
npm --version

# Install global packages
npm install -g @react-native-community/cli
npm install -g expo-cli
```

### 3. Python Environment
```bash
# Install Python 3.9+ from https://python.org/
# Verify installation
python --version
pip --version

# Create virtual environment
python -m venv ai-apps-env

# Activate virtual environment
# Windows:
ai-apps-env\Scripts\activate
# macOS/Linux:
source ai-apps-env/bin/activate

# Upgrade pip
pip install --upgrade pip
```

### 4. Git Configuration
```bash
# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set up SSH key for GitHub
ssh-keygen -t ed25519 -C "your.email@example.com"
```

## 📱 Mobile Development Setup

### React Native Environment

#### Android Development
1. **Install Android Studio**
   - Download from https://developer.android.com/studio
   - Install Android SDK and build tools
   - Set up Android Virtual Device (AVD)

2. **Environment Variables**
   ```bash
   # Add to your shell profile (.bashrc, .zshrc, etc.)
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/emulator
   export PATH=$PATH:$ANDROID_HOME/tools
   export PATH=$PATH:$ANDROID_HOME/tools/bin
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   ```

#### iOS Development (macOS only)
1. **Install Xcode**
   - Download from Mac App Store
   - Install Xcode Command Line Tools
   ```bash
   xcode-select --install
   ```

2. **Install CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```

## 🤖 AI Development Tools

### Python Packages
```bash
# Core AI packages
pip install langchain
pip install llama-index
pip install chromadb
pip install faiss-cpu
pip install openai
pip install huggingface-hub
pip install transformers

# Web framework
pip install fastapi
pip install uvicorn
pip install pydantic

# Data processing
pip install pandas
pip install numpy
pip install matplotlib
pip install seaborn

# Development tools
pip install black
pip install isort
pip install flake8
pip install pytest
pip install jupyter
```

### API Keys Setup
Create a `.env` file in your project root:
```bash
# AI APIs
OPENAI_API_KEY=your_openai_key_here
HUGGINGFACE_API_KEY=your_hf_key_here
GROQ_API_KEY=your_groq_key_here

# External APIs
TAVILY_API_KEY=your_tavily_key_here
CANVA_API_KEY=your_canva_key_here

# Database
DATABASE_URL=your_database_url_here

# App Configuration
APP_SECRET_KEY=your_secret_key_here
DEBUG=true
```

## 🔧 Development Workflow

### 1. Project Structure
```
project-name/
├── frontend/          # React Native app
│   ├── src/
│   ├── assets/
│   └── package.json
├── backend/           # Python FastAPI
│   ├── app/
│   ├── tests/
│   └── requirements.txt
├── docs/             # Documentation
├── scripts/          # Deployment scripts
└── README.md
```

### 2. Git Workflow
```bash
# Start new feature
git checkout -b feature/app-name
git commit -m "feat: add initial app structure"
git push origin feature/app-name

# Create pull request on GitHub
```

### 3. Testing Setup
```bash
# Frontend testing
npm install --save-dev jest @testing-library/react-native

# Backend testing
pip install pytest pytest-asyncio httpx
```

## 🚀 Deployment Preparation

### Free Hosting Platforms

#### Backend Deployment
1. **Render** (Recommended)
   - Sign up at https://render.com
   - Connect GitHub repository
   - Deploy with one click

2. **Heroku**
   - Install Heroku CLI
   - Set up Procfile for deployment

#### Frontend Deployment
1. **Expo**
   - Perfect for development and testing
   - Easy sharing with Expo Go app

2. **App Store/Google Play**
   - Set up developer accounts
   - Configure signing certificates

### Environment Variables for Production
```bash
# Production environment
NODE_ENV=production
DEBUG=false
API_BASE_URL=https://your-api.render.com
```

## 🧪 Testing Your Setup

### Quick Verification Script
Create `setup-test.py`:
```python
#!/usr/bin/env python3

import sys
import subprocess
import importlib

def check_python_packages():
    packages = [
        'langchain', 'llama_index', 'chromadb', 
        'fastapi', 'openai', 'transformers'
    ]
    
    for package in packages:
        try:
            importlib.import_module(package)
            print(f"✅ {package} installed")
        except ImportError:
            print(f"❌ {package} not found")

def check_node_tools():
    tools = ['node', 'npm', 'npx']
    
    for tool in tools:
        try:
            result = subprocess.run([tool, '--version'], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                print(f"✅ {tool} {result.stdout.strip()}")
            else:
                print(f"❌ {tool} not found")
        except FileNotFoundError:
            print(f"❌ {tool} not found")

if __name__ == "__main__":
    print("🔍 Checking Python packages...")
    check_python_packages()
    
    print("\n🔍 Checking Node.js tools...")
    check_node_tools()
    
    print("\n🎉 Setup verification complete!")
```

Run the verification:
```bash
python setup-test.py
```

## 📚 Learning Resources

### Essential Documentation
- [React Native Docs](https://reactnative.dev/docs/getting-started)
- [FastAPI Tutorial](https://fastapi.tiangolo.com/tutorial/)
- [LangChain Documentation](https://python.langchain.com/)
- [LlamaIndex Guides](https://docs.llamaindex.ai/)

### Recommended Courses
- [React Native for Beginners](https://reactnative.dev/docs/tutorial)
- [FastAPI Complete Course](https://fastapi.tiangolo.com/)
- [LangChain & Vector Databases](https://python.langchain.com/docs/get_started)

## 🆘 Troubleshooting

### Common Issues

#### React Native Setup
```bash
# Clear cache if builds fail
npx react-native start --reset-cache
cd android && ./gradlew clean && cd ..
```

#### Python Environment
```bash
# Reinstall packages if imports fail
pip install --upgrade --force-reinstall package-name
```

#### API Connection Issues
- Verify API keys in `.env` file
- Check network connectivity
- Confirm API rate limits

### Getting Help
- Check GitHub Issues for common problems
- Join the project Discord/Slack
- Create detailed bug reports with environment info

---

**Next Steps**: Once your environment is set up, start with the [AI Journal Summarizer](../apps/journal-summarizer/README.md) tutorial!
