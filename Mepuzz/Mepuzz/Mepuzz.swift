//
//  Mepuzz.swift
//  Mepuzz
//
//  Created by Chu Thin on 4/4/20.
//  Copyright © 2020 Chu Thin. All rights reserved.
//
//import Firebase
import FirebaseCore
import FirebaseMessaging
import SafariServices
fileprivate let MEPUZZ_ACTION = "click_action"
fileprivate let MEPUZZ_NOTIFICATION_ID = "notif_id"
fileprivate let MEPUZZ_TOKEN = "mepuzz_token"
fileprivate let MEPUZZ_SUB_ID = "mepuzz_sub_id"
fileprivate let MEPUZZ_SUB_ID_KEY = "sub_id"
fileprivate let MEPUZZ_PAYLOAD = "payload"
fileprivate var appIdValue:String = ""
fileprivate var mepuzzId:String = ""
fileprivate var userInfoData:[AnyHashable : Any] = [:]

public func config(appId:String){
    let delegate = MepuzzNotificationDelegate()
    appIdValue = appId
    mepuzzId = UserDefaults.standard.string(forKey: MEPUZZ_SUB_ID) ?? ""
    FirebaseApp.configure() // gọi hàm để cấu hình 1 app Firebase mặc định
    Messaging.messaging().delegate = delegate
    if #available(iOS 10.0, *) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        center.delegate = delegate
    } else {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
    }
    UIApplication.shared.registerForRemoteNotifications()
    if let fcmToken = Messaging.messaging().fcmToken {
        NSLog("fcmToken %@", fcmToken)
        sendToken(fcmToken)
    }
}

public func handleMessage(_ userInfo:[AnyHashable : Any]){
    userInfoData = userInfo
    let id = userInfoData[MEPUZZ_NOTIFICATION_ID] as? String  ?? ""
    sendView(notificationId: id, mepuzzId: mepuzzId)
}

public func setApnsToken(_ deviceToken:Data){
    Messaging.messaging().apnsToken = deviceToken
}

public class MepuzzNotificationDelegate: NSObject , UNUserNotificationCenterDelegate, MessagingDelegate {
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print(response)
            let id = userInfoData[MEPUZZ_NOTIFICATION_ID] as? String  ?? ""
            sendClick(notificationId: id, mepuzzId: mepuzzId)
            if let action = userInfoData[MEPUZZ_ACTION] as? String, let url = URL(string: action) {
                // print()
                
                let vc = SFSafariViewController(url: url)
                UIViewController.topMost?.present(vc, animated: true, completion: nil)
                userInfoData = [:]
                
            }
            print("Open Action")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
    
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        NSLog("fcmToken %@", fcmToken)
        sendToken(fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("fcmToken %@", fcmToken)
        sendToken(fcmToken)
    }
    
    
}

fileprivate func sendToken(_ fcmToken:String){
    var isSend = true
    if let token = UserDefaults.standard.string(forKey: MEPUZZ_TOKEN) {
        isSend = token != fcmToken
    }
    
    if(isSend) {
        let subId = UserDefaults.standard.string(forKey: MEPUZZ_SUB_ID) ?? ""
        sendPushNotification(to: fcmToken,subId: subId)
    }
}

fileprivate func sendPushNotification(to token: String, subId:String = "") {
    let urlString = "https://mepuzz.com/api/\(appIdValue)/subscribe"
    if let url = NSURL(string: urlString){
        let paramString: [String : Any] = ["language" : "vi",
                                           "subscription_id" : token,
                                           "mepuzzId" : subId,
                                           "device_os" : UIDevice.current.systemVersion,
                                           "operating_system" : "IOS",
                                           "operating_system_version" : "",
                                           "device_platform" : "Mobile",
                                           "device_model" : "",
                                           "ip" :"",
                                           "sdk_version" : ""]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    UserDefaults.standard.set(token, forKey: MEPUZZ_TOKEN)
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                        if let payload = jsonDataDict["payload"], let subIdResponse = payload[MEPUZZ_SUB_ID_KEY] as? String {
                            mepuzzId = subIdResponse
                            UserDefaults.standard.set(subIdResponse, forKey: MEPUZZ_SUB_ID)
                        }
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}

fileprivate func sendClick(notificationId: String,mepuzzId:String) {
    let urlString = "https://mepuzz.com/api/notif-click?notif=\(notificationId)&&mepuzzId=\(mepuzzId)"
    if let url = NSURL(string: urlString)
    {
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            if let jsonData = data{
                print(jsonData)
            }
            else {
                print(error.debugDescription )
            }
        }
        task.resume()
    }
    
}



fileprivate func sendView(notificationId: String,mepuzzId:String) {
    let urlString = "https://mepuzz.com/api/notif-view?notif=\(notificationId)&&mepuzzId=\(mepuzzId)"
    if let url = NSURL(string: urlString) {
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            if let jsonData = data{
                print(jsonData)
            }
            else {
                print(error.debugDescription )
            }
        }
        task.resume()
    }
}


public func sendEvent(event: String) {
    if let token = UserDefaults.standard.string(forKey: MEPUZZ_TOKEN) {
            let urlString = "https://mePuzz.com/api/track"
              if let url = NSURL(string: urlString) {
                  let paramString: [String : Any] = ["event" : event,
                                                     "app" : appIdValue,
                                                     "token" : token,
                                                     "mepuzzId" : mepuzzId]
                  
                  let request = NSMutableURLRequest(url: url as URL)
                  request.httpMethod = "POST"
                  request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
                  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                  
                  let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                      if let jsonData = data{
                          print(jsonData)
                      }
                      else {
                          print(error.debugDescription )
                      }
                  }
                  task.resume()
              }
    }
   
}

extension UIViewController {
    private class var sharedApplication: UIApplication? {
        let selector = NSSelectorFromString("sharedApplication")
        return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
    }
    
    /// Returns the current application's top most view controller.
    open class var topMost: UIViewController? {
        guard let currentWindows = self.sharedApplication?.windows else { return nil }
        var rootViewController: UIViewController?
        for window in currentWindows {
            if let windowRootViewController = window.rootViewController, window.isKeyWindow {
                rootViewController = windowRootViewController
                break
            }
        }
        
        return self.topMost(of: rootViewController)
    }
    /// Returns the top most view controller from given view controller's stack.
    open class func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}

