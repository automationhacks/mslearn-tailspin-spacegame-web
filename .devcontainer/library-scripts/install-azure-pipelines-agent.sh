#!/bin/bash

AGENT_VERSION=$1
ARCH=$2

# Install necessary dependencies
apt-get update && \
apt-get install -y \
    liblttng-ust1 \
    libcurl4 \
    libkrb5-3 \
    zlib1g \
    libicu72 \
    && rm -rf /var/lib/apt/lists/*

# Create and set up agent directory
cd /home/vscode
mkdir -p azure-pipelines
cd azure-pipelines

# Download and extract agent
curl -O -L https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${ARCH}-${AGENT_VERSION}.tar.gz
tar xzf vsts-agent-linux-${ARCH}-${AGENT_VERSION}.tar.gz

# Clean up downloaded archive
rm vsts-agent-linux-${ARCH}-${AGENT_VERSION}.tar.gz

# Set permissions
chown -R vscode:vscode /home/vscode/azure-pipelines
