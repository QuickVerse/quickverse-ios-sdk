Pod::Spec.new do |spec|
  spec.name         = "QuickVerse"
  spec.version      = "1.4.2"
  spec.summary      = "Effortlessly integrate your quickverse.io localisations into your iOS app, for instant, over-the-air updates & more."
  spec.description  = <<-DESC
  QuickVerse lets you translate your web and mobile apps with ease. Powered by instant, over-the-air updates, you can change your app copy anytime, anywhere.
                   DESC
  spec.homepage     = "https://quickverse.io"
  spec.license      = { :type => 'Commercial', :file => 'LICENSE.md' }
  spec.author        = { "QuickVerse" => "team@quickverse.io" }
  spec.social_media_url = 'https://twitter.com/quickverse_io'
  spec.source        = { :git => "https://github.com/QuickVerse/quickverse-ios-sdk.git", :tag => "#{spec.version}" }
  spec.frameworks    = 'Foundation', 'UIKit'
  spec.requires_arc = true
  spec.platform     = :ios, '11.0'
  spec.source_files = 'Sources/**/*.{h,m,swift}'
  spec.swift_version       = '5.0'
end
