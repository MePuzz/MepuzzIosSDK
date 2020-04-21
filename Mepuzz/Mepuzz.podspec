
Pod::Spec.new do |spec|
  spec.name         = "Mepuzz"
  spec.version      = "0.0.1"
  spec.summary      = "An implement Cycle.js"
  spec.description  = "An implement Cycle.js with Swift, RxSwif, Stylist"

  spec.homepage     = "https://github.com/chuthin/CycleSwift"
  spec.license      = "MIT"
  spec.author             = { "Chu Thin" => "thincv@live.com" }
  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/chuthin/CycleSwift.git", :tag => "#{spec.version}" }
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
