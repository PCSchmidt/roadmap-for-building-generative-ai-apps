#!/bin/bash

# Enhanced script to update portfolio statistics with automation support
# Fetches data from all app repositories and updates the central roadmap
# Supports both manual runs and automated GitHub Actions triggers

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

# GitHub username (customize this)
GITHUB_USERNAME="PCSchmidt"

# App names and their display names
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

print_status "🔄 Fetching portfolio statistics..."

# Initialize counters
total_repos=0
existing_repos=0
total_stars=0
total_forks=0
repos_with_demos=0
repos_deployed=0
repos_in_development=0

# Create temporary file for statistics
stats_file=$(mktemp)
detailed_stats=$(mktemp)

echo "# Portfolio Statistics (Updated: $(date -u))" > "$stats_file"
echo "" >> "$stats_file"
echo "| App | Status | Repository | Stars | Demos | Deployment |" > "$detailed_stats"
echo "|-----|--------|------------|-------|-------|------------|" >> "$detailed_stats"

# Check each repository
for app_key in "${!APPS[@]}"; do
    app_display="${APPS[$app_key]}"
    repo_name="generative-ai-$app_key"
    print_status "🔍 Checking $repo_name..."
    
    total_repos=$((total_repos + 1))
    
    # Check if repository exists
    if gh api repos/$GITHUB_USERNAME/$repo_name >/dev/null 2>&1; then
        existing_repos=$((existing_repos + 1))
        
        # Get repository statistics
        repo_data=$(gh api repos/$GITHUB_USERNAME/$repo_name)
        stars=$(echo "$repo_data" | jq -r '.stargazers_count')
        forks=$(echo "$repo_data" | jq -r '.forks_count')
        
        total_stars=$((total_stars + stars))
        total_forks=$((total_forks + forks))
        
        # Determine status based on recent activity
        last_push=$(echo "$repo_data" | jq -r '.pushed_at')
        created_at=$(echo "$repo_data" | jq -r '.created_at')
        
        # Check if repo was created recently (within last 30 days)
        if [[ $(date -d "$created_at" +%s) -gt $(date -d "30 days ago" +%s) ]]; then
            status="🚧 In Development"
            repos_in_development=$((repos_in_development + 1))
        else
            status="✅ Active"
        fi
        
        # Check for demo and deployment indicators
        demo_status="❌"
        deployment_status="❌"
        
        if gh api repos/$GITHUB_USERNAME/$repo_name/contents/README.md >/dev/null 2>&1; then
            readme_content=$(gh api repos/$GITHUB_USERNAME/$repo_name/contents/README.md --jq '.content' | base64 -d)
            
            # Check for demo links
            if echo "$readme_content" | grep -qi "live demo\|demo.*live\|huggingface\.co\|streamlit\|gradio"; then
                repos_with_demos=$((repos_with_demos + 1))
                demo_status="✅"
            fi
            
            # Check for deployment badges/indicators
            if echo "$readme_content" | grep -qi "app store\|google play\|production\|deployed\|render\|heroku"; then
                repos_deployed=$((repos_deployed + 1))
                deployment_status="✅"
            fi
        fi
        
        # Check for GitHub Actions workflows (indicates CI/CD setup)
        if gh api repos/$GITHUB_USERNAME/$repo_name/contents/.github/workflows >/dev/null 2>&1; then
            status="🚀 CI/CD Active"
        fi
        
        echo "| [$app_display](https://github.com/$GITHUB_USERNAME/$repo_name) | $status | [$repo_name](https://github.com/$GITHUB_USERNAME/$repo_name) | $stars ⭐ | $demo_status | $deployment_status |" >> "$detailed_stats"
        
        print_success "$repo_name found - Stars: $stars, Forks: $forks, Status: $status"
    else
        echo "| $app_display | 📋 Planned | Not Created | - | - | - |" >> "$detailed_stats"
        print_warning "$repo_name not found"
    fi
done

# Calculate percentages
completion_percentage=$((existing_repos * 100 / total_repos))
demo_percentage=$((repos_with_demos * 100 / total_repos))
deployment_percentage=$((repos_deployed * 100 / total_repos))

print_status "📊 Generating statistics summary..."

# Generate updated README section
readme_file="README.md"
temp_readme=$(mktemp)

