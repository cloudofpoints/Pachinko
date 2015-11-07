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
        let context: FeatureContext? = testFeatureMapper.featureContextFromDefaultsItem(stubDefaultsContext)
        XCTAssertNotNil(context, "FeatureContext should not be nil")
        XCTAssertEqual(context?.name, testContextFixtureName)
        XCTAssertEqual(context?.synopsis, testContextFixtureSynopsis)
    }
    
    func testFeatureContextFromDefaultsItemIncorrectKey() {
        let stubDefaultsContext = ["SomeRandomKey" : testContextFixtureName,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue : testContextFixtureSynopsis]
        let context: FeatureContext? = testFeatureMapper.featureContextFromDefaultsItem(stubDefaultsContext)
        XCTAssertNil(context, "An invalid key should result in a nil feature context")
    }
    
    func testFeatureContextFromDefaultsItemMissingKey() {
        let stubDefaultsContext = ["SomeRandomKey" : testContextFixtureName]
        let context: FeatureContext? = testFeatureMapper.featureContextFromDefaultsItem(stubDefaultsContext)
        XCTAssertNil(context, "A missing key should result in a nil feature context")
    }
    
    func testFeatureContextFromDefaultsItemEmptyDictionary() {
        let stubDefaultsItem: [String:String] = [:]
        let context: FeatureContext? = testFeatureMapper.featureContextFromDefaultsItem(stubDefaultsItem)
        XCTAssertNil(context, "An empty item dictionary should result in a nil feature context")
    }
    
    func testFeatureFromDefaultsItem(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let expectedFeatureSignature = FeatureSignature(id: testFeatureFixtureId,
            name: testFeatureFixtureName, synopsis: testFeatureFixtureSynopsis)
        let feature: ConditionalFeature? = testFeatureMapper.featureFromDefaultsItem(stubDefaultsItem)
        XCTAssertNotNil(feature, "Feature should not be nil")
        XCTAssertEqual(feature?.signature, expectedFeatureSignature)
        XCTAssertEqual(feature?.status, FeatureStatus.Active)
    }
    
    func testFeatureFromDefaultsItemIncorrectKey(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            "SomeRandomKey" : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let feature: ConditionalFeature? = testFeatureMapper.featureFromDefaultsItem(stubDefaultsItem)
        XCTAssertNil(feature, "An invalid key should result in a nil feature")
    }
    
    func testFeatureFromDefaultsItemMissingKey(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
        let feature: ConditionalFeature? = testFeatureMapper.featureFromDefaultsItem(stubDefaultsItem)
        XCTAssertNil(feature, "An missing key should result in a nil feature")
    }
    
    func testFeatureFromDefaultsItemIncorrectStatusRawValue(){
        let stubDefaultsItem = [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : "Invalid"]
        let feature: ConditionalFeature? = testFeatureMapper.featureFromDefaultsItem(stubDefaultsItem)
        XCTAssertNil(feature, "An invalid status raw value should result in a nil feature")
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
