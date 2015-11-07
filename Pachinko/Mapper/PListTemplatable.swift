//
//  PListTemplatable.swift
//  Pachinko
//
//  Created by Tim Antrobus on 07/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol PListTemplatable {
    func plistTemplate() -> NSDictionary
    init?(template: NSDictionary?)
}