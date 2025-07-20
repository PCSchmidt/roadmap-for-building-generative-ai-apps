#!/bin/bash

# Script to update portfolio statistics in the main README
# Fetches data from all app repositories and updates the central roadmap

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

# App names
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

print_status "Fetching portfolio statistics..."

# Initialize counters
total_repos=0
existing_repos=0
total_stars=0
total_forks=0
repos_with_demos=0
repos_deployed=0

# Create temporary file for statistics
stats_file=$(mktemp)

echo "# Portfolio Statistics (Updated: $(date))" > "$stats_file"
echo "" >> "$stats_file"

# Check each repository
for app in "${APPS[@]}"; do
    repo_name="generative-ai-$app"
    print_status "Checking $repo_name..."
    
    # Check if repository exists
    if gh api repos/$GITHUB_USERNAME/$repo_name >/dev/null 2>&1; then
        existing_repos=$((existing_repos + 1))
        
        # Get repository statistics
        repo_data=$(gh api repos/$GITHUB_USERNAME/$repo_name)
        stars=$(echo "$repo_data" | jq -r '.stargazers_count')
        forks=$(echo "$repo_data" | jq -r '.forks_count')
        
        total_stars=$((total_stars + stars))
        total_forks=$((total_forks + forks))
        
        # Check for demo/deployment indicators
        if gh api repos/$GITHUB_USERNAME/$repo_name/contents/README.md >/dev/null 2>&1; then
            readme_content=$(gh api repos/$GITHUB_USERNAME/$repo_name/contents/README.md --jq '.content' | base64 -d)
            
            # Check for demo links
            if echo "$readme_content" | grep -q "Live Demo\|Demo.*Live\|huggingface\.co"; then
                repos_with_demos=$((repos_with_demos + 1))
            fi
            
            # Check for deployment badges
            if echo "$readme_content" | grep -q "App Store\|Google Play\|Production"; then
                repos_deployed=$((repos_deployed + 1))
            fi
        fi
        
        echo "✅ $app: $stars ⭐ $forks 🍴" >> "$stats_file"
        print_success "$repo_name found - Stars: $stars, Forks: $forks"
    else
        echo "⏳ $app: Not created yet" >> "$stats_file"
        print_warning "$repo_name not found"
    fi
    
    total_repos=$((total_repos + 1))
done

# Calculate percentages
completion_percentage=$((existing_repos * 100 / total_repos))
demo_percentage=$((repos_with_demos * 100 / total_repos))
deployment_percentage=$((repos_deployed * 100 / total_repos))

# Generate statistics summary
echo "" >> "$stats_file"
echo "## Summary" >> "$stats_file"
echo "- **Total Repositories**: $existing_repos/$total_repos ($completion_percentage%)" >> "$stats_file"
echo "- **Total GitHub Stars**: $total_stars" >> "$stats_file"
echo "- **Total Forks**: $total_forks" >> "$stats_file"
echo "- **Live Demos**: $repos_with_demos/$total_repos ($demo_percentage%)" >> "$stats_file"
echo "- **Deployed Apps**: $repos_deployed/$total_repos ($deployment_percentage%)" >> "$stats_file"

# Update README.md badges
print_status "Updating README badges..."

# Read current README
readme_file="README.md"
temp_readme=$(mktemp)

# Update the portfolio statistics section
awk '
BEGIN { in_stats = 0; }
/^## 📊 Portfolio Statistics/ { in_stats = 1; print; next }
/^## / && in_stats { in_stats = 0 }
!in_stats { print }
in_stats && /^## / { in_stats = 0; print }
' "$readme_file" > "$temp_readme"

# Insert new statistics after the Portfolio Statistics header
awk -v stats_file="$stats_file" '
/^## 📊 Portfolio Statistics/ {
    print
    print ""
    print "![Portfolio Overview](https://img.shields.io/badge/Total%20Apps-10-blue.svg)"
    print "![Completed](https://img.shields.io/badge/Completed-'$existing_repos'-green.svg)"
    print "![In%20Development](https://img.shields.io/badge/In%20Development-'$((existing_repos > 0 ? 1 : 0))'-yellow.svg)"
    print "![Planned](https://img.shields.io/badge/Planned-'$((total_repos - existing_repos))'-lightgrey.svg)"
    print "![Stars](https://img.shields.io/badge/Total%20Stars-'$total_stars'-yellow.svg)"
    print ""
    print "| Metric | Count | Progress |"
    print "|--------|-------|----------|"
    print "| **Total Repositories** | '$existing_repos'/'$total_repos' | '$completion_percentage'% |"
    print "| **GitHub Stars** | '$total_stars' | Tracking across all repos |"
    print "| **Live Demos** | '$repos_with_demos'/'$total_repos' | '$demo_percentage'% |"
    print "| **Deployed Apps** | '$repos_deployed'/'$total_repos' | '$deployment_percentage'% |"
    print ""
    next
}
{ print }
' "$temp_readme" > "$readme_file"

# Update individual app status in the App Portfolio section
print_status "Updating individual app statuses..."

for app in "${APPS[@]}"; do
    repo_name="generative-ai-$app"
    
    if gh api repos/$GITHUB_USERNAME/$repo_name >/dev/null 2>&1; then
        status="🚧 In Development"
        stars=$(gh api repos/$GITHUB_USERNAME/$repo_name --jq '.stargazers_count')
        
        # Update the README with actual repository link and star count
        sed -i "s|generative-ai-$app.*🚧|generative-ai-$app) ✅|g" "$readme_file"
        sed -i "s|**Status:** 📋 Planned|**Status:** $status|g" "$readme_file"
    fi
done

# Clean up
rm "$stats_file" "$temp_readme"

print_success "Portfolio statistics updated successfully!"
print_status "Summary:"
echo "  - Repositories: $existing_repos/$total_repos ($completion_percentage%)"
echo "  - Total Stars: $total_stars"
echo "  - Live Demos: $repos_with_demos"
echo "  - Deployed Apps: $repos_deployed"

# Commit changes if there are any
if git diff --quiet README.md; then
    print_status "No changes to commit"
else
    print_status "Committing updated statistics..."
    git add README.md
    git commit -m "Update portfolio statistics

- Repositories: $existing_repos/$total_repos ($completion_percentage%)
- Total Stars: $total_stars
- Live Demos: $repos_with_demos
- Deployed Apps: $repos_deployed

Auto-updated: $(date)"
    
    print_success "Changes committed. Push with: git push origin main"
fi
