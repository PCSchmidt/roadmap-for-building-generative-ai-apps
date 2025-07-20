#!/bin/bash

# Deploy Progress Tracking to All App Repositories
# This script adds the progress reporting workflow to all individual app repos

set -e

# Configuration
GITHUB_USERNAME="PCSchmidt"
BASE_DIR="c:/Users/pchri/Documents/Copilot"
WORKFLOW_TEMPLATE="templates/app-progress-workflow.yml"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[DEPLOY]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# App repositories
APPS=(
    "journal-summarizer"
    "icebreaker-generator"
    "flashcard-creator"
    "meme-generator"
    "travel-planner"
    "recipe-generator"
    "study-buddy"
    "workout-planner"
    "story-starter"
    "budget-tracker"
)

deploy_workflow_to_app() {
    local app_key="$1"
    local app_dir="${BASE_DIR}/generative-ai-${app_key}"
    local repo_name="generative-ai-${app_key}"
    
    print_status "📱 Deploying progress tracking to: $repo_name"
    
    if [[ ! -d "$app_dir" ]]; then
        print_warning "  Directory not found: $app_dir"
        return 1
    fi
    
    cd "$app_dir"
    
    # Create .github/workflows directory if it doesn't exist
    mkdir -p ".github/workflows"
    
    # Copy the progress workflow template
    if [[ -f "${BASE_DIR}/roadmap_build_generative_ai/${WORKFLOW_TEMPLATE}" ]]; then
        cp "${BASE_DIR}/roadmap_build_generative_ai/${WORKFLOW_TEMPLATE}" ".github/workflows/report-progress.yml"
        print_success "  ✅ Progress workflow added"
    else
        print_warning "  ⚠️ Workflow template not found"
        return 1
    fi
    
    # Add progress tracking documentation
    cat << 'EOF' > docs/progress-tracking.md
# Progress Tracking

This app automatically reports development progress to the central roadmap repository.

## How It Works

1. **Automatic Analysis**: Every push to main branch triggers progress analysis
2. **Metrics Calculation**: Analyzes code structure, features, and completion status
3. **Roadmap Updates**: Sends progress data to the central roadmap repository
4. **Documentation Sync**: Updates portfolio documentation automatically

## Progress Metrics

The system tracks these development milestones:

- **Frontend Setup** (10%): package.json and basic React Native structure
- **Main App Component** (10%): App.js or App.tsx implementation
- **Screen Components** (15%): Individual app screens in src/screens/
- **Backend API** (15%): FastAPI backend with main.py
- **AI Integration** (20%): AI service implementation
- **Testing** (10%): Test suite implementation
- **Documentation** (5%): README and docs/ directory
- **Deployment Ready** (10%): CI/CD and containerization setup

## Status Levels

- **Created** (0%): Repository exists but minimal code
- **Started** (1-19%): Basic structure in place
- **Development** (20-39%): Core features being built
- **Alpha** (40-59%): Major features implemented
- **Beta** (60-79%): Feature complete, testing and polish
- **Production Ready** (80%+): Ready for deployment and use

## Manual Progress Updates

You can trigger progress updates manually:

```bash
# From the app repository
gh workflow run report-progress.yml
```

## Viewing Progress

Check your app's progress in the central roadmap:
- [Portfolio Overview](https://github.com/PCSchmidt/roadmap-for-building-generative-ai-apps)
- [Progress Dashboard](https://github.com/PCSchmidt/roadmap-for-building-generative-ai-apps/blob/main/data/app-progress.json)

EOF
    
    # Commit and push if it's a git repository
    if [[ -d ".git" ]]; then
        # Configure git if needed
        if [[ -z "$(git config user.name)" ]]; then
            git config user.name "Auto Deployment"
            git config user.email "auto@example.com"
        fi
        
        # Add files
        git add .github/workflows/report-progress.yml docs/progress-tracking.md
        
        # Check if there are changes to commit
        if ! git diff --staged --quiet; then
            git commit -m "📊 Add automated progress tracking

- Automatic progress reporting to roadmap repository
- Development milestone tracking
- Portfolio synchronization
- Progress documentation"
            
            print_success "  📝 Changes committed locally"
            
            # Try to push (will work if remote is set up)
            if git push 2>/dev/null; then
                print_success "  🚀 Changes pushed to GitHub"
            else
                print_warning "  ⚠️ Could not push to GitHub (check remote setup)"
            fi
        else
            print_status "  ℹ️ No changes to commit"
        fi
    else
        print_warning "  ⚠️ Not a git repository, skipping commit"
    fi
    
    return 0
}

main() {
    print_status "🚀 Deploying progress tracking to all app repositories..."
    
    # Check if workflow template exists
    if [[ ! -f "$WORKFLOW_TEMPLATE" ]]; then
        print_warning "Workflow template not found: $WORKFLOW_TEMPLATE"
        echo "Please run this script from the roadmap repository root."
        exit 1
    fi
    
    local successful=0
    local failed=0
    
    # Deploy to each app
    for app_key in "${APPS[@]}"; do
        if deploy_workflow_to_app "$app_key"; then
            ((successful++))
        else
            ((failed++))
        fi
        echo
    done
    
    # Summary
    print_status "📊 Deployment Summary:"
    echo "  ✅ Successful: $successful"
    echo "  ❌ Failed: $failed"
    echo "  📱 Total Apps: ${#APPS[@]}"
    
    if [[ $successful -gt 0 ]]; then
        print_success "🎉 Progress tracking deployed successfully!"
        echo ""
        echo "Next steps:"
        echo "1. Push any uncommitted changes to GitHub"
        echo "2. Verify workflows run on next commits"
        echo "3. Check progress updates in roadmap repository"
        echo "4. Run: ./scripts/sync-app-progress.sh to test integration"
    fi
    
    if [[ $failed -gt 0 ]]; then
        print_warning "⚠️ Some deployments failed. Check individual app directories."
    fi
}

# Run main function
main "$@"
