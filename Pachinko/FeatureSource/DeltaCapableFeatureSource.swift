//
//  DeltaCapableFeatureSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 10/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public enum FeatureSourceError: ErrorType {
    case InvalidVersion(version: FeatureVersion)
}

public protocol DeltaCapableFeatureSource: FeatureSource {
    func featureDeltas(forVersion: FeatureVersion) throws -> [String:FeatureContext]?
}