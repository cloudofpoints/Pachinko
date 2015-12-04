//
//  DynamicCacheingFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct DynamicCacheingFeatureSource: FeatureSource, Versionable {

    var featureCache: CachableSource
    var remoteFeatureSource: DeltaCapableFeatureSource?
    
    public init(source: CachableSource = DefaultsBackedFeatureSource(), remoteSource: DeltaCapableFeatureSource) {
        featureCache = source
        remoteFeatureSource = remoteSource
        featureCache.refresh()
    }
    
    public func activeFeature(context: FeatureContext, signature: FeatureSignature) -> ConditionalFeature? {
        return featureCache.activeFeature(context, signature: signature)
    }
    
    public mutating func refresh() {
    
        if let maxVersion = activeVersion(),
            let remoteSource = remoteFeatureSource {
            
            deltaLoop: do {
            
                guard let deltas = try remoteSource.featureDeltas(maxVersion) else {
                    break deltaLoop
                }

                for (contextKey,deltaContext) in deltas {
                    featureCache[contextKey] = deltaContext
                }

                
            } catch let remoteError as FeatureSourceError {
                print("Failed to load feature deltas from remote source : \(remoteError)")
            } catch {
                print("Failed to load feature deltas due to unknown error")
            }
            
        }


        // Refresh local cache
        featureCache.refresh()
    }
    
    public func activeVersion() -> FeatureVersion? {
        return featureCache.activeVersion()
    }
        
}