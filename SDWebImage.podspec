Pod::Spec.new do |s|
  s.name = 'SDWebImage'
  s.version = '5.21.1'

  s.osx.deployment_target = '10.11'
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '7.0'
  s.visionos.deployment_target = "1.0"
  s.summary = 'Asynchronous image downloader with cache support with an UIImageView category.'
  s.homepage         = 'https://github.com/songyang/SDWebImage'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'songyang' => 'yang.song@govee.com' }
  s.source           = { :git => 'git@github.com:GoveeHomeApp/SDWebImage.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.requires_arc = true
  s.framework = 'ImageIO'
  s.source_files = 'SDWebImage/Classes/**/*'
  

  s.pod_target_xcconfig = {
    'SUPPORTS_MACCATALYST' => 'YES',
    'DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER' => 'NO'
  }
  
end
