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


# 🍏 Apple Sign-In Integration on iOS

Apple Sign-In allows users to **sign in or register** in your app using their Apple ID.  
It provides basic user information like **email, full name**, and a **unique user identifier (`userId`)** to verify the user on your backend.

---

## 1️⃣ What is Apple Sign-In & How It Works

Apple Sign-In is an **OAuth 2.0 authentication system** that lets users sign in **without creating a separate password** for your app.  
Your backend can use the **userId** or **identity token** received from Apple to authenticate the user.  

- Can be used for **Sign Up** (new user) or **Login** (existing user)  
- Provides **email and full name** (first time only; later sign-ins may not return name/email)  
- Does **not provide phone number** → ask user separately if needed  

> If your app requires data not provided by Apple, you must ask the user to fill it after signing in.

---

<br>

## 2️⃣ Requirements

- iOS 13+  
- Xcode 13+  
- Apple Developer Account  
- Sign in with Apple enabled for your app  
- Real device for testing (Simulator can show button but requires real device for full login)  

---

<br>

## 3️⃣ Setup Steps in Xcode

1. Open your project → select your Target  
2. Go to **Signing & Capabilities** → click **+ Capability** → add **Sign in with Apple**  
3. Make sure your **Apple Developer account** is connected and Apple ID is active  
4. Backend should store the `userId` for returning users  

---

<br>

## 4️⃣ Swift Sample File – Apple Sign-In Manager / ViewController

```swift
import UIKit
import AuthenticationServices

class LoginVC: UIViewController {
@IBOutlet weak var appleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Apple Action -
extension LoginVC {
    @IBAction func AppleButtonAction(_ sender: Any) {
        
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate & PresentationContextProviding
extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // Provide window for the Apple Sign-In popup
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    // Called when user successfully signs in
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIdCredential.user // Unique Apple ID for this app
            let fullName = appleIdCredential.fullName // User's full name
            let email = appleIdCredential.email ?? "No Email" // User email
            
            print("User Apple ID:", userId)
            print("User Name:", fullName ?? "No Name")
            print("User Email:", email)
            
            // ✅ Send userId or identityToken to backend
            // Backend stores userId to recognize returning users
        }
    }
    
    // Called when Sign in with Apple fails
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple failed:", error.localizedDescription)
    }
}
```

<br>

## 5️⃣ Summary 
Provides user info: userId, full name, email
  - Does not provide phone number → ask separately if needed
  - Can be used for both Login and Sign Up flows

Your backend is responsible for:
  - Storing userId to recognize returning users
  - Optionally verifying identity token with Apple servers
  - Creating new user or returning existing user session
  - Sending your app's session token back to the app

  Without backend verification, you only have an Apple account object in the app; you cannot securely manage user sessions.

<br><br><br><br>



