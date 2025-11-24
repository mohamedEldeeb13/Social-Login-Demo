//
//  AppDelegate.swift
//  Social Login Demo
//
//  Created by Mohamed Abd Elhakam on 23/11/2025.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // -------------------------
        // 🔵 Facebook Configuration
        // -------------------------
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        
        // -------------------------
        // 🔴 Google Configuration
        // -------------------------
        if let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        } else {
            print("❌ Missing GIDClientID in Info.plist")
        }
        
        
        // Restore previous sign-in (Optional)
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user {
                print("User already signed in:", user.profile?.name ?? "")
            } else {
                print("Not signed in yet")
            }
        }
        return true
    }
    
    // -------------------------------------------------------
    // 🔗 Combined URL Handler for Facebook & Google
    // -------------------------------------------------------
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        // 1️⃣ Try Facebook
        if ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[.sourceApplication] as? String,
            annotation: options[.annotation]
        ) {
            return true
        }
        
        // 2️⃣ Try Google
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        // Not handled
        return false
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

