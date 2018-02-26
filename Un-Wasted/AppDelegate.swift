//
//  AppDelegate.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // register for Push Notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
            
        
        // Create inital view controller
        let tabBarController = HomeTabBarController()
        
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        if let notification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            handleNotification(notification: notification)
        }
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserManager.currentUser.apnsToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        handleNotification(notification: userInfo)
    }

    private func handleNotification(notification: [AnyHashable: Any]) {
        
        let tabBarController = self.window?.rootViewController
        
        let scheduledCollectionViewController = ScheduledCollectionViewController.initalize()
        scheduledCollectionViewController.matchText = (notification["aps"] as? [String: Any])?["alert"] as? String ?? ""
        scheduledCollectionViewController.recipientImageURL = notification["userImage"] as? String ?? ""
        scheduledCollectionViewController.recipientName = notification["messageFrom"] as? String ?? ""
        
        tabBarController?.present(scheduledCollectionViewController, animated: true, completion: nil)
    }
}

