//
//  PListFeatureReader.swift
//  Pachinko
//
//  Created by Tim Antrobus on 01/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public enum PListFeatureReaderError: ErrorType {
    case InvalidPListName(detail: String)
}

public protocol PListFeatureReader {
    func featuresFromPList(pListName: String, featureBundle: NSBundle) throws -> [String:AnyObject]?
}

public extension PListFeatureReader {
    
    public func featuresFromPList(pListName: String = "Pachinko", featureBundle: NSBundle = NSBundle.mainBundle()) throws -> [String:AnyObject]? {
    
        guard let plistPath = featureBundle.pathForResource(pListName, ofType: "plist") else {
            throw PListFeatureReaderError.InvalidPListName(detail: "Unable to locate \(pListName).plist in bundle \(featureBundle.description)")
        }
        
        if let features = NSDictionary(contentsOfFile: plistPath) as? [String : AnyObject] {
            return features
        } else {
            return .None
        }
    }
}