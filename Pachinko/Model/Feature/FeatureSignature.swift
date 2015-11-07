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

public struct FeatureSignature : Hashable, PListTemplatable {
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
    
    public init?(template: NSDictionary?) {
        guard let signature = template else {
            return nil
        }
        if let id = signature[FeaturePlistKey.FEATURE_ID.rawValue] as? String,
                name = signature[FeaturePlistKey.FEATURE_NAME.rawValue] as? String,
                synopsis = signature[FeaturePlistKey.FEATURE_SYNOPSIS.rawValue] as? String {
                    
                    self.id = id
                    self.name = name
                    self.synopsis = synopsis
        } else {
            return nil
        }
    }
    
    public func plistTemplate() -> NSDictionary {
        let template: [String:AnyObject] = [FeaturePlistKey.FEATURE_ID.rawValue: id,
                                            FeaturePlistKey.FEATURE_NAME.rawValue: name,
                                            FeaturePlistKey.FEATURE_SYNOPSIS.rawValue: synopsis]
        return template
    }
    
    public static func emptySignature() -> FeatureSignature {
        return FeatureSignature(id: "", name: "", synopsis: "")
    }
}