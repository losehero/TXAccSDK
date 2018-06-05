#
# Be sure to run `pod lib lint TXAccountSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TXAccountSDK'
  s.version          = '0.2.0'
  s.summary          = 'A short description of TXAccountSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/losehero/TXAccSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'losehero' => 'jinlong@medical-lighter.com' }
  s.source           = { :git => 'https://github.com/losehero/TXAccSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TXAccountSDK/Classes/**/*'
  s.resources = 'TXAccountSDK/Assets/TXPodsImages.bundle' , 'TXAccountSDK/Resources/xibs/*.xib'

  
  # s.resource_bundles = {
  #   'TXAccountSDK' => ['TXAccountSDK/Assets/*.png']
  # }

   s.frameworks = 'UIKit','CoreData','Foundation','CoreGraphics'
   s.dependency 'XLForm', '~> 3.0'
   s.dependency 'JVFloatLabeledTextField', '1.0.2'
  # s.dependency 'AFNetworking', '~> 2.3'
end
