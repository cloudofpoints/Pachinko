//
//  ToggleConditionTests.swift
//  Pachinko
//
//  Created by Tim Antrobus on 17/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import XCTest
@testable import Pachinko

class ToggleConditionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSingleConditionTrue() {
        let testProfile = StubUserProfile(firstName: "Basil", surname: "Fawlty", location: .GB, products: [.TV])
        let testCondition = ToggleCondition<StubUserProfile>(subject: testProfile){profile in profile.isTVOnly()}
        XCTAssertTrue(testCondition.evaluate(), "Single condition should evaluate to true")
    }
    
    func testSingleConditionFalse() {
        let testProfile = StubUserProfile(firstName: "Basil", surname: "Fawlty", location: .GB, products: [.Broadband,.TV])
        let testCondition = ToggleCondition<StubUserProfile>(subject: testProfile){profile in profile.isTVOnly()}
        XCTAssertFalse(testCondition.evaluate(), "Single condition should evaluate to false")
    }
    
}
