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
     
        NSUserDefaults.standardUserDefaults().setInteger(0,forKey: "launch")
        NSUserDefaults.standardUserDefaults().setInteger(0,forKey: "launchview")
        NSUserDefaults.standardUserDefaults().synchronize()
         
        UINavigationBar.appearance().barTintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("authkey") != nil {
           let vc = storyboard.instantiateViewControllerWithIdentifier("Home") as!SWRevealViewController
       //    let followupController = vc.topViewController as! FollowUpViewController
           self.window!.rootViewController = vc;
        }
        else
        {
           let vc = storyboard.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
           self.window!.rootViewController = vc;
        }
        Util.copyFile("mcubeios")
        
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)

        
        return true
    }

    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        //let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
       // let viewController = appDelegate.window!.rootViewController as! UINavigationController
   
       if let nav = window?.rootViewController as? UINavigationController,
            viewControllers = nav.viewControllers as? [UITableViewController] {
            for viewController in viewControllers {
                if let fetchViewController = viewController as? FollowUpViewController {
                    fetchViewController.fetch {
                        fetchViewController.updateUI()
                        completionHandler(.NewData)
                    }
                }
            }
        }
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

