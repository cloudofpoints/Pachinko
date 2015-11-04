//
//  DynamicCacheingFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct DynamicCacheingFeatureSource: FeatureSource {

    var featureCache: DefaultsBackedFeatureSource?
    
    public func activeFeature(context: FeatureContext, signature: FeatureSignature) -> ConditionalFeature? {
        return featureCache?.activeFeature(context, signature: signature)
    }
    
//    public func featureDeltas() -> [FeatureContext:[ConditionalFeature]]? {
//        // Get latest timestamp and version/hash from local feature store
//        // Get features from remote FeatureSource that are greater than current version / timestamp
//        // Iterate through list of deltas & update local PLIST, user defaults
//        // Push out notification updates ?? Property observers ??
//        return [:]
//    }
    
}