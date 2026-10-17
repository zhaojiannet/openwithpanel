#!/bin/zsh
# 环境变量：
#   DEVELOPER_ID   签名身份，如 "Developer ID Application: Name (TEAMID)"；不设时用 ad-hoc 签名，
#                  用户第一次打开会被系统拦截，DMG 里附上放行步骤
#   NOTARY_PROFILE `xcrun notarytool store-credentials` 存下的凭据名；设了才公证并 staple
#   NOTARY_KEYCHAIN 凭据所在的钥匙串路径；不设时用默认钥匙串，CI 里凭据存在临时钥匙串时才需要
set -euo pipefail

cd "$(dirname "$0")/.."
root=$PWD
build=$root/.build/release
dist=$root/.build/dist
identity=${DEVELOPER_ID:--}

if [[ -n ${NOTARY_PROFILE:-} && $identity == - ]]; then
  echo "NOTARY_PROFILE requires DEVELOPER_ID: an ad-hoc signed app can't be notarized" >&2
  exit 1
fi

version=$(xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel -configuration Release \
  -showBuildSettings 2>/dev/null | awk '$1 == "MARKETING_VERSION" { print $3; exit }')
app=$build/Build/Products/Release/OpenWithPanel.app
dmg=$dist/OpenWithPanel-$version.dmg

xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel -configuration Release \
  -derivedDataPath "$build" build | grep -E "error:|warning:|BUILD" || true
[[ -d $app ]] || { echo "build failed: $app not found" >&2; exit 1; }

# 由内向外签：先签内嵌的辅助程序，再签主 App。Developer ID 签名要带安全时间戳才能公证
sign_flags=(--force --options runtime --sign "$identity")
[[ $identity != - ]] && sign_flags+=(--timestamp)
for helper in "$app"/Contents/Helpers/*.app; do
  codesign "${sign_flags[@]}" "$helper"
done
codesign "${sign_flags[@]}" "$app"
codesign --verify --deep --strict --verbose=2 "$app"

rm -rf "$dist" && mkdir -p "$dist/stage"
ditto "$app" "$dist/stage/OpenWithPanel.app"
ln -s /Applications "$dist/stage/Applications"
[[ $identity == - ]] && cp "packaging/First Launch.txt" "$dist/stage/"
# 不用 hdiutil create：macOS 27 起已标为弃用。diskutil image 默认格式 ULFO（lzfse 压缩）
diskutil image create from --volumeName OpenWithPanel "$dist/stage" "$dmg" >/dev/null
rm -rf "$dist/stage"
[[ $identity != - ]] && codesign --force --timestamp --sign "$identity" "$dmg"

if [[ -n ${NOTARY_PROFILE:-} ]]; then
  notary_flags=(--keychain-profile "$NOTARY_PROFILE")
  [[ -n ${NOTARY_KEYCHAIN:-} ]] && notary_flags+=(--keychain "$NOTARY_KEYCHAIN")
  xcrun notarytool submit "$dmg" "${notary_flags[@]}" --wait
  xcrun stapler staple "$dmg"
  spctl --assess --type open --context context:primary-signature --verbose "$dmg"
fi

sha=$(shasum -a 256 "$dmg" | awk '{ print $1 }')
sed -e "s/@VERSION@/$version/" -e "s/@SHA256@/$sha/" packaging/openwithpanel.rb >"$dist/openwithpanel.rb"
echo "$dmg"
echo "sha256 $sha"
[[ $identity == - ]] && echo "ad-hoc signed, not notarized: users must click Open Anyway in System Settings › Privacy & Security on first launch"
exit 0
