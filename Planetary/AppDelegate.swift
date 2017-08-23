//
//  AppDelegate.swift
//  Hackin the Web
//
//  Created by Kyle Lee on 6/18/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GADMobileAds.configure(withApplicationID: "com.photosurplus.planetary")
        FirebaseApp.configure()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0, green: 170/255, blue: 240/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 20)!]
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
        UITabBar.appearance().tintColor = UIColor(red: 0, green: 170/255, blue: 240/255, alpha: 1)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 17)!], for: .normal) // your textattributes here
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if let presentedViewController = window?.rootViewController?.presentedViewController {
            let className = String(describing: type(of: presentedViewController))
            if ["MPInlineVideoFullscreenViewController", "MPMoviePlayerViewController", "AVFullScreenViewController", "PSImageViewController", "SFSafariViewController", "PSSafariViewController"].contains(className) {
                UIApplication.shared.statusBarStyle = .default
                if className == "SFSafariViewController" || className == "PSSafariViewController" {
                    return UIInterfaceOrientationMask.portrait
                } else {
                    return UIInterfaceOrientationMask.allButUpsideDown
                }
            } else {
                UIApplication.shared.statusBarStyle = .lightContent
                UIApplication.shared.isStatusBarHidden = false
            }
        }
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
        return UIInterfaceOrientationMask.portrait
    }
    
    func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        
    }

}
