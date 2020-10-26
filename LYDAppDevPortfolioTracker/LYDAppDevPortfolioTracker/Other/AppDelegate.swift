//
//  AppDelegate.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("Error: The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
    }
    

        var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 0.737, green: 0.722, blue: 0.694, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 0.2)
        UITabBar.appearance().tintColor = UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 0.8)
        FirebaseApp.configure()
        
        let signIn = GIDSignIn.sharedInstance()
        signIn?.clientID = FirebaseApp.app()?.options.clientID
        //signIn?.clientID = "780801679852-u44mc2idlv0ous8ngm19kfdvf342gjn6.apps.googleusercontent.com"
        if Auth.auth().currentUser != nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: "PersonInfoViewController")
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }

        return true
    }
    
}

