//
//  ConditionalFeature.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol ConditionalFeature : Feature {
    func isRunnable(conditions: [FeaturePredicate]?) -> Bool
}

extension ConditionalFeature {
    
    public func isActive() -> Bool {
        return status == FeatureStatus.Active
    }
    
    public func isRunnable(conditions: [FeaturePredicate]?) -> Bool {
        
        guard let predicates = conditions else {
            return isActive()
        }
        
        return predicates.reduce(isActive()) { (aggregate: Bool, predicate: FeaturePredicate) in
            return aggregate && predicate.evaluate()
        }
        
    }
}