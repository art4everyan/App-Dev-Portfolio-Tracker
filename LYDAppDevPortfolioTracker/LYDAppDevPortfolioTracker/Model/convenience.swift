//
//  convenience.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Person {
   
    var personRepresentation: PersonRepresentation? {
        guard let uuid = uuid,
            let github = github,
            let name = name else {return nil}
        return PersonRepresentation(uuid: uuid,
                                    github: github,
                                    name: name,
                                    introduction: introduction)
    }
    
    @discardableResult convenience init(uuid: String?,
                                        name: String,
                                        github: String,
                                        introduction:String?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.uuid = uuid
        self.name = name
        self.introduction = introduction
        self.github = github
    }
    
    @discardableResult convenience init?(representation: PersonRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(uuid: representation.uuid,
                  name: representation.name,
                  github: representation.github,
                  introduction: representation.introduction,
                  context: context)
        
    }
}
extension Project {
    
    var projectRepresentation: ProjectRepresentation? {
        guard let name = name, let github = github, let language = languages, let uuid = uuid else { return nil }
        return ProjectRepresentation(name: name, github: github, introduction: introduction, languages: language, pinned: pinned, uuid: uuid)
    }
    
    @discardableResult convenience init(name: String, github: String, introduction: String?, languages: String, pinned: Bool, uuid: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.introduction = introduction
        self.languages = languages
        self.pinned = pinned
        self.github = github
        self.uuid = uuid
    }
    
    @discardableResult convenience init?(representation: ProjectRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(name: representation.name,
                  github: representation.github,
                  introduction: representation.introduction,
                  languages: representation.languages,
                  pinned: representation.pinned,
                  uuid: representation.uuid,
                  context: context)
    }
}
