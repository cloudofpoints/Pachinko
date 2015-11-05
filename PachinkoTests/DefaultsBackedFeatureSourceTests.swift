//
//  DefaultsBackedFeatureSourceTests.swift
//  Pachinko
//
//  Created by Tim Antrobus on 04/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import XCTest
@testable import Pachinko

class DefaultsBackedFeatureSourceTests: XCTestCase {
    
    var testFeatureSource: DefaultsBackedFeatureSource = DefaultsBackedFeatureSource()
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
    
    func testFeatureContextFromDefaultsItem() {
        let stubDefaultsContext = [FeaturePlistKey.CONTEXT_NAME.rawValue : testContextFixtureName,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue : testContextFixtureSynopsis]
        let context: FeatureContext? = testFeatureSource.featureContextFromDefaultsItem(stubDefaultsContext)
        XCTAssertNotNil(context, "FeatureContext should not be nil")
        XCTAssertEqual(context?.name, testContextFixtureName)
        XCTAssertEqual(context?.synopsis, testContextFixtureSynopsis)
    }
    
    func testFeatureContextFromDefaultsItemIncorrectKey() {
        let stubDefaultsContext = ["SomeRandomKey" : testContextFixtureName,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue : testContextFixtureSynopsis]
        let context: FeatureContext? = testFeatureSource.featureContextFromDefaultsItem(stubDefaultsContext)
        XCTAssertNil(context, "An invalid key should result in a nil feature context")
    }
    
    func testFeatureContextFromDefaultsItemMissingKey() {
        let stubDefaultsContext = ["SomeRandomKey" : testContextFixtureName]
        let context: FeatureContext? = testFeatureSource.featureContextFromDefaultsItem(stubDefaultsContext)
        XCTAssertNil(context, "A missing key should result in a nil feature context")
    }
    
    func testFeatureContextFromDefaultsItemEmptyDictionary() {
        let stubDefaultsItem: [String:String] = [:]
        let context: FeatureContext? = testFeatureSource.featureContextFromDefaultsItem(stubDefaultsItem)
        XCTAssertNil(context, "An empty item dictionary should result in a nil feature context")
    }
    
    func testFeatureFromDefaultsItem(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let expectedFeatureSignature = FeatureSignature(id: testFeatureFixtureId,
            name: testFeatureFixtureName, synopsis: testFeatureFixtureSynopsis)
        let feature: ConditionalFeature? = testFeatureSource.featureFromDefaultsItem(stubDefaultsItem)
        XCTAssertNotNil(feature, "Feature should not be nil")
        XCTAssertEqual(feature?.signature, expectedFeatureSignature)
        XCTAssertEqual(feature?.status, FeatureStatus.Active)
    }
    
    func testFeatureFromDefaultsItemIncorrectKey(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            "SomeRandomKey" : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let feature: ConditionalFeature? = testFeatureSource.featureFromDefaultsItem(stubDefaultsItem)
        XCTAssertNil(feature, "An invalid key should result in a nil feature")
    }
    
    func testFeatureFromDefaultsItemMissingKey(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let feature: ConditionalFeature? = testFeatureSource.featureFromDefaultsItem(stubDefaultsItem)
        XCTAssertNil(feature, "An missing key should result in a nil feature")
    }
    
    func testFeatureFromDefaultsItemIncorrectStatusRawValue(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : "Invalid"]
        let feature: ConditionalFeature? = testFeatureSource.featureFromDefaultsItem(stubDefaultsItem)
        XCTAssertNil(feature, "An invalid status raw value should result in a nil feature")
    }
    
    func testFeaturesFromDefaultsTestTargetBundle() {
        let testBundle = NSBundle(forClass: FeatureSourceTests.self)
        testFeatureSource = DefaultsBackedFeatureSource(featureBundle: testBundle)
        testFeatureSource.refresh()
        let features: [FeatureContext:[ConditionalFeature]]? = testFeatureSource.featuresByContext()
        XCTAssertNotNil(features, "Features loaded from PLIST should not be nil")
        let plistContext = FeatureContext(name: plistContextFixtureName, synopsis: plistContextFixtureSynopsis)
        let plistFeatureSignature = FeatureSignature(id: plistFeatureFixtureId, name: plistFeatureFixtureName, synopsis: plistFeatureFixtureSynopsis)
        let feature = testFeatureSource.activeFeature(plistContext, signature: plistFeatureSignature)
        XCTAssertNotNil(feature, "Active feature retrieved from PLIST should not be nil")
        XCTAssertEqual(feature?.signature, plistFeatureSignature)
    }

}
