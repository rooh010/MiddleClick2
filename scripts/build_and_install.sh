#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="MiddleClick2"
DERIVED_DATA="$ROOT_DIR/build"
APP_PATH="$DERIVED_DATA/Build/Products/Debug/${APP_NAME}.app"
INSTALL_PATH="/Applications/${APP_NAME}.app"

xcodebuild -project "$ROOT_DIR/MiddleClick2.xcodeproj" \
  -scheme "$APP_NAME" \
  -configuration Debug \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGN_ALLOW_ENTITLEMENTS_MODIFICATION=YES

if [[ ! -d "$APP_PATH" ]]; then
  echo "Build output not found: $APP_PATH" >&2
  exit 1
fi

rm -rf "$INSTALL_PATH"
cp -R "$APP_PATH" "$INSTALL_PATH"

echo "Installed to $INSTALL_PATH"
