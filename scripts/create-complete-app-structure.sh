#!/bin/bash

# Complete AI App Infrastructure Setup Script
# Creates professional-grade directory structure for AI mobile apps

set -e

APP_NAME="$1"
if [[ -z "$APP_NAME" ]]; then
    echo "Usage: $0 <app-name>"
    echo "Example: $0 journal-summarizer"
    exit 1
fi

APP_DIR="generative-ai-${APP_NAME}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[SETUP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

create_directory_structure() {
    print_status "📁 Creating complete directory structure..."
    
    # Frontend structure
    mkdir -p "$APP_DIR/src/components/common"
    mkdir -p "$APP_DIR/src/components/forms"
    mkdir -p "$APP_DIR/src/components/navigation"
    mkdir -p "$APP_DIR/src/components/ui"
    mkdir -p "$APP_DIR/src/screens/auth"
    mkdir -p "$APP_DIR/src/screens/onboarding"
    mkdir -p "$APP_DIR/src/screens/main"
    mkdir -p "$APP_DIR/src/screens/settings"
    mkdir -p "$APP_DIR/src/services"
    mkdir -p "$APP_DIR/src/hooks"
    mkdir -p "$APP_DIR/src/context"
    mkdir -p "$APP_DIR/src/navigation"
    mkdir -p "$APP_DIR/src/constants"
    mkdir -p "$APP_DIR/src/types"
    mkdir -p "$APP_DIR/src/styles"
    mkdir -p "$APP_DIR/src/utils"
    
    # Assets
    mkdir -p "$APP_DIR/assets/images"
    mkdir -p "$APP_DIR/assets/fonts"
    mkdir -p "$APP_DIR/assets/videos"
    mkdir -p "$APP_DIR/assets/audio"
    
    # Backend structure
    mkdir -p "$APP_DIR/backend/app/api/endpoints"
    mkdir -p "$APP_DIR/backend/app/core"
    mkdir -p "$APP_DIR/backend/app/services"
    mkdir -p "$APP_DIR/backend/app/models"
    mkdir -p "$APP_DIR/backend/app/utils"
    mkdir -p "$APP_DIR/backend/data/uploads"
    mkdir -p "$APP_DIR/backend/data/vector_store"
    mkdir -p "$APP_DIR/backend/data/cache"
    mkdir -p "$APP_DIR/backend/data/knowledge_base"
    mkdir -p "$APP_DIR/backend/tests"
    mkdir -p "$APP_DIR/backend/migrations"
    
    # AI specific
    mkdir -p "$APP_DIR/ai/models"
    mkdir -p "$APP_DIR/ai/prompts"
    mkdir -p "$APP_DIR/ai/data"
    mkdir -p "$APP_DIR/ai/notebooks"
    mkdir -p "$APP_DIR/embeddings"
    mkdir -p "$APP_DIR/experiments"
    
    # DevOps
    mkdir -p "$APP_DIR/.github/workflows"
    mkdir -p "$APP_DIR/.github/ISSUE_TEMPLATE"
    mkdir -p "$APP_DIR/config"
    mkdir -p "$APP_DIR/scripts"
    mkdir -p "$APP_DIR/kubernetes"
    
    # Documentation
    mkdir -p "$APP_DIR/docs"
    
    # Testing
    mkdir -p "$APP_DIR/tests/frontend/components"
    mkdir -p "$APP_DIR/tests/frontend/screens"
    mkdir -p "$APP_DIR/tests/frontend/integration"
    mkdir -p "$APP_DIR/tests/backend/api"
    mkdir -p "$APP_DIR/tests/backend/services"
    mkdir -p "$APP_DIR/tests/backend/models"
    mkdir -p "$APP_DIR/tests/ai"
    mkdir -p "$APP_DIR/tests/e2e"
    mkdir -p "$APP_DIR/fixtures"
    mkdir -p "$APP_DIR/mocks"
    
    print_success "✅ Directory structure created"
}

create_backend_files() {
    print_status "🐍 Creating backend infrastructure..."
    
    # FastAPI main.py
    cat > "$APP_DIR/backend/main.py" << 'EOF'
from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer
import uvicorn
import os
from app.core.config import settings
from app.api.dependencies import get_current_user
from app.api.endpoints import auth, ai

app = FastAPI(
    title=f"${APP_NAME} AI API",
    version="1.0.0",
    description="AI-powered mobile app backend"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_HOSTS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["authentication"])
app.include_router(ai.router, prefix="/api/ai", tags=["ai"])

security = HTTPBearer()

@app.get("/")
async def root():
    return {
        "message": f"${APP_NAME} AI API is running!",
        "version": "1.0.0",
        "status": "healthy"
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "${APP_NAME}-api"}

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=int(os.getenv("PORT", 8000)),
        reload=settings.DEBUG
    )
