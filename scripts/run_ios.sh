#!/usr/bin/env bash
set -euo pipefail

DEVICE_NAME="${1:-iPhone 17}"

echo "Opening Simulator..."
open -a Simulator 2>/dev/null || true

echo "Booting ${DEVICE_NAME}..."
xcrun simctl boot "$DEVICE_NAME" 2>/dev/null || true

echo "Launching Flutter app on ${DEVICE_NAME}..."
flutter run -d "$DEVICE_NAME"
