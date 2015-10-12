//
//  FeatureSignature.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public func ==(lhs: FeatureSignature, rhs: FeatureSignature) -> Bool {
    return (lhs.id == rhs.id && lhs.name == rhs.name && lhs.synopsis == rhs.synopsis)
}

public struct FeatureSignature : Hashable {
    public let id: String
    public let name: String
    public let synopsis: String
    
    public var hashValue: Int {
        get {
            return (31 &* id.hashValue) &+ name.hashValue &+ synopsis.hashValue
        }
    }
    
    public init(id: String, name: String, synopsis: String){
        self.id = id
        self.name = name
        self.synopsis = synopsis
    }
}