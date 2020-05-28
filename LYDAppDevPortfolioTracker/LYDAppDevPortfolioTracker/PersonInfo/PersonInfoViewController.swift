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
    var fetchedResultsController: NSFetchedResultsController<Person>?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let projects = fetchedResultsController?.fetchedObjects?.first?.projects ?? []
        let allProject: [Project] = projects.allObjects as! [Project]
        let filtered = allProject.filter({$0.pinned == true})
            
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinnedCell", for: indexPath)
        if let projects = fetchedResultsController?.fetchedObjects?.first?.projects {
            let allProject: [Project] = projects.allObjects as! [Project]
            let filtered = allProject.filter({$0.pinned == true})

            if filtered.count > 0 {
                let project = filtered[indexPath.row]
                cell.textLabel?.text = project.name
                cell.detailTextLabel?.text = project.languages
            }
        } else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
// MARK: - Properties
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var gitLabel: UILabel!
    @IBOutlet var introTextField: UITextView!
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            self.fetchedResultsController = {
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
        
        if let person = fetchedResultsController?.fetchedObjects?.first {
            
            nameLabel.text = person.name
            gitLabel.text = person.github
            introTextField.text = person.introduction ?? ""
            
        } else {
            performSegue(withIdentifier: "SettingSegue", sender: self)
        }
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SettingSegue":
            guard let settingVC = segue.destination as? PersonInfoEditViewController else {return}
            settingVC.personController = personController
            if let person = fetchedResultsController?.fetchedObjects?.first {
                settingVC.person = person
            }
            
        case "PinnedProjectSegue":
            guard let pinnedVC = segue.destination as? ProjectViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            if let projects = fetchedResultsController?.fetchedObjects?.first?.projects {
                let allProject: [Project] = projects.allObjects as! [Project]
                let filtered = allProject.filter({$0.pinned == true})
                
                pinnedVC.project = filtered[indexPath.row]
            }
            pinnedVC.person = fetchedResultsController?.fetchedObjects?.first
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
