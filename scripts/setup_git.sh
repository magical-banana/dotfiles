#!/bin/bash

export RED='\033[0;31m'
export NC='\033[0m'

# Define filenames
EXAMPLE_FILE="$HOME/dotfiles/git/.gitconfig.local.example"
TARGET_FILE="$HOME/.gitconfig.local"

echo "⚙️  Configuring Git..."

# 1. Check if .gitconfig already exists
if [ -f "$TARGET_FILE" ]; then
    echo "✅ Existing $TARGET_FILE found. Skipping setup."
    exit 0
fi

# 2. Check if the example file exists to copy from
if [ ! -f "$EXAMPLE_FILE" ]; then
    echo "${RED}❌ Error: $EXAMPLE_FILE not found!${NC}"
    exit 1
fi

echo "ℹ️  Setting up your git identity..."

# 3. Prompt for user details
read -p "Enter your Full Name: " git_name
read -p "Enter your Email address: " git_email

# 4. Copy example to target
cp "$EXAMPLE_FILE" "$TARGET_FILE"

# 5. Replace the placeholders in the new file
# We use -i for in-place editing. 
# Using '|' as a delimiter in case the email contains '/'
sed -i "s/\[Your Full Name for THIS Machine\]/$git_name/" "$TARGET_FILE"
sed -i "s/\[Your Email for THIS Machine\]/$git_email/" "$TARGET_FILE"

echo "✅ Success! $TARGET_FILE has been created with your identity."