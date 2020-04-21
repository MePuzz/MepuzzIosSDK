# MepuzzIosSDK
# Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Mepuzz into your Xcode project using CocoaPods, specify it in your `Podfile`:

```bash
pod 'Mepuzz'
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
