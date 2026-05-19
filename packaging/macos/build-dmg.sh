#!/usr/bin/env bash
set -euo pipefail

APP_VERSION="${1:?version required}"
APP_BUNDLE="${2:?app bundle path required}"
OUTPUT_DIR="${3:?output dir required}"

STAGE_DIR="$(mktemp -d)"
TMP_DMG_PATH="$(mktemp "${TMPDIR:-/tmp}/atcmder-${APP_VERSION}.XXXXXX.dmg")"
DMG_NAME="atcmder-macos-${APP_VERSION}.dmg"
DMG_PATH="${OUTPUT_DIR}/${DMG_NAME}"

cleanup() {
  rm -rf "${STAGE_DIR}"
  rm -f "${TMP_DMG_PATH}"
}
trap cleanup EXIT

mkdir -p "${OUTPUT_DIR}"
rm -f "${DMG_PATH}"
cp -R "${APP_BUNDLE}" "${STAGE_DIR}/ATCMDer.app"
ln -s /Applications "${STAGE_DIR}/Applications"

for attempt in 1 2 3; do
  if hdiutil create \
    -volname "ATCMDer" \
    -srcfolder "${STAGE_DIR}" \
    -ov \
    -format UDZO \
    "${TMP_DMG_PATH}"; then
    mv "${TMP_DMG_PATH}" "${DMG_PATH}"
    echo "${DMG_PATH}"
    exit 0
  fi

  sleep "$((attempt * 2))"
done

echo "Failed to create DMG after 3 attempts." >&2
exit 1
