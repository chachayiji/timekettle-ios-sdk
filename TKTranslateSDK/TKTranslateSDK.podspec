Pod::Spec.new do |s|
  s.name         = "TKTranslateSDK"
  s.version      = "1.0.9"
  s.summary      = "TKTranslateSDK"
  s.description  = "A lightweight translation SDK skeleton."
  s.homepage     = "https://github.com/chachayiji/timekettle-ios-sdk"
  s.license      = { :type => "MIT", :text => "MIT" }
  s.author       = { "Timekettle" => "support@timekettle.co" }

  s.source       = { :http => "https://github.com/chachayiji/timekettle-ios-sdk/releases/download/v#{s.version}/TKTranslateSDK.xcframework.zip" }
  s.vendored_frameworks = "TKTranslateSDK.xcframework"
  s.static_framework = true

  s.platform = :ios, "15.0"
  s.swift_version = "5.0"

end
