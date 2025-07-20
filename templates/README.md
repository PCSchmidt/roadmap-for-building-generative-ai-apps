# App Repository Template

This directory contains templates and boilerplate code for creating new app repositories.

## 📋 Using the Template

### 1. Repository Creation Script
```bash
# Use the provided script to create a new app repository
./scripts/create-app-repo.sh [app-name]
```

### 2. Manual Setup
```bash
# Create new repository
gh repo create generative-ai-[app-name] --public --clone
cd generative-ai-[app-name]

# Copy template files
cp -r /path/to/roadmap/templates/app-template/* .

# Customize the files for your specific app
# Update README.md, package.json, requirements.txt, etc.
```

## 📁 Template Structure

### Core Files
- `README-template.md` - Comprehensive app documentation template
- `package-template.json` - Node.js dependencies and scripts
- `requirements-template.txt` - Python dependencies
- `.gitignore-template` - Comprehensive gitignore
- `LICENSE` - MIT license
- `.env.example` - Environment variables template

### Directory Templates
- `frontend/` - React Native app structure
- `backend/` - FastAPI backend structure
- `docs/` - Documentation templates
- `.github/` - GitHub Actions and issue templates

## 🎯 Customization Checklist

When creating a new app repository:

- [ ] Replace `[APP_NAME]` placeholders
- [ ] Update app description and features
- [ ] Customize tech stack and dependencies  
- [ ] Add app-specific environment variables
- [ ] Update repository URL references
- [ ] Add app-specific documentation
- [ ] Configure GitHub Actions for CI/CD
- [ ] Set up issue and PR templates

## 🚀 Best Practices

1. **Consistent Structure**: All apps follow the same organization
2. **Comprehensive Documentation**: Clear setup and usage instructions
3. **Working Demos**: Always include live examples
4. **Production Ready**: Code quality suitable for deployment
5. **Community Friendly**: Good first issues and contribution guides

---

Use these templates to maintain consistency across all app repositories while allowing for app-specific customizations.
