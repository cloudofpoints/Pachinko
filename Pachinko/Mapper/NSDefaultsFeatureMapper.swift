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

        guard let pachinkoDefaults = NSUserDefaults.standardUserDefaults().persistentDomainForName(domain) else {
            return .None
        }
        
        guard let contexts = pachinkoDefaults[FeaturePlistKey.PACHINKO_FEATURES.rawValue] as? [[String:AnyObject]] else {
            return .None
        }
        
        return importModels(contexts)
    }
    
    public func importModel<T:PListTemplatable>(templates: [AnyObject]?) -> [T] {
        
        guard let modelTemplates = templates else {
            return []
        }
        
        return modelTemplates.map({$0 as? NSDictionary}).flatMap({T(template: $0)})
    }

    
    public func importModels(templates: [AnyObject]?) -> [FeatureContext:[ConditionalFeature]] {
        
        var modelDict: [FeatureContext:[ConditionalFeature]] = [:]
        
        guard let modelTemplates = templates else {
            return modelDict
        }
        for template: NSDictionary in modelTemplates.flatMap({$0 as? NSDictionary}) {
            
            guard let modelKey = FeatureContext(template: template) else {
                continue
            }
            let contextFeaturesKey = FeaturePlistKey.CONTEXT_FEATURES.rawValue
            let modelValues: [BaseFeature] = importModel(template[contextFeaturesKey] as? [AnyObject])
            modelDict[modelKey] = modelValues.map({$0 as ConditionalFeature})
        }
        return modelDict
    }
}