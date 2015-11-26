//
//  DefaultsBackedFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct DefaultsBackedFeatureSource: CachableSource, NSDefaultsFeatureMapper, PListFeatureReader {
    
    static let pachinkoPListName = "Pachinko"
    static let pachinkoDefaultsDomain = "com.cloudofpoints.pachinko"
    var featureCache: [String : FeatureContext]?
    
    public init(pListName: String = DefaultsBackedFeatureSource.pachinkoPListName,
                featureBundle: NSBundle = NSBundle.mainBundle()){
        loadFeaturesFromPList(pListName, featureBundle: featureBundle)
    }
    
    // MARK: - FeatureSource Protocol
    
    public func activeFeature(context: FeatureContext, signature: FeatureSignature) -> ConditionalFeature? {
        
        guard let matchedContext: FeatureContext = featureCache?[context.id] else {
            return .None
        }
        
        guard let activeFeatures = matchedContext.features else {
            return .None
        }

        return activeFeatures.filter({$0.signature == signature}).first
    }
    
    public mutating func refresh() {
        featureCache = featureContexts(DefaultsBackedFeatureSource.pachinkoDefaultsDomain)
    }
    
    // MARK: - CacheableSource Protocol
    
    public func context(forKey contextKey: String) -> FeatureContext? {
        guard let context =  featureCache?[contextKey] else {
            return .None
        }
        return context
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
    
    public func activeVersion() -> FeatureVersion? {
    
        guard let features = featureCache else {
            return .None
        }
        
        let contexts = Array(features.values)
        
        if let maxActiveVersion = contexts.map({$0.activeVersion()}).flatMap({$0}).maxElement() {
            return maxActiveVersion
        } else {
            return .None
        }
    }

}