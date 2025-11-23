//
//  GoogleLoginManager.swift
//  Social Login Demo
//
//  Created by Mohamed Abd Elhakam on 23/11/2025.
//

import GoogleSignIn
import UIKit

class GoogleLoginManager {
    
    static let shared = GoogleLoginManager()
    
    
    /// Start Google Login
    func signIn(from vc: UIViewController, completion: @escaping (GIDSignInResult?, String?) -> Void) {
        
        
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { signInResult, error in
            guard error == nil else {
                completion(nil, "Missing Client ID")
                return
            }
            completion(signInResult, nil)
          }
    }
    
    /// Sign-out
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
