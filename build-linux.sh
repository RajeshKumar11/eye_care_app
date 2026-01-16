#!/bin/bash

# Eye Care App - Linux Build Script
# This script automates the Linux build process

set -e  # Exit on error

echo "========================================="
echo "  Eye Care App - Linux Build Script"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo -e "${RED}Error: This script is for Linux only${NC}"
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
    echo "Install Flutter from: https://docs.flutter.dev/get-started/install/linux"
    exit 1
fi

echo -e "${GREEN}✓ Flutter found${NC}"

# Check for required dependencies
echo ""
echo "Checking for required dependencies..."

MISSING_DEPS=()

# Check for GTK
if ! pkg-config --exists gtk+-3.0; then
    MISSING_DEPS+=("libgtk-3-dev")
fi

# Check for AppIndicator
if ! pkg-config --exists ayatana-appindicator3-0.1; then
    if ! pkg-config --exists appindicator3-0.1; then
        MISSING_DEPS+=("libayatana-appindicator3-dev")
    fi
fi

# Check for other tools
for cmd in cmake ninja pkg-config; do
    if ! command -v $cmd &> /dev/null; then
        MISSING_DEPS+=($cmd)
    fi
done

# If dependencies are missing, show installation command
if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${RED}✗ Missing dependencies:${NC} ${MISSING_DEPS[*]}"
    echo ""
    echo "Please install them with:"
    echo ""
    echo -e "${YELLOW}sudo apt-get update && sudo apt-get install -y ${MISSING_DEPS[*]}${NC}"
    echo ""
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ All dependencies found${NC}"
fi

# Clean previous builds (optional)
echo ""
read -p "Clean previous builds? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleaning..."
    flutter clean
    echo -e "${GREEN}✓ Cleaned${NC}"
fi

# Get dependencies
echo ""
echo "Getting Flutter dependencies..."
flutter pub get
echo -e "${GREEN}✓ Dependencies resolved${NC}"

# Run analyzer (optional)
echo ""
read -p "Run flutter analyze? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Running analyzer..."
    flutter analyze || echo -e "${YELLOW}⚠ Analyzer found issues (continuing anyway)${NC}"
fi

# Build
echo ""
echo "Building Linux release..."
echo "This may take several minutes..."
echo ""

BUILD_TYPE="${1:-release}"

if flutter build linux --$BUILD_TYPE; then
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}  Build Successful! ✓${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""

    BUILD_DIR="build/linux/x64/$BUILD_TYPE/bundle"
    EXECUTABLE="$BUILD_DIR/eye_care_app"

    echo "Build output: $BUILD_DIR"
    echo "Executable: $EXECUTABLE"
    echo ""

    # Get file size
    if [ -f "$EXECUTABLE" ]; then
        SIZE=$(du -h "$BUILD_DIR" | tail -1 | cut -f1)
        echo "Total size: $SIZE"
    fi

    echo ""
    echo "To run the app:"
    echo -e "${YELLOW}./$EXECUTABLE${NC}"
    echo ""

    # Offer to run the app
    read -p "Run the app now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Starting Eye Care App..."
        ./$EXECUTABLE
    fi

    # Offer to create tarball
    echo ""
    read -p "Create tarball for distribution? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        VERSION="1.0.0"
        TARBALL="eye-care-app-linux-x64-v$VERSION.tar.gz"

        echo "Creating tarball..."
        cd $BUILD_DIR
        tar -czf "../../../../../$TARBALL" *
        cd - > /dev/null

        echo -e "${GREEN}✓ Created: $TARBALL${NC}"
        echo "Size: $(du -h $TARBALL | cut -f1)"
    fi

else
    echo ""
    echo -e "${RED}=========================================${NC}"
    echo -e "${RED}  Build Failed ✗${NC}"
    echo -e "${RED}=========================================${NC}"
    echo ""
    echo "Common fixes:"
    echo "1. Install missing dependencies (see error above)"
    echo "2. Run: flutter clean && flutter pub get"
    echo "3. Check BUILD_LINUX.md for detailed instructions"
    echo ""
    exit 1
fi

echo ""
echo "Build script completed!"
