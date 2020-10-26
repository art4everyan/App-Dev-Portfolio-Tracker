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
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PersonController {
    
    //MARK: -Update
    
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
    
    func updatePerson(person: Person, name: String, intro: String, github: String) {
        
        guard userDefault.string(forKey: "token") == nil else { return }
        person.name = name
        person.introduction = intro
        person.github = github
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving person change failed")
        }
    }
    
    func updatePersonFirebase(person: Person, name: String, intro: String, github: String, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let uuid = userDefault.string(forKey: "token"), !uuid.isEmpty else { completion(false); return }
        
        deletePersonFromFirebase()
        
        person.name = name
        person.introduction = intro
        person.github = github
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving person change failed")
        }
        
        guard let representation = person.personRepresentation else { return }
        uploadPerson(rep: representation, uuid: uuid) { (url) in
            guard url != nil else { completion(false); return }
            DispatchQueue.main.async {
                completion(true)
            }
        }
       
    }
    func updateProjectFirebase(project: Project, name: String, intro: String?, pinned: Bool, languages: String, github: String, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let uuid = userDefault.string(forKey: "token"), !uuid.isEmpty else { completion(false); return }
        
        deleteProjectFromFirebase(projectUUID: project.uuid!)
        
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
        guard let representation = project.projectRepresentation else { return }
        uploadProject(rep: representation, uuid: uuid) { (url) in
            guard url != nil else { completion(false); return }
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    //MARK: - Creation
    func createPersonFirebase(name: String, github: String, intro: String?, uuid: String?, completion: @escaping (Bool) -> Void = { _ in }) {
        
        guard let uuid = userDefault.string(forKey: "token"), !uuid.isEmpty else { completion(false); return }
        
        let person = Person(uuid: uuid, name: name, github: github, introduction: intro)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Creating person error")
        }
        guard let representation = person.personRepresentation else { return }
        uploadPerson(rep: representation, uuid: uuid) { (url) in
            guard url != nil else { completion(false); return }
            NSLog("creating person succeed")
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    func createPerson(name: String, github: String, intro: String?, uuid: String?) {
        guard userDefault.string(forKey: "token") == "" else { return }
        guard let uuid = userDefault.string(forKey: "token") else { return }
        _ = Person(uuid: uuid, name: name, github: github, introduction: intro)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Creating person error")
        }
        
    }
    func createProject(person: Person, name: String, intro: String?, pinned: Bool, languages: String, github: String) {
        guard userDefault.string(forKey: "token") == "" else {return}
        let uuid = UUID().uuidString
        let project = Project(name: name, github: github, introduction: intro ?? "", languages: languages, pinned: pinned, uuid: uuid)
        
        person.addToProjects(project)
                
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Creating project error")
        }
    }
    func createProjectFirebase(person: Person, name: String, intro: String?, pinned: Bool, languages: String, github: String, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let uuid = userDefault.string(forKey: "token"), !uuid.isEmpty else { completion(false); return }
        let projectUUID = UUID().uuidString
        let project = Project(name: name, github: github, introduction: intro, languages: languages, pinned: pinned, uuid: projectUUID)
        
        person.addToProjects(project)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Creating project error")
        }
        guard let representation = project.projectRepresentation else { return }
        uploadProject(rep: representation, uuid: uuid) { (url) in
            guard url != nil else { completion(false); return }
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    //MARK: -Deletion
    func deleteProject(project: Project){
        
        if userDefault.string(forKey: "token") != "" {
            deleteProjectFromFirebase(projectUUID: project.uuid!)
        }
        CoreDataStack.shared.mainContext.delete(project)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Delete project failed")
        }
    }
    
    //MARK: - Firebase Storage
    
    let storageRef = Storage.storage().reference()
    
    private func deletePersonFromFirebase() {
        guard let uuid = userDefault.string(forKey: "token"), !uuid.isEmpty else { return }
        let personRef = storageRef.child(uuid).child("Info.json")
        
        personRef.delete { (error) in
            if let error = error {
                NSLog("Error Deleting Person File for Update: \(error)")
            } else {
                NSLog("Deletion before update success")
            }
        }
    }
    private func deleteProjectFromFirebase(projectUUID: String) {
        guard let uuid = userDefault.string(forKey: "token"), !uuid.isEmpty else { return }
        let projectRef = storageRef.child(uuid).child(projectUUID)
        
        projectRef.delete { (error) in
            if let error = error {
                NSLog("Error Deleting Project File for Update: \(error)")
            } else {
                NSLog("Deletion of project success")
            }
        }
    }
    
    private func uploadProject(rep: ProjectRepresentation, uuid: String, completion: @escaping (URL?) -> Void) {
        var data: Data?
        do {
            data = try JSONEncoder().encode(rep)
        } catch {
            NSLog("Data Encoding for project failed")
        }
        
        let projectRef = storageRef.child(uuid).child(rep.uuid) //uuid = user uuid, rep.uuid = project uuid
        guard let dataNonNil = data else { return }
        
        let uploadTask = projectRef.putData(dataNonNil, metadata: nil) {(metadata, error) in
            if let error = error {
                NSLog("Error storing project data: \(error)")
                completion(nil)
                return
            }
            if metadata == nil {
                NSLog("No metadata returned from uploading project.")
                completion(nil)
                return
            }
            projectRef.downloadURL { (url, error) in
                if let error = error {
                    NSLog("Error getting download url of project: \(error)")
                }
                
                guard let url = url else {
                    NSLog("Download url is nil. Unable to create a project object")
                    
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
        uploadTask.resume()
    }
    
    private func uploadPerson(rep: PersonRepresentation, uuid: String, completion: @escaping (URL?) -> Void) {
        var data: Data?
        do {
            data = try JSONEncoder().encode(rep)
            
        } catch {
            NSLog("Data Encoding for person failed")
        }
        let personRef = storageRef.child(uuid).child("Info.json")
        guard let dataNonNil = data else { return }
        let uploadTask = personRef.putData(dataNonNil, metadata: nil) { (metadata, error) in
            if let error = error {
                NSLog("Error storing person data: \(error)")
                completion(nil)
                return
            }
            
            if metadata == nil {
                NSLog("No metadata returned from uploading person.")
                completion(nil)
                return
            }
            personRef.downloadURL { (url, error) in
                if let error = error {
                    NSLog("Error getting download url of person: \(error)")
                }
                
                guard let url = url else {
                    NSLog("Download url is nil. Unable to create a person object")
                    
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
        uploadTask.resume()
    }
    
    func fetchPerson(uuid: String, completion: @escaping (Result<Person, Error>) -> Void) {
        
        let personRef = storageRef.child(uuid).child("Info.json")
        personRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                NSLog("Error when fetching user: \(error)")
                completion(.failure(error))
            }
            
            guard data != nil else {
                NSLog("Person data nil")
                return
            }
            
            if let data = data {
                do {
                    let personRep = try JSONDecoder().decode(PersonRepresentation.self, from: data)
                    if let person = Person(representation: personRep) {
                        try CoreDataStack.shared.save()
                        DispatchQueue.main.async {
                            completion(.success(person))
                        }
                    }
                } catch {
                    NSLog("Fetching person failed on decode")
                }
            }
            
        }.resume()
        
        
    }
}
