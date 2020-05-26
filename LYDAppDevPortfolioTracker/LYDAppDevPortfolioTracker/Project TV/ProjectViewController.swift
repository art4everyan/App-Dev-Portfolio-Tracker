//
//  ProjectViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {

    
// MARK: - Properties
    
    @IBOutlet var languages: UITextField!
    @IBOutlet var projectName: UITextField!
    @IBOutlet var githubAddress: UITextField!
    @IBOutlet var pinnedSwitch: UISwitch!
    @IBOutlet var introAndUpdate: UITextView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var edit: UIBarButtonItem!
    @IBOutlet var save: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func editTapped(_ sender: Any) {
    }
    @IBAction func saveTapped(_ sender: Any) {
    }
    @IBAction func addTapped(_ sender: Any) {
    }
    
}
