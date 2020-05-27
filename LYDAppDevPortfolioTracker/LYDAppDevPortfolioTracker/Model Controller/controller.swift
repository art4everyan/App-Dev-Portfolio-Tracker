//
//  controller.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import CoreData

class PersonController {
    
    func updateProjects(project: Project, name: String, intro: String, pinned: Bool, languages: String, github: String){
        project.name = name
        project.introduction = intro
        project.pinned = pinned
        project.languages = languages
        project.github = github
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving project change failed")
        }
    }
    
    func updatePerson(person: Person, name: String, intro: String, github: String) {
        person.name = name
        person.introduction = intro
        person.github = github
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving person change failed")
        }
    }
    
    func deleteProject(project: Project){
        CoreDataStack.shared.mainContext.delete(project)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Delete project failed")
        }
    }
    
}
