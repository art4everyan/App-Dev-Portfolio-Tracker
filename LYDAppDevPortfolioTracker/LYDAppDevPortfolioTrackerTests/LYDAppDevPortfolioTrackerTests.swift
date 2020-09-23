//
//  LYDAppDevPortfolioTrackerTests.swift
//  LYDAppDevPortfolioTrackerTests
//
//  Created by Lydia Zhang on 9/23/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import XCTest
@testable import LYDAppDevPortfolioTracker


class LYDAppDevPortfolioTrackerTests: XCTestCase {

    let personInfoPage = PersonInfoEditViewController()
    let mainPage = PersonInfoViewController()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testName() {
        guard let name = personInfoPage.person else { return }
        guard let mainName = mainPage.person else { return }
        
        XCTAssertEqual(name, mainName)
    }

    func testGithub() {
        guard let github = personInfoPage.person?.github else { return }
        guard let mainGithub = mainPage.person?.github else { return }
        
        XCTAssertEqual(github, mainGithub)
    }
    
    func testImage() {
        guard let image = personInfoPage.person?.image else { return }
        guard let mainImage = mainPage.person?.image else { return }
        
        XCTAssertEqual(image, mainImage)
    }
    
    func testIntro() {
        guard let intro = personInfoPage.person?.introduction else { return }
        guard let mainIntro = mainPage.person?.introduction else { return }
        
        XCTAssertEqual(intro, mainIntro)
    }
    
    
}
