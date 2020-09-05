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
    
    //@NSManaged var projects: [Project]?
    
    @discardableResult convenience init(uuid: UUID = UUID(), name: String, github: String, introduction:String?, image: String? = "", username: String? = "", password: String? = "", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.uuid = uuid
        self.name = name
        self.introduction = introduction
        self.github = github
        self.image = image
        self.username = username
        self.password = password
    }
}

//UIImage(imageLiteralResourceName: "default")

extension Project {
    
    
    @discardableResult convenience init(name: String, github: String, introduction: String, languages: String, pinned: Bool, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)

        self.name = name
        self.introduction = introduction
        self.languages = languages
        self.pinned = pinned
        self.github = github
    }
}
