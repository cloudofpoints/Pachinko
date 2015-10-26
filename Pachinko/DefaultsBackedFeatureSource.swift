//
//  DefaultsBackedFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 25/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol DefaultsBackedFeatureSource {
    
    mutating func persistFeatures(pListName: String, featureBundle: NSBundle, domain: String) -> ()
    
}

public extension DefaultsBackedFeatureSource {
    
    public mutating func persistFeatures(pListName: String = "Pachinko",
                                        featureBundle: NSBundle = NSBundle.mainBundle(),
                                        domain: String = "com.cloudofpoints.pachinko") -> () {
        
        guard let featuresURL = featureBundle.URLForResource(pListName, withExtension:"plist") else {
            print("Unable to locate \(pListName).plist in bundle \(featureBundle.description)")
            return
        }
        
        guard let featuresDict = NSDictionary(contentsOfURL: featuresURL) as? Dictionary<String,AnyObject> else {
            print("Unable to create dictionary from resource URL : \(featuresURL)")
            return
        }
        
//        guard let pachinkoDefaults = NSUserDefaults(suiteName: domain) else {
//            print("Unable to initialise NSUserDefaults with suiteName : \(domain)")
//            return
//        }
        
        //pachinkoDefaults.registerDefaults(featuresDict)
        
        let pachinkoDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        pachinkoDefaults.setPersistentDomain(featuresDict, forName: domain)
    }
}