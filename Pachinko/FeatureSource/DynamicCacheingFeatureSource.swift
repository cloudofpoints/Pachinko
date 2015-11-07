//
//  DynamicCacheingFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct DynamicCacheingFeatureSource: FeatureSource {

    var featureCache: FeatureSource?
    
    public init(source: FeatureSource = DefaultsBackedFeatureSource()) {
        featureCache = source
        featureCache?.refresh()
    }
    
    public func activeFeature(context: FeatureContext, signature: FeatureSignature) -> ConditionalFeature? {
        return featureCache?.activeFeature(context, signature: signature)
    }
    
    public mutating func refresh() {
        featureCache?.refresh()
    }
        
}