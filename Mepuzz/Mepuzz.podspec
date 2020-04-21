
Pod::Spec.new do |spec|
  spec.name         = "Mepuzz"
  spec.version      = "1.0.0"
  spec.summary      = "Mepuzz sdk for iOS"
  spec.description  = "Mepuzz SDK for iOS platform"

  spec.homepage     = "https://github.com/MePuzz/MepuzzIosSDK"
  spec.license      = "MIT"
  spec.author             = { "Mepuzz" => "hotro@mepuzz.com" }
  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/MePuzz/MepuzzIosSDK.git", :tag => "#{spec.version}" }
  spec.static_framework = true
  
  spec.source_files  = "Mepuzz/**/*.{swift}"
  spec.framework = 'Foundation'
  spec.framework  = 'SafariServices'
  # spec.framework  = "SomeFramework"
  # spec.dependency "JSONKit", "~> 1.4"
  spec.ios.dependency 'Firebase'
  spec.ios.dependency 'FirebaseCore'
  spec.ios.dependency 'FirebaseMessaging'
  spec.swift_version = '5.0'
end
