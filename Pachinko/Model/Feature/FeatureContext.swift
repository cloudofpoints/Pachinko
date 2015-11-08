//
//  FeatureContext.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public func ==(lhs: FeatureContext, rhs: FeatureContext) -> Bool {
    return (lhs.name == rhs.name && lhs.synopsis == rhs.synopsis)
}

public struct FeatureContext : Hashable {
    
    public let name: String
    public let synopsis: String
    public var hashValue: Int {
        return (31 &* name.hashValue) &+ synopsis.hashValue
    }
    
    public init(name: String, synopsis: String) {
        self.name = name
        self.synopsis = synopsis
    }
}

extension FeatureContext: PListTemplatable {
 
    public init?(template: NSDictionary?) {
        guard let context = template else {
            return nil
        }
        if let name = context[FeaturePlistKey.CONTEXT_NAME.rawValue] as? String,
            synopsis = context[FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue] as? String {
                self.name = name
                self.synopsis = synopsis
        } else {
            return nil
        }
    }
    
    public func plistTemplate() -> NSDictionary {
        let template: [String:AnyObject] = [FeaturePlistKey.CONTEXT_NAME.rawValue:name,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue:synopsis]
        return template
    }
    
}