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
        get {
            return (31 &* self.name.hashValue) &+ self.synopsis.hashValue
        }
    }
    
    public init(name: String, synopsis: String) {
        self.name = name
        self.synopsis = synopsis
    }
    
}