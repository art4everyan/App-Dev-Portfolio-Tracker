//
//  SignInViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 10/5/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        setUpSignInButton()
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Error signing in with Google: \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credntial = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credntial) { (authResult, error) in
            if let error = error {
                print("Error signing in with Google: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                let signSB = UIStoryboard(name: "Sign", bundle: nil)
                let mainsNavigationController = signSB.instantiateViewController(identifier: "MainSB")
                mainsNavigationController.modalPresentationStyle = .fullScreen
                self.present(mainsNavigationController, animated: true, completion: nil)
            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User disconnected")
    }
    
    func setUpSignInButton() {
        
        let button = GIDSignInButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        
        let buttonCenterXConstraint = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let buttonCenterYConstraint = button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let buttonWidthConstraint = button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        
        view.addConstraints([buttonCenterXConstraint,
                             buttonCenterYConstraint,
                             buttonWidthConstraint])
    }
    
}
