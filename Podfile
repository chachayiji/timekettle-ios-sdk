platform :ios, '15.0'

workspace 'timekettle-ios-sdk'

inhibit_all_warnings!

use_frameworks!

project 'TKTranslateSDKDemo/TKTranslateSDKDemo.xcodeproj'

# CocoaPods for Demo

target 'TKTranslateSDKDemo' do
  pod 'SnapKit', '~> 5.7'
end

target 'TKTranslateSDKDemoTests' do
  inherit! :search_paths
end

target 'TKTranslateSDKDemoUITests' do
  inherit! :search_paths
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
