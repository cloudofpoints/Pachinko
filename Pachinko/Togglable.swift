//
//  Togglable.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol Togglable {
    var context: FeatureContext {get}
    var signature: FeatureSignature {get}
    var featureSource: FeatureSource {get}
    func featurePredicates() -> [FeaturePredicate]?
    mutating func bindFeaturePredicates(predicates: [FeaturePredicate]) -> ()
}

public extension Togglable {
        
    func shouldExecuteFeature() -> Bool {
        
        guard let activeFeature = featureSource.activeFeature(context, signature: signature) else {
            return false
        }
        
        let activeFeaturePredicates = featurePredicates()
        return activeFeature.shouldExecute(activeFeaturePredicates)
    }
}