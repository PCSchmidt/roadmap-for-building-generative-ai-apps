# Development Environment Setup Guide

## Overview
This guide explains **exactly** how to start building your first AI app in this roadmap. You have multiple development paths depending on your preferences and system setup.

## 🚀 Quick Start (Recommended for Beginners)

### Option 1: Standard Node.js + Python Setup (Easiest)
```bash
# 1. Navigate to your chosen app
cd c:/Users/pchri/Documents/Copilot/generative-ai-journal-summarizer

# 2. Install frontend dependencies
npm install

# 3. Start the frontend
npm start

# 4. In a new terminal, set up Python backend
python -m venv venv
source venv/Scripts/activate  # Windows
pip install -r ../roadmap_build_generative_ai/templates/backend-requirements.txt

# 5. Start backend development server
python -m uvicorn main:app --reload --port 8000
```

### Option 2: Modern Python with UV (Recommended for Python developers)
```bash
# 1. Install UV (fastest Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 2. Navigate to app and create virtual environment
cd c:/Users/pchri/Documents/Copilot/generative-ai-journal-summarizer
uv venv

# 3. Activate environment and install dependencies
source .venv/Scripts/activate  # Windows
uv pip install -r ../roadmap_build_generative_ai/templates/backend-requirements.txt

# 4. Start frontend in parallel
npm install && npm start
```

### Option 3: Docker Containerization (Best for Production-like Development)
```bash
# 1. Copy Docker templates to your app
cd c:/Users/pchri/Documents/Copilot/generative-ai-journal-summarizer
cp ../roadmap_build_generative_ai/templates/Dockerfile.* .
cp ../roadmap_build_generative_ai/templates/docker-compose.yml .

# 2. Build and run containers
docker-compose up --build

# Frontend: http://localhost:19006
# Backend: http://localhost:8000
```

## 🐍 Python Environment: UV vs PIP

### Use UV when:
- You want **blazing fast** dependency installation (10-100x faster than pip)
- You're doing heavy Python development
- You need reproducible builds
- You want modern Python tooling

### Use PIP when:
- You're new to Python development
- You want maximum compatibility
- Your system doesn't support UV
- You're following tutorials that use pip

**Recommendation**: Start with UV if you're comfortable with command line tools, otherwise use pip.

## 🐳 Should You Use Docker?

### Use Docker when:
- You want **identical environments** across team members
- You're deploying to production later
- You want to avoid "it works on my machine" issues
- You're building multiple apps with different dependencies

### Skip Docker when:
- You're just getting started and want simplicity
- You're prototyping quickly
- You prefer direct control over your environment
- You're learning React Native/Expo basics

**Recommendation**: Start without Docker for your first app, then containerize once you're comfortable with the development workflow.

## 📂 Backend Structure Creation

Every AI app needs a backend. Here's how to create it:

### 1. Create Backend Directory Structure
```bash
cd c:/Users/pchri/Documents/Copilot/generative-ai-journal-summarizer

# Create backend structure
mkdir -p backend/app/{api,core,services,models,utils}
mkdir -p backend/data/{uploads,vector_store}
mkdir -p backend/tests
```

### 2. Create FastAPI Main File
```bash
# Create backend/main.py
cat > backend/main.py << 'EOF'
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn

app = FastAPI(title="AI Journal Summarizer API", version="1.0.0")

# Enable CORS for React Native
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure properly for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class JournalEntry(BaseModel):
    content: str
    date: str

class SummaryResponse(BaseModel):
    summary: str
    key_insights: list[str]
    mood_analysis: str

@app.get("/")
async def root():
    return {"message": "AI Journal Summarizer API is running!"}

@app.post("/summarize", response_model=SummaryResponse)
async def summarize_journal(entry: JournalEntry):
    # TODO: Implement AI summarization logic
    return SummaryResponse(
        summary="This is a placeholder summary of your journal entry.",
        key_insights=["Placeholder insight 1", "Placeholder insight 2"],
        mood_analysis="neutral"
    )

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF
```

