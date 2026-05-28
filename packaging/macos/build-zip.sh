#!/usr/bin/env bash
set -euo pipefail

APP_VERSION="${1:-}"
OUTPUT_DIR="${2:-release}"
BUILD_KIND="${3:-all}"
ARM64_PYTHON_BIN="${ARM64_PYTHON_BIN:-python3}"
UNIVERSAL_PYTHON_BIN="${UNIVERSAL_PYTHON_BIN:-/usr/bin/python3}"

build_zip() {
  local arch="$1"
  local python_bin="$2"
  local target_arch="$3"
  local venv_dir=".build/macos-${arch}-venv"
  local zip_name="atcmder-macos-${arch}${APP_VERSION:+-${APP_VERSION}}.zip"
  local zip_path="${OUTPUT_DIR}/${zip_name}"

  rm -rf "${venv_dir}"
  "${python_bin}" -m venv "${venv_dir}"

  # shellcheck source=/dev/null
  source "${venv_dir}/bin/activate"
  python -m pip install --upgrade pip
  python -m pip install "pyinstaller<7" "PySide6-Essentials>=6.4" pyserial PyYAML

  PYINSTALLER_TARGET_ARCH="${target_arch}" pyinstaller --clean -y atcmder.spec

  mkdir -p "${OUTPUT_DIR}"
  rm -f "${zip_path}"
  ditto -c -k --sequesterRsrc --keepParent dist/atcmder.app "${zip_path}"
  echo "${zip_path}"

  deactivate
}

case "${BUILD_KIND}" in
  all)
    build_zip "arm64" "${ARM64_PYTHON_BIN}" "arm64"
    build_zip "universal" "${UNIVERSAL_PYTHON_BIN}" "universal2"
    ;;
  arm64)
    build_zip "arm64" "${ARM64_PYTHON_BIN}" "arm64"
    ;;
  universal | universal2)
    build_zip "universal" "${UNIVERSAL_PYTHON_BIN}" "universal2"
    ;;
  *)
    echo "Usage: $0 [version] [output_dir] [all|arm64|universal]" >&2
    exit 2
    ;;
esac
