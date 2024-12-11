#!/bin/bash

build_dylib() {
    echo "Building dylib..."
    
    swift build --configuration debug
    
    if [ $? -eq 0 ]; then
        echo "✅ dylib build succeeded."
    else
        echo "❌ dylib build failed."
        exit 1
    fi
}

build_ios() {
    echo "Building for iOS..."
    xcodebuild \
    -scheme "RumbleHearts" \
    -sdk iphoneos \
    -destination 'generic/platform=iOS' \
    -derivedDataPath "./.build/ios/" \
    build

    if [ $? -eq 0 ]; then
        echo "✅ iOS build succeeded."
    else
        echo "❌ iOS build failed."
        exit 1
    fi
}

# 빌드 시작
build_dylib
build_ios

echo "🎉 Complete!"
