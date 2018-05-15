//
//  AppDelegate.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 04/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import OneSignal
import GoogleMobileAds
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mS = MyService()
    var backgroundTask: UIBackgroundTaskIdentifier = 0
    

        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        Fabric.with([Crashlytics.self])
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-8446699920682817~7829108542")
        
       let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        //ONE SIGNAL
       
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "f5854e88-0b58-495f-8d3f-e7899202d43d",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        
        //UIApplication.shared.setMinimumBackgroundFetchInterval(10)
        
        
        UIApplication.shared.statusBarStyle = .lightContent
         UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        mS.StartTimer()
     
        NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.applicationWillTerminate(_:)), name:NSNotification.Name.UIApplicationWillTerminate, object:nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.applicationDidEnterBackground(_:)), name:NSNotification.Name.UIApplicationDidEnterBackground, object:nil)
   
        return true

    }
   

    func applicationWillTerminate(_ application: UIApplication) {
   
       mS.StartTimer()
    
       
       
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        mS.StartTimer()
        
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("FOREGROUND")
        mS.StartTimer()
    }

}

