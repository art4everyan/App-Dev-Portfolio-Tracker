//
//  ProfileTest.swift
//  LYDAppDevPortfolioTrackerTests
//
//  Created by Lydia Zhang on 9/23/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import XCTest
@testable import LYDAppDevPortfolioTracker

class ProfileTest: XCTestCase {

    let mainPage = PersonInfoViewController()
    let projectPage = ProjectsTableViewController()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPinned() {
        
        let numberOfPinnedInMain = mainPage.tableView.visibleCells.count
        let projects = projectPage.fetchProjectController.fetchedObjects ?? []
        let pinned: [Project] = projects.filter{$0.pinned == true}
        
        XCTAssertEqual(numberOfPinnedInMain, pinned.count)
    }
}
