# 🚀 Complete Setup Guide - Start Building AI Apps in 15 Minutes!

> **Goal**: Get you from zero to building your first AI-powered mobile app as quickly as possible, with clear explanations every step of the way.

## 🎯 What You'll Have After This Guide

- ✅ **Complete development environment** ready for AI mobile app development
- ✅ **Your first AI app** running on your phone
- ✅ **Understanding** of how everything fits together
- ✅ **Confidence** to start building any of the 10 AI applications

## 📋 Before We Start

### ✅ **What You Need**
- **Computer**: Windows, Mac, or Linux (any modern computer works)
- **Smartphone**: iPhone or Android for testing your apps
- **Internet**: Stable connection for downloading tools and AI services
- **Time**: About 15-30 minutes for initial setup

### ❌ **What You DON'T Need**
- ❌ Previous AI experience (we'll teach you!)
- ❌ Mobile development experience (React Native is beginner-friendly!)
- ❌ Expensive software (everything is free!)
- ❌ Powerful computer (modern laptops work great!)

---

## 🏃‍♂️ Quick Start (For the Impatient)

**Want to get started immediately? Run these 4 commands:**

```bash
# 1. Get the code
git clone https://github.com/PCSchmidt/roadmap-for-building-generative-ai-apps.git
cd roadmap-for-building-generative-ai-apps

# 2. Set up everything automatically
./scripts/setup.sh

# 3. Create your first app (AI Recipe Generator - perfect for beginners!)
./scripts/create-app-repo.sh recipe-generator

# 4. Start building!
cd ../generative-ai-recipe-generator
npm install && npm start
```

**That's it!** Your first AI app is now running. Continue reading for detailed explanations.

---

## 📚 Detailed Setup (Recommended for Learning)

### **Step 1: Install Core Development Tools**

#### **🔹 Git (Version Control)**
**What it does**: Saves your code and tracks changes  
**Why you need it**: Backup your work and collaborate with others

**Install:**
- **Windows**: Download from [git-scm.com](https://git-scm.com/)
- **Mac**: `brew install git` or download from [git-scm.com](https://git-scm.com/)
- **Linux**: `sudo apt install git` (Ubuntu) or `sudo yum install git` (CentOS)

**Verify**: `git --version` (should show version number)

#### **🔹 Node.js (JavaScript Runtime)**
**What it does**: Runs JavaScript code and manages app dependencies  
**Why you need it**: React Native (our mobile framework) needs it

**Install:** Download LTS version from [nodejs.org](https://nodejs.org/)  
**Verify**: `node --version` and `npm --version` (both should show version numbers)

#### **🔹 Python (AI Backend Language)**
**What it does**: Runs our AI services and backend APIs  
**Why you need it**: All the AI magic happens in Python

**Install:** Download Python 3.9+ from [python.org](https://python.org/)  
**Verify**: `python --version` (should be 3.9 or higher)

#### **🔹 VS Code (Code Editor)**
**What it does**: Your main workspace for writing code  
**Why this one**: Best AI coding assistance with GitHub Copilot

**Install:** Download from [code.visualstudio.com](https://code.visualstudio.com/)  
**Essential Extensions**:
- GitHub Copilot (AI coding assistant)
- Python (Python language support)
- React Native Tools (Mobile development support)

### **Step 2: Set Up Mobile Development**

#### **🔹 Expo CLI (Mobile App Tool)**
**What it does**: Makes mobile development super easy  
**Why you'll love it**: Test apps on your phone instantly, no complicated setup

```bash
npm install -g @expo/cli
```

**Verify**: `expo --version`

#### **🔹 Expo Go App (On Your Phone)**
**What it does**: Run your apps directly on your phone during development  
**Download**: Search "Expo Go" in App Store (iOS) or Google Play (Android)

### **Step 3: Get This Repository**

```bash
# Clone the main repository
git clone https://github.com/PCSchmidt/roadmap-for-building-generative-ai-apps.git

# Go into the directory
cd roadmap-for-building-generative-ai-apps

# Take a look around
ls -la
```

**What you'll see:**
- `📁 docs/` - Learning guides and documentation
- `📁 scripts/` - Helpful automation scripts
- `📁 templates/` - Starting templates for new apps
- `📄 README.md` - Project overview
- `📄 CONTRIBUTING.md` - How to contribute

### **Step 4: Set Up AI Services (Free Accounts)**

#### **🔹 Hugging Face (Free AI Models)**
**What it provides**: Access to thousands of AI models  
**Free tier**: 2,000 API calls per month (plenty for learning!)

1. Go to [huggingface.co](https://huggingface.co/) and create account
2. Go to Settings → Access Tokens
3. Create a new token (select "Read" permissions)
4. Save this token - you'll need it later!

#### **🔹 Groq (Super Fast AI)**
**What it provides**: Lightning-fast AI model inference  
**Free tier**: Generous limits for development

1. Go to [console.groq.com](https://console.groq.com/) and create account
2. Go to API Keys section
3. Create a new API key
4. Save this key - you'll need it later!

### **Step 5: Create Your First App**

#### **🔹 Choose Your Starting App**

**For Beginners**: 🍳 **AI Recipe Generator**
- Simple AI concepts
- Fun, practical results
- Quick to build and understand

**For Intermediate**: 📝 **AI Journal Summarizer**  
- Real-world utility
- Learn document processing
- Great for portfolios

**For Advanced**: 🤝 **AI Icebreaker Generator**
- Complex integrations
- Advanced AI concepts
- Impressive results

#### **🔹 Create the App**

```bash
# From the main roadmap directory
./scripts/create-app-repo.sh recipe-generator

# This creates a new directory with everything set up
cd ../generative-ai-recipe-generator
```

#### **🔹 Install Dependencies**

```bash
# Install all the packages your app needs
npm install

# Install Python packages for AI backend
pip install -r backend/requirements.txt
```

### **Step 6: Configure Your AI Keys**

Create a file called `.env` in your app directory:

```bash
# In your app directory (e.g., generative-ai-recipe-generator)
touch .env
```

Add your API keys to this file:

```env
# Your Hugging Face token
HUGGINGFACE_API_KEY=your_token_here

# Your Groq API key  
GROQ_API_KEY=your_key_here

# App configuration
NODE_ENV=development
API_BASE_URL=http://localhost:8000
```

**⚠️ Important**: Never commit this file to git! It's already in `.gitignore`.

### **Step 7: Start Your First App**

#### **🔹 Start the Backend (AI Services)**

```bash
# In one terminal, start the Python backend
cd backend
python -m uvicorn app.main:app --reload --port 8000
```

You should see: `Uvicorn running on http://127.0.0.1:8000`

#### **🔹 Start the Frontend (Mobile App)**

```bash
# In another terminal, start the React Native app
npm start
```

You should see a QR code and several options.

#### **🔹 Test on Your Phone**

1. **Open Expo Go** app on your phone
2. **Scan the QR code** (or type the URL)
3. **Wait for the app to load** (first time takes a minute)
4. **🎉 Success!** Your AI app is running on your phone!

---

## 🎉 You're Ready to Build!

### **What You've Accomplished**

✅ **Complete development environment** for AI mobile apps  
✅ **Your first AI app** running live on your phone  
✅ **Understanding** of the development workflow  
✅ **Foundation** to build any of the 10 AI applications  

### **Next Steps**

1. **🎯 Follow the app-specific guide** in your chosen app's `docs/` folder
2. **🧠 Learn AI concepts** as you implement features
3. **📱 Test frequently** on your phone to see progress
4. **🚀 Deploy** when ready to share with others

### **Quick Development Workflow**

```bash
# Daily development routine:

# 1. Start backend
cd backend && python -m uvicorn app.main:app --reload

# 2. Start frontend  
npm start

# 3. Code, test, repeat!
# 4. Push to GitHub when ready
git add . && git commit -m "Add new feature" && git push
```

## 🆘 Need Help?

### **Common Issues & Solutions**

**🔧 "Command not found" errors**
- Make sure you installed Node.js, Python, and added them to your PATH
- Restart your terminal after installing

**🔧 "Permission denied" errors**  
- On Mac/Linux: Add `sudo` before commands
- On Windows: Run terminal as Administrator

**🔧 "Module not found" errors**
- Run `npm install` in the frontend directory
- Run `pip install -r requirements.txt` in the backend directory

**🔧 App won't load on phone**
- Make sure your phone and computer are on the same WiFi
- Try typing the URL manually instead of scanning QR code

### **Get Community Support**

- 💬 **GitHub Issues**: Ask questions on the repository
- 🤝 **Discussions**: Share your progress and get help
- 📧 **Direct Contact**: Check the repository for contact information

---

## 🎯 Ready for Advanced Setup?

Once you're comfortable with the basics, explore these advanced topics:

- **🐳 Docker**: Containerize your applications
- **☁️ Cloud Deployment**: Deploy to Render, Heroku, or AWS
- **🔄 CI/CD**: Automate testing and deployment
- **📊 Analytics**: Track app usage and AI performance
- **🛡️ Security**: Implement authentication and secure API keys

**Happy building! 🚀 You're about to create amazing AI applications that people will love to use.**
