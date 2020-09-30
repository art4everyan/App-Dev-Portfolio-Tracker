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
    @IBOutlet var introLabel: UILabel!
    @IBOutlet var pinnedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        self.view.backgroundColor = UIColor(displayP3Red: 0.737, green: 0.722, blue: 0.694, alpha: 1)
        self.pinnedLabel.textColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1)
        self.introLabel.textColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1)
        
        self.introAndUpdate.layer.cornerRadius = 10
        self.introAndUpdate.layer.borderWidth = 2
        self.introAndUpdate.layer.borderColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1)
        self.introAndUpdate.backgroundColor = UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 0.4)
        self.introAndUpdate.textColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        
        self.projectName.backgroundColor = UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 0.5)
        self.projectName.layer.cornerRadius = 5
        self.projectName.layer.borderWidth = 2
        self.projectName.layer.borderColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
            
        self.githubAddress.backgroundColor = UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 0.5)
        self.githubAddress.layer.cornerRadius = 5
        self.githubAddress.layer.borderWidth = 2
        self.githubAddress.layer.borderColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        
        self.languages.backgroundColor = UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 0.5)
        self.languages.layer.cornerRadius = 5
        self.languages.layer.borderWidth = 2
        self.languages.layer.borderColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        
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
