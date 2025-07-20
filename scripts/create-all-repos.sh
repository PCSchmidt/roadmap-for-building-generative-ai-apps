#!/bin/bash

# Bulk repository creator for the remaining 9 generative AI apps
# This script creates all the repositories efficiently with proper structure

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

# Configuration
GITHUB_USERNAME="PCSchmidt"
BASE_DIR="c:/Users/pchri/Documents/Copilot"
GH_CLI="/c/Program Files/GitHub CLI/gh.exe"

# App configurations (excluding journal-summarizer which already exists)
declare -A APPS
APPS["icebreaker-generator"]="Personalized Icebreaker Generator|AI-powered conversation starters for networking events|icebreaker conversation social-ai networking"
APPS["flashcard-creator"]="AI Flashcard Creator|Intelligent study cards generator from documents|flashcards study-ai education learning"
APPS["meme-generator"]="AI Meme Generator|Viral meme creator with trending templates|memes ai-humor social-media content"
APPS["travel-planner"]="AI Travel Itinerary Planner|Smart trip planning with local insights|travel ai-planner itinerary recommendations"
APPS["recipe-generator"]="AI Recipe Generator|Custom recipes from available ingredients|recipes cooking ai-chef meal-planning"
APPS["study-buddy"]="AI Study Buddy Chatbot|Personalized tutoring and Q&A assistant|education ai-tutor chatbot learning"
APPS["workout-planner"]="AI Workout Planner|Customized fitness routines and tracking|fitness ai-trainer workout health"
APPS["story-starter"]="AI Story Starter|Creative writing prompts and story generation|writing ai-creativity stories prompts"
APPS["budget-tracker"]="AI Budget Tracker|Smart expense tracking with insights|finance ai-budgeting expenses tracking"

# Functions
create_repository_structure() {
    local app_key="$1"
    local app_info="$2"
    
    IFS='|' read -r display_name description keywords <<< "$app_info"
    local repo_name="generative-ai-$app_key"
    local repo_dir="$BASE_DIR/$repo_name"
    
    print_status "🏗️ Creating repository structure for $repo_name..."
    
    # Create directory
    mkdir -p "$repo_dir"
    cd "$repo_dir"
    
    # Initialize git repository
    git init
    
    # Create README from template
    sed "s/{{APP_NAME}}/$display_name/g; s/{{APP_DESCRIPTION}}/$description/g; s/{{REPO_NAME}}/$repo_name/g; s/{{GITHUB_USERNAME}}/$GITHUB_USERNAME/g; s/{{KEYWORDS}}/$keywords/g" \
        "$BASE_DIR/roadmap_build_generative_ai/templates/README-template.md" > README.md
    
    # Create basic project structure
    mkdir -p {src/{components,screens,services,utils},assets/{images,fonts},docs,tests}
    
    # Create package.json
    cat > package.json << EOF
{
  "name": "$repo_name",
  "version": "1.0.0",
  "description": "$description",
  "main": "index.js",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "web": "expo start --web",
    "test": "jest",
    "lint": "eslint .",
    "build": "expo build"
  },
  "keywords": [$(echo "$keywords" | sed 's/ /", "/g' | sed 's/^/"/; s/$/"/')],
  "author": "$GITHUB_USERNAME",
  "license": "MIT",
  "dependencies": {
    "expo": "~49.0.0",
    "react": "18.2.0",
    "react-native": "0.72.0",
    "@react-navigation/native": "^6.1.0",
    "axios": "^1.6.0"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0",
    "eslint": "^8.50.0",
    "jest": "^29.2.1"
  }
}
EOF
    
    # Create basic app structure
    cat > App.js << EOF
import React from 'react';
import { StyleSheet, Text, View, SafeAreaView } from 'react-native';

export default function App() {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>$display_name</Text>
        <Text style={styles.description}>$description</Text>
        <Text style={styles.status}>🚧 Coming Soon...</Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  content: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    textAlign: 'center',
    marginBottom: 10,
  },
  description: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 20,
  },
  status: {
    fontSize: 18,
    color: '#007AFF',
    fontWeight: '600',
  },
});
EOF
    
    # Create .gitignore
    cat > .gitignore << 'EOF'
# Expo
.expo/
dist/
web-build/
expo-env.d.ts

# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# React Native
*.log
.DS_Store
.vscode/
.idea/

# Environment variables
.env
.env.local
.env.production

# Build artifacts
build/
*.tgz
*.tar.gz

# Temporary files
*.tmp
*.temp
EOF
    
    # Copy GitHub workflow
    mkdir -p .github/workflows
    cp "$BASE_DIR/roadmap_build_generative_ai/templates/app-workflow-template.yml" .github/workflows/ci.yml
    
    # Create initial documentation
    cat > docs/setup.md << EOF
# $display_name - Setup Guide

## 📋 Prerequisites