EOF

    # Core configuration
    cat > "$APP_DIR/backend/app/core/config.py" << 'EOF'
from pydantic_settings import BaseSettings
from typing import List, Optional
import os

class Settings(BaseSettings):
    # App
    APP_NAME: str = "${APP_NAME}"
    DEBUG: bool = os.getenv("DEBUG", "false").lower() == "true"
    VERSION: str = "1.0.0"
    
    # Security
    SECRET_KEY: str = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    ALGORITHM: str = "HS256"
    
    # Database
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./data/app.db")
    
    # AI Services
    OPENAI_API_KEY: Optional[str] = os.getenv("OPENAI_API_KEY")
    HUGGINGFACE_API_KEY: Optional[str] = os.getenv("HUGGINGFACE_API_KEY")
    GROQ_API_KEY: Optional[str] = os.getenv("GROQ_API_KEY")
    
    # Vector Database
    VECTOR_DB_PATH: str = "./data/vector_store"
    EMBEDDINGS_MODEL: str = "sentence-transformers/all-MiniLM-L6-v2"
    
    # CORS
    ALLOWED_HOSTS: List[str] = ["*"]  # Configure for production
    
    # File Upload
    UPLOAD_PATH: str = "./data/uploads"
    MAX_UPLOAD_SIZE: int = 10 * 1024 * 1024  # 10MB
    
    class Config:
        env_file = ".env"

settings = Settings()
EOF

    # Database setup
    cat > "$APP_DIR/backend/app/core/database.py" << 'EOF'
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from .config import settings

engine = create_engine(settings.DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
EOF

    # Security utilities
    cat > "$APP_DIR/backend/app/core/security.py" << 'EOF'
from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from .config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def verify_token(token: str):
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return payload
    except JWTError:
        return None
EOF

    print_success "✅ Backend core files created"
}

