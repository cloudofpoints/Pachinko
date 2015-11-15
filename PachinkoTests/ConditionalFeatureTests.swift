//
//  ConditionalFeatureTests.swift
//  Pachinko
//
//  Created by Tim Antrobus on 17/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import XCTest
@testable import Pachinko

class ConditionalFeatureTests: XCTestCase {

    var testFeatureSignature = FeatureSignature(id: "001", versionId: FeatureVersion(major: 1, minor: 0, patch: 0), name: "TestSignature", synopsis: "FeatureSignature test fixture")

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testDefaultInitialStatus() {
        let initialisedFeature = BaseFeature(signature: testFeatureSignature)
        XCTAssertTrue(initialisedFeature.status == FeatureStatus.Initialised, "Default feature status should be FeatureStatus.Initialised")
    }
    
    func testDefaultInitialStatusIsNotActive() {
        let initialisedFeature = BaseFeature(signature: testFeatureSignature)
        XCTAssertFalse(initialisedFeature.isActive(), "Default feature status of Initialised should mean isActive() returns false")
    }
    
    func testCustomStatusActive() {
        let activeFeature = BaseFeature(signature: testFeatureSignature, status: FeatureStatus.Active)
        XCTAssertTrue(activeFeature.isActive(), "Custom feature status of Active should mean isActive() returns true")
    }
    
    func testCustomStatusNotActive() {
        let inactiveFeature = BaseFeature(signature: testFeatureSignature, status: FeatureStatus.Inactive)
        XCTAssertFalse(inactiveFeature.isActive(), "Custom feature status of Inactive should mean isActive() returns false")
    }
    
    func testActiveFeatureSinglePredicateEvaluation() {
        let activeFeature = BaseFeature(signature: testFeatureSignature, status: FeatureStatus.Active)
        let testProfile = StubUserProfile(firstName: "Sybil", surname: "Fawlty", location: .IE, products: [.TV])
        let toggleCondition = ToggleCondition<StubUserProfile>(subject: testProfile){profile in profile.isTVOnly()}
        let predicates: [FeaturePredicate] = [toggleCondition]
        XCTAssertTrue(activeFeature.shouldExecute(predicates), "Active feature with true predicates should return true")
    }
    
    func testActiveFeatureMultiplePredicateEvaluationAllTrue() {
        let activeFeature = BaseFeature(signature: testFeatureSignature, status: FeatureStatus.Active)
        let testProfile = StubUserProfile(firstName: "Sybil", surname: "Fawlty", location: .IE, products: [.TV])
        let toggleCondition1 = ToggleCondition<StubUserProfile>(subject: testProfile){profile in profile.isTVOnly()}
        let toggleCondition2 = ToggleCondition<StubUserProfile>(subject: testProfile){profile in profile.isROI()}
        let predicates: [FeaturePredicate] = [toggleCondition1, toggleCondition2]
        XCTAssertTrue(activeFeature.shouldExecute(predicates), "Active feature with true predicates should return true")
    }
    
    func testActiveFeatureMultiplePredicateEvaluationOneFalse() {
        let activeFeature = BaseFeature(signature: testFeatureSignature, status: FeatureStatus.Active)
        let testProfile = StubUserProfile(firstName: "Sybil", surname: "Fawlty", location: .EU, products: [.TV])
        let toggleCondition1 = ToggleCondition<StubUserProfile>(subject: testProfile){profile in profile.isTVOnly()}
        let toggleCondition2 = ToggleCondition<StubUserProfile>(subject: testProfile){profile in profile.isROI()}
        let predicates: [FeaturePredicate] = [toggleCondition1, toggleCondition2]
        XCTAssertFalse(activeFeature.shouldExecute(predicates), "Active feature with one false predicate should return false")
    }
    
    func testInActiveFeatureMultiplePredicateEvaluationAllTrue() {
        let inactiveFeature = BaseFeature(signature: testFeatureSignature, status: FeatureStatus.Inactive)
        let testProfile = StubUserProfile(firstName: "Sybil", surname: "Fawlty", location: .IE, products: [.TV])
        let toggleCondition1 = ToggleCondition<StubUserProfile>(subject: testProfile){profile in profile.isTVOnly()}
        let toggleCondition2 = ToggleCondition<StubUserProfile>(subject: testProfile){profile in profile.isROI()}
        let predicates: [FeaturePredicate] = [toggleCondition1, toggleCondition2]
        XCTAssertFalse(inactiveFeature.shouldExecute(predicates), "Inactive feature with true predicates should return false")
    }
    
    func testActiveFeatureNoPredicatesEvaluation() {
        let activeFeature = BaseFeature(signature: testFeatureSignature, status: FeatureStatus.Active)
        XCTAssertTrue(activeFeature.shouldExecute([]), "Active feature with no predicates should return true")
    }
    
    func testInActiveFeatureNoPredicatesEvaluation() {
        let inactiveFeature = BaseFeature(signature: testFeatureSignature, status: FeatureStatus.Inactive)
        XCTAssertFalse(inactiveFeature.shouldExecute([]), "Inactive feature with no predicates should return false")
    }
    

}
