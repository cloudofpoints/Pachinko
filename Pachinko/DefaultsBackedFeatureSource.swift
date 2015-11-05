//
//  DefaultsBackedFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct DefaultsBackedFeatureSource: FeatureSource, PListFeatureReader {
    
    static let pachinkoPListName = "Pachinko"
    static let pachinkoDefaultsDomain = "com.cloudofpoints.pachinko"
    var featureCache: [FeatureContext :[ConditionalFeature]]?
    
    public init(pListName: String = DefaultsBackedFeatureSource.pachinkoPListName,
                featureBundle: NSBundle = NSBundle.mainBundle()){
        loadFeaturesFromPList(pListName, featureBundle: featureBundle)
    }
    
    // MARK: - FeatureSource Protocol
    
    public func activeFeature(context: FeatureContext, signature: FeatureSignature) -> ConditionalFeature? {
        
        guard let features = featureCache?[context] else {
            return .None
        }
        
        return features.filter({$0.signature == signature}).last
    }
    
    public mutating func refresh() {
        featureCache = featuresByContext()
    }
    
    // MARK: - Read Features from PLIST
    
    public func loadFeaturesFromPList(pListName: String,
        featureBundle: NSBundle = NSBundle.mainBundle()) -> Bool {
            
        let pachinkoDefaults = NSUserDefaults.standardUserDefaults()
        
        do {
            
            guard let featuresDict = try featuresFromPList(pListName, featureBundle: featureBundle) else {
                return false
            }
            
            pachinkoDefaults.setPersistentDomain(featuresDict, forName: DefaultsBackedFeatureSource.pachinkoDefaultsDomain)
            
        } catch PListFeatureReaderError.InvalidPListName(let detail) {
            print("Failed to read features from PLIST : \(detail)")
            return false
        } catch {
            print("Caught unhandled error : \(error)")
            return false
        }
        return true
    }
    
    public func featuresByContext() -> [FeatureContext: [ConditionalFeature]]? {
        
        guard let pachinkoDefaults = NSUserDefaults.standardUserDefaults().persistentDomainForName(DefaultsBackedFeatureSource.pachinkoDefaultsDomain) else {
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