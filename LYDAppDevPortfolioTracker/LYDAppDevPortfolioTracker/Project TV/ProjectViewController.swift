//
//  ProjectViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import CoreData

class ProjectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    private var isEditPressed: Bool = false
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
    @IBOutlet var save: UIBarButtonItem!
 
    
    
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
            introAndUpdate.layer.cornerRadius = 20
            save.isEnabled = true
            self.save.title = "Edit"
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
            save.isEnabled = true
            introAndUpdate.layer.cornerRadius = 20
            self.save.title = "Save"
            projectName.becomeFirstResponder()
        }
    }
    
    @IBAction func switchToggled(_ sender: UISwitch!) {
        isOn.toggle()
        pinnedSwitch.setOn(isOn, animated: true)
    }

    
    @IBAction func saveTapped(_ sender: Any) {
        if isEditPressed == false && self.save.title == "Save" {
            if let personController = personController, let person = person {
                guard let languages = languages.text, !languages.isEmpty, let name = projectName.text, !name.isEmpty, let github = githubAddress.text, !github.isEmpty else {
                    let alert = UIAlertController(title: "Saving failed", message: "Please fill out all required field", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Back", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true)
                    return
                }
                personController.createProject(person: person, name: name, intro: introAndUpdate.text ?? "", pinned: pinnedSwitch.isOn, languages: languages, github: github)
                dismiss(animated: true, completion: nil)
            }
        } else {
            isEditPressed.toggle()
            if isEditPressed {
                projectName.isUserInteractionEnabled = true
                githubAddress.isUserInteractionEnabled = true
                languages.isUserInteractionEnabled = true
                introAndUpdate.isUserInteractionEnabled = true
                pinnedSwitch.isUserInteractionEnabled = true
                save.title = "Save"
            } else {
                if let personController = personController {
                    guard let languages = languages.text, !languages.isEmpty, let name = projectName.text, !name.isEmpty, let github = githubAddress.text, !github.isEmpty else {
                        let alert = UIAlertController(title: "Saving failed", message: "Please fill out all required field", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Back", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true)
                        return
                    }
                    if let project = project {
                        personController.updateProjects(project: project, name: name, intro: introAndUpdate.text ?? "" , pinned: pinnedSwitch.isOn, languages: languages, github: github)
                    }
                }
                projectName.isUserInteractionEnabled = false
                githubAddress.isUserInteractionEnabled = false
                languages.isUserInteractionEnabled = false
                introAndUpdate.isUserInteractionEnabled = false
                pinnedSwitch.isUserInteractionEnabled = false
                save.title = "Edit"
            }
        }
    }
    @IBAction func goBacktapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
