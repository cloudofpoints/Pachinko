//
//  FeaturePredicate.swift
//  Pachinko
//
//  Created by Antrobus, Tim on 12/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol FeaturePredicate {
    func evaluate() -> Bool
}
