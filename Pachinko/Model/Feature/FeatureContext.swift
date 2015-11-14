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
    public var features: [ConditionalFeature]?
    public var hashValue: Int {
        return (31 &* id.hashValue) &+ name.hashValue &+ synopsis.hashValue
    }
    
    public init(id: String, name: String, synopsis: String) {
        self.id = id
        self.name = name
        self.synopsis = synopsis
    }
}

extension FeatureContext: PListTemplatable {
 
    public init?(template: NSDictionary?) {
        guard let context = template else {
            return nil
        }
        if let id = context[FeaturePlistKey.CONTEXT_ID.rawValue] as? String,
            name = context[FeaturePlistKey.CONTEXT_NAME.rawValue] as? String,
            synopsis = context[FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue] as? String {
                self.id = id
                self.name = name
                self.synopsis = synopsis
                
                if let featureTemplates = context[FeaturePlistKey.CONTEXT_FEATURES.rawValue] as? [NSDictionary] {
                    
                    if let featureModels: [ConditionalFeature]? = featureTemplates.map({BaseFeature(template: $0)!}) {
                        self.features = featureModels
                    }
                }
                
        } else {
            return nil
        }
    }
    
    public func plistTemplate() -> NSDictionary {
    
        var template: [String:AnyObject] = [FeaturePlistKey.CONTEXT_ID.rawValue:id,
            FeaturePlistKey.CONTEXT_NAME.rawValue:name,
            FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue:synopsis]
        
        if let featureModels = features {
            
            let featureTemplates: [AnyObject] = featureModels.map({$0 as? PListTemplatable})
                                                            .flatMap({$0?.plistTemplate()})
            
            template[FeaturePlistKey.CONTEXT_FEATURES.rawValue] = featureTemplates
        }
        
        return template
    }
    
}