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
    let testContextFixtureName = "TestContext"
    let testContextFixtureSynopsis = "Unit test context fixture"
    let testFeatureFixtureId = "001"
    let testFeatureFixtureName = "TestFeature1"
    let testFeatureFixtureSynopsis = "Unit test feature fixture"
    let testFeatureFixtureStatusActive = "Active"
    let testFeatureFixtureStatusInctive = "Inactive"
    let testFeatureFixtureStatusInitialised = "Initialised"
    
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
    
    func testFeatureContextFromPListItem() {
        let stubPListItem = [FeaturePlistKey.CONTEXT_NAME.rawValue : testContextFixtureName,
                            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue : testContextFixtureSynopsis]
        let context: FeatureContext? = testFeatureSource.featureContextFromPlistItem(stubPListItem)
        XCTAssertNotNil(context, "FeatureContext should not be nil")
        XCTAssertEqual(context?.name, testContextFixtureName)
        XCTAssertEqual(context?.synopsis, testContextFixtureSynopsis)
    }
    
    func testFeatureContextFromPListItemIncorrectKey() {
        let stubPListItem = ["SomeRandomKey" : testContextFixtureName,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue : testContextFixtureSynopsis]
        let context: FeatureContext? = testFeatureSource.featureContextFromPlistItem(stubPListItem)
        XCTAssertNil(context, "An invalid key should result in a nil feature context")
    }
    
    func testFeatureContextFromPListItemMissingKey() {
        let stubPListItem = ["SomeRandomKey" : testContextFixtureName]
        let context: FeatureContext? = testFeatureSource.featureContextFromPlistItem(stubPListItem)
        XCTAssertNil(context, "A missing key should result in a nil feature context")
    }
    
    func testFeatureContextFromPListItemEmptyDictionary() {
        let stubPListItem: [String:String] = [:]
        let context: FeatureContext? = testFeatureSource.featureContextFromPlistItem(stubPListItem)
        XCTAssertNil(context, "An empty item dictionary should result in a nil feature context")
    }
    
    func testFeatureFromPListItem(){
        let stubPListItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
                            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
                            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
                            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let expectedFeatureSignature = FeatureSignature(id: testFeatureFixtureId,
        name: testFeatureFixtureName, synopsis: testFeatureFixtureSynopsis)
        let feature: ConditionalFeature? = testFeatureSource.featureFromPlistItem(stubPListItem)
        XCTAssertNotNil(feature, "Feature should not be nil")
        XCTAssertEqual(feature?.signature, expectedFeatureSignature)
        XCTAssertEqual(feature?.status, FeatureStatus.Active)
    }
    
    func testFeatureFromPListItemIncorrectKey(){
        let stubPListItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            "SomeRandomKey" : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let feature: ConditionalFeature? = testFeatureSource.featureFromPlistItem(stubPListItem)
        XCTAssertNil(feature, "An invalid key should result in a nil feature")
    }
    
    func testFeatureFromPListItemMissingKey(){
        let stubPListItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let feature: ConditionalFeature? = testFeatureSource.featureFromPlistItem(stubPListItem)
        XCTAssertNil(feature, "An missing key should result in a nil feature")
    }
    
    func testFeatureFromPListItemIncorrectStatusRawValue(){
        let stubPListItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : "Invalid"]
        let feature: ConditionalFeature? = testFeatureSource.featureFromPlistItem(stubPListItem)
        XCTAssertNil(feature, "An invalid status raw value should result in a nil feature")
    }
    
    func testBindFeaturesFromPlistTestTargetBundle() {
        let testBundle = NSBundle(forClass: FeatureSourceTests.self)
        let featuresDict = testFeatureSource.bindFeaturesFromPList(featureBundle: testBundle)
        XCTAssertNotNil(featuresDict, "Features dictionary should not be nil")
        XCTAssertTrue(featuresDict?.keys.count == 2)
    }
}
