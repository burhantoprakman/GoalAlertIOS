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
    var background_task : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    

        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        Fabric.with([Crashlytics.self])
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-8446699920682817~7829108542")
        
       let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        //ONE SIGNAL
       
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "011612ff-da89-490f-9133-1d53b5ba967a",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        
         UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
   
        
        //mS.StartTimer()
     
        //NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.applicationWillTerminate(_:)), name:NSNotification.Name.UIApplicationWillTerminate, object:nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.applicationWillEnterForeground(_:)), name:NSNotification.Name.UIApplicationWillEnterForeground, object:nil)
   
        return true

    }
   

    func applicationWillTerminate(_ application: UIApplication) {
   
       //mS.StartTimer()
    
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
//            self.mS.StartTimer()
//        if let vc = window?.rootViewController as? LiveScores{
//            vc.getLiveMatches(url : URL(string: "http://opucukgonder.com/tipster/index.php/Service/lastLive"))
//            completionHandler(.newData)
//        }
        

    }
    
    
    func application(_ application: UIApplication,
                              didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                              fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        completionHandler(UIBackgroundFetchResult.newData)
    }
 
    func applicationDidEnterBackground(_ application: UIApplication) {
//        if let vc = window?.rootViewController as? LiveScores{
//            vc.getLiveMatches(url : URL(string: "http://opucukgonder.com/tipster/index.php/Service/lastLive"))
//        }
//        mS.StartTimer()
        
    }
 
    func applicationWillEnterForeground(_ application: UIApplication) {
//        if let vc = window?.rootViewController as? LiveScores{
//            vc.getLiveMatches(url : URL(string: "http://opucukgonder.com/tipster/index.php/Service/lastLive"))
//        }
//        mS.StartTimer()
//    }


}

}
