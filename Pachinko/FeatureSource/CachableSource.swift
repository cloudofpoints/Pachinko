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
    mutating func setContext(context: FeatureContext, forKey contextKey: String) -> Void
}

extension CachableSource {
    subscript(key: String) -> FeatureContext? {
    
        get {
            return context(forKey: key)
        }

        set(newValue){
            guard let newContextValue = newValue else {
                return
            }
            setContext(newContextValue, forKey: key)
        }

    }
}