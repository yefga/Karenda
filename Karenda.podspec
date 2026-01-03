Pod::Spec.new do |spec|
  spec.name         = "Karenda"
  spec.version      = "1.0.0"
  spec.summary      = "A modern UIKit-based UI component framework for iOS"
  spec.description  = <<-DESC
    Karenda is a reusable UI component framework designed for iOS applications.
    It provides a clean, modular structure with base views, theming support,
    and extensible components for building beautiful user interfaces.
  DESC

  spec.homepage     = "https://github.com/example/Karenda"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Author" => "author@example.com" }

  spec.platform     = :ios, "13.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/example/Karenda.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/**/*.swift"
  spec.resources    = "Sources/Resources/**/*"

  spec.framework    = "UIKit"
  spec.requires_arc = true

  # Build settings for library evolution
  spec.pod_target_xcconfig = {
    "BUILD_LIBRARY_FOR_DISTRIBUTION" => "YES",
    "SKIP_INSTALL" => "NO"
  }
end
