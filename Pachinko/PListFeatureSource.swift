//
//  PListFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol PListFeatureSource {
    mutating func bindFeaturesFromPList(pListName: String, featureBundle: NSBundle) -> ()
}

public extension PListFeatureSource {
    
    public mutating func bindFeaturesFromPList(pListName: String = "Pachinko", featureBundle: NSBundle = NSBundle.mainBundle()) -> () {
        
        guard let plistPath = featureBundle.pathForResource(pListName, ofType: "plist") else {
            print("Unable to locate \(pListName).plist in bundle \(featureBundle.description)")
            return
        }
        
        guard let contexts = NSDictionary(contentsOfFile: plistPath)?.objectForKey(FeaturePlistKey.PACHINKO_FEATURES.rawValue) as? [[String:AnyObject]] else {
            return
        }
        
        var contextFeatures: [FeatureContext: [ConditionalFeature]] = [:]
        for contextDict: Dictionary in contexts {
            
            guard let featureContext = featureContextFromPlistItem(contextDict) else {
                continue
            }
            
            guard let features = contextDict[FeaturePlistKey.CONTEXT_FEATURES.rawValue] as? [[String:String]] else {
                continue
            }
            
            for featureDict: [String:String] in features {
                
                guard let feature = featureFromPlistItem(featureDict) else {
                    continue
                }
                
                if !contextFeatures.keys.contains(featureContext){
                    contextFeatures[featureContext] = [ConditionalFeature]()
                }
                contextFeatures[featureContext]?.append(feature)
            }
            
        }
    }
    
    func featureContextFromPlistItem(entry: [String:AnyObject]) -> FeatureContext? {
        guard let name: String = entry[FeaturePlistKey.CONTEXT_NAME.rawValue] as? String else {
            return nil
        }
        guard let synopsis: String = entry[FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue] as? String else {
            return nil
        }
        return FeatureContext(name: name, synopsis: synopsis)
    }
    
    func featureFromPlistItem(featureDict: [String:String]) -> ConditionalFeature? {
        if let featureId = featureDict[FeaturePlistKey.FEATURE_ID.rawValue],
            featureName = featureDict[FeaturePlistKey.FEATURE_NAME.rawValue],
            featureSynopsis = featureDict[FeaturePlistKey.FEATURE_SYNOPSIS.rawValue],
            featureStatusStr = featureDict[FeaturePlistKey.FEATURE_STATUS.rawValue] {
                
                guard let featureStatus = FeatureStatus(rawValue: featureStatusStr) else {
                    return nil
                }
                
                let signature = FeatureSignature(id: featureId, name: featureName, synopsis: featureSynopsis)
                return BaseFeature(signature: signature, status: featureStatus)
        }
        return nil
    }
    
    
}