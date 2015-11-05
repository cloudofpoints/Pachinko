//
//  StubFeatureSource.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 15/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation
@testable import Pachinko

public class StubFeatureSource : FeatureSource {
    
    let testContextOne = FeatureContext(name: "TestContext1", synopsis: "TestContext1 Features")
    let testContextTwo = FeatureContext(name: "TestContext2", synopsis: "TestContext2 Features")
    let loginFeatureSignature = FeatureSignature(id: "001", name: "LoginFeature", synopsis: "Test login feature")
    let campaignFeatureSignature = FeatureSignature(id: "002", name: "CampaignFeature", synopsis: "Test campaign feature")
    let buttonABTestSignature_A = FeatureSignature(id: "003", name: "ButtonABTestFeature_A", synopsis: "Button A/B testing - A")
    let buttonABTestSignature_B = FeatureSignature(id: "004", name: "ButtonABTestFeature_B", synopsis: "Button A/B testing - B")
    
    private lazy var featureCache: [FeatureContext : [FeatureSignature : ConditionalFeature]] = self.populateFeatureCache()
    
    private func populateFeatureCache() -> [FeatureContext: [FeatureSignature: ConditionalFeature]] {
        
        let testFeature1: ConditionalFeature = BaseFeature(signature: loginFeatureSignature, status: FeatureStatus.Active)
        let testFeature2: ConditionalFeature = BaseFeature(signature: campaignFeatureSignature, status: FeatureStatus.Active)
        let testFeature3: ConditionalFeature = BaseFeature(signature: buttonABTestSignature_A, status: FeatureStatus.Active)
        let testFeature4: ConditionalFeature = BaseFeature(signature: buttonABTestSignature_B, status: FeatureStatus.Active)
        
        let cache = [
            testContextOne : [loginFeatureSignature : testFeature1, campaignFeatureSignature : testFeature2],
            testContextTwo : [buttonABTestSignature_A : testFeature3, buttonABTestSignature_B: testFeature4]
        ]
        return cache
    }
    
    public func activeFeature(context: FeatureContext, signature: FeatureSignature) -> ConditionalFeature? {
        guard let contextFeatures = self.featureCache[context] else {
            return .None
        }
        return contextFeatures[signature]
    }
    
    public func refresh() {
        featureCache = populateFeatureCache()
    }
}