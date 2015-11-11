//
//  DefaultsBackedFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct DefaultsBackedFeatureSource: FeatureSource, NSDefaultsFeatureMapper, PListFeatureReader {
    
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
    
    // MARK: -
    // TODO: -
    
    public func activeVersion() -> String {
        // Derive max activeVersion from each Context
        return "1.0.0"
    }

}