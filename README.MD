Appoxee SDK
===========
This repository contains the Appoxee iOS SDK.

Integration
-----------

**Cocoa pods**

```ruby
target 'project_name' do
    pod 'AppoxeeSDK'
end
```

**OR**


```ruby
target 'project_name' do
    pod 'AppoxeeSDK', :git => 'https://github.com/AppoxeeMobile/iosArtifacts.git', :tag => '4.1.4'
end
```

**Manual**

* Drag and drop the ```AppoxeeSDK.framework``` to your project.
* Drag and drop the ```AppoxeeSDKResources.bundle``` to your project.
* Link ```UserNotifications.framework``` to your project.


Configuration file
------------------

Make sure to provide an ```AppoxeeConfig.plist``` file.

![Image of AppoxeeConfiguration.plist](https://s3.amazonaws.com/download.appoxee.com/sdk/Images/AppoxeeConfigurationPlist.png)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>sdk</key>
        <dict>
            <key>sdk_key</key>
            <string>123456789.00</string>
            <key>is_eu</key> <!-- Optional, indicate if account is EU / US -->
            <false/>
            <key>open_landing_page_inside_app</key> <!-- Optional, indicate if landing page should open inside the app or via Safari -->
            <false/>
        </dict>
    </dict>
</plist>
```

Implementation
--------------

**Objective-C**
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Appoxee shared] engageAndAutoIntegrateWithLaunchOptions:launchOptions andDelegate:nil];

    return YES;
}
```

**Swift**
```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    Appoxee.shared()?.engageAndAutoIntegrateWithLaunchOptions(launchOptions, andDelegate: nil)

    return true
}
```

License
-------
http://www.appoxee.com/terms/
