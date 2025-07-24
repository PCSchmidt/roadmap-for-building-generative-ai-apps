# Apps Directory

This directory contains the individual app projects for the 10 generative AI mobile applications.

## 📱 App Structure

Each app follows a consistent structure:

```
app-name/
├── frontend/          # React Native mobile app
│   ├── src/
│   ├── assets/
│   ├── package.json
│   └── README.md
├── backend/           # Python FastAPI backend
│   ├── app/
│   ├── tests/
│   ├── requirements.txt
│   └── README.md
├── docs/             # App-specific documentation
├── demos/            # Demo files and screenshots
└── README.md         # Main app documentation
```

## 🚀 App Status

| App | Status | Progress | Demo |
|-----|--------|----------|------|
| 📝 [Journal Summarizer](./journal-summarizer/) | 🚧 Planning | 0% | - |
| 🤝 [Icebreaker Generator](./icebreaker-generator/) | 📋 Planned | 0% | - |
| 🧠 [Flashcard Creator](./flashcard-creator/) | 📋 Planned | 0% | - |
| 😂 [Meme Generator](./meme-generator/) | 📋 Planned | 0% | - |
| ✈️ [Travel Planner](./travel-planner/) | 📋 Planned | 0% | - |
| 👨‍🍳 [Recipe Generator](./recipe-generator/) | 📋 Planned | 0% | - |
| 🎓 [Study Buddy](./study-buddy/) | 📋 Planned | 0% | - |
| 💪 [Workout Planner](./workout-planner/) | 📋 Planned | 0% | - |
| ✍️ [Story Starter](./story-starter/) | 📋 Planned | 0% | - |
| 💰 [Budget Tracker](./budget-tracker/) | 📋 Planned | 0% | - |

## 🛠️ Development Workflow

### 1. Starting a New App
```bash
# Navigate to apps directory
cd apps

# Create new app structure
mkdir app-name
cd app-name

# Initialize frontend
npx create-expo-app frontend
cd frontend
npm install

# Initialize backend
cd ../
mkdir backend
cd backend
touch requirements.txt
touch main.py
```

### 2. Development Commands
```bash
# Install dependencies for all apps
npm run install-all

# Start development for specific app
cd apps/app-name
npm run dev

# Run tests
npm test
```

### 3. Deployment Process
```bash
# Build for production
npm run build

# Deploy backend
# (App-specific deployment commands)

# Build mobile app
expo build:android
expo build:ios
```

## 📚 Shared Resources

### Common Components
- Authentication flows
- API clients
- UI components
- Vector database utilities
- AI model interfaces

### Shared Libraries
Located in `../shared/`:
- `ai-utils/` - Common AI operations
- `ui-components/` - Reusable React Native components
- `api-client/` - Backend communication
- `vector-store/` - Database abstractions

## 🎯 Development Guidelines

### Code Organization
- Keep app-specific code in respective directories
- Share common utilities in `../shared/`
- Document all APIs and components
- Follow consistent naming conventions

### Testing Strategy
- Unit tests for business logic
- Integration tests for AI workflows
- End-to-end tests for critical paths
- Performance tests for AI operations

### Documentation
- Each app has comprehensive README
- API documentation with examples
- Setup and deployment guides
- Troubleshooting sections

## 🔄 Cross-App Learning

As you build each app, capture learnings:

### Technical Patterns
- Successful AI integration patterns
- Performance optimization techniques
- Error handling strategies
- User experience improvements

### Business Insights
- User engagement metrics
- Feature usage analytics
- Cost optimization findings
- Market feedback

## 🚀 Getting Started

1. **Choose your first app** (recommended: Journal Summarizer)
2. **Set up development environment** (see [Setup Guide](../docs/setup-guide.md))
3. **Follow the app-specific README**
4. **Build, test, and deploy**
5. **Document learnings for next app**

---

Ready to build the future of AI-powered mobile applications! 🎉
