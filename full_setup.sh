#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install system dependencies
install_system_dependencies() {
    echo "Installing system dependencies..."
    
    # Check OS and install accordingly
    if command_exists apt-get; then
        # Ubuntu/Debian
        apt-get update && apt-get install -y \
            curl \
            git \
            docker.io \
            docker-compose
    elif command_exists yum; then
        # CentOS/RHEL
        yum install -y \
            curl \
            git \
            docker \
            docker-compose
    elif command_exists brew; then
        # macOS
        brew install \
            curl \
            git \
            docker \
            docker-compose
    else
        echo "Unsupported package manager"
        exit 1
    fi
}

# Function to install Docker Desktop for Windows
install_docker_desktop_windows() {
    echo "Installing Docker Desktop for Windows..."
    
    # Create temporary download directory
    mkdir -p /tmp/docker
    cd /tmp/docker
    
    # Download Docker Desktop installer
    curl -L "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" -o docker-desktop.exe
    
    # Run the installer
    ./docker-desktop.exe
    
    # Clean up
    rm docker-desktop.exe
    cd -
    rm -rf /tmp/docker
}

# Function to clone and setup repository
setup_repository() {
    echo "Setting up repository..."
    
    # Create project directory if it doesn't exist
    if [ ! -d "chatbot" ]; then
        mkdir chatbot
    fi
    
    cd chatbot
    
    # Clone repository if it doesn't exist
    if [ ! -d ".git" ]; then
        git clone https://github.com/eastkode/chatbot.git .
    else
        # Pull latest changes
        git pull origin master
    fi
}

# Function to build and run containers
build_and_run_containers() {
    echo "Building and running containers..."
    
    # Check if docker-compose.yml exists
    if [ ! -f "docker-compose.yml" ]; then
        echo "Error: docker-compose.yml not found"
        exit 1
    fi

    # Build and start containers
    docker compose up -d --build
    
    # Wait for containers to start
    echo "Waiting for containers to start..."
    sleep 10
    
    # Check if containers are running
    RUNNING=$(docker compose ps | grep -c "Up")
    if [ "$RUNNING" -eq 0 ]; then
        echo "Error: Containers failed to start"
        docker compose logs
        exit 1
    fi
    
    echo "\nChatbot is now running at http://localhost:5002"
    
    # Show container status
    echo "\nContainer status:"
    docker compose ps
}

# Main script execution

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (sudo)"
    exit 1
fi

# Check OS
OS=$(uname)

# Handle Windows WSL
if [ "$OS" == "MINGW64_NT-10.0" ]; then
    echo "Detected Windows WSL environment"
    
    # Install Docker Desktop for Windows
    install_docker_desktop_windows
    
    # Wait for Docker Desktop to start
    echo "Please start Docker Desktop and wait for it to initialize"
    echo "Press Enter when Docker Desktop is running..."
    read
    
    # Continue with setup
    setup_repository
    build_and_run_containers
    exit 0
fi

# Install system dependencies
install_system_dependencies

# Start Docker service
if command_exists systemctl; then
    systemctl start docker
    systemctl enable docker
fi

# Setup repository
setup_repository

# Build and run containers
build_and_run_containers

# Show completion message
echo "\nSetup complete!"
echo "Chatbot is running at http://localhost:5002"
echo "You can stop the containers with: docker compose down"
