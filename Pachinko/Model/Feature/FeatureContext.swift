//
//  FeatureContext.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public func ==(lhs: FeatureContext, rhs: FeatureContext) -> Bool {
    return (lhs.id == rhs.id && lhs.name == rhs.name && lhs.synopsis == rhs.synopsis)
}

public struct FeatureContext : Hashable {
    
    public let id: String
    public let name: String
    public let synopsis: String
    public var features: [BaseFeature]?
    public var hashValue: Int {
        return (31 &* id.hashValue) &+ name.hashValue &+ synopsis.hashValue
    }
    
    public init(id: String, name: String, synopsis: String) {
        self.id = id
        self.name = name
        self.synopsis = synopsis
    }
    
    public func featureSet() -> Set<BaseFeature>? {
        guard let contextFeatures = features else {
            return .None
        }
        
        return Set<BaseFeature>(contextFeatures)
    }
}

extension FeatureContext: PListTemplatable, Versionable {
 
    public init?(template: NSDictionary?) {
        guard let context = template else {
            return nil
        }
        
        guard let id = context[FeaturePlistKey.CONTEXT_ID.rawValue] as? String,
            name = context[FeaturePlistKey.CONTEXT_NAME.rawValue] as? String,
            synopsis = context[FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.synopsis = synopsis
        
        if let featureTemplates = context[FeaturePlistKey.CONTEXT_FEATURES.rawValue] as? [NSDictionary] {
            if let featureModels: [BaseFeature]? = featureTemplates.map({BaseFeature(template: $0)!}) {
                self.features = featureModels
            }
        }
    }
    
    public func plistTemplate() -> NSDictionary {
    
        var template: [String:AnyObject] = [FeaturePlistKey.CONTEXT_ID.rawValue:id,
            FeaturePlistKey.CONTEXT_NAME.rawValue:name,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue:synopsis]
        
        if let featureModels = features {
            
            let featureTemplates: [AnyObject] = featureModels.flatMap({$0.plistTemplate()})
            
            template[FeaturePlistKey.CONTEXT_FEATURES.rawValue] = featureTemplates
        }
        
        return template
    }
    
    public func activeVersion() -> FeatureVersion? {
        
        guard let contextFeatures = features else {
            return .None
        }
        
        guard let maxActiveVersion = contextFeatures.map({$0.signature.versionId}).maxElement() else {
            return .None
        }
        
        return maxActiveVersion
    }
    
}