//
//  ToggleCondition.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct ToggleCondition<T> : FeaturePredicate {
    
    public typealias Evaluator = T -> Bool
    private let subject: T
    private let evaluator: Evaluator
    
    public init(subject: T, evaluator: Evaluator){
        self.subject = subject
        self.evaluator = evaluator
    }
    
    public func evaluate() -> Bool {
        return evaluator(subject)
    }
}
