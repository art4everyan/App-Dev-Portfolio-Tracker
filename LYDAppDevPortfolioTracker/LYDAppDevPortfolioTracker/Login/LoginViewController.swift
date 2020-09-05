//
//  LoginViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 9/5/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var segmentBar: UISegmentedControl!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signinButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupTapped(_ sender: Any) {
    }
    @IBAction func signinTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "LoginSegue", sender: nil)
    }
    @IBAction func guestTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "GuestSegue", sender: nil)
    }

}
