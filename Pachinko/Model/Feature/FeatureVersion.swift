//
//  FeatureVersion.swift
//  Pachinko
//
//  Created by Tim Antrobus on 15/11/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public func ==(lhs: FeatureVersion, rhs: FeatureVersion) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public func <(lhs: FeatureVersion, rhs: FeatureVersion) -> Bool {
    return lhs.major < rhs.major && lhs.minor < rhs.minor && lhs.patch < rhs.patch
}

public struct FeatureVersion: Hashable, Comparable {
    public let major: Int
    public let minor: Int
    public let patch: Int
    public var hashValue: Int {
        return (31 &* major.hashValue) &+ minor.hashValue &+ patch.hashValue
    }
    
    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public init?(version: String){
        guard let versionTokens: [String] = version.componentsSeparatedByString(".") else {
            return nil
        }
        
        if versionTokens.count != 3 {
            return nil
        }
        
        guard let majorNum = Int(versionTokens[0]),
                    minorNum = Int(versionTokens[1]),
                    patchNum = Int(versionTokens[2]) else {
            return nil
        }
        
        self.major = majorNum
        self.minor = minorNum
        self.patch = patchNum

    }
    
    public init?(major: String, minor: String, patch: String) {
        if let majorNum = Int(major), minorNum = Int(minor), patchNum = Int(patch) {
            self.major = majorNum
            self.minor = minorNum
            self.patch = patchNum
        } else {
            return nil
        }
    }
    
    public func description() -> String {
        return "\(major).\(minor).\(patch)"
    }
}