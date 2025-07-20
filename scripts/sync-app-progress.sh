#!/bin/bash

# Cross-Repository Progress Synchronization Script
# Monitors individual app development progress and updates the central roadmap

set -e

# Configuration
GITHUB_USERNAME="PCSchmidt"
ROADMAP_REPO="roadmap-for-building-generative-ai-apps"
BASE_DIR="c:/Users/pchri/Documents/Copilot"
PROGRESS_FILE="data/app-progress.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[SYNC]${NC} $1"
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

# App configuration with their directories and metrics
declare -A APPS
APPS=(
    ["journal-summarizer"]="AI-Powered Journal Summarizer"
    ["icebreaker-generator"]="Personalized Icebreaker Generator"
    ["flashcard-creator"]="AI Flashcard Creator"
    ["meme-generator"]="AI Meme Generator"
    ["travel-planner"]="AI Travel Itinerary Planner"
    ["recipe-generator"]="AI Recipe Generator"
    ["study-buddy"]="AI Study Buddy Chatbot"
    ["workout-planner"]="AI Workout Planner"
    ["story-starter"]="AI Story Starter"
    ["budget-tracker"]="AI Budget Tracker"
)

# Function to analyze app development progress
analyze_app_progress() {
    local app_key="$1"
    local app_dir="${BASE_DIR}/generative-ai-${app_key}"
    
    if [[ ! -d "$app_dir" ]]; then
        echo "{\"status\": \"not_created\", \"progress\": 0}"
        return
    fi
    
    cd "$app_dir"
    
    # Initialize progress metrics
    local progress=0
    local status="created"
    local features=()
    local commits=0
    local files=0
    local backend_setup=false
    local frontend_setup=false
    local ai_integration=false
    local tests_available=false
    local documentation=false
    local deployment_ready=false
    
    # Count files and commits
    if [[ -d ".git" ]]; then
        commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    fi
    
    files=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" -o -name "*.py" | wc -l)
    
    # Check project structure and features
    if [[ -f "package.json" ]]; then
        frontend_setup=true
        progress=$((progress + 10))
        features+=("Frontend Setup")
    fi
    
    if [[ -f "App.js" || -f "App.tsx" ]]; then
        progress=$((progress + 10))
        features+=("Main App Component")
    fi
    
    if [[ -d "src/screens" && $(ls src/screens/ 2>/dev/null | wc -l) -gt 0 ]]; then
        progress=$((progress + 15))
        features+=("Screen Components")
    fi
    
    if [[ -d "backend" && -f "backend/main.py" ]]; then
        backend_setup=true
        progress=$((progress + 15))
        features+=("Backend API")
    fi
    
    if [[ -f "backend/app/services/ai_service.py" || -f "src/services/aiService.js" ]]; then
        ai_integration=true
        progress=$((progress + 20))
        features+=("AI Integration")
    fi
    
    if [[ -d "tests" && $(ls tests/ 2>/dev/null | wc -l) -gt 0 ]]; then
        tests_available=true
        progress=$((progress + 10))
        features+=("Testing")
    fi
    
    if [[ -f "README.md" && -d "docs" ]]; then
        documentation=true
        progress=$((progress + 5))
        features+=("Documentation")
    fi
    
    if [[ -f ".github/workflows/deploy.yml" || -f "docker-compose.yml" ]]; then
        deployment_ready=true
        progress=$((progress + 10))
        features+=("Deployment Ready")
    fi
    
    # Determine status based on progress
    if [[ $progress -ge 80 ]]; then
        status="production_ready"
    elif [[ $progress -ge 60 ]]; then
        status="beta"
    elif [[ $progress -ge 40 ]]; then
        status="alpha"
    elif [[ $progress -ge 20 ]]; then
        status="development"
    elif [[ $progress -gt 0 ]]; then
        status="started"
    fi
    
    # Create JSON output
    local features_json=$(printf '%s\n' "${features[@]}" | jq -R . | jq -s .)
    
    cat << EOF
{
    "status": "$status",
    "progress": $progress,
    "commits": $commits,
    "files": $files,
    "features": $features_json,
    "backend_setup": $backend_setup,
    "frontend_setup": $frontend_setup,
    "ai_integration": $ai_integration,
    "tests_available": $tests_available,
    "documentation": $documentation,
    "deployment_ready": $deployment_ready,
    "last_updated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

# Function to fetch GitHub repository statistics
fetch_github_stats() {
    local repo_name="$1"
    local api_url="https://api.github.com/repos/${GITHUB_USERNAME}/${repo_name}"
    
    local response=$(curl -s "$api_url" 2>/dev/null)
    local stars=$(echo "$response" | jq -r '.stargazers_count // 0' 2>/dev/null || echo "0")
    local forks=$(echo "$response" | jq -r '.forks_count // 0' 2>/dev/null || echo "0")
    local issues=$(echo "$response" | jq -r '.open_issues_count // 0' 2>/dev/null || echo "0")
    local last_push=$(echo "$response" | jq -r '.pushed_at // "unknown"' 2>/dev/null || echo "unknown")
    
    cat << EOF
{
    "stars": $stars,
    "forks": $forks,
    "open_issues": $issues,
    "last_push": "$last_push"
}
EOF
}

# Main progress analysis function
main() {
    print_status "🔍 Analyzing development progress across all apps..."
    
    # Create data directory if it doesn't exist
    mkdir -p "$(dirname "$PROGRESS_FILE")"
    
    # Initialize progress data
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    local progress_data="{\"last_updated\": \"$timestamp\", \"apps\": {}}"
    
    # Analyze each app
    for app_key in "${!APPS[@]}"; do
        local app_name="${APPS[$app_key]}"
        local repo_name="generative-ai-${app_key}"
        
        print_status "📱 Analyzing: $app_name"
        
        # Get local development progress
        local app_progress=$(analyze_app_progress "$app_key")
        
        # Get GitHub statistics
        local github_stats=$(fetch_github_stats "$repo_name")
        
        # Combine data
        local combined_data=$(echo "{}" | jq --argjson progress "$app_progress" --argjson github "$github_stats" \
            '.progress = $progress | .github = $github | .display_name = "'"$app_name"'" | .repository = "'"$repo_name"'"')
        
        # Add to progress data
        progress_data=$(echo "$progress_data" | jq --arg key "$app_key" --argjson data "$combined_data" \
            '.apps[$key] = $data')
        
        # Extract progress percentage for display
        local progress_percent=$(echo "$app_progress" | jq -r '.progress')
        local status=$(echo "$app_progress" | jq -r '.status')
        
        print_success "  📊 Progress: ${progress_percent}% | Status: ${status}"
    done
    
    # Save progress data
    echo "$progress_data" | jq '.' > "$PROGRESS_FILE"
    print_success "💾 Progress data saved to: $PROGRESS_FILE"
    
    # Generate summary statistics
    local total_apps=$(echo "$progress_data" | jq '.apps | length')
    local avg_progress=$(echo "$progress_data" | jq '[.apps[].progress.progress] | add / length | floor')
    local completed_apps=$(echo "$progress_data" | jq '[.apps[] | select(.progress.status == "production_ready")] | length')
    local in_development=$(echo "$progress_data" | jq '[.apps[] | select(.progress.status == "development" or .progress.status == "alpha" or .progress.status == "beta")] | length')
    
    print_status "📈 Portfolio Summary:"
    echo -e "   Total Apps: ${total_apps}"
    echo -e "   Average Progress: ${avg_progress}%"
    echo -e "   Production Ready: ${completed_apps}"
    echo -e "   In Development: ${in_development}"
    
    # Update README with progress
    update_readme_progress "$progress_data"
}

# Function to update README.md with latest progress
update_readme_progress() {
    local progress_data="$1"
    local readme_file="README.md"
    
    if [[ ! -f "$readme_file" ]]; then
        print_warning "README.md not found, skipping update"
        return
    fi
    
    print_status "📝 Updating README.md with latest progress..."
    
    # Generate progress table
    local progress_table="| # | App Name | Progress | Status | Features | GitHub |"
    progress_table+="\n|---|----------|----------|--------|----------|--------|"
    
    local counter=1
    for app_key in journal-summarizer icebreaker-generator flashcard-creator meme-generator travel-planner recipe-generator study-buddy workout-planner story-starter budget-tracker; do
        local app_data=$(echo "$progress_data" | jq -r ".apps[\"$app_key\"]")
        local display_name=$(echo "$app_data" | jq -r '.display_name // "Unknown"')
        local progress=$(echo "$app_data" | jq -r '.progress.progress // 0')
        local status=$(echo "$app_data" | jq -r '.progress.status // "not_created"')
        local stars=$(echo "$app_data" | jq -r '.github.stars // 0')
        local repo_name=$(echo "$app_data" | jq -r '.repository // ""')
        local features_count=$(echo "$app_data" | jq -r '.progress.features | length')
        
        # Status emoji mapping
        local status_emoji
        case "$status" in
            "production_ready") status_emoji="🚀 Production" ;;
            "beta") status_emoji="🧪 Beta" ;;
            "alpha") status_emoji="⚠️ Alpha" ;;
            "development") status_emoji="🔨 Development" ;;
            "started") status_emoji="🌱 Started" ;;
            "created") status_emoji="📁 Created" ;;
            *) status_emoji="⭕ Not Started" ;;
        esac
        
        local github_link="[⭐ ${stars}](https://github.com/${GITHUB_USERNAME}/${repo_name})"
        
        progress_table+="\n| ${counter} | ${display_name} | ${progress}% | ${status_emoji} | ${features_count} features | ${github_link} |"
        ((counter++))
    done
    
    # Create temporary file with updated progress
    local temp_file=$(mktemp)
    local in_progress_section=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^##.*Progress.*Tracking ]]; then
            in_progress_section=true
            echo "$line" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "Last Updated: $(date '+%Y-%m-%d %H:%M:%S UTC')" >> "$temp_file"
            echo "" >> "$temp_file"
            echo -e "$progress_table" >> "$temp_file"
            echo "" >> "$temp_file"
            # Skip until next section
            continue
        elif [[ "$in_progress_section" == true && "$line" =~ ^## ]]; then
            in_progress_section=false
            echo "$line" >> "$temp_file"
        elif [[ "$in_progress_section" == false ]]; then
            echo "$line" >> "$temp_file"
        fi
    done < "$readme_file"
    
    # Replace original file
    mv "$temp_file" "$readme_file"
    print_success "✅ README.md updated with latest progress"
}

# Run the main function
main "$@"
