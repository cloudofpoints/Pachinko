//
//  Versionable.swift
//  Pachinko
//
//  Created by Tim Antrobus on 15/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol Versionable {
    func activeVersion() -> FeatureVersion?
}
