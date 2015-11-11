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
    let testContextFixtureId = "com.cloudofpoints.pachinko.context.1"
    let testContextFixtureName = "TestContext"
    let testContextFixtureSynopsis = "Unit test context fixture"
    let testFeatureFixtureId = "001"
    let testFeatureFixtureVersionId = "1.0.0"
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
            
        NSUserDefaults.standardUserDefaults().setPersistentDomain(features, forName: testDefaultsDomain)
    }
    
    func purgeDefaultsTestFixture() {
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(testDefaultsDomain)
    }
    
    func defaultsContextFixture() -> [String:String] {
        return [FeaturePlistKey.CONTEXT_ID.rawValue : testContextFixtureId,
            FeaturePlistKey.CONTEXT_NAME.rawValue : testContextFixtureName,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue : testContextFixtureSynopsis]
    }
    
    
    func defaultsItemFixture() -> [String:String] {
        return [FeaturePlistKey.FEATURE_ID.rawValue : testFeatureFixtureId,
            FeaturePlistKey.FEATURE_VERSION_ID.rawValue: testFeatureFixtureVersionId,
            FeaturePlistKey.FEATURE_NAME.rawValue : testFeatureFixtureName,
            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue : testFeatureFixtureSynopsis,
            FeaturePlistKey.FEATURE_STATUS.rawValue : testFeatureFixtureStatusActive]
    }
    
    func testFeatureContextFromDefaultsItem() {
        let stubDefaultsContext = defaultsContextFixture()
        let contexts: [FeatureContext] = testFeatureMapper.importModel([stubDefaultsContext])
        XCTAssertNotNil(contexts, "FeatureContext array should not be nil")
        XCTAssertTrue(contexts.count == 1, "FeatureContext array should have one element")
        XCTAssertEqual(contexts[0].id, testContextFixtureId, "FeatureContext ID should equal expected value")
        XCTAssertEqual(contexts[0].name, testContextFixtureName, "FeatureContext name should equal expected  value")
        XCTAssertEqual(contexts[0].synopsis, testContextFixtureSynopsis, "FeatureContext synopsis should equal expected value")
    }
    
    func testFeatureContextFromDefaultsItemIncorrectKey() {
        var stubDefaultsContext = defaultsContextFixture()
        let contextNameIndex = stubDefaultsContext.indexForKey(FeaturePlistKey.CONTEXT_NAME.rawValue)
        stubDefaultsContext.removeAtIndex(contextNameIndex!)
        stubDefaultsContext["SomeRandomKey"] = testContextFixtureName
        let contexts: [FeatureContext] = testFeatureMapper.importModel([stubDefaultsContext])
        XCTAssertNotNil(contexts, "An invalid key should result in a non-nil array of FeatureContext")
        XCTAssertTrue(contexts.isEmpty, "FeatureContext array should empty for invalid key")
    }

    func testFeatureContextFromDefaultsItemMissingKey() {
        var stubDefaultsContext = defaultsContextFixture()
        let contextSynopsisIndex = stubDefaultsContext.indexForKey(FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue)
        stubDefaultsContext.removeAtIndex(contextSynopsisIndex!)
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
        let stubDefaultsItem = defaultsItemFixture()
        let expectedFeatureSignature = FeatureSignature(id: testFeatureFixtureId, versionId: testFeatureFixtureVersionId,name: testFeatureFixtureName, synopsis: testFeatureFixtureSynopsis)
        let features: [BaseFeature] = testFeatureMapper.importModel([stubDefaultsItem])
        XCTAssertNotNil(features, "Features array should not be nil")
        XCTAssertTrue(features.count == 1, "Features array should have one element")
        XCTAssertEqual(features[0].signature, expectedFeatureSignature, "Feature signature should equal expected value")
        XCTAssertEqual(features[0].status, FeatureStatus.Active, "Feature status should equal expected value")
    }

    func testFeatureFromDefaultsItemIncorrectKey(){
        var stubDefaultsItem = defaultsItemFixture()
        let synopsisIndex = stubDefaultsItem.indexForKey(FeaturePlistKey.FEATURE_SYNOPSIS.rawValue)
        stubDefaultsItem.removeAtIndex(synopsisIndex!)
        stubDefaultsItem["SomeRandomKey"] = testFeatureFixtureSynopsis
        let features: [BaseFeature] = testFeatureMapper.importModel([stubDefaultsItem])
        XCTAssertNotNil(features, "An invalid key should result in a non-nil array of BaseFeature")
        XCTAssertTrue(features.isEmpty, "BaseFeature array should be empty for an invalid key")
    }

    func testFeatureFromDefaultsItemMissingKey(){
        var stubDefaultsItem = defaultsItemFixture()
        let synopsisIndex = stubDefaultsItem.indexForKey(FeaturePlistKey.FEATURE_SYNOPSIS.rawValue)
        stubDefaultsItem.removeAtIndex(synopsisIndex!)
        let features: [BaseFeature] = testFeatureMapper.importModel([stubDefaultsItem])
        XCTAssertNotNil(features, "An missing key should result in a non-nil array of BaseFeature")
        XCTAssertTrue(features.isEmpty, "BaseFeature array should be empty for a missing key")
    }
    
    func testFeatureFromDefaultsItemIncorrectStatusRawValue(){
        var stubDefaultsItem = defaultsItemFixture()
        stubDefaultsItem[FeaturePlistKey.FEATURE_STATUS.rawValue] = "Invalid"
        let features: [BaseFeature] = testFeatureMapper.importModel([stubDefaultsItem])
        XCTAssertNotNil(features, "An invalid FeatureStatus value should result in a non-nil array of BaseFeature")
        XCTAssertTrue(features.count == 1, "BaseFeature array should have one element")
        XCTAssertEqual(features[0].status, FeatureStatus.Initialised, "An invalid FeatureStatus should default to Initialised")
    }
    
    func testFeaturesFromDefaultsTestTargetBundle() {
        let testBundle = NSBundle(forClass: FeatureSourceTests.self)
        testFeatureMapper = DefaultsBackedFeatureSource(featureBundle: testBundle)
        let features: [String:FeatureContext]? = testFeatureMapper.featureContexts(testDefaultsDomain)
        XCTAssertNotNil(features, "Features loaded from PLIST should not be nil")
        let expectedContext = FeatureContext(id: "com.cloudofpoints.pachinko.context.1", name: plistContextFixtureName, synopsis: plistContextFixtureSynopsis)
        let expectedFeatureSignature = FeatureSignature(id: plistFeatureFixtureId, versionId: testFeatureFixtureVersionId, name: plistFeatureFixtureName, synopsis: plistFeatureFixtureSynopsis)
        if let actualContext: FeatureContext = features?[expectedContext.id] {
            let actualFeatures: [ConditionalFeature]? = actualContext.features
            XCTAssertNotNil(actualFeatures, "Features retrieved from defaults should contain expected context")
            let actualFeature: ConditionalFeature? = actualFeatures?.first
            XCTAssertEqual(expectedFeatureSignature, actualFeature?.signature)
        } else {
            XCTFail()
        }

    }

}