### 3. Create AI Service Template
```bash
# Create backend/app/services/ai_service.py
cat > backend/app/services/ai_service.py << 'EOF'
from typing import List, Dict
import os
from langchain.llms import HuggingFacePipeline
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain

class AIService:
    def __init__(self):
        self.model_name = "microsoft/DialoGPT-medium"
        self.initialize_model()
    
    def initialize_model(self):
        """Initialize the AI model - start with HuggingFace free tier"""
        try:
            # Use HuggingFace Inference API for free tier
            self.llm = HuggingFacePipeline.from_model_id(
                model_id=self.model_name,
                task="text-generation",
                model_kwargs={"temperature": 0.7, "max_length": 512}
            )
        except Exception as e:
            print(f"Model initialization failed: {e}")
            self.llm = None
    
    async def summarize_journal_entry(self, content: str) -> Dict:
        """Summarize a journal entry and extract insights"""
        if not self.llm:
            return self._fallback_summary(content)
        
        prompt_template = PromptTemplate(
            input_variables=["journal_content"],
            template="""
            Analyze this journal entry and provide:
            1. A concise summary (2-3 sentences)
            2. Key insights or themes (3-5 bullet points)
            3. Emotional tone analysis
            
            Journal Entry: {journal_content}
            
            Summary:
            """
        )
        
        try:
            chain = LLMChain(llm=self.llm, prompt=prompt_template)
            result = await chain.arun(journal_content=content)
            return self._parse_ai_response(result)
        except Exception as e:
            print(f"AI processing failed: {e}")
            return self._fallback_summary(content)
    
    def _fallback_summary(self, content: str) -> Dict:
        """Simple fallback when AI is unavailable"""
        word_count = len(content.split())
        return {
            "summary": f"Journal entry with {word_count} words. Main topics appear to be personal reflection and daily activities.",
            "key_insights": [
                "Personal growth and reflection",
                "Daily activities and routines",
                "Emotional processing"
            ],
            "mood_analysis": "reflective"
        }
    
    def _parse_ai_response(self, response: str) -> Dict:
        """Parse structured response from AI model"""
        # TODO: Implement proper parsing logic
        return {
            "summary": response[:200] + "..." if len(response) > 200 else response,
            "key_insights": ["AI-generated insight 1", "AI-generated insight 2"],
            "mood_analysis": "positive"
        }
EOF
```

## 🔧 Development Workflow Steps

### Step 1: Choose Your First App
Start with **AI Journal Summarizer** - it's the simplest and most foundational.

### Step 2: Set Up Environment
Choose one of the three setup options above based on your comfort level.

### Step 3: Understand the Architecture
```
generative-ai-journal-summarizer/
├── src/                    # React Native frontend
│   ├── components/         # Reusable UI components
│   ├── screens/           # App screens
│   ├── services/          # API communication
│   └── utils/             # Helper functions
├── backend/               # Python FastAPI backend
│   ├── app/
│   │   ├── api/           # API routes
│   │   ├── services/      # AI and business logic
│   │   └── models/        # Data models
│   ├── data/              # File storage and vector DB
│   └── main.py            # FastAPI entry point
├── assets/                # Images, fonts, etc.
└── docs/                  # Documentation
```

### Step 4: Start Development
1. **Frontend First**: Get the UI working with mock data
2. **Backend Integration**: Connect to your FastAPI backend
3. **AI Integration**: Add real AI functionality step by step
4. **Testing**: Test on Expo Go app on your phone
5. **Polish**: Improve UI/UX and add advanced features

### Step 5: Deploy and Test
1. **Local Testing**: Use Expo Go for rapid iteration
2. **Backend Deployment**: Deploy to Render or Heroku
3. **App Building**: Create APK/IPA files with EAS Build
4. **Demo Creation**: Deploy demo to Hugging Face Spaces

## 🔑 Environment Variables Setup

Create a `.env` file in your app root:
```bash
# API Keys (get free tiers)
HUGGINGFACE_API_KEY=your_key_here
GROQ_API_KEY=your_key_here

# Backend Configuration
API_BASE_URL=http://localhost:8000
DATABASE_URL=sqlite:///./data/app.db

# Development Settings
NODE_ENV=development
DEBUG=true
```

## 🏃‍♂️ Next Steps After Setup

1. **Test the basic setup** - Make sure frontend and backend communicate
2. **Implement one feature** - Start with journal entry input and display
3. **Add AI gradually** - Begin with simple text processing, then add real AI
4. **Follow the learning path** in the main README.md
5. **Join the community** - Document your progress and help others

## 🆘 Troubleshooting

### Common Issues:
- **Port conflicts**: Change ports in package.json or docker-compose.yml
- **Python path issues**: Use absolute paths or activate virtual environment properly
- **Expo connection issues**: Ensure your phone and computer are on same WiFi
- **AI model loading**: Start with fallback responses, add real AI later

### Getting Help:
1. Check the app-specific `docs/setup.md` file
2. Review the main project documentation
3. Create an issue in the GitHub repository
4. Follow the troubleshooting guides in each app's docs

---

**Remember**: Start simple, build iteratively, and don't try to implement everything at once. The goal is to create a working prototype first, then enhance it with advanced AI features.
