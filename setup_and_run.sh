#!/bin/bash

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    
    # Check OS and install accordingly
    if [ -f "/etc/os-release" ]; then
        # Linux
        . /etc/os-release
        
        case $ID in
            ubuntu|debian)
                # Install Docker on Ubuntu/Debian
                apt-get update
                apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                curl -fsSL https://download.docker.com/linux/$ID/gpg | apt-key add -
                add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$ID $(lsb_release -cs) stable"
                apt-get update
                apt-get install -y docker-ce docker-ce-cli containerd.io
                ;;
            centos|rhel)
                # Install Docker on CentOS/RHEL
                yum install -y yum-utils
                yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
                yum install -y docker-ce docker-ce-cli containerd.io
                ;;
            *)
                echo "Unsupported Linux distribution"
                exit 1
                ;;
        esac
    elif [ "$(uname)" == "Darwin" ]; then
        # macOS
        echo "Please install Docker Desktop for Mac from: https://www.docker.com/products/docker-desktop"
        exit 1
    elif [ "$(uname)" == "MINGW64_NT-10.0" ]; then
        # Windows (WSL)
        echo "Please install Docker Desktop for Windows from: https://www.docker.com/products/docker-desktop"
        exit 1
    else
        echo "Unsupported operating system"
        exit 1
    fi
}

# Function to install Docker Compose
install_docker_compose() {
    echo "Installing Docker Compose..."
    
    # Check OS and install accordingly
    if [ -f "/etc/os-release" ]; then
        # Linux
        curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    elif [ "$(uname)" == "Darwin" ]; then
        # macOS
        brew install docker-compose
    elif [ "$(uname)" == "MINGW64_NT-10.0" ]; then
        # Windows (WSL)
        echo "Docker Compose will be installed with Docker Desktop"
    fi
}

# Function to clone repository
clone_repo() {
    echo "Cloning repository..."
    if [ -d "chatbot" ]; then
        echo "Directory chatbot already exists. Pulling latest changes..."
        cd chatbot
        git pull origin master
        cd ..
    else
        git clone https://github.com/eastkode/chatbot.git chatbot
        cd chatbot
    fi
}

# Function to build and run containers
build_and_run() {
    echo "Building and running containers..."
    
    # Check if docker-compose.yml exists
    if [ ! -f "docker-compose.yml" ]; then
        echo "Error: docker-compose.yml not found in current directory"
        exit 1
    fi

    # Build and start containers
    docker compose up -d --build
    if [ $? -ne 0 ]; then
        echo "Error: Failed to start containers"
        exit 1
    fi
    
    # Wait for containers to start
    echo "Waiting for containers to start..."
    sleep 5
    
    echo "Chatbot is now running at http://localhost:5002"
    
    # Show container status
    echo "\nContainer status:"
    docker compose ps
    
    # Show logs
    echo "\nContainer logs:"
    docker compose logs
}

# Main script execution

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing..."
    install_docker
else
    echo "Docker is already installed"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing..."
    install_docker_compose
else
    echo "Docker Compose is already installed"
fi

# Check if in chatbot directory
if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "Not in chatbot directory. Cloning repository..."
    clone_repo
fi

# Build and run containers
build_and_run

# Show status of running containers
echo "\nContainer status:" docker compose ps

# Show logs
echo "\nContainer logs:" docker compose logs
