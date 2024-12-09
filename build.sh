#!/bin/bash

cd RumbleHeartsSwift

swift build --configuration debug

cd ..

cp RumbleHeartsSwift/.build/arm64-apple-macosx/debug/*.dylib ./bin
