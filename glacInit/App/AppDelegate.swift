//
//  AppDelegate.swift
//  glacInit
//
//  Created by Parshav Chauhan on 2/11/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

//Questions that arise
//do we assume everyone will have the same size Ipad or will it be modular? if so will need to refactor (more for if others are planning on using it
//Standardization if refactored/ we will need to create a standard that everything will be reformatted to, like 600 by 400 regardless of screen size
//export button will need to be updated where it checks if account is connected if not will will reprompt user to connect



import UIKit
import BoxContentSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Reachability code
        // Allocate a reachability object\
//        DropboxClientsManager.setupWithAppKey("k7md28kj4bojyxxa65kd1bwraxlhhq60")
        BOXContentClient.setClientID("k7md28kj4bojyxxa65kd1bwraxlhhq60", clientSecret: "ES1YfYYpIFyKo4lkBdhphhFlEBfqPtpg")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: PickerView())
        
        //DropboxClientsManager.setupWithAppKey("k7md28kj4bojyxxa65kd1bwraxlhhq60")
        
       // DropboxClientsManager.
        //BOXContentClient.setClientID("k7md28kj4bojyxxa65kd1bwraxlhhq60", clientSecret: "ES1YfYYpIFyKo4lkBdhphhFlEBfqPtpg")
        
        return true
    }

//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
//            switch authResult {
//            case .success:
//                print("Success! User is logged into Dropbox.")
//            case .cancel:
//                print("Authorization flow was manually canceled by user!")
//            case .error(_, let description):
//                print("Error: \(description)")
//            }
//        }
//        return true
//    }
    
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
        //let contentClient = BOXContentClient.default()
        //contentClient?.logOut()
    }


}

