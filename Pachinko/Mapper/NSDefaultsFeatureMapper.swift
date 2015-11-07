//
//  NSDefaultsFeatureMapper.swift
//  Pachinko
//
//  Created by Tim Antrobus on 04/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol NSDefaultsFeatureMapper {}

public extension NSDefaultsFeatureMapper {
    
    public func featuresByContext(domain: String) -> [FeatureContext: [ConditionalFeature]]? {
        
        guard let pachinkoDefaults = NSUserDefaults().persistentDomainForName(domain) else {
            return .None
        }
        
        guard let contexts = pachinkoDefaults[FeaturePlistKey.PACHINKO_FEATURES.rawValue] as? [[String:AnyObject]] else {
            return .None
        }
        
        var contextFeatures: [FeatureContext: [ConditionalFeature]] = [:]
        
        for contextDict: [String:AnyObject] in contexts {
            
            guard let featureContext = featureContextFromDefaultsItem(contextDict) else {
                continue
            }
            
            guard let features = contextDict[FeaturePlistKey.CONTEXT_FEATURES.rawValue] as? [[String:String]] else {
                continue
            }
            
            for featureDict: [String:String] in features {
                
                guard let feature = featureFromDefaultsItem(featureDict) else {
                    continue
                }
                
                if !contextFeatures.keys.contains(featureContext){
                    contextFeatures[featureContext] = [ConditionalFeature]()
                }
                contextFeatures[featureContext]?.append(feature)
            }
        }
        return contextFeatures
    }
    
    public func featureContextFromDefaultsItem(entry: [String:AnyObject]) -> FeatureContext? {
        guard let name: String = entry[FeaturePlistKey.CONTEXT_NAME.rawValue] as? String else {
            return .None
        }
        guard let synopsis: String = entry[FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue] as? String else {
            return .None
        }
        return FeatureContext(name: name, synopsis: synopsis)
    }
    
    public func featureFromDefaultsItem(featureDict: [String:String]) -> ConditionalFeature? {
        if let featureId = featureDict[FeaturePlistKey.FEATURE_ID.rawValue],
            featureName = featureDict[FeaturePlistKey.FEATURE_NAME.rawValue],
            featureSynopsis = featureDict[FeaturePlistKey.FEATURE_SYNOPSIS.rawValue],
            featureStatusStr = featureDict[FeaturePlistKey.FEATURE_STATUS.rawValue] {
                
                guard let featureStatus = FeatureStatus(rawValue: featureStatusStr) else {
                    return .None
                }
                
                let signature = FeatureSignature(id: featureId, name: featureName, synopsis: featureSynopsis)
                return BaseFeature(signature: signature, status: featureStatus)
        }
        return .None
    }
    
}