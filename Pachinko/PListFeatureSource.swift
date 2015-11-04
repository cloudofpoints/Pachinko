//
//  PListFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol PListFeatureSource {
    var featureReader: PListFeatureReader? {get set}
    func featuresFromPList(pListName: String, featureBundle: NSBundle) -> [FeatureContext: [ConditionalFeature]]?
}

public extension PListFeatureSource {
    
    public func featuresFromPList(pListName: String = "Pachinko", featureBundle: NSBundle = NSBundle.mainBundle()) -> [FeatureContext:[ConditionalFeature]]? {
        
        var contextFeatures: [FeatureContext: [ConditionalFeature]] = [:]
        
        do {
            
            guard let featuresDict = try featureReader?.featuresFromPList(pListName, featureBundle: featureBundle) else {
                return .None
            }
            
            guard let contexts = featuresDict[FeaturePlistKey.PACHINKO_FEATURES.rawValue] as? [[String:AnyObject]] else {
                return .None
            }
            
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
            
        } catch PListFeatureReaderError.InvalidPListName(let detail) {
            print("Unable to source features due to error : \(detail)")
            return .None
        } catch {
            print("Caught unhandled error : \(error)")
            return .None
        }
        
        return contextFeatures
    }
    
    func featureContextFromPlistItem(entry: [String:AnyObject]) -> FeatureContext? {
        guard let name: String = entry[FeaturePlistKey.CONTEXT_NAME.rawValue] as? String else {
            return .None
        }
        guard let synopsis: String = entry[FeaturePlistKey.CONTEXT_SYNOPSIS.rawValue] as? String else {
            return .None
        }
        return FeatureContext(name: name, synopsis: synopsis)
    }
    
    func featureFromPlistItem(featureDict: [String:String]) -> ConditionalFeature? {
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