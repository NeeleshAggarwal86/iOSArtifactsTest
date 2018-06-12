Pod::Spec.new do |s|

  s.name         = "AppoxeeSDK5.0"
  s.version      = "5.0"
  s.summary      = "Appoxee SDK enables developers to harnest the full power of Appoxee on their iOS applications."
  s.description  = 	<<-DESC
  					Appoxee SDK enables push notification in your iOS application, for engaging your application users and increasing retention.
                   	DESC
  s.homepage     = "http://www.appoxee.com"
  s.license      = { :type => "Custom", :file => "AppoxeeLicence.txt" }
  s.author       = { "Appoxee" => "info@appoxee.com" }
  s.source       = { :git => "https://github.com/NeeleshAggarwal86/iOSArtifactsTest.git", :tag => "5.0" }
  s.ios.framework = 'UserNotifications'
  s.platform     = :ios, "8.0"
  s.ios.vendored_frameworks = "SDK/AppoxeeSDK.framework"
  s.preserve_paths = 'SDK/AppoxeeSDK.framework'
  s.resource_bundle = { 'AppoxeeSDKResources' => 'SDK/AppoxeeSDKResources.bundle' }
  s.requires_arc = true

end
