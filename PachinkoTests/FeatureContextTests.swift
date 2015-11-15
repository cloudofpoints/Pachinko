//
//  FeatureContextTests.swift
//  Pachinko
//
//  Created by Tim Antrobus on 14/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import XCTest
@testable import Pachinko

class FeatureContextTests: XCTestCase {

    let testContextFixtureId = "com.cloudofpoints.pachinko.context.1"
    let testContextFixtureName = "TestContext"
    let testContextFixtureSynopsis = "Unit test context fixture"
    let testFeatureFixtureId = "001"
    let testFeatureFixtureVersionId = FeatureVersion(major: 1, minor: 0, patch: 0)
    let testFeatureFixtureName = "TestFeature1"
    let testFeatureFixtureSynopsis = "Unit test feature fixture"
    let testFeatureFixtureStatusActive = "Active"
    
    var contextTemplate: NSDictionary?

    override func setUp() {
        super.setUp()
        contextTemplate = defaultsContextFixture()
    }
    
    override func tearDown() {
        contextTemplate = .None
        super.tearDown()
    }
    
    func defaultsContextFixture() -> [String:AnyObject] {
        return [FeaturePlistKey.CONTEXT_ID.rawValue : testContextFixtureId,
            FeaturePlistKey.CONTEXT_NAME.rawValue : testContextFixtureName,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue : testContextFixtureSynopsis,
            FeaturePlistKey.CONTEXT_FEATURES.rawValue : defaultsItemFixture()]
    }
    
    
    func defaultsItemFixture() -> [[String:String]] {
        return [[FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_VERSION_ID.rawValue: testFeatureFixtureVersionId.description(),
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]]
    }

    func testTemplateInitialiser() {
        let testContext = FeatureContext(template: contextTemplate)
        XCTAssertNotNil(testContext, "Test context should not be nil")
        XCTAssertEqual(testContext?.id, testContextFixtureId, "Test context ID should equal expected value")
        if let contextFeatures = testContext?.features {
            XCTAssertFalse(contextFeatures.isEmpty, "Test context features should not be empty")
        } else {
            XCTFail("Test execution should not reach this point")
        }
    }

    func testTemplateOutput() {
        let testContext = FeatureContext(template: contextTemplate)
        XCTAssertNotNil(testContext, "Test context should not be nil")
        let templateOutput = testContext?.plistTemplate()
        XCTAssertNotNil(templateOutput, "Template output should not be nil")
        XCTAssertEqual(templateOutput![FeaturePlistKey.CONTEXT_NAME.rawValue]! as? String, testContextFixtureName, "Template output context name should equal expected value")
        XCTAssertNotNil(templateOutput![FeaturePlistKey.CONTEXT_FEATURES.rawValue]! as? [[String:String]], "Template output context features should not be nil")
    }

}
