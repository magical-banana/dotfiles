#!/bin/bash

echo "⚙️  Setup mise..."

# Install Mise if missing
if ! command -v mise &> /dev/null; then
    echo "ℹ️  mise command is missing, installing mise..."
    curl https://mise.jdx.dev/install.sh | sh
fi

echo "✅ Mise setup complete."