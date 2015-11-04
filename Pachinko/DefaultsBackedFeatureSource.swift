//
//  DefaultsBackedFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct DefaultsBackedFeatureSource: FeatureSource, PListFeatureReader {
    
    var featureCache: [FeatureContext :[ConditionalFeature]]?
    
    
    public func activeFeature(context: FeatureContext, signature: FeatureSignature) -> ConditionalFeature? {

        if featureCache == nil {
            populateDefaults()
        }
        
        guard let features = featureCache?[context] else {
            return .None
        }
        
        return features.filter({$0.signature == signature}).last
    }
    
    public func populateDefaults(pListName: String = "Pachinko",
        featureBundle: NSBundle = NSBundle.mainBundle(),
        domain: String = "com.cloudofpoints.pachinko") -> () {
            
            let pachinkoDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            do {
                
                guard let featuresDict = try featuresFromPList(pListName, featureBundle: featureBundle) else {
                    // Could be no features defined so just exit quietly
                    return
                }
                
                
                pachinkoDefaults.setPersistentDomain(featuresDict, forName: domain)
                
            } catch PListFeatureReaderError.InvalidPListName(let detail) {
                print("Failed to read features from PLIST : \(detail)")
            } catch {
                print("Caught unhandled error : \(error)")
            }
    }
    
    public func featuresByContext() -> [FeatureContext: [ConditionalFeature]]? {
        
        let pachinkoDefaults = NSUserDefaults.standardUserDefaults()
        
        guard let contexts = pachinkoDefaults.objectForKey(FeaturePlistKey.PACHINKO_FEATURES.rawValue) as? [[String:AnyObject]] else {
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
    
    private func featureContextFromDefaultsItem(entry: [String:AnyObject]) -> FeatureContext? {
        guard let name: String = entry[FeaturePlistKey.CONTEXT_NAME.rawValue] as? String else {
            return .None
        }
        guard let synopsis: String = entry[FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue] as? String else {
            return .None
        }
        return FeatureContext(name: name, synopsis: synopsis)
    }
    
    private func featureFromDefaultsItem(featureDict: [String:String]) -> ConditionalFeature? {
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