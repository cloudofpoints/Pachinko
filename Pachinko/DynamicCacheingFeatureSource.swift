//
//  DynamicCacheingFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct DynamicCacheingFeatureSource: FeatureSource, PListFeatureSource {

    let pachinkoSuiteName = "com.cloudofpoints.pachinko"
    var featureDefaults: NSUserDefaults?
    var featureCache: [FeatureContext:[ConditionalFeature]]?
    
    public func activeFeature(context: FeatureContext, signature: FeatureSignature) -> ConditionalFeature? {
        guard let features = featureCache?[context] else {
            return nil
        }
        return features.filter({$0.signature == signature}).last
    }
    
    mutating func bindDefaults(pachinkoDefaults: NSUserDefaults) ->() {
        featureDefaults = pachinkoDefaults
    }
    
    public mutating func bindFeaturesFromPList(pListName: String = "Pachinko", featureBundle: NSBundle = NSBundle.mainBundle()) -> () {
        
        guard let featuresURL = featureBundle.URLForResource(pListName, withExtension:"plist") else {
            print("Unable to locate \(pListName).plist in bundle \(featureBundle.description)")
            return
        }
        
        guard let featuresDict = NSDictionary(contentsOfURL: featuresURL) as? Dictionary<String,AnyObject> else {
            print("Unable to create dictionary from resource URL : \(featuresURL)")
            return
        }
        
        guard let pachinkoDefaults = NSUserDefaults(suiteName: pachinkoSuiteName) else {
            print("Unable to initialise NSUserDefaults with suiteName : \(pachinkoSuiteName)")
            return
        }
        
        pachinkoDefaults.registerDefaults(featuresDict)
        bindDefaults(pachinkoDefaults)
    }
    
    public func featureDeltas() -> [FeatureContext:[ConditionalFeature]]? {
        // Get latest timestamp and version/hash from local feature store
        // Get features from remote FeatureSource that are greater than current version / timestamp
        // Iterate through list of deltas & update local PLIST, user defaults
        // Push out notification updates ?? Property observers ??
        return [:]
    }
    
}