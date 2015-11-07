//
//  FeatureToggle.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 13/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct FeatureToggle : Togglable {
    
    public let context: FeatureContext
    public let signature: FeatureSignature
    public let featureSource: FeatureSource
    private var predicates: [FeaturePredicate]?
    
    public init(context: FeatureContext, signature: FeatureSignature, featureSource: FeatureSource){
        self.context = context
        self.signature = signature
        self.featureSource = featureSource
    }
    
    public func featurePredicates() -> [FeaturePredicate]? {
        guard let conditions = predicates else {
            return nil
        }
        return conditions
    }
    
    public mutating func bindFeaturePredicates(predicates: [FeaturePredicate]) -> () {
        self.predicates = predicates
    }
    
}