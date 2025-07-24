# Shared Resources

This directory contains reusable code, components, and utilities shared across all apps in the generative AI portfolio.

## 📁 Directory Structure

```
shared/
├── ai-utils/          # AI model utilities and abstractions
├── ui-components/     # Reusable React Native components
├── api-client/        # Backend communication utilities
├── vector-store/      # Vector database abstractions
├── auth/             # Authentication and user management
├── config/           # Shared configuration
├── types/            # TypeScript type definitions
├── utils/            # General utility functions
└── README.md         # This file
```

## 🤖 AI Utils (`ai-utils/`)

Common AI operations and model abstractions:

- **Model Managers**: Unified interface for different LLMs
- **Embedding Utilities**: Text-to-vector conversion
- **Prompt Templates**: Reusable prompt patterns
- **Response Parsers**: Structured output extraction

Example usage:
```python
from shared.ai_utils import ModelManager, EmbeddingService

# Use any model with consistent interface
model = ModelManager.get_model("mistral-7b")
response = model.generate("Summarize this text...")

# Generate embeddings
embeddings = EmbeddingService.embed_texts(["text1", "text2"])
```

## 🎨 UI Components (`ui-components/`)

Reusable React Native components:

- **Input Components**: Text inputs, file pickers, voice recording
- **Display Components**: Cards, lists, chat bubbles
- **Loading States**: Spinners, progress bars, skeletons
- **Error Handling**: Error boundaries, retry mechanisms

Example usage:
```jsx
import { AITextInput, LoadingSpinner, ErrorBoundary } from '../shared/ui-components';

function MyComponent() {
  return (
    <ErrorBoundary>
      <AITextInput 
        placeholder="Enter your prompt..."
        onSubmit={handleSubmit}
        loading={isProcessing}
      />
    </ErrorBoundary>
  );
}
```

## 🌐 API Client (`api-client/`)

Backend communication utilities:

- **HTTP Client**: Configured axios instance with auth
- **Request Builders**: Type-safe API request construction
- **Response Handlers**: Error handling and data transformation
- **Caching**: Response caching strategies

Example usage:
```typescript
import { ApiClient } from '../shared/api-client';

const client = new ApiClient({
  baseURL: process.env.API_BASE_URL,
  apiKey: process.env.API_KEY
});

const summary = await client.post('/summarize', {
  text: document.content,
  options: { maxLength: 100 }
});
```

## 🗄️ Vector Store (`vector-store/`)

Database abstraction layer:

- **Store Interface**: Unified API for all vector databases
- **ChromaDB Adapter**: Implementation for ChromaDB
- **FAISS Adapter**: Implementation for FAISS
- **Migration Tools**: Data export/import utilities

Example usage:
```python
from shared.vector_store import VectorStoreFactory

# Create store (implementation auto-selected)
store = VectorStoreFactory.create_store("chromadb")
store.add_documents(documents)
results = store.similarity_search("query", k=5)
```

## 🔐 Auth (`auth/`)

Authentication and user management:

- **Auth Provider**: React context for authentication state
- **Token Management**: JWT handling and refresh
- **User Profile**: User data management
- **Permissions**: Role-based access control

Example usage:
```jsx
import { useAuth } from '../shared/auth';

function ProtectedComponent() {
  const { user, isAuthenticated, login, logout } = useAuth();
  
  if (!isAuthenticated) {
    return <LoginScreen onLogin={login} />;
  }
  
  return <AppContent user={user} />;
}
```

## ⚙️ Config (`config/`)

Shared configuration management:

- **Environment Config**: Environment-specific settings
- **Model Config**: AI model configurations
- **App Config**: App-specific settings
- **Theme Config**: UI theming and styling

Example usage:
```typescript
import { config } from '../shared/config';

const modelConfig = config.models.mistral7b;
const apiEndpoint = config.api.baseUrl;
const theme = config.ui.theme;
```

## 📝 Types (`types/`)

TypeScript type definitions:

- **AI Types**: Model responses, embeddings, etc.
- **API Types**: Request/response interfaces
- **UI Types**: Component props and state
- **Data Types**: Business logic entities

Example usage:
```typescript
import { 
  AIModelResponse, 
  VectorSearchResult, 
  UserProfile 
} from '../shared/types';

function processAIResponse(response: AIModelResponse): string {
  return response.content.trim();
}
```

## 🛠️ Utils (`utils/`)

General utility functions:

- **Text Processing**: Cleaning, chunking, formatting
- **File Handling**: Upload, download, format conversion
- **Validation**: Input validation and sanitization
- **Performance**: Debouncing, memoization, caching

Example usage:
```typescript
import { 
  chunkText, 
  validateEmail, 
  debounce,
  formatFileSize 
} from '../shared/utils';

const chunks = chunkText(document, { size: 1000, overlap: 200 });
const isValid = validateEmail(email);
const debouncedSearch = debounce(searchFunction, 300);
```

## 🏗️ Architecture Patterns

### Dependency Injection
```typescript
// Service container for dependency management
import { Container } from '../shared/container';

Container.register('aiService', AIService);
Container.register('vectorStore', ChromaDBStore);

const aiService = Container.resolve<AIService>('aiService');
```

### Event System
```typescript
// Shared event bus for cross-app communication
import { EventBus } from '../shared/events';

EventBus.emit('document.processed', { id, summary });
EventBus.on('user.preferences.changed', handlePreferencesChange);
```

### State Management
```typescript
// Shared state management with Zustand
import { useAppStore } from '../shared/store';

const { user, setUser, preferences, updatePreferences } = useAppStore();
```

## 🧪 Testing Utilities

### Mock Services
```typescript
import { MockAIService, MockVectorStore } from '../shared/testing';

// Use in tests
const mockAI = new MockAIService();
mockAI.setResponse('Mocked response');
```

### Test Helpers
```typescript
import { renderWithProviders, createMockUser } from '../shared/testing';

const user = createMockUser({ plan: 'premium' });
const { getByText } = renderWithProviders(<Component />, { user });
```

## 📦 Package Management

### Installation
```bash
cd shared
npm install  # Install shared dependencies
```

### Building
```bash
npm run build   # Build shared components
npm run test    # Run shared tests
npm run lint    # Lint shared code
```

## 🔄 Update Strategy

### Versioning
- Use semantic versioning for shared components
- Document breaking changes in CHANGELOG.md
- Provide migration guides for major updates

### Distribution
```json
{
  "workspaces": [
    "apps/*",
    "shared"
  ]
}
```

## 📚 Documentation

### API Documentation
- JSDoc comments for all public APIs
- TypeScript interfaces for type safety
- Usage examples in README files

### Architecture Decision Records (ADRs)
Document important architectural decisions:
- Why certain patterns were chosen
- Trade-offs and alternatives considered
- Migration paths for future changes

## 🎯 Best Practices

### Code Organization
- Keep interfaces stable across versions
- Use composition over inheritance
- Implement proper error boundaries
- Follow consistent naming conventions

### Performance
- Lazy load components when possible
- Implement proper caching strategies
- Monitor bundle sizes
- Profile performance regularly

### Security
- Validate all inputs
- Sanitize user data
- Use secure defaults
- Implement proper error handling

---

The shared resources form the foundation of your generative AI app ecosystem. Keep them well-maintained, documented, and tested for maximum productivity across all projects! 🚀