create_ai_services() {
    print_status "🤖 Creating AI service infrastructure..."
    
    # Main AI service
    cat > "$APP_DIR/backend/app/services/ai_service.py" << 'EOF'
from typing import List, Dict, Optional
import os
from langchain.llms import HuggingFacePipeline
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.vectorstores import FAISS
from langchain.text_splitter import CharacterTextSplitter
from ..core.config import settings

class AIService:
    def __init__(self):
        self.embeddings = None
        self.vector_store = None
        self.llm = None
        self.initialize_services()
    
    def initialize_services(self):
        """Initialize AI services"""
        try:
            # Initialize embeddings
            self.embeddings = HuggingFaceEmbeddings(
                model_name=settings.EMBEDDINGS_MODEL
            )
            
            # Load vector store if exists
            vector_store_path = settings.VECTOR_DB_PATH
            if os.path.exists(vector_store_path):
                self.vector_store = FAISS.load_local(vector_store_path, self.embeddings)
            
            # Initialize LLM (start with HuggingFace free tier)
            self.initialize_llm()
            
        except Exception as e:
            print(f"AI service initialization warning: {e}")
    
    def initialize_llm(self):
        """Initialize language model"""
        if settings.OPENAI_API_KEY:
            from langchain.llms import OpenAI
            self.llm = OpenAI(openai_api_key=settings.OPENAI_API_KEY)
        elif settings.HUGGINGFACE_API_KEY:
            # Use HuggingFace Inference API
            self.llm = HuggingFacePipeline.from_model_id(
                model_id="microsoft/DialoGPT-medium",
                task="text-generation",
                model_kwargs={"temperature": 0.7, "max_length": 512}
            )
        else:
            print("No AI API keys found. Using fallback responses.")
    
    async def process_text(self, text: str, task_type: str = "analyze") -> Dict:
        """Process text with AI"""
        if not self.llm:
            return self._fallback_response(text, task_type)
        
        try:
            prompt_template = self._get_prompt_template(task_type)
            chain = LLMChain(llm=self.llm, prompt=prompt_template)
            result = await chain.arun(text=text)
            return self._parse_response(result, task_type)
        except Exception as e:
            print(f"AI processing failed: {e}")
            return self._fallback_response(text, task_type)
    
    def _get_prompt_template(self, task_type: str) -> PromptTemplate:
        """Get prompt template for specific task"""
        templates = {
            "analyze": PromptTemplate(
                input_variables=["text"],
                template="Analyze the following text and provide insights:\n\n{text}\n\nAnalysis:"
            ),
            "summarize": PromptTemplate(
                input_variables=["text"],
                template="Summarize the following text concisely:\n\n{text}\n\nSummary:"
            ),
            "generate": PromptTemplate(
                input_variables=["text"],
                template="Based on this input, generate creative content:\n\n{text}\n\nGenerated content:"
            )
        }
        return templates.get(task_type, templates["analyze"])
    
    def _parse_response(self, response: str, task_type: str) -> Dict:
        """Parse AI response into structured format"""
        return {
            "result": response.strip(),
            "task_type": task_type,
            "confidence": 0.8,
            "metadata": {
                "model": "ai_service",
                "timestamp": str(datetime.utcnow())
            }
        }
    
    def _fallback_response(self, text: str, task_type: str) -> Dict:
        """Fallback response when AI is unavailable"""
        word_count = len(text.split())
        
        fallbacks = {
            "analyze": f"Text analysis: {word_count} words detected. Content appears to contain meaningful information.",
            "summarize": f"Summary: Text with {word_count} words covering various topics.",
            "generate": f"Generated content based on {word_count} word input would be created here."
        }
        
        return {
            "result": fallbacks.get(task_type, "AI processing result would appear here."),
            "task_type": task_type,
            "confidence": 0.5,
            "metadata": {
                "model": "fallback",
                "timestamp": str(datetime.utcnow())
            }
        }
    
    async def create_embeddings(self, texts: List[str]) -> List[List[float]]:
        """Create embeddings for texts"""
        if not self.embeddings:
            return []
        
        try:
            return await self.embeddings.aembed_documents(texts)
        except Exception as e:
            print(f"Embedding creation failed: {e}")
            return []
    
    async def similarity_search(self, query: str, k: int = 5) -> List[Dict]:
        """Search for similar content in vector store"""
        if not self.vector_store:
            return []
        
        try:
            docs = await self.vector_store.asimilarity_search(query, k=k)
            return [{"content": doc.page_content, "score": doc.metadata.get("score", 0)} for doc in docs]
        except Exception as e:
            print(f"Similarity search failed: {e}")
            return []

# Global AI service instance
ai_service = AIService()
EOF

    # Vector store service
    cat > "$APP_DIR/backend/app/services/vector_store.py" << 'EOF'
from typing import List, Dict
import os
from langchain.vectorstores import FAISS
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.text_splitter import CharacterTextSplitter
from ..core.config import settings

class VectorStoreService:
    def __init__(self):
        self.embeddings = HuggingFaceEmbeddings(model_name=settings.EMBEDDINGS_MODEL)
        self.vector_store = None
        self.load_vector_store()
    
    def load_vector_store(self):
        """Load existing vector store or create new one"""
        try:
            if os.path.exists(settings.VECTOR_DB_PATH):
                self.vector_store = FAISS.load_local(settings.VECTOR_DB_PATH, self.embeddings)
            else:
                # Create empty vector store
                self.vector_store = FAISS.from_texts([""], self.embeddings)
        except Exception as e:
            print(f"Vector store initialization failed: {e}")
    
    async def add_documents(self, texts: List[str], metadata: List[Dict] = None):
        """Add documents to vector store"""
        try:
            if metadata is None:
                metadata = [{}] * len(texts)
            
            # Split texts if they're too long
            text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
            split_texts = []
            split_metadata = []
            
            for i, text in enumerate(texts):
                chunks = text_splitter.split_text(text)
                split_texts.extend(chunks)
                split_metadata.extend([metadata[i]] * len(chunks))
            
            # Add to vector store
            self.vector_store.add_texts(split_texts, split_metadata)
            self.save_vector_store()
            
        except Exception as e:
            print(f"Failed to add documents: {e}")
    
    async def search(self, query: str, k: int = 5) -> List[Dict]:
        """Search for similar documents"""
        try:
            docs = self.vector_store.similarity_search_with_score(query, k=k)
            return [
                {
                    "content": doc.page_content,
                    "score": float(score),
                    "metadata": doc.metadata
                }
                for doc, score in docs
            ]
        except Exception as e:
            print(f"Search failed: {e}")
            return []
    
    def save_vector_store(self):
        """Save vector store to disk"""
        try:
            os.makedirs(os.path.dirname(settings.VECTOR_DB_PATH), exist_ok=True)
            self.vector_store.save_local(settings.VECTOR_DB_PATH)
        except Exception as e:
            print(f"Failed to save vector store: {e}")

# Global vector store instance
vector_store_service = VectorStoreService()
EOF

    print_success "✅ AI services created"
}

