{
  description = "Bull Bitcoin Mobile Wallet - Flutter Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    android.url = "github:tadfisher/android-nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, android }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Android SDK configuration
        androidSdk = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
          cmdline-tools-latest
          build-tools-35-0-0
          platform-tools
          platforms-android-35
          platforms-android-34
          platforms-android-33
          platforms-android-32
          platforms-android-31
          platforms-android-30
          platforms-android-29
          platforms-android-28
          platforms-android-27
          platforms-android-26
          ndk-25-2-9519653
          cmake-3-22-1
          emulator
        ]);

        # Flutter version
        flutterVersion = "3.24.5";
        
        # Flutter SDK
        flutter = pkgs.flutter.override {
          version = flutterVersion;
        };

        # Development tools
        devTools = with pkgs; [
          # Core development tools
          git
          curl
          wget
          unzip
          zip
          
          # Java and Kotlin
          jdk21
          kotlin
          
          # Build tools
          cmake
          ninja
          pkg-config
          
          # Additional utilities
          tree
          htop
          ripgrep
          fd
          bat
          exa
          
          # Network tools
          openssl
          cacert
        ];

        # Android development environment
        androidEnv = pkgs.buildEnv {
          name = "android-sdk-env";
          paths = [ androidSdk ];
          pathsToLink = [ "/" ];
        };

      in {
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = devTools ++ [ flutter androidEnv ];

          shellHook = ''
            echo "🐂 Bull Bitcoin Mobile Development Environment"
            echo "=============================================="
            echo "Flutter version: ${flutterVersion}"
            echo "Android SDK: Available"
            echo ""
            echo "Available commands:"
            echo "  flutter doctor          - Check Flutter installation"
            echo "  flutter pub get         - Install dependencies"
            echo "  flutter build apk       - Build Android APK"
            echo "  flutter build ios       - Build iOS (macOS only)"
            echo "  flutter test            - Run tests"
            echo "  flutter run             - Run the app"
            echo ""
            
            # Set Android SDK environment variables
            export ANDROID_HOME=${androidEnv}
            export ANDROID_SDK_ROOT=${androidEnv}
            export PATH="$PATH:${androidEnv}/cmdline-tools/latest/bin"
            export PATH="$PATH:${androidEnv}/platform-tools"
            export PATH="$PATH:${androidEnv}/build-tools/35.0.0"
            
            # Set Java environment
            export JAVA_HOME=${pkgs.jdk21}
            export PATH="$PATH:$JAVA_HOME/bin"
            
            # Set Flutter environment
            export PATH="$PATH:${flutter}/bin"
            
            # Additional environment variables for the project
            export FLUTTER_ROOT=${flutter}
            export PUB_CACHE="${builtins.getEnv "HOME"}/.pub-cache"
            
            echo "Environment variables set:"
            echo "  ANDROID_HOME: $ANDROID_HOME"
            echo "  JAVA_HOME: $JAVA_HOME"
            echo "  FLUTTER_ROOT: $FLUTTER_ROOT"
            echo ""
          '';

          # Environment variables
          ANDROID_HOME = "${androidEnv}";
          ANDROID_SDK_ROOT = "${androidEnv}";
          JAVA_HOME = "${pkgs.jdk21}";
          FLUTTER_ROOT = "${flutter}";
          
          # Additional environment setup
          ANDROID_NDK_HOME = "${androidEnv}/ndk/25.2.9519653";
          ANDROID_NDK_ROOT = "${androidEnv}/ndk/25.2.9519653";
        };

        # Packages
        packages = {
          # Flutter app package
          flutter-app = pkgs.stdenv.mkDerivation {
            pname = "bull-bitcoin-mobile";
            version = "5.3.0";
            src = ./.;
            
            nativeBuildInputs = [ flutter androidEnv pkgs.jdk21 ];
            
            buildPhase = ''
              export ANDROID_HOME=${androidEnv}
              export ANDROID_SDK_ROOT=${androidEnv}
              export JAVA_HOME=${pkgs.jdk21}
              export PATH="$PATH:${flutter}/bin"
              export PATH="$PATH:${androidEnv}/cmdline-tools/latest/bin"
              export PATH="$PATH:${androidEnv}/platform-tools"
              export PATH="$PATH:${androidEnv}/build-tools/35.0.0"
              
              flutter pub get
              flutter build apk --release
            '';
            
            installPhase = ''
              mkdir -p $out
              cp build/app/outputs/flutter-apk/app-release.apk $out/bull-bitcoin-mobile.apk
            '';
            
            meta = {
              description = "Bull Bitcoin Mobile Wallet";
              homepage = "https://bullbitcoin.com";
              license = pkgs.lib.licenses.mit;
              platforms = pkgs.lib.platforms.linux;
            };
          };

          # Development tools package
          dev-tools = pkgs.buildEnv {
            name = "bull-bitcoin-dev-tools";
            paths = devTools ++ [ flutter androidEnv ];
          };
        };

        # Apps
        apps = {
          # Flutter doctor
          doctor = {
            type = "app";
            program = "${pkgs.writeShellScript "flutter-doctor" ''
              export ANDROID_HOME=${androidEnv}
              export ANDROID_SDK_ROOT=${androidEnv}
              export JAVA_HOME=${pkgs.jdk21}
              export PATH="$PATH:${flutter}/bin"
              ${flutter}/bin/flutter doctor
            ''}";
          };

          # Flutter pub get
          pub-get = {
            type = "app";
            program = "${pkgs.writeShellScript "flutter-pub-get" ''
              export ANDROID_HOME=${androidEnv}
              export ANDROID_SDK_ROOT=${androidEnv}
              export JAVA_HOME=${pkgs.jdk21}
              export PATH="$PATH:${flutter}/bin"
              ${flutter}/bin/flutter pub get
            ''}";
          };

          # Build APK
          build-apk = {
            type = "app";
            program = "${pkgs.writeShellScript "flutter-build-apk" ''
              export ANDROID_HOME=${androidEnv}
              export ANDROID_SDK_ROOT=${androidEnv}
              export JAVA_HOME=${pkgs.jdk21}
              export PATH="$PATH:${flutter}/bin"
              export PATH="$PATH:${androidEnv}/cmdline-tools/latest/bin"
              export PATH="$PATH:${androidEnv}/platform-tools"
              export PATH="$PATH:${androidEnv}/build-tools/35.0.0"
              ${flutter}/bin/flutter build apk
            ''}";
          };
        };

        # Default package
        defaultPackage = self.packages.${system}.flutter-app;
      }
    );
} 