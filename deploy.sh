#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Clone or update repository
echo "Cloning repository..."
if [ -d "chatbot" ]; then
    cd chatbot
    git pull
else
    git clone https://github.com/eastkode/chatbot.git .
fi

# Build and run containers
echo "Building and running containers..."
docker-compose up -d --build

# Wait for containers to start
echo "Waiting for containers to start..."
sleep 5

echo "Chatbot is now running at http://localhost:5002"
