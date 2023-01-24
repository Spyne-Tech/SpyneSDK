#
# Be sure to run `pod lib lint SpyneSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
 s.name       = 'SpyneSDK'
 s.version     = '0.1.5'
 s.summary     = 'SpyneAl is a Car background photo Editing App that generates Studio-setting Images instantly. This Al-powered app also produces Market place ready Images for Footwear, grocery'
# This description is used to generate tags and improve search results.
#  * Think: What does it do? Why did you write it? What is the focus?
#  * Try to keep it short, snappy and to the point.
#  * Write the description between the DESC delimiters below.
#  * Finally, don't worry about the indent, CocoaPods strips it!
 s.description   = <<-DESC
 'SpyneAl is a Car background photo Editing App that generates Studio-setting Images instantly. It enables you to get car background photo editor options with just your phone. You no longer need to hire studios or even step outside as this simple yet powerful Spyne App lets you click simple images of your products and transforms them into professional marketplace images with the help of Al Automated Editing.'
            DESC
 s.homepage     = 'https://docs.spyne.ai/reference/ios-sdk-quick-start-guide'
 # s.screenshots   = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
 s.license     = { :type => 'MIT', :file => 'LICENSE' }
 s.author      = { 'SpyneSDK' => 'tech@spyne.ai' }
 s.source      = { :git => 'https://github.com/Spyne-Tech/SpyneSDK.git', :tag => s.version.to_s }
 # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
 s.ios.deployment_target = '13.0'
 s.source_files = 'SpyneSDK/Sources/**/*'
 # s.resource_bundles = {
 #  'SpyneSDK' => ['SpyneSDK/Assets/*.png']
 # }
 # s.public_header_files = 'Pod/Classes/**/*.h'
 # s.frameworks = 'UIKit', 'MapKit'
 # s.dependency 'AFNetworking', '~> 2.3'
end
