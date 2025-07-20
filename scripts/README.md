# Portfolio Management Tools

This directory contains scripts and tools for managing the 10-app portfolio across multiple repositories.

## 📋 Available Scripts

### Repository Management
- `create-app-repo.sh` - Create new app repository from template
- `update-portfolio-stats.sh` - Update README with latest statistics
- `sync-templates.sh` - Sync template changes across all repos

### Development Tools
- `setup.sh` - Initial development environment setup
- `deploy-all.sh` - Deploy all apps to production
- `test-all.sh` - Run tests across all repositories

## 🚀 Usage Examples

### Create a New App Repository
```bash
# Make script executable (first time only)
chmod +x scripts/create-app-repo.sh

# Create journal summarizer app
./scripts/create-app-repo.sh journal-summarizer

# Create icebreaker generator app  
./scripts/create-app-repo.sh icebreaker-generator
```

### Update Portfolio Statistics
```bash
# Fetch latest stats from all repositories
./scripts/update-portfolio-stats.sh
```

### Initial Development Setup
```bash
# Set up development environment
./scripts/setup.sh
```

## 🛠️ Script Configuration

### Environment Variables
```bash
# GitHub configuration
GITHUB_USERNAME=PCSchmidt
GITHUB_TOKEN=your_token_here

# Template repository (optional)
TEMPLATE_REPO=generative-ai-app-template
```

### Script Permissions
```bash
# Make all scripts executable
chmod +x scripts/*.sh
```

## 📊 Portfolio Management

### Repository Tracking
The scripts automatically track:
- Repository creation status
- Star counts across all repos
- Deployment status
- Demo availability
- Documentation completeness

### Automation Features
- Auto-update main README with stats
- Cross-repository template synchronization
- Batch operations across all apps
- CI/CD pipeline management

---

Use these tools to efficiently manage your 10-app portfolio and maintain consistency across all repositories.
