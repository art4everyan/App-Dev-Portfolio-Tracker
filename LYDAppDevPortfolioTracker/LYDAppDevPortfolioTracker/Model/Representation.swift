//
//  Representation.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 9/5/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
struct PersonRepresentation: Codable {
    var uuid: UUID
    var username: String
    var password: String
    var github: String
    var name: String
    var introduction:String?
    var image: String?
}

struct ProjectPepresentation: Codable {
    var name: String
    var github: String
    var introduction: String?
    var languages: String
    var pinned: Bool
}
