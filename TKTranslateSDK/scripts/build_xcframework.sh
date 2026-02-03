#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DERIVED_DATA="$ROOT_DIR/.build/DerivedData"
CONFIG="Release"
XCCONFIG="$ROOT_DIR/Configs/TKTranslateSDK.xcconfig"
WORKSPACE="$ROOT_DIR/.swiftpm/xcode/package.xcworkspace"

if [[ "${TK_SDK_SKIP_BUILD:-0}" == "1" ]]; then
  echo "Skipping TKTranslateSDK build (TK_SDK_SKIP_BUILD=1)"
  exit 0
fi

rm -rf "$DERIVED_DATA"
mkdir -p "$DERIVED_DATA"

build() {
  local sdk="$1"
  local destination="$2"
  local build_dir="$3"

  set +e
  xcodebuild build \
    -workspace "$WORKSPACE" \
    -scheme TKTranslateSDK \
    -UseModernBuildSystem=NO \
    -configuration "$CONFIG" \
    -sdk "$sdk" \
    -destination "$destination" \
    -derivedDataPath "$DERIVED_DATA" \
    -xcconfig "$XCCONFIG" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO \
    BUILD_DIR="$build_dir" \
    OBJROOT="$DERIVED_DATA/Obj" \
    SYMROOT="$DERIVED_DATA/Sym"
  local status=$?
  if [[ $status -ne 0 ]]; then
    echo "xcodebuild failed (sdk=$sdk). Retrying once..." >&2
    sleep 1
    xcodebuild build \
      -workspace "$WORKSPACE" \
      -scheme TKTranslateSDK \
      -UseModernBuildSystem=NO \
      -configuration "$CONFIG" \
      -sdk "$sdk" \
      -destination "$destination" \
      -derivedDataPath "$DERIVED_DATA" \
      -xcconfig "$XCCONFIG" \
      BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
      SKIP_INSTALL=NO \
      BUILD_DIR="$build_dir" \
      OBJROOT="$DERIVED_DATA/Obj" \
      SYMROOT="$DERIVED_DATA/Sym"
    status=$?
  fi
  set -e
  return $status
}

PRODUCTS_DIR="$DERIVED_DATA/Build"
ARTIFACTS_DIR="$DERIVED_DATA/Artifacts"

build iphoneos "generic/platform=iOS" "$DERIVED_DATA/Build"
build iphonesimulator "generic/platform=iOS Simulator" "$DERIVED_DATA/Build"
build macosx "generic/platform=macOS" "$DERIVED_DATA/Build"
build macosx "generic/platform=macOS,variant=Mac Catalyst" "$DERIVED_DATA/Build"

WORKSPACE_ROOT="$(cd "$ROOT_DIR/.." && pwd)"
OUTPUT_XCFRAMEWORK="$WORKSPACE_ROOT/TKTranslateSDK.xcframework"
rm -rf "$OUTPUT_XCFRAMEWORK"

rm -rf "$ARTIFACTS_DIR"
mkdir -p "$ARTIFACTS_DIR"

stage_slice() {
  local platform_dir="$1"
  local slice_dir="$2"

  local products="$PRODUCTS_DIR/$platform_dir"
  local framework="$ARTIFACTS_DIR/$slice_dir/TKTranslateSDK.framework"
  local headers="$framework/Headers"
  local modules="$framework/Modules"
  local swiftmodules="$modules/TKTranslateSDK.swiftmodule"

  mkdir -p "$headers" "$swiftmodules"

  # Build a static library inside a .framework bundle.
  /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/libtool \
    -static -o "$framework/TKTranslateSDK" "$products/TKTranslateSDK.o"

  cat > "$headers/TKTranslateSDK.h" <<'EOF'
#import <Foundation/Foundation.h>
EOF

  cat > "$modules/module.modulemap" <<'EOF'
framework module TKTranslateSDK {
  umbrella header "TKTranslateSDK.h"
  export *
  module * { export * }
}
EOF

  # Copy Swift module interfaces.
  cp -R "$products/TKTranslateSDK.swiftmodule/" "$swiftmodules/"

  # Trim private/package interfaces from the shipped bundle.
  rm -f "$swiftmodules"/*.private.swiftinterface
  rm -f "$swiftmodules"/*.package.swiftinterface

  # Remove compiled modules to avoid source mapping in editors.
  rm -f "$swiftmodules"/*.swiftmodule
  rm -f "$swiftmodules"/*.swiftdoc
  rm -f "$swiftmodules"/*.abi.json
}

stage_slice "Release-iphoneos" "iphoneos"
stage_slice "Release-iphonesimulator" "iphonesimulator"
stage_slice "Release" "macos"
stage_slice "Release-maccatalyst" "maccatalyst"

xcodebuild -create-xcframework \
  -framework "$ARTIFACTS_DIR/iphoneos/TKTranslateSDK.framework" \
  -framework "$ARTIFACTS_DIR/iphonesimulator/TKTranslateSDK.framework" \
  -framework "$ARTIFACTS_DIR/macos/TKTranslateSDK.framework" \
  -framework "$ARTIFACTS_DIR/maccatalyst/TKTranslateSDK.framework" \
  -output "$OUTPUT_XCFRAMEWORK"

echo "Created: $OUTPUT_XCFRAMEWORK"
