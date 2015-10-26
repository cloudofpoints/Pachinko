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
    
    public func featureDeltas() -> [FeatureContext:[ConditionalFeature]]? {
        // Get latest timestamp and version/hash from local feature store
        // Get features from remote FeatureSource that are greater than current version / timestamp
        // Iterate through list of deltas & update local PLIST, user defaults
        // Push out notification updates ?? Property observers ??
        return [:]
    }
    
}