create_api_endpoints() {
    print_status "🔌 Creating API endpoints..."
    
    # Dependencies
    cat > "$APP_DIR/backend/app/api/dependencies.py" << 'EOF'
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from ..core.database import get_db
from ..core.security import verify_token

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
):
    """Get current authenticated user"""
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = verify_token(credentials.credentials)
        if payload is None:
            raise credentials_exception
        
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
            
        # TODO: Fetch user from database
        return {"id": user_id, "email": payload.get("email")}
        
    except Exception:
        raise credentials_exception
EOF

    # Auth endpoints
    cat > "$APP_DIR/backend/app/api/endpoints/auth.py" << 'EOF'
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer
from sqlalchemy.orm import Session
from pydantic import BaseModel
from datetime import timedelta
from ...core.database import get_db
from ...core.security import create_access_token, verify_password, get_password_hash
from ...core.config import settings

router = APIRouter()
security = HTTPBearer()

class UserLogin(BaseModel):
    email: str
    password: str

class UserRegister(BaseModel):
    email: str
    password: str
    name: str

class Token(BaseModel):
    access_token: str
    token_type: str

@router.post("/register", response_model=Token)
async def register_user(user_data: UserRegister, db: Session = Depends(get_db)):
    """Register a new user"""
    # TODO: Check if user exists
    # TODO: Create user in database
    
    # For demo purposes, create token
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user_data.email, "email": user_data.email},
        expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/login", response_model=Token)
async def login_user(user_data: UserLogin, db: Session = Depends(get_db)):
    """Login user"""
    # TODO: Verify user credentials from database
    
    # For demo purposes, accept any login
    if user_data.email and user_data.password:
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": user_data.email, "email": user_data.email},
            expires_delta=access_token_expires
        )
        return {"access_token": access_token, "token_type": "bearer"}
    
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Incorrect email or password",
    )

@router.get("/me")
async def get_current_user_info(current_user: dict = Depends(get_current_user)):
    """Get current user information"""
    return current_user
EOF

    # AI endpoints
    cat > "$APP_DIR/backend/app/api/endpoints/ai.py" << 'EOF'
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from ...services.ai_service import ai_service
from ...services.vector_store import vector_store_service
from ..dependencies import get_current_user

router = APIRouter()

class TextProcessRequest(BaseModel):
    text: str
    task_type: str = "analyze"

class TextProcessResponse(BaseModel):
    result: str
    task_type: str
    confidence: float
    metadata: dict

class SearchRequest(BaseModel):
    query: str
    k: int = 5

@router.post("/process", response_model=TextProcessResponse)
async def process_text(
    request: TextProcessRequest,
    current_user: dict = Depends(get_current_user)
):
    """Process text with AI"""
    try:
        result = await ai_service.process_text(request.text, request.task_type)
        return TextProcessResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Processing failed: {str(e)}")

@router.post("/search")
async def search_similar(
    request: SearchRequest,
    current_user: dict = Depends(get_current_user)
):
    """Search for similar content"""
    try:
        results = await vector_store_service.search(request.query, request.k)
        return {"results": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Search failed: {str(e)}")

@router.post("/add-knowledge")
async def add_knowledge(
    texts: List[str],
    current_user: dict = Depends(get_current_user)
):
    """Add texts to knowledge base"""
    try:
        await vector_store_service.add_documents(texts)
        return {"message": f"Added {len(texts)} documents to knowledge base"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to add knowledge: {str(e)}")
EOF

    # __init__.py files
    touch "$APP_DIR/backend/app/__init__.py"
    touch "$APP_DIR/backend/app/api/__init__.py"
    touch "$APP_DIR/backend/app/api/endpoints/__init__.py"
    touch "$APP_DIR/backend/app/core/__init__.py"
    touch "$APP_DIR/backend/app/services/__init__.py"
    touch "$APP_DIR/backend/app/models/__init__.py"
    touch "$APP_DIR/backend/app/utils/__init__.py"

    print_success "✅ API endpoints created"
}

main() {
    if [[ -d "$APP_DIR" ]]; then
        print_status "📁 Directory $APP_DIR already exists. Enhancing structure..."
    else
        print_status "📁 Creating new app: $APP_DIR"
        mkdir -p "$APP_DIR"
    fi
    
    cd "$APP_DIR"
    
    create_directory_structure
    create_backend_files
    create_ai_services
    create_api_endpoints
    
    print_success "🎉 Complete AI app infrastructure created!"
    echo ""
    echo "Next steps:"
    echo "1. cd $APP_DIR"
    echo "2. pip install -r ../roadmap_build_generative_ai/templates/backend-requirements.txt"
    echo "3. npm install (for frontend)"
    echo "4. Copy environment template: cp ../roadmap_build_generative_ai/templates/.env.example .env"
    echo "5. Start development: python backend/main.py"
}

main "$@"
