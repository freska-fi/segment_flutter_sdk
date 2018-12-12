#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'segment_flutter_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin that allows sending analytics events to https://segment.com'
  s.description      = <<-DESC
A Flutter plugin that allows sending analytics events to https:&#x2F;&#x2F;segment.com
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end

