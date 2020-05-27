//
//  ProjectViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    
    var personController: PersonController?
    var project: Project? {
        didSet {
            
        }
    }
    
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
    }
    
    func updateViews() {
        if let project = project {
            languages.text = project.languages
            languages.isUserInteractionEnabled = false
            projectName.text = project.name
            projectName.isUserInteractionEnabled = false
            githubAddress.text = project.github
            githubAddress.isUserInteractionEnabled = false
            introAndUpdate.text = project.introduction ?? ""
            introAndUpdate.isUserInteractionEnabled = false
            edit.isEnabled = true
            
        } else {
            languages.text = ""
            languages.isUserInteractionEnabled = true
            projectName.text = ""
            projectName.isUserInteractionEnabled = true
            githubAddress.text = ""
            githubAddress.isUserInteractionEnabled = true
            introAndUpdate.text = ""
            introAndUpdate.isUserInteractionEnabled = true
            edit.isEnabled = false
            projectName.becomeFirstResponder()
        }
    }
    @IBAction func editTapped(_ sender: Any) {
        languages.isUserInteractionEnabled = true
        projectName.isUserInteractionEnabled = true
        githubAddress.isUserInteractionEnabled = true
        introAndUpdate.isUserInteractionEnabled = true
    }
    @IBAction func saveTapped(_ sender: Any) {
    }
    @IBAction func addTapped(_ sender: Any) {
    }
    
}
