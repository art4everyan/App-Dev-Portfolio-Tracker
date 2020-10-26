//
//  PersonInfoViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import CoreData

class PersonInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var personController = PersonController()
    var person: NSFetchedResultsController<Person>?
    lazy var fetchProjectController: NSFetchedResultsController<Project> = {
        
            let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pinned", ascending: true)]
            fetchRequest.predicate = NSPredicate(format: "pinned == TRUE")
            let context = CoreDataStack.shared.mainContext
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                 managedObjectContext: context,
                                                 sectionNameKeyPath: nil,
                                                 cacheName: nil)
            frc.delegate = self
            do {
                try frc.performFetch()
            } catch {
                NSLog("Error doing frc fetch")
            }
            return frc
        
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchProjectController.sections?[section].numberOfObjects ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinnedCell", for: indexPath)
        cell.backgroundColor = UIColor(displayP3Red: 0.737, green: 0.722, blue: 0.694, alpha: 1)
        
        if let projects = fetchProjectController.fetchedObjects {
            let project = projects[indexPath.row]
            cell.textLabel?.text = project.name
            cell.textLabel?.textColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
            cell.detailTextLabel?.text = project.languages
            cell.detailTextLabel?.textColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
            return cell
        } else {
            return UITableViewCell()
        }

    }
    
// MARK: - Properties
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var gitLabel: UILabel!
    @IBOutlet var introTextField: UITextView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var projectsLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 0.737, green: 0.722, blue: 0.694, alpha: 1)
        self.tableView.backgroundColor = UIColor(displayP3Red: 0.737, green: 0.722, blue: 0.694, alpha: 1)
        self.introTextField.backgroundColor = UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 0.4)
        self.introTextField.layer.cornerRadius = 8
        self.introTextField.layer.borderWidth = 2.0
        self.introTextField.layer.borderColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        self.introTextField.textColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        self.nameLabel.textColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        self.gitLabel.textColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        self.projectsLabel.textColor = UIColor(displayP3Red: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let uuid = userDefault.string(forKey: "token")
        if uuid != "" {
            personController.fetchPerson(uuid: uuid!) { (person) in
                do{
                    _ = try person.get()
                    self.person = {
                        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
                        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                        let context = CoreDataStack.shared.mainContext
                        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
                        frc.delegate = self
                        do {
                            try frc.performFetch()
                        } catch {
                            NSLog("Error doing frc fetch")
                        }
                        return frc
                    } ()
                    self.nameLabel.text = self.person?.fetchedObjects?.first?.name ?? ""
                    self.gitLabel.text = self.person?.fetchedObjects?.first?.github ?? ""
                    self.introTextField.text = self.person?.fetchedObjects?.first?.introduction ?? ""
                } catch {
                    NSLog("\(error)")
                }
            }
        }
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard person != nil else {
            performSegue(withIdentifier: "SettingSegue", sender: self)
            return
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SettingSegue":
            guard let settingVC = segue.destination as? PersonInfoEditViewController else {return}
            settingVC.personController = personController
            if let person = person {
                settingVC.person = person.fetchedObjects?.first
            }
            
        case "PinnedProjectSegue":
            guard let pinnedVC = segue.destination as? ProjectViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            if let projects = fetchProjectController.fetchedObjects {
    
                pinnedVC.project = projects[indexPath.row]
            }
            pinnedVC.person = person?.fetchedObjects?.first
            pinnedVC.personController = personController
        default:
            break
        }
    }
}

extension PersonInfoViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
