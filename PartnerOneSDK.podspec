#
# Be sure to run `pod lib lint PartnerOneSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PartnerOneSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PartnerOneSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A SDK to send documentation and facil validation.'

  s.homepage         = 'https://github.com/partneroneti/p1sdk.ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Thiago Silva' => 'thyago_casablancas@hotmail.com' }
  s.source           = { :git => 'https://github.com/partneroneti/p1sdk.ios/PartnerOneSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/PartnerOneSDK/Classes/**/*'
  s.dependency 'unicocheck-ios', '~> 2.16.12'

  s.resource_bundles = {
    'PartnerOneSDK' => [
       'Sources/PartnerOneSDK/Resources/Assets/*.png',
       'Sources/PartnerOneSDK/Resources/Assets/*.jpg',
       'Sources/PartnerOneSDK/Resources/Assets/Assets.xcassets',
       'Sources/PartnerOneSDK/Resources/Assets/Assets.xcassets/DocumentScan/*.png',
       'Sources/PartnerOneSDK/Resources/Fonts/*.{ttf}',
    ]
  }

   s.public_header_files = 'Pods/Classes/**/*.h'
end
