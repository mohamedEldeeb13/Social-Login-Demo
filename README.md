# 🌐 Google Login Integration on iOS

Google Login allows users to **sign in or register** in your app using their Google account.  
It provides basic user information like **email, name, profile picture**, and an **ID Token** to verify the user on your backend.

---

## 1️⃣ What is Google Login & How It Works

Google Login is an **OAuth 2.0 authentication system** that lets users sign in **without creating a separate password** for your app.  
Your backend can verify the **ID Token** received from Google to authenticate the user.  

- Can be used for **Sign Up** (new user) or **Login** (existing user)  
- Provides **email, name, profile picture**  
- Does **not always provide phone number** → ask user separately if needed  

> If your app requires data not provided by Google, you must ask the user to fill it after signing in.

---

<br>

## 2️⃣ Requirements

- iOS 13+  
- Xcode 13+  
- Google Cloud Project with OAuth Client ID  
- GoogleSignIn SDK (latest)  
- Real device or Simulator (Simulator works for Google Login)  

---

<br>

## 3️⃣ Setup Steps on Google Cloud & Xcode

1. Go to [Google Cloud Console](https://console.cloud.google.com/) → **Create a Project**  
2. Navigate to **APIs & Services → OAuth consent screen** → configure app name, scopes, email, etc.  
3. Go to **Credentials → Create Credentials → OAuth Client ID** → choose iOS application  
4. Add your **bundle ID**  
5. Copy the **iOS Client ID**  

---

### 3️⃣ Info.plist Setup

```xml
<key>GIDClientID</key>
<string>YOUR_IOS_CLIENT_ID</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>YOUR_DOT_REVERSED_IOS_CLIENT_ID</string>
    </array>
  </dict>
</array>
```
---

<br>

## 4️⃣ AppDelegate Setup

```swift
func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    // Restore previous sign-in if available
    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
        if let user = user {
            print("User already signed in:", user.profile?.name ?? "")
            // Navigate to Home Screen
        } else {
            print("Not signed in yet")
        }
    }
    return true
}

func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
) -> Bool {
    let handled = GIDSignIn.sharedInstance.handle(url)
    return handled
}
```

---

<br>

## 5️⃣ Swift Sample File – Google Login Manager

```swift
import UIKit
import GoogleSignIn

class GoogleLoginManager {
    
    static let shared = GoogleLoginManager()
    
    /// Start Google Login
    func signIn(from vc: UIViewController, completion: @escaping (GIDSignInResult?, String?) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { signInResult, error in
            guard error == nil else {
                completion(nil, "Failed to sign in")
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
```

--- 

<br>

## 6️⃣ Summary

Provides user info: email, name, profile picture
  - Provides ID Token to verify user on backend
  - Does not always provide phone number → ask separately if needed
  - Can be used for both Login and Sign Up flows

Your backend is responsible for:
  - Verifying ID Token with Google servers
  - Creating new user or returning existing user session
  - Sending your app's session token back to the app
  Without backend verification, you only have a Google account object in the app; you cannot securely manage user sessions.

<br><br><br><br>
