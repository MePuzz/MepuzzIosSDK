//
//  AppDelegate.swift
//  MepuzzExample
//
//  Created by Chu Thin on 4/5/20.
//  Copyright © 2020 Chu Thin. All rights reserved.
//

import UIKit
import Mepuzz
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Mepuzz.config(appId:"BXQ9JLy4nE")
        Mepuzz.sendEvent(event: "IOS SDK event")
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Mepuzz.setApnsToken(deviceToken)
    }
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Mepuzz.handleMessage(userInfo)
    }

}

