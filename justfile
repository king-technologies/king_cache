set shell := ["powershell.exe", "-c"]

packageName := "King Cache"

# Default recipe - show available commands
default:
    @echo "Welcome to the {{packageName}}"
    @just --list

# === Main Package Commands ===

# Install dependencies for main package
[group('package')]
install:
    flutter pub get

# Run tests for main package
[group('package')]
test:
    flutter test

# Analyze code for main package
[group('package')]
analyze:
    flutter analyze

# Format code for main package
[group('package')]
format:
    dart format .

# Check formatting without making changes
[group('package')]
format-check:
    dart format --set-exit-if-changed .

# Run code generation (if needed)
[group('package')]
gen:
    flutter pub run build_runner build --delete-conflicting-outputs

# Clean build artifacts for main package
[group('package')]
clean:
    flutter clean

# Publish dry run
[group('package')]
publish-dry:
    dart pub publish --dry-run

# Publish package to pub.dev
[group('package')]
publish:
    dart pub publish

# === Example App Commands ===

# Install dependencies for example app
[group('example')]
example-install:
    cd example
    flutter pub get

# Run example app
[group('example')]
example-run:
    cd example
    flutter run

# Build example app for Android
[group('example')]
example-build-android:
    cd example
    flutter build apk

# Build example app for iOS
[group('example')]
example-build-ios:
    cd example
    flutter build ios

# Build example app for web
[group('example')]
example-build-web:
    cd example
    flutter build web

# Build example app for Windows
[group('example')]
example-build-windows:
    cd example
    flutter build windows

# Build example app for macOS
[group('example')]
example-build-macos:
    cd example
    flutter build macos

# Build example app for Linux
[group('example')]
example-build-linux:
    cd example
    flutter build linux

# Test example app
[group('example')]
example-test:
    cd example
    flutter test

# Clean example app
[group('example')]
example-clean:
    cd example
    flutter clean

# === Combined Commands ===

# Install all dependencies (package + example)
[group('all')]
install-all:
    @just install
    @just example-install

# Clean everything
[group('all')]
clean-all:
    @just clean
    @just example-clean

# Test everything
[group('all')]
test-all:
    @just test
    @just example-test

# Full check (format, analyze, test)
[group('all')]
check:
    @just format-check
    @just analyze
    @just test

# Prepare for release (check + publish dry run)
[group('all')]
prepare-release:
    @just check
    @just publish-dry
