//
//  BaseFeature.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public struct SimpleFeature : ConditionalFeature {
    public let signature: FeatureSignature
    public var status = FeatureStatus.Initialised
    
    public init(signature: FeatureSignature, status: FeatureStatus){
        self.signature = signature
        self.status = status
    }
}
