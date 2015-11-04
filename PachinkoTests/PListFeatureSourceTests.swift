//
//  PListFeatureSourceTests.swift
//  Pachinko
//
//  Created by Tim Antrobus on 01/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import XCTest
@testable import Pachinko


class PListFeatureSourceTests: XCTestCase {
    
    var testFeatureSource: PListFeatureSource
    let testContextFixtureName = "TestContext"
    let testContextFixtureSynopsis = "Unit test context fixture"
    let testFeatureFixtureId = "001"
    let testFeatureFixtureName = "TestFeature1"
    let testFeatureFixtureSynopsis = "Unit test feature fixture"
    let testFeatureFixtureStatusActive = "Active"
    let testFeatureFixtureStatusInctive = "Inactive"
    let testFeatureFixtureStatusInitialised = "Initialised"
    let plistContextFixtureName = "SampleFeatureContext"
    let plistContextFixtureSynopsis = "A sample feature context"
    let plistFeatureFixtureId = "003"
    let plistFeatureFixtureName = "SampleFeature3"
    let plistFeatureFixtureSynopsis = "A third sample feature"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
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
        var plistFeatureSource: PListFeatureSource = DynamicCacheingFeatureSource()
        let testBundle = NSBundle(forClass: FeatureSourceTests.self)
        let features: [FeatureContext:[ConditionalFeature]]? = plistFeatureSource.featuresFromPList(featureBundle: testBundle)
        let plistContext = FeatureContext(name: plistContextFixtureName, synopsis: plistContextFixtureSynopsis)
        let plistFeatureSignature = FeatureSignature(id: plistFeatureFixtureId, name: plistFeatureFixtureName, synopsis: plistFeatureFixtureSynopsis)
        let feature = plistFeatureSource.activeFeature(plistContext, signature: plistFeatureSignature)
        XCTAssertNotNil(feature, "Active feature retrieved from PLIST should not be nil")
        XCTAssertEqual(feature?.signature, plistFeatureSignature)
    }
    
}