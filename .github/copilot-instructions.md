# GitHub Copilot Instructions - Generative AI Mobile Apps Roadmap

## 🎯 Project Overview

This is a comprehensive roadmap for building **10 commercializable generative AI mobile apps** using React Native and modern AI technologies. The project follows a portfolio-first strategy with separate repositories for maximum visibility and recruiter appeal.

### Key Objectives
- Build 10 production-ready mobile apps with AI capabilities
- Create a strong developer portfolio for career advancement
- Use free/open-source technologies and hosting
- Implement automated portfolio tracking and management
- Focus on real-world commercializable applications

## 📁 Repository Architecture

### Central Hub Repository
- **Name**: `roadmap_build_generative_ai` (this repository)
- **Purpose**: Portfolio management, documentation, automation, templates
- **Location**: `c:\Users\pchri\Documents\Copilot\roadmap_build_generative_ai`
- **GitHub**: `https://github.com/PCSchmidt/roadmap-for-building-generative-ai-apps`

### Individual App Repositories (10 total)
- **Strategy**: Separate repositories for each app (not monorepo)
- **Naming Convention**: `generative-ai-[app-key]`
- **Base Directory**: `c:\Users\pchri\Documents\Copilot\`
- **GitHub Owner**: `PCSchmidt`

## 📱 The 10 Mobile Applications

| # | Repository Name | Display Name | Status | Description |
|---|----------------|--------------|--------|-------------|
| 1 | `generative-ai-journal-summarizer` | AI-Powered Journal Summarizer | ✅ Created | Smart daily journal insights and summaries |
| 2 | `generative-ai-icebreaker-generator` | Personalized Icebreaker Generator | 📋 Planned | AI-powered conversation starters for networking |
| 3 | `generative-ai-flashcard-creator` | AI Flashcard Creator | 📋 Planned | Intelligent study cards from documents |
| 4 | `generative-ai-meme-generator` | AI Meme Generator | 📋 Planned | Viral meme creator with trending templates |
| 5 | `generative-ai-travel-planner` | AI Travel Itinerary Planner | 📋 Planned | Smart trip planning with local insights |
| 6 | `generative-ai-recipe-generator` | AI Recipe Generator | 📋 Planned | Custom recipes from available ingredients |
| 7 | `generative-ai-study-buddy` | AI Study Buddy Chatbot | 📋 Planned | Personalized tutoring and Q&A assistant |
| 8 | `generative-ai-workout-planner` | AI Workout Planner | 📋 Planned | Customized fitness routines and tracking |
| 9 | `generative-ai-story-starter` | AI Story Starter | 📋 Planned | Creative writing prompts and story generation |
| 10 | `generative-ai-budget-tracker` | AI Budget Tracker | 📋 Planned | Smart expense tracking with insights |

## 🛠️ Technology Stack

### Frontend (Mobile Apps)
- **Framework**: React Native with Expo (v49+)
- **Navigation**: React Navigation v6
- **UI Components**: React Native Elements or NativeBase
- **State Management**: Redux Toolkit or Zustand
- **Styling**: StyleSheet, Styled Components

### Backend & AI
- **API Framework**: Python FastAPI (lightweight, fast)
- **AI Orchestration**: LangChain for complex workflows
- **Vector Databases**: ChromaDB (local) or FAISS for embeddings
- **Document Processing**: LlamaIndex for data retrieval
- **Models**: Open-source (Mistral 7B, Llama 3) via Hugging Face/Groq

### Development & Deployment
- **Version Control**: Git + GitHub
- **CI/CD**: GitHub Actions
- **Backend Hosting**: Render or Heroku (free tiers)
- **Mobile Testing**: Expo Go app
- **Database**: SQLite (local) or Supabase (free tier)

## 🤖 AI Integration Patterns

### Common AI Components
```javascript
// Standard AI service structure for all apps
src/services/
├── aiService.js          // Main AI API wrapper
├── promptTemplates.js    // Reusable prompt templates
├── vectorStore.js        // Vector database integration
└── modelConfig.js        // Model selection and configuration
```

### API Integration
- **Hugging Face Inference API**: Free tier for model access
- **Groq API**: Fast inference for Llama models
- **OpenAI API**: Fallback option (requires API key)
- **Local Models**: Ollama for offline development

## 📂 Standard Project Structure

Each app repository follows this structure:
```
generative-ai-[app-name]/
├── src/
│   ├── components/       # Reusable UI components
│   ├── screens/         # App screens/pages
│   ├── services/        # AI services, API calls
│   ├── utils/           # Helper functions
│   └── navigation/      # Navigation configuration
├── assets/
│   ├── images/          # App images and icons
│   └── fonts/           # Custom fonts
├── docs/                # Documentation
├── tests/               # Test files
├── .github/workflows/   # CI/CD configuration
├── App.js               # Main app entry point
├── package.json         # Dependencies and scripts
└── README.md            # App-specific documentation
```

## 🔄 Automation System

### Portfolio Tracking
- **Script**: `scripts/update-portfolio-curl.sh`
- **Purpose**: Automatically tracks repository statistics
- **Schedule**: Daily via GitHub Actions
- **Metrics**: Repos created, stars, forks, deployment status

### Repository Creation
- **Bulk Script**: `scripts/create-all-repos.sh`
- **Individual Script**: `scripts/create-app-repo.sh`
- **Templates**: `templates/README-template.md`, `templates/app-workflow-template.yml`

### GitHub Actions Workflows
- **Portfolio Updates**: `.github/workflows/update-portfolio.yml`
- **Cross-repo Sync**: `.github/workflows/trigger-sync.yml`
- **App CI/CD**: Individual app workflows for testing and deployment

## 💾 Important File Locations

### Core Configuration Files
- **Main README**: `README.md` (portfolio overview with automated stats)
- **Contributing Guide**: `CONTRIBUTING.md`
- **Setup Instructions**: `docs/setup-guide.md`
- **AI Documentation**: `docs/model-selection.md`, `docs/vector-databases.md`

### Scripts Directory
- `scripts/create-app-repo.sh` - Create single app repository
- `scripts/create-all-repos.sh` - Bulk create all 9 remaining repos
- `scripts/update-portfolio-stats.sh` - Original portfolio tracker (requires GitHub CLI)
- `scripts/update-portfolio-curl.sh` - Alternative tracker using curl
- `scripts/setup.sh` - Initial project setup

### Templates Directory
- `templates/README-template.md` - Standard app README template
- `templates/app-workflow-template.yml` - GitHub Actions CI/CD template

## 🎨 Development Workflow

### Starting New App Development
1. Use bulk creation script: `./scripts/create-all-repos.sh`
2. Create GitHub repository manually or with GitHub CLI
3. Push local repository to GitHub
4. Install dependencies: `npm install`
5. Start development: `npm start`

### Code Standards
- **Naming**: camelCase for variables, PascalCase for components
- **File Structure**: Organized by feature, not file type
- **Comments**: JSDoc for functions, inline for complex logic
- **Testing**: Jest for unit tests, Detox for E2E tests

### AI Service Implementation
```javascript
// Standard pattern for AI integration
export class AIService {
  constructor(modelProvider = 'huggingface') {
    this.provider = modelProvider;
    this.apiKey = process.env.AI_API_KEY;
  }
  
