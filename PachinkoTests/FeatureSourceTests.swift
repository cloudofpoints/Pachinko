//
//  FeatureSourceTests.swift
//  FeatureSourceTests
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import XCTest
@testable import Pachinko

class FeatureSourceTests: XCTestCase {
    
    var testFeatureSource: FeatureSource = StubFeatureSource()

    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testActiveFeatureHappyPath() {
        let existingContext = FeatureContext(name: "TestContext1", synopsis: "TestContext1 Features")
        let existingFeatureSignature = FeatureSignature(id: "001", name: "LoginFeature", synopsis: "Test login feature")
        XCTAssertNotNil(testFeatureSource.activeFeature(existingContext, signature: existingFeatureSignature), "Existing feature \(existingFeatureSignature) should not be nil")
    }
    
    func testActiveFeatureInvalidFeature() {
        let existingContext = FeatureContext(name: "TestContext1", synopsis: "TestContext1 Features")
        let invalidFeatureSignature = FeatureSignature(id: "999", name: "InvalidFeature", synopsis: "Invalid test feature")
        XCTAssertNil(testFeatureSource.activeFeature(existingContext, signature: invalidFeatureSignature), "Invalid feature \(invalidFeatureSignature) should be nil")
    }
    
    func testActiveFeatureInvalidContext() {
        let invalidContext = FeatureContext(name: "InvalidContext", synopsis: "InvalidContext Features")
        let existingFeatureSignature = FeatureSignature(id: "001", name: "LoginFeature", synopsis: "Test login feature")
        XCTAssertNil(testFeatureSource.activeFeature(invalidContext, signature: existingFeatureSignature), "Existing feature should be nil for invalid context \(invalidContext)")
    }
    

}
