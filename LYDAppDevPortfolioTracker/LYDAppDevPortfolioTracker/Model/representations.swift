//
//  representations.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation

struct PersonRep: Codable {
    var uuid: String?
    var name: String
    var github: String
}

struct ProjectRep: Codable {
    var name: String
    var uuid: String?
    var id: String
    var introduction: String?
    var languages: String
    var pinned: Bool
    var github: String
}