# Update the portfolio statistics section with enhanced metrics
print_status "🔄 Updating README badges and statistics..."

# Create the new portfolio statistics section
cat > "$stats_file" << EOF
## 📊 Portfolio Statistics

![Portfolio Overview](https://img.shields.io/badge/Total%20Apps-10-blue.svg)
![Completed](https://img.shields.io/badge/Completed-$existing_repos-green.svg)
![In%20Development](https://img.shields.io/badge/In%20Development-$repos_in_development-yellow.svg)
![Planned](https://img.shields.io/badge/Planned-$((total_repos - existing_repos))-lightgrey.svg)
![Total Stars](https://img.shields.io/badge/Total%20Stars-$total_stars-yellow.svg)
![Live Demos](https://img.shields.io/badge/Live%20Demos-$repos_with_demos-green.svg)

| Metric | Count | Progress | Target |
|--------|-------|----------|---------|
| **Total Repositories** | $existing_repos/$total_repos | $completion_percentage% | 100% |
| **GitHub Stars** | $total_stars | Growing | 500+/repo |
| **GitHub Forks** | $total_forks | Growing | 50+/repo |
| **Live Demos** | $repos_with_demos/$total_repos | $demo_percentage% | 100% |
| **Deployed Apps** | $repos_deployed/$total_repos | $deployment_percentage% | 100% |
| **App Store Apps** | 0 | 0% | 10 |
| **Google Play Apps** | 0 | 0% | 10 |

### 📈 Development Progress

$(cat "$detailed_stats")

**Last Updated**: $(date -u '+%Y-%m-%d %H:%M:%S UTC') | **Auto-Updated**: ✅ GitHub Actions
EOF

# Replace the portfolio statistics section in README
awk '
BEGIN { in_stats = 0; skip_until_next_section = 0; }
/^## 📊 Portfolio Statistics/ { 
    in_stats = 1; 
    skip_until_next_section = 1;
    next 
}
/^## / && skip_until_next_section { 
    skip_until_next_section = 0;
    in_stats = 0;
}
!skip_until_next_section { print }
' "$readme_file" > "$temp_readme"

# Insert new statistics after finding where the old section was
awk -v stats_content="$(cat "$stats_file")" '
/^## 🗂️ Repository Organization Strategy/ {
    print stats_content
    print ""
    print
    next
}
{ print }
' "$temp_readme" > "$readme_file"

# Clean up temporary files
rm "$stats_file" "$detailed_stats" "$temp_readme"

print_success "✅ Portfolio statistics updated successfully!"
print_status "📊 Summary:"
echo "  - Repositories: $existing_repos/$total_repos ($completion_percentage%)"
echo "  - Total Stars: $total_stars"
echo "  - Total Forks: $total_forks"
echo "  - Live Demos: $repos_with_demos/$total_repos ($demo_percentage%)"
echo "  - Deployed Apps: $repos_deployed/$total_repos ($deployment_percentage%)"

# Only commit if running in CI or if explicitly requested
if [[ "$CI" == "true" ]] || [[ "$1" == "--commit" ]]; then
    if git diff --quiet README.md; then
        print_status "ℹ️ No changes to commit"
    else
        print_status "💾 Committing updated statistics..."
        git add README.md
        git commit -m "🤖 Auto-update portfolio statistics

📊 Portfolio Metrics Update:
- Repositories: $existing_repos/$total_repos ($completion_percentage%)
- Total GitHub Stars: $total_stars
- Total Forks: $total_forks  
- Live Demos: $repos_with_demos ($demo_percentage%)
- Deployed Apps: $repos_deployed ($deployment_percentage%)

🤖 Automated update via GitHub Actions
🕐 Timestamp: $(date -u)"
        
        print_success "✅ Changes committed successfully!"
        
        if [[ "$CI" == "true" ]]; then
            print_status "🚀 Pushing changes to GitHub..."
            git push origin main
        else
            print_status "💡 Run 'git push origin main' to sync changes"
        fi
    fi
else
    if ! git diff --quiet README.md; then
        print_status "💡 Changes detected. Run with --commit flag to commit automatically"
        print_status "💡 Or commit manually: git add README.md && git commit && git push"
    fi
fi
