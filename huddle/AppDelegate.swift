//
//  AppDelegate.swift
//  huddle
//
//  Created by Mateo Garcia on 3/19/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mapViewController: MapViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /** CONNECT TO PARSE **/
        
        if let keys = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Keys", ofType: "plist")!) {
            // Parse config.
            let configuration = ParseClientConfiguration {
                $0.applicationId = keys["ParseApplicationID"] as? String
                $0.clientKey = keys["ParseClientKey"] as? String
                
                /* DEVELOPMENT ONLY */
                #if TARGET_IPHONE_SIMULATOR
                    $0.server = "http://localhost:1337/parse"
                #else
                    // $0.server = "http://mog.local:1337/parse"
                    $0.server = "http://192.168.1.84:1337/parse"
                #endif
                /* END DEVELOPMENT ONLY */
                
                /*********** ENABLE BEFORE APP DEPLOY ***********/
                $0.server = "https://thedelt.herokuapp.com/parse"
            }
            Parse.enableDataSharing(withApplicationGroupIdentifier: "group.com.tdx.thedelt")
            Parse.enableLocalDatastore()
            Parse.initialize(with: configuration)
            
            PFUser.enableRevocableSessionInBackground { (error: Error?) -> Void in
                print("enableRevocableSessionInBackgroundWithBlock completion")
            }
        } else {
            print("Error: Unable to load Keys.plist.")
        }
        
        /** SET INITIAL VIEW **/
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.mapViewController = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as? HamburgerViewController
        
        /** CHECK IF USER LOGGED IN **/
        
        if PFUser.current() == nil {
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            // Does exactly the same as arrow in storyboard. ("100% parity." --Tim Lee)
            window?.rootViewController = loginViewController
            // Will register for push after successful login.
            
        } else {
            
            // Save username to NSUserDefaults in case PFUser.currentUser() fails in share extension.
            UserDefaults(suiteName: "group.com.tdx.thedelt")?.set(PFUser.current()!.username!, forKey: "Username")
            
            if let isAdmin = PFUser.current()!.object(forKey: "is_admin") as? Bool {
                AppDelegate.isAdmin = isAdmin
            } else {
                AppDelegate.isAdmin = false
            }
            
            // Does exactly the same as arrow in storyboard. ("100% parity." --Tim Lee)
            window?.rootViewController = self.mapViewController
        }
        
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

