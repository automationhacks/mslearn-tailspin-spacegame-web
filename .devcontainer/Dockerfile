# Base image contains .NET SDK
FROM mcr.microsoft.com/devcontainers/dotnet:1-8.0

# Install NodeJS
# [Choice] Node.js version: none, lts/*, 18, 16, 14
ARG NODE_VERSION="16"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Install Gulp
RUN npm install --global gulp-cli

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# [Optional] Install zsh
ARG INSTALL_ZSH="true"
# [Optional] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"

# Install needed packages and setup non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true"

# Install additional .NET tools
RUN su vscode -c "dotnet tool install -g dotnet-ef && \
    dotnet tool install -g dotnet-aspnet-codegenerator && \
    dotnet dev-certs https --trust"

# Setup Azure Pipelines agent
ARG ARCH="x64"
ARG AGENT_VERSION="2.206.1"

# Copy and run the Azure Pipelines agent installation script
COPY library-scripts/install-azure-pipelines-agent.sh /tmp/library-scripts/
RUN chmod +x /tmp/library-scripts/install-azure-pipelines-agent.sh && \
    /tmp/library-scripts/install-azure-pipelines-agent.sh "${AGENT_VERSION}" "${ARCH}"

# Copy over the start.sh script
COPY library-scripts/start.sh /home/vscode/azure-pipelines/start.sh
RUN chmod +x /home/vscode/azure-pipelines/start.sh

# Add .NET tools to PATH
ENV PATH="/home/vscode/.dotnet/tools:${PATH}"

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/library-scripts