Pod::Spec.new do |s|
  s.name         = "TKTranslateSDK"
  s.version      = "0.1.0"
  s.summary      = "TKTranslateSDK"
  s.description  = "A lightweight translation SDK skeleton."
  s.homepage     = "https://github.com/chachayiji/timekettle-ios-sdk"
  s.license      = { :type => "MIT", :text => "MIT" }
  s.author       = { "Timekettle" => "support@timekettle.co" }

  s.source       = { :git => "https://github.com/chachayiji/timekettle-ios-sdk.git", :tag => s.version.to_s }
  s.vendored_frameworks = "TKTranslateSDK.xcframework"
  s.static_framework = true

  s.ios.deployment_target = "15.0"
  s.osx.deployment_target = "12.0"
  s.swift_version = "5.0"

  s.dependency "Moya", "~> 15.0"
end
