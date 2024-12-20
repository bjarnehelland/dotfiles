#!/bin/bash

# Prompt for user email
echo "Enter your GitHub email address:"
read email

# Generate the SSH key
ssh-keygen -t ed25519 -C "$email"

# Start the ssh-agent and add the SSH key
eval "$(ssh-agent -s)"

# Create or append to the SSH config file
SSH_CONFIG=~/.ssh/config
if [ ! -f "$SSH_CONFIG" ]; then
    touch "$SSH_CONFIG"
fi

# Add GitHub configuration to ~/.ssh/config if not already present
if ! grep -q "github.com" "$SSH_CONFIG"; then
    echo "Adding GitHub configuration to $SSH_CONFIG"
    cat <<EOL >> "$SSH_CONFIG"

# GitHub configuration
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
EOL
else
    echo "GitHub configuration already exists in $SSH_CONFIG"
fi


ssh-add --apple-use-keychain ~/.ssh/id_ed25519

pbcopy < ~/.ssh/id_ed25519.pub

echo "Copy this key and add it to your GitHub account:"
echo "https://github.com/settings/keys"