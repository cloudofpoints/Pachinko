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

    
    public func featureContexts(domain: String) -> [String:FeatureContext]? {
    
        guard let pachinkoDefaults = NSUserDefaults.standardUserDefaults().persistentDomainForName(domain) else {
            return .None
        }
        
        guard let contexts = pachinkoDefaults[FeaturePlistKey.PACHINKO_FEATURES.rawValue] as? [[String:AnyObject]] else {
            return .None
        }
        
        let contextArray = importModels(contexts)
        var contextsDict: [String:FeatureContext] = [:]
        for context in contextArray {
            contextsDict[context.id] = context
        }
        return contextsDict
    }
    
    public func importModel<T:PListTemplatable>(templates: [AnyObject]?) -> [T] {
        
        guard let modelTemplates = templates else {
            return []
        }
        
        return modelTemplates.map({$0 as? NSDictionary}).flatMap({T(template: $0)})
    }

    
    public func importModels(templates: [AnyObject]?) -> [FeatureContext] {
        
        guard let modelTemplates = templates else {
            return []
        }
        
        let modelArray: [FeatureContext] = importModel(modelTemplates)
        return modelArray
    }
}