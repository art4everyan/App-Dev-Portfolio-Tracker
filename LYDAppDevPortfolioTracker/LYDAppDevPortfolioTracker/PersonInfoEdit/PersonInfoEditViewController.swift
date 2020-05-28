//
//  PersonInfoEditViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class PersonInfoEditViewController: UIViewController {
    
    var personController: PersonController?
    var person: Person? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        if let person = person, isViewLoaded {
            name.text = person.name
            github.text = person.github
            introduction.text = person.introduction ?? ""
            name.isUserInteractionEnabled = false
            github.isUserInteractionEnabled = false
            introduction.isUserInteractionEnabled = false
            edit.isEnabled = true
        } else if isViewLoaded {
            name.text = ""
            github.text = ""
            introduction.text = ""
            edit.title = ""
            edit.isEnabled = false
            name.isUserInteractionEnabled = true
            introduction.isUserInteractionEnabled = true
            github.isUserInteractionEnabled = true
            name.becomeFirstResponder()
        }
    }
    
// MARK: - Properties
    @IBOutlet var name: UITextField!
    @IBOutlet var github: UITextField!
    @IBOutlet var introduction: UITextView!
    
    @IBOutlet var edit: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    @IBAction func editTapped(_ sender: Any) {
        name.isUserInteractionEnabled = true
        introduction.isUserInteractionEnabled = true
        github.isUserInteractionEnabled = true
        edit.title = ""
        edit.isEnabled = false
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let personController = personController {
            
            guard let name = name.text, !name.isEmpty, let github = github.text, !github.isEmpty, let intro = introduction.text else {return}
            
            if let person = person {
                
                personController.updatePerson(person: person, name: name, intro: intro, github: github)
            } else {
                personController.createPerson(name: name, github: github, intro: intro)
            }
        }
        //        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
