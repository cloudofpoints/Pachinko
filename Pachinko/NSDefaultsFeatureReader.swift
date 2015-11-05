//
//  NSDefaultsFeatureReader.swift
//  Pachinko
//
//  Created by Tim Antrobus on 04/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol NSDefaultsFeatureReader {
    func featuresByContext() -> [FeatureContext: [ConditionalFeature]]?
    func featureContextFromDefaultsItem(entry: [String:AnyObject]) -> FeatureContext?
    func featureFromDefaultsItem(featureDict: [String:String]) -> ConditionalFeature?
}