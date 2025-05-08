# Amity University Chatbot

A Dockerized chatbot application using OpenAI's GPT-3.5 model.

## Features

- Simple chat interface with Amity University theme
- Poppins font for modern look
- Real-time chat with AI responses
- Dockerized for easy deployment
- Frontend runs on port 5002
- Backend runs on port 5001

## Setup

1. Clone the repository:
```bash
git clone https://github.com/eastkode/chatbot.git
```

2. Navigate to the project directory:
```bash
cd chatbot
```

3. Build and run the containers:
```bash
docker-compose up -d
```

## Deployment

Use the provided `deploy.sh` script to deploy on a fresh server:

```bash
bash deploy.sh
```

The script will:
1. Install Docker and Docker Compose if needed
2. Clone the repository
3. Build and run the containers

## Training Data

To add custom training data:

1. Create a `data` folder in the root directory
2. Add your training data files (.txt or .md)
3. The bot will use this data as additional context for replies

## Ports

- Frontend: http://localhost:5002
- Backend API: http://localhost:5001
