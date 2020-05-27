//
//  ProjectsTableViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import CoreData

class ProjectsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var personController = PersonController()
    
    var fetchedResultsController: NSFetchedResultsController<Person> {
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
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.first?.projects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllProjectCell", for: indexPath)
        
        let projects = Array(fetchedResultsController.fetchedObjects?.first?.projects ?? [])
        let project = projects[indexPath.row]
        cell.textLabel?.text = (project as! Project).name ?? ""
        cell.detailTextLabel?.text = (project as! Project).languages ?? ""
        
        return cell
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AddSegue":
            guard let addVC = segue.destination as? ProjectViewController else {return}
            addVC.person = fetchedResultsController.fetchedObjects?.first
            addVC.personController = personController
            
        case "ShowSegue":
            guard let showVC = segue.destination as? ProjectViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            showVC.person = fetchedResultsController.fetchedObjects?.first
            showVC.personController = personController
            let projects = Array(fetchedResultsController.fetchedObjects?.first?.projects ?? [])
            let project = projects[indexPath.row]
            showVC.project = (project as! Project)
            
            
        default:
            break
        }
    }
    

}

extension ProjectsTableViewController :NSFetchedResultsControllerDelegate {
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
            guard let indexPath = indexPath else { return }
            tableView.insertRows(at: [indexPath], with: .automatic)
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
