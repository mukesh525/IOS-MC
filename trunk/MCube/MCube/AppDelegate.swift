//
//  AppDelegate.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
     
        NSUserDefaults.standardUserDefaults().setInteger(0,forKey: LAUNCH)
        NSUserDefaults.standardUserDefaults().setInteger(0,forKey: LAUNCHVIEW)
        NSUserDefaults.standardUserDefaults().synchronize()
         
        UINavigationBar.appearance().barTintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if NSUserDefaults.standardUserDefaults().stringForKey(AUTHKEY) != nil {
           let vc = storyboard.instantiateViewControllerWithIdentifier("Home") as!SWRevealViewController
           self.window!.rootViewController = vc;
        }
        else
        {
           let vc = storyboard.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
           self.window!.rootViewController = vc;
        }
          Util.copyFile("mcubeios")
        
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        return true
    }

    
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("Complete");
        completionHandler(UIBackgroundFetchResult.NewData)
        updateBackground();
        
    }
    
    func updateBackground() {
        
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 2
        let types = [TRACK,FOLLOWUP,IVRS,LEAD,X,MTRACKER]
        for type in types {
            let operation = NetworkOperation(type: type) { responseObject, error in
                if responseObject == nil {
                    print("failed: \(error)")
                } else {
                    let result:NSMutableArray=ParseJason().ParseReportJason(responseObject!);
                    let menu:Array<OptionsData>=ParseJason().ParseMenu(responseObject!);
                    let isUpdated = ModelManager.getInstance().insertData(type, isDelete: true, Datas: result, isMore: false)
                    let isMenu = ModelManager.getInstance().insertMenu (type, Options: menu)
                    if(isUpdated && isMenu){
                        
                        print("Background Result for type \(type) and \(ParseJason().ParseReportJason(responseObject!).count)")
                    }
                    
                    
                }
            }
            queue.addOperation(operation)
        }
        
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS9"
        localNotification.alertBody = "Fetch Completed"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

    
    }
    
 
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

