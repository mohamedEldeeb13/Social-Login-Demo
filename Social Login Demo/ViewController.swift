//
//  ViewController.swift
//  Social Login Demo
//
//  Created by Mohamed Abd Elhakam on 23/11/2025.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var googleButton: UIButton!
    
    //MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
       configuration()
    }
}

//MARK: - Configuration -
extension ViewController {
    private func configuration() {
        setUpInitialUI()
    }
    
    private func setUpInitialUI(){
        googleButton.layer.cornerRadius = 10
        googleButton.layer.borderWidth = 1
        googleButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        googleButton.clipsToBounds = true
    }
}
    
//MARK: - Actions -
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

