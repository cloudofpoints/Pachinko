//
//  NSDefaultsFeatureMapperTests.swift
//  Pachinko
//
//  Created by Tim Antrobus on 04/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import XCTest
@testable import Pachinko

struct TestDefaultsFeatureMapper: NSDefaultsFeatureMapper {}

class NSDefaultsFeatureMapperTests: XCTestCase {
    
    var testFeatureMapper: NSDefaultsFeatureMapper = TestDefaultsFeatureMapper()
    let testDefaultsDomain = "com.cloudofpoints.pachinko-test"
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
        populateDefaultsTestFixture()
    }
    
    override func tearDown() {
        super.tearDown()
        purgeDefaultsTestFixture()
    }
    
    func populateDefaultsTestFixture() {
    
        let testFeatureBundle: NSBundle = NSBundle(forClass: NSDefaultsFeatureMapperTests.self)
        guard let plistPath = testFeatureBundle.pathForResource("Pachinko", ofType: "plist") else {
            return
        }
        
        guard let features = NSDictionary(contentsOfFile: plistPath) as? [String : AnyObject] else {
            return
        }
            
        NSUserDefaults().setPersistentDomain(features, forName: testDefaultsDomain)
    }
    
    func purgeDefaultsTestFixture() {
        NSUserDefaults().removePersistentDomainForName(testDefaultsDomain)
    }
    
    func testFeatureContextFromDefaultsItem() {
        let stubDefaultsContext = [FeaturePlistKey.CONTEXT_NAME.rawValue : testContextFixtureName,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue : testContextFixtureSynopsis]
        let contexts: [FeatureContext] = testFeatureMapper.importModel([stubDefaultsContext])
        XCTAssertNotNil(contexts, "FeatureContext array should not be nil")
        XCTAssertTrue(contexts.count == 1, "FeatureContext array should have one element")
        XCTAssertEqual(contexts[0].name, testContextFixtureName, "FeatureContext name should equal expected  value")
        XCTAssertEqual(contexts[0].synopsis, testContextFixtureSynopsis, "FeatureContext synopsis should equal expected value")
    }
    
    func testFeatureContextFromDefaultsItemIncorrectKey() {
        let stubDefaultsContext = ["SomeRandomKey" : testContextFixtureName,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue : testContextFixtureSynopsis]
        let contexts: [FeatureContext] = testFeatureMapper.importModel([stubDefaultsContext])
        XCTAssertNotNil(contexts, "An invalid key should result in a non-nil array of FeatureContext")
        XCTAssertTrue(contexts.isEmpty, "FeatureContext array should empty for invalid key")
    }

    func testFeatureContextFromDefaultsItemMissingKey() {
        let stubDefaultsContext = ["SomeRandomKey" : testContextFixtureName]
        let contexts: [FeatureContext] = testFeatureMapper.importModel([stubDefaultsContext])
        XCTAssertNotNil(contexts, "A missing key should result in a non-nil array of FeatureContext")
        XCTAssertTrue(contexts.isEmpty, "FeatureContext array should empty for a missing key")
    }

    func testFeatureContextFromDefaultsItemEmptyDictionary() {
        let stubDefaultsItem: [String:String] = [:]
        let contexts: [FeatureContext] = testFeatureMapper.importModel([stubDefaultsItem])
        XCTAssertNotNil(contexts, "An empty dictionary should result in a non-nil array of FeatureContext")
        XCTAssertTrue(contexts.isEmpty, "FeatureContext array should empty for an empty dictionary")
    }

    func testFeatureFromDefaultsItem(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let expectedFeatureSignature = FeatureSignature(id: testFeatureFixtureId,
            name: testFeatureFixtureName, synopsis: testFeatureFixtureSynopsis)
        let features: [BaseFeature] = testFeatureMapper.importModel([stubDefaultsItem])
        XCTAssertNotNil(features, "Features array should not be nil")
        XCTAssertTrue(features.count == 1, "Features array should have one element")
        XCTAssertEqual(features[0].signature, expectedFeatureSignature, "Feature signature should equal expected value")
        XCTAssertEqual(features[0].status, FeatureStatus.Active, "Feature status should equal expected value")
    }

    func testFeatureFromDefaultsItemIncorrectKey(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            "SomeRandomKey" : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let features: [BaseFeature] = testFeatureMapper.importModel([stubDefaultsItem])
        XCTAssertNotNil(features, "An invalid key should result in a non-nil array of BaseFeature")
        XCTAssertTrue(features.isEmpty, "BaseFeature array should be empty for an invalid key")
    }

    func testFeatureFromDefaultsItemMissingKey(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let features: [BaseFeature] = testFeatureMapper.importModel([stubDefaultsItem])
        XCTAssertNotNil(features, "An missing key should result in a non-nil array of BaseFeature")
        XCTAssertTrue(features.isEmpty, "BaseFeature array should be empty for a missing key")
    }
    
    func testFeatureFromDefaultsItemIncorrectStatusRawValue(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : "Invalid"]
        let features: [BaseFeature] = testFeatureMapper.importModel([stubDefaultsItem])
        XCTAssertNotNil(features, "An invalid FeatureStatus value should result in a non-nil array of BaseFeature")
        XCTAssertTrue(features.count == 1, "BaseFeature array should have one element")
        XCTAssertEqual(features[0].status, FeatureStatus.Initialised, "An invalid FeatureStatus should default to Initialised")
    }
    
    func testFeaturesFromDefaultsTestTargetBundle() {
        let testBundle = NSBundle(forClass: FeatureSourceTests.self)
        testFeatureMapper = DefaultsBackedFeatureSource(featureBundle: testBundle)
        let features: [FeatureContext:[ConditionalFeature]]? = testFeatureMapper.featuresByContext(testDefaultsDomain)
        XCTAssertNotNil(features, "Features loaded from PLIST should not be nil")
        let expectedContext = FeatureContext(name: plistContextFixtureName, synopsis: plistContextFixtureSynopsis)
        let expectedFeatureSignature = FeatureSignature(id: plistFeatureFixtureId, name: plistFeatureFixtureName, synopsis: plistFeatureFixtureSynopsis)
        let actualFeatures: [ConditionalFeature]? = features?[expectedContext]
        XCTAssertNotNil(actualFeatures, "Features retrieved from defaults should contain expected context")
        let actualFeature: ConditionalFeature? = actualFeatures?.first
        XCTAssertEqual(expectedFeatureSignature, actualFeature?.signature)
    }

}
