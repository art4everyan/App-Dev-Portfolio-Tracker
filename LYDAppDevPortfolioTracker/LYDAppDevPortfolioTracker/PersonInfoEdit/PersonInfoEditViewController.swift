//
//  PersonInfoEditViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

class PersonInfoEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinnedCellEdit", for: indexPath)
        if let person = person {
            guard let project = person.projects?[indexPath.row] else {
                cell.detailTextLabel?.text = ""
                cell.textLabel?.text = ""
                return cell
            }
            cell.textLabel?.text = project.name
            cell.detailTextLabel?.text = project.languages
        } else {
            cell.detailTextLabel?.text = ""
            cell.textLabel?.text = ""
            return cell
        }
        return cell
    }
    
    
// MARK: - Properties
    @IBOutlet var name: UITextField!
    @IBOutlet var github: UITextField!
    @IBOutlet var introduction: UITextView!
    
    @IBOutlet var save: UIBarButtonItem!
    @IBOutlet var edit: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        updateViews()
    }
    @IBAction func editTapped(_ sender: Any) {
        name.isUserInteractionEnabled = true
        introduction.isUserInteractionEnabled = true
        github.isUserInteractionEnabled = true
        
        if let personController = personController {
            guard let name = name.text, !name.isEmpty, let github = github.text, !github.isEmpty, let intro = introduction.text else {return}
            personController.updatePerson(name: name, intro: intro, github: github)
        }
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {

        if let personController = personController {
            guard let name = name.text, !name.isEmpty, let github = github.text, !github.isEmpty, let intro = introduction.text else {return}
            personController.createPerson(name: name, github: github, intro: intro)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
