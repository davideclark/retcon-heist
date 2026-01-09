#!/bin/bash
# Build script for The Computer Fair Heist
# Compiles to Z3 format for TRS-80 Model 4 with M4ZVM

echo "Building The Computer Fair Heist..."
echo "Target: Z-code version 3 (optimized for TRS-80)"
echo ""

# Extract build number from BUILD_NUMBER constant in source file
VERSION=$(grep "^Constant BUILD_NUMBER" computer-fair-heist.inf | sed 's/Constant BUILD_NUMBER = \([0-9]*\);.*/\1/')
if [ -z "$VERSION" ]; then
  echo "Error: Could not find BUILD_NUMBER in computer-fair-heist.inf"
  exit 1
fi

OUTPUT="heist${VERSION}.z3"

echo "Version: $VERSION"
echo "Output file: $OUTPUT"
echo ""

# Use the punyinform wrapper script installed by Homebrew
# This automatically sets up the correct library paths
$(brew --prefix inform6)/bin/punyinform -v3 computer-fair-heist.inf "$OUTPUT"

if [ $? -eq 0 ]; then
  echo ""
  echo "Build successful!"
  echo "Output file: $OUTPUT"
  ls -lh "$OUTPUT"
  echo ""
  echo "File size comparison:"
  echo "  Inform 7 (Z8): 317KB"
  echo "  PunyInform (Z3): $(ls -lh "$OUTPUT" | awk '{print $5}')"
  echo ""
  echo "To test on Mac: frotz $OUTPUT"
  echo "To deploy: cp $OUTPUT ../gotek-disks/"
else
  echo ""
  echo "Build failed!"
  exit 1
fi
