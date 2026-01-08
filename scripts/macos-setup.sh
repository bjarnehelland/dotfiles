#!/bin/bash

# macos-setup.sh - Configure macOS defaults and system settings

set -e  # Exit on any error

echo "🍎 Configuring macOS defaults..."

# Configure Touch ID for sudo
configure_touchid_sudo() {
    echo "⚡ Configuring Touch ID for sudo..."
    
    # Check if Touch ID is already configured
    if grep -q "pam_tid.so" /etc/pam.d/sudo 2>/dev/null; then
        echo "✅ Touch ID for sudo already configured"
        return 0
    fi
    
    # Create backup
    sudo cp /etc/pam.d/sudo /etc/pam.d/sudo.backup
    
    # Add Touch ID support
    echo "auth       sufficient     pam_tid.so" | sudo tee /etc/pam.d/sudo.tmp > /dev/null
    sudo cat /etc/pam.d/sudo.backup >> /etc/pam.d/sudo.tmp
    sudo mv /etc/pam.d/sudo.tmp /etc/pam.d/sudo
    
    echo "✅ Touch ID configured for sudo"
}

# macOS System Preferences
configure_macos_defaults() {
    echo "⚙️  Setting macOS defaults..."
    
    # Finder preferences
    defaults write com.apple.finder ShowHiddenFiles -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    
    # Dock preferences  
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock tilesize -int 48
    defaults write com.apple.dock minimize-to-application -bool true
    
    # Screenshot location
    defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"
    
    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    
    # Key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    
    # Show battery percentage
    defaults write com.apple.menuextra.battery ShowPercent -bool true
    
    echo "✅ macOS defaults configured"
}

# Apply changes
apply_changes() {
    echo "🔄 Applying changes..."
    
    # Restart affected applications
    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    killall SystemUIServer 2>/dev/null || true
    
    echo "✅ Changes applied"
}

update_blocc_cron() {
    local interval="${1:-2}"  # Default to every 2 hours if not specified
    local bl_path="$(which bl)"
    
    # Remove any existing bl cron entries (broken or old versions)
    local cleaned_cron=$(crontab -l 2>/dev/null | grep -v "bl$" | grep -v "$bl_path")
    
    # Add the new cron job with suppressed output
    local new_job="$bl_path >/dev/null 2>&1"
    local schedule="0 */$interval * * *"
    
    echo "$cleaned_cron" | (cat; echo "$schedule $new_job") | crontab -
    
    echo "✅ Updated blocc cron job: runs every $interval hour(s)"
    echo "   Schedule: $schedule"
    echo "   Command: $new_job"
}

# Main execution
main() {
    echo "🚀 Starting macOS configuration..."
    
    configure_touchid_sudo
    configure_macos_defaults
    apply_changes
    update_blocc_cron 2  # Update blocc cron job to run every 2 hours
    
    echo "🎉 macOS configuration complete!"
    echo "💡 You may need to restart some applications or log out/in for all changes to take effect"
}



# Run if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi