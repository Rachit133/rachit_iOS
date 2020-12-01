//
//  AppDelegate.swift
//  Beer Connect
//
//  Created by Synsoft on 20/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LMCSideMenu
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   var navigationController: UINavigationController?
   let notificationCenter = UNUserNotificationCenter.current()
    
   func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        // Override point for customization after application launch.
        self.registerForPushNotifications()
        IQKeyboardManager.shared.enable = true
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        NetworkManager.shared.setUpProgressBar()
        self.setUpRootViewController()
        return true
   }
    
    func registerForPushNotifications() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
   
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }
    
   @available(iOS 13.0, *)
   func application(_ application: UIApplication,
                    configurationForConnecting connectingSceneSession: UISceneSession,
                    options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }
   
   @available(iOS 13.0, *)
   func application(_ application: UIApplication,
                    didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      // Called when the user discards a scene session.
      // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
   }
  

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         let tokenParts = deviceToken.map { data -> String in
             return String(format: "%02.2hhx", data)
         }
         let token = tokenParts.joined()
         print("Device Token: \(token)")
         UserDefaults.standard.set(token, forKey: "deviceToken")
    }

     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         // 1. Print out error if PNs registration not successful
         print("Failed to register for remote notifications with error: \(error)")
     }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        let state = UIApplication.shared.applicationState
        let test=userInfo["aps"] as! Dictionary<String,Any>
        let main=test["alert"] as! Dictionary<String,Any>
        //let data=userInfo["data"] as! Dictionary<String,Any>
        if state == .active {
            let alert=UIAlertController(title: main["title"] as? String, message: main["body"] as? String, preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.onGetNotification(main: main)
            })
            let action_cancel=UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
                return
            })
            alert.addAction(action)
            alert.addAction(action_cancel)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        else if state == .background{
            onGetNotification(main: main)
        }
        else if state == .inactive{
            onGetNotification(main: main)
        }
        else{
            onGetNotification(main: main)
        }

    }
    func onGetNotification(main:Dictionary<String,Any>){
        let notType=main["link_type"] as! String
        let notification_id=main["notification_id"] as! String
        if UserDefaults.standard.value(forKey: "NotificationIDS") != nil {
            let temp=UserDefaults.standard.value(forKey: "NotificationIDS") as! String
            let data=","+notification_id
            UserDefaults.standard.set(temp+data, forKey: "NotificationIDS")
        
        } else { UserDefaults.standard.set(notification_id,
                                      forKey: "NotificationIDS")
        }
        
        if notType.lowercased().trim() == "category" {
            let data=main["link_id"] as! String
            UserDefaults.standard.set(["category":data], forKey: "NotificationData")
            
        } else if notType.lowercased().trim() == "product" {
            let data=main["link_id"] as! String
            UserDefaults.standard.set(["product":data], forKey: "NotificationData")
        }
        
        self.setUpRootViewController()
        /*else if notType.lowercased().trim() == "website" {
            let data=main["link_id"] as! String
            UserDefaults.standard.set(["website":data], forKey: "NotificationData")
        }*/
        return
    }
}


// MARK: SET UP ROOT VIEW CONTROLLER
extension AppDelegate {
   func setUpRootViewController() {
      self.window = UIWindow(frame: UIScreen.main.bounds)
         let storyBoard = UIStoryboard.init(name: STORYBOARDCONS.ONBOARD,
                                                     bundle: Bundle.main)
         if let loginVC = storyBoard.instantiateViewController(
                             withIdentifier: VCIDENTIFIER.LOGINVC)
                                      as? LoginViewController {
            self.navigationController = UINavigationController(rootViewController: loginVC)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            if #available(iOS 11.0, *) {
               self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            self.window?.rootViewController = self.navigationController!
            self.window?.makeKeyAndVisible()
         }
    
        //}
   }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        
        completionHandler()
    }
    
    func scheduleNotification(invoiceData: Data) {
        
        let content = UNMutableNotificationContent() 
        let categoryIdentifire = "Delete Notification Type"
        
        content.title = "Invoice"
        content.body = "Invoice downloaded successfully"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        //let snoozeAction = UNNotificationAction(identifier: "Open", title: "Invoice", options: [])
        //let deleteAction = UNNotificationAction(identifier: "Cancel", title: "Cancel", options: [.destructive])
        //let category = UNNotificationCategory(identifier: categoryIdentifire,
          //                                    actions: [snoozeAction, deleteAction],
           //                                   intentIdentifiers: [],
            //                                  options: [])
        
        //notificationCenter.setNotificationCategories([category])
    }
}