  async generateContent(prompt, options = {}) {
    // Implementation varies by app
  }
  
  async processWithRAG(query, context) {
    // Vector search + generation pattern
  }
}
```

## 🚀 Deployment Strategy

### Development Phase
- **Testing**: Expo Go app for rapid iteration
- **Preview**: Expo development builds
- **Backend**: Local FastAPI development server

### Production Phase
- **Mobile**: Expo Application Services (EAS) builds
- **Backend**: Render or Heroku deployment
- **Database**: Supabase or PlanetScale free tiers
- **CDN**: Cloudflare for static assets

## 📊 Success Metrics

### Technical Goals
- All 10 apps with basic AI functionality
- 500+ GitHub stars across portfolio
- 50+ forks per popular app
- Live demos for each app
- App store presence (at least 3 apps)

### Portfolio Impact
- Professional developer portfolio
- Demonstrable AI/mobile expertise
- Open source contributions
- Community engagement

## 🔧 Common Commands

### Repository Management
```bash
# Create all remaining repositories
./scripts/create-all-repos.sh

# Update portfolio statistics
./scripts/update-portfolio-curl.sh

# Create single app repository
./scripts/create-app-repo.sh [app-name]
```

### Development Commands
```bash
# Start any app
cd c:/Users/pchri/Documents/Copilot/generative-ai-[app-name]
npm install && npm start

# Run tests
npm test

# Build for production
npm run build
```

## 🎯 Current Status (Updated Automatically)

- **Repositories Created**: 1/10 (10%)
- **Total GitHub Stars**: 0 (growing)
- **Active Development**: generative-ai-journal-summarizer
- **Next Priority**: Create remaining 9 repositories

## 🤝 Contributing Context

When helping with this project, always consider:
1. **Portfolio Impact**: Code quality matters for job applications
2. **Scalability**: Patterns should work across all 10 apps
3. **Documentation**: Everything should be well-documented
4. **Automation**: Prefer automated solutions over manual processes
5. **Cost**: Use free tiers and open-source solutions
6. **Mobile-First**: All apps must work well on mobile devices
7. **AI Integration**: Each app should have meaningful AI features

## 🔗 Key Links

- **Main Repository**: https://github.com/PCSchmidt/roadmap-for-building-generative-ai-apps
- **First App**: https://github.com/PCSchmidt/generative-ai-journal-summarizer
- **Documentation**: Available in `/docs` directory
- **Templates**: Available in `/templates` directory

---

*This document is maintained automatically and should be referenced for all project context.*
