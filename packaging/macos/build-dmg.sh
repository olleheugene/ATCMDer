#!/usr/bin/env bash
set -euo pipefail

APP_VERSION="${1:?version required}"
APP_BUNDLE="${2:?app bundle path required}"
OUTPUT_DIR="${3:?output dir required}"

STAGE_DIR="$(mktemp -d)"
DMG_NAME="atcmder-macos-${APP_VERSION}.dmg"
DMG_PATH="${OUTPUT_DIR}/${DMG_NAME}"

mkdir -p "${OUTPUT_DIR}"
cp -R "${APP_BUNDLE}" "${STAGE_DIR}/ATCMDer.app"

hdiutil create \
  -volname "ATCMDer" \
  -srcfolder "${STAGE_DIR}" \
  -ov \
  -format UDZO \
  "${DMG_PATH}"

rm -rf "${STAGE_DIR}"
echo "${DMG_PATH}"
