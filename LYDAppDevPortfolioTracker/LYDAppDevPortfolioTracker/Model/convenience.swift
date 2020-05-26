//
//  convenience.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import CoreData

extension Person {
    
    var personRep: PersonRep? {
        guard let uuid = uuid, let name = name, let github = github else {
            return nil
        }
        return PersonRep(uuid: uuid.uuidString, name: name, github: github)
    }
    
    @discardableResult convenience init?(personRep: PersonRep, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        self.init(uuid: UUID(uuidString: personRep.uuid!) ?? UUID(), name: personRep.name, github: personRep.github, context: context)
        self.init(context: context)
        self.uuid = UUID(uuidString: personRep.uuid!) ?? UUID()
        self.name = personRep.name
        self.github = personRep.github
    }
    
    @discardableResult convenience init(uuid: UUID, name: String, github: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.uuid = uuid
        self.name = name
        self.github = github
    }
}

extension Project {
    
    var projectRep: ProjectRep?{
        guard let name = name, let uuid = uuid, let id = id, let introduction = introduction, let languages = languages, let github = github else {
            return nil
        }
        
        return ProjectRep(name: name, uuid: uuid.uuidString, id: id, introduction: introduction, languages: languages, pinned: pinned, github: github)
    }
    
    @discardableResult convenience init?(projectRep: ProjectRep, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        self.init(context: context, name: projectRep.name, uuid: UUID(uuidString: projectRep.uuid!) ?? UUID())
        self.init(context: context)
        self.uuid = UUID(uuidString: projectRep.uuid!) ?? UUID()
        self.id = projectRep.id
        self.name = projectRep.name
        self.introduction = projectRep.introduction
        self.pinned = projectRep.pinned
        self.github = projectRep.github
        self.languages = projectRep.languages
    }
    
    @discardableResult convenience init(uuid: UUID, name: String, github: String, id: String, introduction: String, languages: String, pinned: Bool, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.uuid = uuid
        self.id = id
        self.name = name
        self.introduction = introduction
        self.languages = languages
        self.pinned = pinned
        self.github = github
    }
}
