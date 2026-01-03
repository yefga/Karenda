Pod::Spec.new do |spec|
  spec.name         = "Karenda"
  spec.version      = "1.0.0"
  spec.summary      = "A customizable UIKit-based calendar date picker for iOS"
  spec.description  = <<-DESC
    Karenda is a highly customizable calendar date picker framework for iOS.
    
    Features:
    - Vertical scrolling (all months) or horizontal paging (one month per page)
    - Single date or date range selection
    - Public holiday highlighting with dot indicators
    - Configurable start day of week (Sunday, Monday, etc.)
    - Customizable colors, fonts, and selection styles
    - Footer showing holiday names for each month
    - Built with UICollectionView and Compositional Layout
  DESC

  spec.homepage     = "https://github.com/yefga/Karenda"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Yefga" => "yefga@naver.com" }

  spec.platform     = :ios, "13.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/yefga/Karenda.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/**/*.swift"

  spec.framework    = "UIKit"
  spec.requires_arc = true

  # Build settings for library evolution
  spec.pod_target_xcconfig = {
    "BUILD_LIBRARY_FOR_DISTRIBUTION" => "YES",
    "SKIP_INSTALL" => "NO"
  }
end
