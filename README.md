# MepuzzIosSDK
# Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Mepuzz into your Xcode project using CocoaPods, specify it in your `Podfile`:

```bash
pod 'Mepuzz', '~> 1.0'
```

Then, run the following command:

```bash
$ pod install
```

## Usage
**Import**

Import module in Swift language:
```swift
import Mepuzz
```

**Initialization**
In application:didFinishLaunchingWithOptions method, initialize Mepuzz SDK as below:

```swift
// Swift language
let appID = "your application id from Mepuzz"
Mepuzz.config(appId:appID)
```
In application:didRegisterForRemoteNotificationsWithDeviceToken method, initialize Mepuzz SDK as below:
```swift
// Swift language
Mepuzz.setApnsToken(deviceToken)
```
In application:didReceiveRemoteNotification:fetchCompletionHandler completionHandler method, initialize Mepuzz SDK as below:

```swift
// Swift language
Mepuzz.handleMessage(userInfo)
```
**Event tracking**
```swift
// Swift language
Mepuzz.sendEvent(event: "event name")
```
## Config project

**Create certificate**

[How to create Certificate](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/establishing_a_certificate-based_connection_to_apns)

**Enable capabilities**
<img src="https://koenig-media.raywenderlich.com/uploads/2018/09/Push-Notification-Capability.png" />
