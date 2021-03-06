//
//  AppDelegate.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-24.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configuring database
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        // Configure textfield fix
        IQKeyboardManager.sharedManager().enable = true
        
        //let friendVC = FriendsViewController()
        //friendVC.fetchFriends()
        fetchFriends()
        fetchPoints()
        
        
        // Change color
        
        //let greenColor = UIColor(red: 0, green: 144, blue: 123, alpha: 1)
        
        // Background color
        UITabBar.appearance().barTintColor = UIColor.orange
        UINavigationBar.appearance().barTintColor = UIColor.orange
        
        // Text color
        UINavigationBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.white
        
 

        
        // Change text size and style of navigation bar
        let navigationFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 18)!
        let navigationFontAttributes = [NSFontAttributeName : navigationFont]
        
        UINavigationBar.appearance().titleTextAttributes = navigationFontAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(navigationFontAttributes, for: .normal)
        
        /*
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: identifiersStoryboard.Main.rawValue, bundle: nil)
        var vc: UIViewController
        
        if (UserDefaults.standard.value(forKey: forKey.Username.rawValue) as? String) == nil {
            // Show onbaording screen
            vc = storyboard.instantiateViewController(withIdentifier: identifiersVC.OnboardingVC.rawValue)
        } else {
            // SHow main screen
            vc = storyboard.instantiateInitialViewController()!
        }
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        */
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


}

