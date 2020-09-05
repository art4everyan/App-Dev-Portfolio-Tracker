//
//  controller.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class PersonController {
    
    //var person: Person?
    
    func updateProjects(project: Project, name: String, intro: String?, pinned: Bool, languages: String, github: String){
        
        project.name = name
        project.introduction = intro ?? ""
        project.pinned = pinned
        project.languages = languages
        project.github = github
        
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving project change failed")
        }
    }
    
    func updatePerson(person: Person, name: String, intro: String, github: String, imagePath: String?) {
        
        person.name = name
        person.introduction = intro
        person.github = github
        person.image = imagePath
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving person change failed")
        }
    }
    func createPerson(name: String, github: String, intro: String?, imagePath: String?) {
        
        let person = Person(name: name, github: github, introduction: intro, image: imagePath, username: "", password: "")
        person.image = imagePath
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Creating person error")
        }
    }
    func createProject(person: Person, name: String, intro: String?, pinned: Bool, languages: String, github: String) {
        
        
        let project = Project(name: name, github: github, introduction: intro ?? "", languages: languages, pinned: pinned)
        
        person.addToProjects(project)
        
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Creating project error")
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
