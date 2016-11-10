//
//  AppDelegate.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate {

    var window: UIWindow?

 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        UserDefaults.standard.set(0,forKey: LAUNCH)
        UserDefaults.standard.set(0,forKey: LAUNCHVIEW)
        UserDefaults.standard.synchronize()
         
        UINavigationBar.appearance().barTintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if UserDefaults.standard.string(forKey: AUTHKEY) != nil {
           let vc = storyboard.instantiateViewController(withIdentifier: "Home") as!SWRevealViewController
           self.window!.rootViewController = vc;
        } else {
           let vc = storyboard.instantiateViewController(withIdentifier: "loginController") as! LoginViewController
           self.window!.rootViewController = vc;
        }
          Util.copyFile("mcubeios")
        
   
    
      let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      UIApplication.shared.registerUserNotificationSettings(settings)
      UIApplication.shared.registerForRemoteNotifications()
  
        return true
    }
    
    
    
    
    @nonobjc func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       let token = String(format: "%@", deviceToken as CVarArg)
            .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
         print(token)

    }

    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("APNs registration failed: \(error)")
    }
    
     
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Complete");
        completionHandler(UIBackgroundFetchResult.newData)
        updateBackground();
        
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
    func updateBackground() {
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        let types = [TRACK,FOLLOWUP,IVRS,LEAD,X,MTRACKER]
        for type in types {
            let operation = NetworkOperation(type: type) { responseObject, error in
                if responseObject == nil {
                    print("failed: \(error)")
                } else {
                    let result:NSMutableArray=ParseJason().ParseReportJason(responseObject!,type: type);
                    let menu:Array<OptionsData>=ParseJason().ParseMenu(responseObject!);
                    let isUpdated = ModelManager.getInstance().insertData(type, isDelete: true, Datas: result, isMore: false)
                    let isMenu = ModelManager.getInstance().insertMenu (type, Options: menu)
                    if(isUpdated && isMenu){
                        
                        print("Background Result for type \(type) and \(ParseJason().ParseReportJason(responseObject!,type:type).count)")
                    }
                    
                    
                }
            }
            queue.addOperation(operation)
        }
        
//        let localNotification:UILocalNotification = UILocalNotification()
//        localNotification.alertAction = "Testing notifications on iOS9"
//        localNotification.alertBody = "Fetch Completed"
//        localNotification.fireDate = Date(timeIntervalSinceNow: 1)
//        UIApplication.shared.scheduleLocalNotification(localNotification)

    
    }
    
 
    @nonobjc func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void){
        
        
           print("Push notification received: \(userInfo)")
    }
    
    
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

