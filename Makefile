iOSPlatform?=iOS Simulator
iOSDevice?=iPhone SE (2nd generation)
iOSSDK?=$(shell xcrun --sdk iphonesimulator --show-sdk-path)

.PHONY: install
install:
	swift package generate-xcodeproj

.PHONY: example
example: schema
	# See also: https://github.com/apple/swift/blob/master/utils/build-script-impl#L504
	swift build -Xswiftc "-sdk" -Xswiftc $(iOSSDK) -Xswiftc "-target" -Xswiftc "x86_64-apple-ios14.0-simulator"
	xcodebuild -workspace GeccoExample/GeccoExample.xcworkspace -scheme GeccoExample -destination 'platform=$(iOSPlatform),name=$(iOSDevice)'
	open GeccoExample/GeccoExample.xcworkspace

.PHONY: carthage-project
carthage-project: install schema
	rm -rf Gecco-Carthage.xcodeproj
	cp -r Gecco.xcodeproj Gecco-Carthage.xcodeproj
 
.PHONY: sourcery
sourcery: 
	sourcery --sources ./Sources/Gecco --templates ./templates/sourcery/mockable.stencil  --output ./Tests/GeccoTests/Mock.generated.swift 

.PHONY: test
test: schema sourcery
	xcodebuild test -project Gecco.xcodeproj -scheme Gecco -configuration Debug -sdk $(iOSSDK) -destination "platform=$(iOSPlatform),name=$(iOSDevice)" 
	xcodebuild test -project Gecco.xcodeproj -scheme Gecco -configuration Debug # macOS

.PHONY: schema
schema: install
	mv Gecco.xcodeproj/xcshareddata/xcschemes/Gecco-Package.xcscheme Gecco.xcodeproj/xcshareddata/xcschemes/Gecco.xcscheme

