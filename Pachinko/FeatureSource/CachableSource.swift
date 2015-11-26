//
//  CachableSource.swift
//  Pachinko
//
//  Created by Tim Antrobus on 19/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol CachableSource: FeatureSource {
    func context(forKey contextKey: String) -> FeatureContext?
}

extension CachableSource {
    subscript(key: String) -> FeatureContext? {
        return context(forKey: key)
    }
}