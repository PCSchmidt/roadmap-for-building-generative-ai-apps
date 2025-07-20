#!/bin/bash

# Alternative portfolio update script using curl instead of gh CLI
# This version works when GitHub CLI is not available

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

# GitHub username
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

print_status "🔄 Fetching portfolio statistics (using curl)..."

# Initialize counters
total_repos=0
existing_repos=0
total_stars=0
total_forks=0
repos_with_demos=0
repos_deployed=0

# Create detailed stats table
detailed_stats=$(mktemp)
echo "| App | Status | Repository | Stars | Demos | Deployment |" > "$detailed_stats"
echo "|-----|--------|------------|-------|-------|------------|" >> "$detailed_stats"

# Check each repository
for app_key in "${!APPS[@]}"; do
    app_display="${APPS[$app_key]}"
    repo_name="generative-ai-$app_key"
    print_status "🔍 Checking $repo_name..."
    
    total_repos=$((total_repos + 1))
    
    # Check if repository exists using curl
    repo_response=$(curl -s "https://api.github.com/repos/$GITHUB_USERNAME/$repo_name")
    
    if echo "$repo_response" | grep -q '"id"'; then
        existing_repos=$((existing_repos + 1))
        
        # Extract repository statistics using basic text processing
        stars=$(echo "$repo_response" | grep '"stargazers_count"' | sed 's/.*: \([0-9]*\).*/\1/')
        forks=$(echo "$repo_response" | grep '"forks_count"' | sed 's/.*: \([0-9]*\).*/\1/')
        
        total_stars=$((total_stars + stars))
        total_forks=$((total_forks + forks))
        
        # Check creation date to determine status
        created_at=$(echo "$repo_response" | grep '"created_at"' | sed 's/.*: "\([^"]*\)".*/\1/')
        
        status="🚧 In Development"
        
        # Check for demo and deployment indicators by fetching README
        readme_response=$(curl -s "https://api.github.com/repos/$GITHUB_USERNAME/$repo_name/contents/README.md")
        
        demo_status="❌"
        deployment_status="❌"
        
        if echo "$readme_response" | grep -q '"content"'; then
            # README exists, check for demo/deployment indicators
            # Note: We'd need to decode base64 content for detailed checking
            demo_status="⏳"  # Assume demo planned
            deployment_status="⏳"  # Assume deployment planned
        fi
        
        echo "| [$app_display](https://github.com/$GITHUB_USERNAME/$repo_name) | $status | [$repo_name](https://github.com/$GITHUB_USERNAME/$repo_name) | $stars ⭐ | $demo_status | $deployment_status |" >> "$detailed_stats"
        
        print_success "$repo_name found - Stars: $stars, Forks: $forks"
    else
        echo "| $app_display | 📋 Planned | Not Created | - | - | - |" >> "$detailed_stats"
        print_warning "$repo_name not found"
    fi
done

# Calculate percentages
completion_percentage=$((existing_repos * 100 / total_repos))

print_status "📊 Generating statistics summary..."

# Create updated README section
readme_section=$(mktemp)
cat > "$readme_section" << EOF
## 📊 Portfolio Statistics

![Portfolio Overview](https://img.shields.io/badge/Total%20Apps-10-blue.svg)
![Completed](https://img.shields.io/badge/Completed-$existing_repos-green.svg)
![In%20Development](https://img.shields.io/badge/In%20Development-$existing_repos-yellow.svg)
![Planned](https://img.shields.io/badge/Planned-$((total_repos - existing_repos))-lightgrey.svg)
![Total Stars](https://img.shields.io/badge/Total%20Stars-$total_stars-yellow.svg)

| Metric | Count | Progress | Target |
|--------|-------|----------|---------|
| **Total Repositories** | $existing_repos/$total_repos | $completion_percentage% | 100% |
| **GitHub Stars** | $total_stars | Growing | 500+/repo |
| **GitHub Forks** | $total_forks | Growing | 50+/repo |
| **Live Demos** | 0/$total_repos | 0% | 100% |
| **Deployed Apps** | 0/$total_repos | 0% | 100% |
| **App Store Apps** | 0 | 0% | 10 |
| **Google Play Apps** | 0 | 0% | 10 |

### 📈 Development Progress

$(cat "$detailed_stats")

**Last Updated**: $(date -u '+%Y-%m-%d %H:%M:%S UTC') | **Method**: curl API
EOF

# Update README.md
readme_file="README.md"
temp_readme=$(mktemp)

# Replace the portfolio statistics section
awk '
BEGIN { in_stats = 0; skip_until_next_section = 0; }
/^## 📊 Portfolio Statistics/ { 
    in_stats = 1; 
    skip_until_next_section = 1;
    next 
}
/^## / && skip_until_next_section { 
    skip_until_next_section = 0;
}
!skip_until_next_section { print }
' "$readme_file" > "$temp_readme"

# Insert new statistics
awk -v stats_content="$(cat "$readme_section")" '
/^## 🗂️ Repository Organization Strategy/ {
    print stats_content
    print ""
    print
    next
}
{ print }
' "$temp_readme" > "$readme_file"

# Clean up
rm "$readme_section" "$detailed_stats" "$temp_readme"

print_success "✅ Portfolio statistics updated!"
print_status "📊 Summary:"
echo "  - Repositories: $existing_repos/$total_repos ($completion_percentage%)"
echo "  - Total Stars: $total_stars"
echo "  - Total Forks: $total_forks"

# Show changes but don't auto-commit
if git diff --quiet README.md; then
    print_status "ℹ️ No changes detected"
else
    print_status "💾 Changes detected in README.md"
    print_status "💡 Run 'git add README.md && git commit -m \"Update portfolio stats\" && git push' to save changes"
fi
