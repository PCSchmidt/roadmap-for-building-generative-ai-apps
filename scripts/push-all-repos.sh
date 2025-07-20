#!/bin/bash

# Push all existing local repositories to GitHub
# This script handles the GitHub repository creation and pushing for repos that were created locally

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

# App repositories to process (excluding journal-summarizer which already exists on GitHub)
REPOS=(
    "generative-ai-icebreaker-generator"
    "generative-ai-flashcard-creator"
    "generative-ai-meme-generator"
    "generative-ai-travel-planner"
    "generative-ai-recipe-generator"
    "generative-ai-study-buddy"
    "generative-ai-workout-planner"
    "generative-ai-story-starter"
    "generative-ai-budget-tracker"
)

# App descriptions for GitHub
declare -A DESCRIPTIONS
DESCRIPTIONS["icebreaker-generator"]="AI-powered conversation starters for networking events and social situations"
DESCRIPTIONS["flashcard-creator"]="Intelligent study cards generator from documents using AI"
DESCRIPTIONS["meme-generator"]="Viral meme creator with trending templates and AI-generated content"
DESCRIPTIONS["travel-planner"]="Smart trip planning with local insights and AI recommendations"
DESCRIPTIONS["recipe-generator"]="Custom recipes from available ingredients using AI"
DESCRIPTIONS["study-buddy"]="Personalized tutoring and Q&A assistant powered by AI"
DESCRIPTIONS["workout-planner"]="Customized fitness routines and tracking with AI guidance"
DESCRIPTIONS["story-starter"]="Creative writing prompts and story generation using AI"
DESCRIPTIONS["budget-tracker"]="Smart expense tracking with AI-powered insights and recommendations"

push_repository() {
    local repo_name="$1"
    local repo_dir="$BASE_DIR/$repo_name"
    
    # Extract app key from repo name
    local app_key="${repo_name#generative-ai-}"
    local description="${DESCRIPTIONS[$app_key]}"
    
    print_status "📤 Processing $repo_name..."
    
    if [[ ! -d "$repo_dir" ]]; then
        print_warning "Directory $repo_dir does not exist, skipping..."
        return
    fi
    
    cd "$repo_dir"
    
    # Check if this is a git repository
    if [[ ! -d ".git" ]]; then
        print_warning "$repo_name is not a git repository, skipping..."
        return
    fi
    
    # Check if remote already exists
    if git remote get-url origin >/dev/null 2>&1; then
        print_status "Remote already exists for $repo_name, attempting to push..."
        if git push -u origin main 2>/dev/null; then
            print_success "✅ $repo_name pushed successfully"
        else
            print_warning "⚠️ Push failed for $repo_name - repository might already exist"
        fi
        return
    fi
    
    # Create GitHub repository and push
    print_status "🚀 Creating GitHub repository for $repo_name..."
    
    if "$GH_CLI" repo create "$GITHUB_USERNAME/$repo_name" --public --description "$description" --source . --push; then
        print_success "✅ Repository $repo_name created and pushed to GitHub!"
    else
        print_error "❌ Failed to create repository $repo_name on GitHub"
        print_status "💡 Manual instructions:"
        echo "
To create manually:
1. Go to https://github.com/new
2. Repository name: $repo_name
3. Description: $description
4. Set to Public, don't initialize with README
5. Then run: 
   cd $repo_dir
   git remote add origin https://github.com/$GITHUB_USERNAME/$repo_name.git
   git push -u origin main
"
    fi
}

# Main execution
main() {
    print_status "🚀 Starting GitHub repository creation for all local repositories..."
    
    # Check GitHub CLI authentication
    if "$GH_CLI" auth status >/dev/null 2>&1; then
        print_success "✅ GitHub CLI is authenticated and ready"
    else
        print_error "❌ GitHub CLI not authenticated"
        print_status "💡 Run 'gh auth login' first"
        exit 1
    fi
    
    local success_count=0
    local total_count=${#REPOS[@]}
    
    # Process each repository
    for repo_name in "${REPOS[@]}"; do
        if push_repository "$repo_name"; then
            success_count=$((success_count + 1))
        fi
        
        # Add small delay to be respectful to GitHub API
        sleep 2
    done
    
    print_success "🎉 Process complete!"
    print_status "📊 Results: $success_count/$total_count repositories processed"
    
    # Update portfolio stats
    print_status "🔄 Updating portfolio statistics..."
    cd "$BASE_DIR/roadmap_build_generative_ai"
    if ./scripts/update-portfolio-curl.sh; then
        print_success "✅ Portfolio statistics updated"
    else
        print_warning "⚠️ Portfolio update failed, run manually later"
    fi
    
    print_status "🎯 Next steps:"
    echo "1. Check your GitHub profile: https://github.com/$GITHUB_USERNAME"
    echo "2. Start development on any app: cd $BASE_DIR/[repo-name] && npm install && npm start"
    echo "3. Portfolio overview: https://github.com/$GITHUB_USERNAME/roadmap-for-building-generative-ai-apps"
}

# Run main function
main "$@"
