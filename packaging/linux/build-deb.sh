#!/usr/bin/env bash
set -euo pipefail

APP_VERSION="${1:?version required}"
APP_BINARY="${2:?binary path required}"
ICON_PATH="${3:?icon path required}"
OUTPUT_DIR="${4:?output dir required}"

PKG_ROOT="$(mktemp -d)"
PKG_NAME="atcmder_${APP_VERSION}_amd64"

mkdir -p "${PKG_ROOT}/DEBIAN"
mkdir -p "${PKG_ROOT}/opt/atcmder"
mkdir -p "${PKG_ROOT}/usr/share/applications"
mkdir -p "${PKG_ROOT}/usr/share/pixmaps"

cat > "${PKG_ROOT}/DEBIAN/control" <<EOF
Package: atcmder
Version: ${APP_VERSION}
Section: utils
Priority: optional
Architecture: amd64
Maintainer: ATCMDer
Depends: libgl1, libxcb-cursor0, libxkbcommon-x11-0
Description: AT Commander serial communication utility
 GUI serial communication tool with predefined commands and terminal output.
EOF

install -m 0755 "${APP_BINARY}" "${PKG_ROOT}/opt/atcmder/atcmder"
install -m 0644 "${ICON_PATH}" "${PKG_ROOT}/usr/share/pixmaps/atcmder.png"
install -m 0644 "packaging/linux/atcmder.desktop" "${PKG_ROOT}/usr/share/applications/atcmder.desktop"

mkdir -p "${OUTPUT_DIR}"
dpkg-deb --build "${PKG_ROOT}" "${OUTPUT_DIR}/${PKG_NAME}.deb"
rm -rf "${PKG_ROOT}"
