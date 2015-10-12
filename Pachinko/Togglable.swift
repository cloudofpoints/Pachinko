//
//  Togglable.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol Togglable {
    var featureSource: FeatureSource {get}
    func featurePredicates(context: FeatureContext, signature: FeatureSignature) -> [FeaturePredicate]?
    
}

extension Togglable {
    
    func executeFeature(context: FeatureContext, signature: FeatureSignature) -> Bool {
        guard let activeFeature = featureSource.activeFeature(context, signature: signature) else {
            return false
        }
        
        let activeFeaturePredicates = featurePredicates(context, signature: signature)
        return activeFeature.isRunnable(activeFeaturePredicates)
    }
}