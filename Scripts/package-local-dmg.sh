#!/usr/bin/env bash

set -euo pipefail

VERSION="${1:-local}"
SAFE_VERSION="$(printf '%s' "$VERSION" | tr -c 'A-Za-z0-9._-' '-')"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_PATH="$REPO_ROOT/JoyBridge.xcodeproj"
SCHEME="JoyBridge"
CONFIGURATION="Release"
DERIVED_DATA_DIR="${DERIVED_DATA_DIR:-/private/tmp/JoyBridgeNewDmgDerivedData}"
STAGING_DIR="/private/tmp/JoyBridgeNewDmg-$SAFE_VERSION"
DIST_DIR="$REPO_ROOT/dist"
APP_NAME="JoyBridge-new.app"
APP_PATH="$DERIVED_DATA_DIR/Build/Products/$CONFIGURATION/$APP_NAME"
PACKAGE_BASENAME="JoyBridge-new-$SAFE_VERSION-local-test"
DMG_PATH="$DIST_DIR/$PACKAGE_BASENAME.dmg"
VOLUME_NAME="JoyBridge-new $VERSION"
GIT_COMMIT="$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || printf 'unknown')"
GIT_TAG="$(git -C "$REPO_ROOT" describe --tags --exact-match HEAD 2>/dev/null || printf 'none')"
APP_INFO_VERSION="$(awk -F '"' '/currentTestVersion/ { print $2; exit }' "$REPO_ROOT/JoyBridge/Utilities/AppInfo.swift")"
MARKETING_VERSIONS="$(awk -F '= ' '/MARKETING_VERSION/ { gsub(";", "", $2); print $2 }' "$REPO_ROOT/JoyBridge.xcodeproj/project.pbxproj" | sort -u | tr '\n' ' ' | sed 's/[[:space:]]*$//')"

if [[ -n "$(git -C "$REPO_ROOT" status --porcelain --untracked-files=normal 2>/dev/null || true)" ]]; then
  GIT_STATUS="dirty"
else
  GIT_STATUS="clean"
fi

if [[ "$VERSION" != "local" ]]; then
  EXPECTED_MARKETING_VERSION="${VERSION#v}"

  if [[ "$APP_INFO_VERSION" != "$VERSION" ]]; then
    echo "ERROR: package version $VERSION does not match AppInfo.currentTestVersion $APP_INFO_VERSION" >&2
    exit 1
  fi

  if [[ "$MARKETING_VERSIONS" != "$EXPECTED_MARKETING_VERSION" ]]; then
    echo "ERROR: package version $VERSION does not match MARKETING_VERSION values: $MARKETING_VERSIONS" >&2
    exit 1
  fi
fi

if ! command -v hdiutil >/dev/null 2>&1; then
  echo "ERROR: hdiutil is required to create a DMG on macOS" >&2
  exit 1
fi

echo "==> JoyBridge-new local DMG"
echo "Version: $VERSION"
echo "AppInfo version: $APP_INFO_VERSION"
echo "Marketing version: $MARKETING_VERSIONS"
echo "Repo: $REPO_ROOT"
echo "Git commit: $GIT_COMMIT"
echo "Git tag: $GIT_TAG"
echo "Git status: $GIT_STATUS"
echo

if [[ -z "${DEVELOPER_DIR:-}" && -d "/Applications/Xcode.app/Contents/Developer" ]]; then
  export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

echo "Developer dir: ${DEVELOPER_DIR:-$(xcode-select -p 2>/dev/null || printf 'not found')}"
echo

mkdir -p "$DIST_DIR"
rm -rf "$STAGING_DIR"
rm -f "$DMG_PATH"
mkdir -p "$STAGING_DIR"

echo "==> Building $CONFIGURATION app"
xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "platform=macOS" \
  -derivedDataPath "$DERIVED_DATA_DIR" \
  ENABLE_USER_SCRIPT_SANDBOXING=NO \
  build

if [[ ! -d "$APP_PATH" ]]; then
  echo "ERROR: built app not found at $APP_PATH" >&2
  exit 1
fi

echo "==> Preparing DMG contents"
cp -R "$APP_PATH" "$STAGING_DIR/$APP_NAME"
ln -s /Applications "$STAGING_DIR/Applications"
cp "$REPO_ROOT/FRIEND_TESTING.md" "$STAGING_DIR/FRIEND_TESTING.md"
cp "$REPO_ROOT/README.md" "$STAGING_DIR/README.md"
cp "$REPO_ROOT/CHANGELOG.md" "$STAGING_DIR/CHANGELOG.md"
cp "$REPO_ROOT/RELEASE_CHECKLIST.md" "$STAGING_DIR/RELEASE_CHECKLIST.md"

{
  printf '%s\n' "JoyBridge-new local test DMG"
  printf '%s\n' "Version: $VERSION"
  printf '%s\n' "Git commit: $GIT_COMMIT"
  printf '%s\n' "Git tag: $GIT_TAG"
  printf '%s\n' "Git status when packaged: $GIT_STATUS"
  printf '\n'
  printf '%s\n' "Install:"
  printf '%s\n' "1. Open this DMG."
  printf '%s\n' "2. Drag JoyBridge-new.app to Applications."
  printf '%s\n' "3. Open JoyBridge-new.app from Applications."
  printf '%s\n' "4. Grant Accessibility permission when prompted."
  printf '\n'
  printf '%s\n' "Important:"
  printf '%s\n' "- This is a local friend-test DMG, not a notarized public release."
  printf '%s\n' "- macOS may warn that the app cannot be verified because it is not notarized yet."
  printf '%s\n' "- If macOS says Apple cannot verify JoyBridge-new, click Done, then open System Settings > Privacy & Security > Security and click Open Anyway."
  printf '%s\n' "- Grant Accessibility permission to the installed copy in /Applications before testing mappings."
  printf '%s\n' "- If an older JoyBridge build was authorized before, keep it if needed and add JoyBridge-new separately."
  printf '\n'
  printf '%s\n' "中文说明："
  printf '%s\n' "1. 打开这个 DMG。"
  printf '%s\n' "2. 把 JoyBridge-new.app 拖到 Applications。"
  printf '%s\n' "3. 从 Applications 打开 JoyBridge-new.app。"
  printf '%s\n' "4. 按提示授权辅助功能权限。"
  printf '\n'
  printf '%s\n' "- 这是本地朋友测试 DMG，不是已经公证的正式公开发行版。"
  printf '%s\n' "- macOS 可能提示无法验证 App，因为当前还没有做 Apple 公证。"
  printf '%s\n' "- 如果 macOS 提示 Apple 无法验证 JoyBridge-new，请点完成，再打开 系统设置 > 隐私与安全性 > 安全性，点击仍要打开。"
  printf '%s\n' "- 测试映射前，请给 /Applications 中安装后的 JoyBridge-new 授权辅助功能权限。"
  printf '%s\n' "- 如果以前授权的是旧 JoyBridge，请按需保留旧记录，并单独添加 JoyBridge-new。"
} > "$STAGING_DIR/READ-ME-FIRST.txt"

echo "==> Creating DMG"
hdiutil create \
  -volname "$VOLUME_NAME" \
  -srcfolder "$STAGING_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH"

echo "==> Verifying DMG"
hdiutil verify "$DMG_PATH"

echo "==> Code signing info"
codesign -dvv "$STAGING_DIR/$APP_NAME" 2>&1 || true

echo "==> Gatekeeper assessment"
spctl -a -vv "$STAGING_DIR/$APP_NAME" 2>&1 || true

echo
echo "Done."
echo "DMG: $DMG_PATH"
