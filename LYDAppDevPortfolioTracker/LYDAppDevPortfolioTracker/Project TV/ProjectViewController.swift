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
           updateViews()
        }
    }
    var person: Person?
    var isOn: Bool = false
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
        updateViews()
    }
    
    func updateViews() {
        if let project = project, isViewLoaded {
            languages.text = project.languages
            languages.isUserInteractionEnabled = false
            projectName.text = project.name
            projectName.isUserInteractionEnabled = false
            githubAddress.text = project.github
            githubAddress.isUserInteractionEnabled = false
            introAndUpdate.text = project.introduction ?? ""
            introAndUpdate.isUserInteractionEnabled = false
            pinnedSwitch.isOn = project.pinned
            pinnedSwitch.isUserInteractionEnabled = false
            
            edit.isEnabled = true
            
        } else if isViewLoaded {
            languages.text = ""
            languages.isUserInteractionEnabled = true
            projectName.text = ""
            projectName.isUserInteractionEnabled = true
            githubAddress.text = ""
            githubAddress.isUserInteractionEnabled = true
            introAndUpdate.text = ""
            introAndUpdate.isUserInteractionEnabled = true
            pinnedSwitch.isUserInteractionEnabled = true
            edit.isEnabled = false
            edit.title = ""
            projectName.becomeFirstResponder()
        }
    }
    
    @IBAction func switchToggled(_ sender: UISwitch!) {
        isOn.toggle()
        pinnedSwitch.setOn(isOn, animated: true)
    }
    @IBAction func editTapped(_ sender: Any) {
        languages.isUserInteractionEnabled = true
        projectName.isUserInteractionEnabled = true
        githubAddress.isUserInteractionEnabled = true
        introAndUpdate.isUserInteractionEnabled = true
        pinnedSwitch.isUserInteractionEnabled = true
        edit.isEnabled = false
        edit.title = ""
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let personController = personController, let person = person {
            guard let languages = languages.text, !languages.isEmpty, let name = projectName.text, !name.isEmpty, let github = githubAddress.text, !github.isEmpty else {return}
            if let project = project {
                personController.updateProjects(project: project, name: name, intro: introAndUpdate.text ?? "" , pinned: isOn, languages: languages, github: github)
                
            } else {
                personController.createProject(person: person, name: name, intro: introAndUpdate.text ?? "", pinned: pinnedSwitch.isOn, languages: languages, github: github)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
    }
    
}
