#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint infobip_webrtc_sdk_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'infobip_voice'
  s.version          = '0.0.5'
  s.summary          = 'Infobip SDK Flutter'
  s.description      = <<-DESC
Infobip SDK Flutter
                       DESC
  s.homepage         = 'https://infobip.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Team Delta' => 'Team_Delta@infobip.com' }
  s.source       = { :path => '.' }

  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'InfobipRTC', '2.2.12'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
