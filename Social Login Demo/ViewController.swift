//
//  ViewController.swift
//  Social Login Demo
//
//  Created by Mohamed Abd Elhakam on 23/11/2025.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController{
    
    //MARK: - IBOutlets -
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    //MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        
        if let token = AccessToken.current, !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
    }
}

//MARK: - Configuration -
extension ViewController {
    private func configuration() {
        setUpInitialUI()
    }
    
    private func setUpInitialUI(){
        let buttons: [UIButton] = [googleButton, appleButton, facebookButton]
        buttons.forEach { button in
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
            button.clipsToBounds = true
        }
    }
}

//MARK: - Google Action -
extension ViewController {
    @IBAction func googleButtonAction(_ sender: Any) {
        
        GoogleLoginManager.shared.signIn(from: self) { signInResult, error in
            guard error == nil else { return }
            let user = signInResult?.user
            
            print(user?.userID ?? "No ID")
            print(user?.profile?.name ?? "No Name")
            print(user?.profile?.email ?? "No Email")
            print(user?.profile?.familyName ?? "No family Name")
        }
    }
}

//MARK: - Apple Action -
extension ViewController {
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

//MARK: - Apple Delegate functions -
extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding  {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredintial = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("User Apple ID: \(appleIdCredintial.user)")
            print("User Apple Name: \(appleIdCredintial.fullName)")
            print("User Apple Email: \(appleIdCredintial.email ?? "No Email")")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple failed:", error.localizedDescription)
    }
}

//MARK: - Facebook Action -
extension ViewController {
    @IBAction func facebookButtonAction(_ sender: Any) {
        
        let loginManager = LoginManager()
        guard let configuration = LoginConfiguration(permissions: ["public_profile", "email"], tracking: .limited) else {return}
        
        loginManager.logIn(configuration: configuration) { result in
            switch result {
            case .cancelled, .failed:
                return
            case .success:
                print(Profile.current?.userID ?? "No User ID")
                print(Profile.current?.name ?? "No name")
                print(Profile.current?.lastName ?? "No last name")
                print(Profile.current?.firstName ?? "No first name")
                print(Profile.current?.imageURL ?? "No image url")
            }
        }
    }
}