- Node.js 18+ and npm
- Expo CLI: \`npm install -g @expo/cli\`
- React Native development environment

## 🚀 Quick Start

1. Clone and install:
\`\`\`bash
git clone https://github.com/$GITHUB_USERNAME/$repo_name.git
cd $repo_name
npm install
\`\`\`

2. Start development:
\`\`\`bash
npm start
\`\`\`

3. Run on device:
\`\`\`bash
npm run android  # Android
npm run ios      # iOS
npm run web      # Web browser
\`\`\`

## 🔧 Development

- App entry point: \`App.js\`
- Components: \`src/components/\`
- Screens: \`src/screens/\`
- Services: \`src/services/\`
- Tests: \`tests/\`

## 📱 Features (Planned)

$description

## 🤝 Contributing

See the main [roadmap repository](https://github.com/$GITHUB_USERNAME/roadmap_build_generative_ai) for contribution guidelines.
EOF
    
    # Initial commit
    git add .
    git commit -m "Initial project setup for $display_name

- Basic React Native/Expo structure
- Project configuration and dependencies
- Documentation and CI/CD setup
- Ready for development

Part of the 10 generative AI apps roadmap."
    
    print_success "✅ Repository structure created for $repo_name"
}

push_to_github() {
    local app_key="$1"
    local app_info="$2"
    
    IFS='|' read -r display_name description keywords <<< "$app_info"
    local repo_name="generative-ai-$app_key"
    local repo_dir="$BASE_DIR/$repo_name"
    
    cd "$repo_dir"
    
    print_status "📤 Creating GitHub repository and pushing $repo_name..."
    
    # Check if GitHub CLI is available and authenticated
    if "$GH_CLI" auth status >/dev/null 2>&1; then
        # Automatically create GitHub repository and push
        print_status "🚀 Creating GitHub repository automatically..."
        
        # Create the repository on GitHub
        if "$GH_CLI" repo create "$GITHUB_USERNAME/$repo_name" --public --description "$description" --source . --push; then
            print_success "✅ Repository $repo_name created and pushed to GitHub!"
        else
            print_error "❌ Failed to create repository $repo_name on GitHub"
            print_status "💡 Manual fallback instructions:"
            show_manual_instructions "$repo_name" "$description"
        fi
    else
        print_warning "⚠️ GitHub CLI not authenticated. Using manual process..."
        show_manual_instructions "$repo_name" "$description"
    fi
}

show_manual_instructions() {
    local repo_name="$1"
    local description="$2"
    
    echo "
To create the GitHub repository for $repo_name manually:

1. Go to https://github.com/new
2. Repository name: $repo_name
3. Description: $description
4. Set to Public
5. Don't initialize with README (we have one)
6. Click 'Create repository'

Then run these commands in $BASE_DIR/$repo_name:
git remote add origin https://github.com/$GITHUB_USERNAME/$repo_name.git
git branch -M main
git push -u origin main
"
}

# Main execution
main() {
    print_status "🚀 Starting bulk repository creation for 9 remaining apps..."
    print_status "📁 Base directory: $BASE_DIR"
    
    # Check GitHub CLI authentication
    if "$GH_CLI" auth status >/dev/null 2>&1; then
        print_success "✅ GitHub CLI is authenticated and ready for automation"
    else
        print_warning "⚠️ GitHub CLI not authenticated - repositories will be created locally only"
        print_status "💡 Run 'gh auth login' to enable automatic GitHub repository creation"
    fi
    
    # Check if base directory exists
    if [[ ! -d "$BASE_DIR" ]]; then
        print_error "Base directory $BASE_DIR does not exist"
        exit 1
    fi
    
    # Check if templates exist
    if [[ ! -f "$BASE_DIR/roadmap_build_generative_ai/templates/README-template.md" ]]; then
        print_error "README template not found"
        exit 1
    fi
    
    local created_count=0
    
    # Create each repository
    for app_key in "${!APPS[@]}"; do
        local app_info="${APPS[$app_key]}"
        
        # Check if directory already exists
        local repo_dir="$BASE_DIR/generative-ai-$app_key"
        if [[ -d "$repo_dir" ]]; then
            print_warning "Directory $repo_dir already exists, skipping..."
            continue
        fi
        
        create_repository_structure "$app_key" "$app_info"
        push_to_github "$app_key" "$app_info"
        
        created_count=$((created_count + 1))
        print_success "✅ Repository $created_count/9 created: generative-ai-$app_key"
        
        # Add small delay to be respectful to GitHub API
        sleep 2
    done
    
    print_success "🎉 Bulk repository creation complete!"
    print_status "📊 Created $created_count new repositories"
    
    # Show next steps
    cat << EOF

## 🎯 Next Steps

1. **Create GitHub Repositories**: For each created directory, follow the GitHub creation instructions shown above

2. **Update Portfolio**: Run the portfolio update script:
   \`cd $BASE_DIR/roadmap_build_generative_ai && ./scripts/update-portfolio-curl.sh\`

3. **Start Development**: Choose an app to work on first:
$(for app_key in "${!APPS[@]}"; do
    echo "   - cd $BASE_DIR/generative-ai-$app_key && npm install && npm start"
done)

4. **Set Up CI/CD**: Each repository has GitHub Actions configured for automatic testing and deployment

5. **Documentation**: Update each app's README.md as development progresses

## 📁 Repository Locations

$(for app_key in "${!APPS[@]}"; do
    echo "- $BASE_DIR/generative-ai-$app_key"
done)

Happy coding! 🚀
EOF
}

# Run main function
main "$@"
