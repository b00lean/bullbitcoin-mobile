#!/usr/bin/env bash

set -euo pipefail

echo "🐂 Bull Bitcoin Mobile - Nix Setup Script"
echo "=========================================="
echo ""

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo "❌ Nix is not installed. Please install Nix first:"
    echo "   https://nixos.org/download.html"
    echo ""
    echo "After installation, enable flakes by adding to ~/.config/nix/nix.conf:"
    echo "   experimental-features = nix-command flakes"
    exit 1
fi

# Check if flakes are enabled
if ! nix flake --help &> /dev/null; then
    echo "❌ Nix flakes are not enabled. Please add to ~/.config/nix/nix.conf:"
    echo "   experimental-features = nix-command flakes"
    exit 1
fi

echo "✅ Nix is installed and flakes are enabled"
echo ""

# Check if direnv is installed
if command -v direnv &> /dev/null; then
    echo "✅ direnv is installed"
    
    # Check if direnv is hooked
    if [[ "$SHELL" == *"bash"* ]]; then
        if grep -q "direnv hook bash" ~/.bashrc 2>/dev/null; then
            echo "✅ direnv is hooked in bash"
        else
            echo "⚠️  direnv is not hooked in bash. Run:"
            echo "   echo 'eval \"\$(direnv hook bash)\"' >> ~/.bashrc"
            echo "   source ~/.bashrc"
        fi
    elif [[ "$SHELL" == *"zsh"* ]]; then
        if grep -q "direnv hook zsh" ~/.zshrc 2>/dev/null; then
            echo "✅ direnv is hooked in zsh"
        else
            echo "⚠️  direnv is not hooked in zsh. Run:"
            echo "   echo 'eval \"\$(direnv hook zsh)\"' >> ~/.zshrc"
            echo "   source ~/.zshrc"
        fi
    fi
else
    echo "⚠️  direnv is not installed. Install it for automatic environment loading:"
    echo "   nix-env -iA nixpkgs.direnv"
    echo "   or"
    echo "   nix profile install nixpkgs#direnv"
fi

echo ""

# Test the flake
echo "🔧 Testing Nix flake..."
if nix flake check --no-build; then
    echo "✅ Flake configuration is valid"
else
    echo "❌ Flake configuration has issues"
    exit 1
fi

echo ""

# Show available commands
echo "📋 Available Nix commands:"
echo "   nix develop              - Enter development shell"
echo "   nix run .#doctor         - Run flutter doctor"
echo "   nix run .#pub-get        - Install dependencies"
echo "   nix run .#build-apk      - Build Android APK"
echo "   nix build .#flutter-app  - Build the app package"
echo ""

# Check if we're in the project directory
if [[ -f "pubspec.yaml" && -f "flake.nix" ]]; then
    echo "✅ You're in the Bull Bitcoin Mobile project directory"
    echo ""
    echo "🚀 Quick start:"
    echo "   1. Enter development shell: nix develop"
    echo "   2. Check setup: flutter doctor"
    echo "   3. Install dependencies: flutter pub get"
    echo "   4. Run the app: flutter run"
    echo ""
    
    if command -v direnv &> /dev/null; then
        echo "💡 With direnv, the environment will load automatically when you enter this directory"
    fi
else
    echo "⚠️  This script should be run from the Bull Bitcoin Mobile project directory"
    echo "   (where pubspec.yaml and flake.nix are located)"
fi

echo ""
echo "📖 For more information, see README-NIX.md" 