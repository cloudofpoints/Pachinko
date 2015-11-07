//
//  BaseFeature.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public class BaseFeature : ConditionalFeature, PListTemplatable {
    public let signature: FeatureSignature
    public var status: FeatureStatus = FeatureStatus.Initialised
    
    public init(signature: FeatureSignature, status: FeatureStatus){
        self.signature = signature
        self.status = status
    }
    
    public convenience init(signature: FeatureSignature){
        self.init(signature: signature, status: FeatureStatus.Initialised)
    }
    
    public required init?(template: NSDictionary?) {
        
        guard let feature = template else  {
            self.signature = FeatureSignature.emptySignature()
            return nil
        }

        if let signature = FeatureSignature(template: feature),
            featureStatusStr = feature[FeaturePlistKey.FEATURE_STATUS.rawValue] as? String {
            
            self.signature = signature
            if let featureStatus = FeatureStatus(rawValue: featureStatusStr) {
                self.status = featureStatus
            }
        } else {
            self.signature = FeatureSignature.emptySignature()
            return nil
        }
    }
    
    public func plistTemplate() -> NSDictionary {
        let template: [String:AnyObject] = [:]
        return template
    }
}
