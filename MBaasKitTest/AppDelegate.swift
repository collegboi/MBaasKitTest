//
//  AppDelegate.swift
//  MBaasKitTest
//
//  Created by Timothy Barnard on 26/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit
import MBaaSKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        TBAnalyitcs.sendOpenApp(self)
        
        MyException.client()
        MyException.sharedClient?.setupExceptionHandler()
        
        self.setupApp()
        
        self.registerForPushNotifications(application)
        
        return true
    }
    
    func setupApp() {
        let navColor = UIColor(red: 38.0/255, green: 154.0/255, blue: 208.0/255, alpha: 0.5)
        UINavigationBar.appearance().barTintColor = navColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName: UIFont(name: "Avenir Next", size: 22)!]
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        TBAnalyitcs.sendCloseApp(self)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        TBAnalyitcs.sendOpenApp(self)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Notifications

    func registerForPushNotifications(_ application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if !granted {
                print("not granted")
            }
        }
        application.registerForRemoteNotifications()
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        
        if let aps = userInfo["aps"] as? NSDictionary {
            let message = aps["alert"]
            print("my messages : \(message)")
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
        
        let installation = TBInstallation(deviceToken: deviceToken)
        installation.sendInBackground("") { ( completed, data) in
            DispatchQueue.main.async {
                if (completed) {
                    print("success")
                } else {
                    print("error")
                }
            }
            
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }

    
}

