#!/bin/bash

# macos-setup.sh - Configure macOS defaults and system settings

set -e  # Exit on any error

echo "🍎 Configuring macOS defaults..."

# Configure Touch ID for sudo (uses sudo_local, survives macOS updates)
configure_touchid_sudo() {
    echo "⚡ Configuring Touch ID for sudo..."

    if [[ -f /etc/pam.d/sudo_local ]] && grep -q "^auth.*pam_tid.so" /etc/pam.d/sudo_local; then
        echo "✅ Touch ID for sudo already configured"
        return 0
    fi

    if [[ ! -f /etc/pam.d/sudo_local.template ]]; then
        echo "⚠️  /etc/pam.d/sudo_local.template not found — skipping (requires macOS 14+)"
        return 0
    fi

    sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
    sudo sed -i '' 's|^#auth.*pam_tid.so|auth       sufficient     pam_tid.so|' /etc/pam.d/sudo_local

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

# Curate Dock apps via dockutil (idempotent — wipes and rebuilds)
configure_dock() {
    echo "🧱 Configuring Dock apps..."

    if ! command -v dockutil >/dev/null; then
        echo "⚠️  dockutil not installed — skipping (run 'make brew' first)"
        return 0
    fi

    local dock_apps=(
        "/Applications/Google Chrome.app"
        "/Applications/Claude.app"
        "/Applications/cmux.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Docker.app"
        "/Applications/Bruno.app"
        "/Applications/Slack.app"
        "/Applications/Microsoft Teams.app"
        "/Applications/Microsoft Outlook.app"
        "/Applications/Notion.app"
        "/Applications/Spotify.app"
        "/Applications/1Password.app"
    )

    dockutil --remove all --no-restart >/dev/null

    for app in "${dock_apps[@]}"; do
        if [[ -d "$app" ]]; then
            dockutil --add "$app" --no-restart >/dev/null
        else
            echo "⏭️  Skipping (not installed): $app"
        fi
    done

    echo "✅ Dock configured"
}

# Add ABC keyboard layout and set it as the default input source
configure_keyboard() {
    echo "⌨️  Configuring ABC as default keyboard..."

    if defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -q '"KeyboardLayout Name" = ABC'; then
        echo "✅ ABC already in enabled input sources"
    else
        defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add \
            '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>252</integer><key>KeyboardLayout Name</key><string>ABC</string></dict>'
        echo "✅ ABC added to input sources"
    fi

    defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string "com.apple.keylayout.ABC"
    defaults write com.apple.HIToolbox AppleDefaultAsciiInputSource -dict \
        "InputSourceKind" -string "Keyboard Layout" \
        "KeyboardLayout ID" -int 252 \
        "KeyboardLayout Name" -string "ABC"

    echo "✅ ABC set as default (logout/login required to fully apply)"
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

# Main execution
main() {
    echo "🚀 Starting macOS configuration..."
    
    configure_touchid_sudo
    configure_macos_defaults
    configure_dock
    configure_keyboard
    apply_changes
    
    echo "🎉 macOS configuration complete!"
    echo "💡 You may need to restart some applications or log out/in for all changes to take effect"
}



# Run if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi