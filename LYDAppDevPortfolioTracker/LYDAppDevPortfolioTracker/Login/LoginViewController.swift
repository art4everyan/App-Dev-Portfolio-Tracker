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
    }
    @IBAction func guestTapped(_ sender: Any) {
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
