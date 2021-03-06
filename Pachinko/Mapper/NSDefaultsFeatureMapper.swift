//
//  NSDefaultsFeatureMapper.swift
//  Pachinko
//
//  Created by Tim Antrobus on 04/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol NSDefaultsFeatureMapper {
    func defaultsProvider() -> DefaultsProvider
}

public extension NSDefaultsFeatureMapper {

    public func defaultsProvider() -> DefaultsProvider {
        return NSUserDefaultsProvider()
    }
    
    public func featureContexts(domain: String) -> [String:FeatureContext]? {
    
        guard let pachinkoDefaults = defaultsProvider().defaultsDictionary(forDomain: domain) else {
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
    
    public func updateFeatureContext(context: FeatureContext, forKey contextKey: String, inDomain domain: String) -> Void {
        
        guard let pachinkoDefaults = defaultsProvider().defaultsDictionary(forDomain: domain) else {
            return
        }
        
        guard let templates = pachinkoDefaults[FeaturePlistKey.PACHINKO_FEATURES.rawValue] as? [[String:AnyObject]] else {
            return
        }
  
        var templateDictionaries = [NSDictionary]()
  
        for var contextDict in templates {
            if let contextId = contextDict[FeaturePlistKey.CONTEXT_ID.rawValue] as? String {
                if contextId == contextKey {
                    templateDictionaries.append(context.plistTemplate())
                    continue
                }
            }
            templateDictionaries.append(contextDict)
        }
  
        let updatedDefaults = [FeaturePlistKey.PACHINKO_FEATURES.rawValue : templateDictionaries]
        defaultsProvider().writeDefaults(defaultsDictionary: updatedDefaults, forDomain: domain)
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

public struct NSUserDefaultsProvider: DefaultsProvider {}