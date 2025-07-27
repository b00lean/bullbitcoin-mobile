# Bull Bitcoin Mobile - Nix Development Environment

This project includes a Nix flake configuration that provides a complete development environment for the Bull Bitcoin Mobile Flutter application.

## Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- [direnv](https://direnv.net/) (optional, for automatic environment loading)

## Quick Start

### Option 1: Using direnv (Recommended)

1. Install direnv and enable it in your shell:
   ```bash
   # For bash
   echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
   source ~/.bashrc
   
   # For zsh
   echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
   source ~/.zshrc
   ```

2. Navigate to the project directory:
   ```bash
   cd bullbitcoin-mobile
   ```

3. The development environment will automatically load when you enter the directory.

### Option 2: Manual Nix Shell

1. Enter the development shell:
   ```bash
   nix develop
   ```

2. Or run specific commands:
   ```bash
   nix run .#doctor      # Run flutter doctor
   nix run .#pub-get     # Install dependencies
   nix run .#build-apk   # Build Android APK
   ```

## What's Included

The Nix configuration provides:

### Development Tools
- **Flutter 3.24.5** - Latest stable Flutter SDK
- **Android SDK** - Complete Android development environment
  - Build Tools 35.0.0
  - Platform Tools
  - Android Platforms (API 26-35)
  - NDK 25.2.9519653
  - CMake 3.22.1
  - Android Emulator
- **Java 21** - Required for Android development
- **Kotlin** - For Android development
- **Build Tools** - CMake, Ninja, pkg-config
- **Development Utilities** - git, curl, ripgrep, fd, bat, exa, etc.

### Environment Variables
The following environment variables are automatically set:
- `ANDROID_HOME` - Android SDK location
- `ANDROID_SDK_ROOT` - Android SDK root
- `JAVA_HOME` - Java installation path
- `FLUTTER_ROOT` - Flutter SDK location
- `ANDROID_NDK_HOME` - Android NDK location

## Available Commands

Once in the development environment, you can use:

```bash
# Flutter commands
flutter doctor          # Check Flutter installation
flutter pub get         # Install dependencies
flutter build apk       # Build Android APK
flutter build ios       # Build iOS (macOS only)
flutter test            # Run tests
flutter run             # Run the app

# Android commands
adb devices             # List connected devices
emulator -list-avds     # List available emulators
emulator -avd <name>    # Start an emulator

# Development utilities
git status              # Check git status
ripgrep "pattern"       # Search code
fd "pattern"            # Find files
bat file.dart           # View files with syntax highlighting
```

## Building the App

### Build Android APK
```bash
# Development build
flutter build apk

# Release build
flutter build apk --release

# Using Nix app
nix run .#build-apk
```

### Build iOS (macOS only)
```bash
flutter build ios
```

## Testing

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Run specific test file
flutter test test/core_test/utils/
```

## Development Workflow

1. **Start development environment:**
   ```bash
   nix develop
   ```

2. **Check setup:**
   ```bash
   flutter doctor
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

5. **Build for release:**
   ```bash
   flutter build apk --release
   ```

## Troubleshooting

### Flutter Doctor Issues
If `flutter doctor` shows issues:

1. **Android SDK not found:**
   - The Nix configuration should handle this automatically
   - Check that `ANDROID_HOME` is set correctly

2. **Java version issues:**
   - The configuration uses Java 21, which should be compatible
   - Verify `JAVA_HOME` is set to the Nix Java installation

3. **NDK issues:**
   - NDK 25.2.9519653 is included and configured
   - Check `ANDROID_NDK_HOME` environment variable

### Build Issues
1. **Clean build:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
   ```

2. **Clear Nix cache:**
   ```bash
   nix store gc
   ```

### Permission Issues
If you encounter permission issues with Android tools:
```bash
chmod +x $ANDROID_HOME/platform-tools/adb
chmod +x $ANDROID_HOME/cmdline-tools/latest/bin/*
```

## Nix Flake Commands

```bash
# Show available packages
nix flake show

# Build the Flutter app package
nix build .#flutter-app

# Build development tools package
nix build .#dev-tools

# Run specific apps
nix run .#doctor
nix run .#pub-get
nix run .#build-apk
```

## Customization

To modify the Nix configuration:

1. **Change Flutter version:**
   Edit `flutterVersion` in `flake.nix`

2. **Add more Android SDK components:**
   Add to the `androidSdk` list in `flake.nix`

3. **Add development tools:**
   Add to the `devTools` list in `flake.nix`

## Contributing

When contributing to this project:

1. Use the Nix development environment
2. Ensure all tests pass: `flutter test`
3. Run integration tests: `flutter test integration_test/`
4. Build the app: `flutter build apk --release`

## License

This Nix configuration is provided under the same license as the Bull Bitcoin Mobile project. 