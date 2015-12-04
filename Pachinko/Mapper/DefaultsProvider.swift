//
//  DefaultsProvider.swift
//  Pachinko
//
//  Created by Tim Antrobus on 03/12/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

import Foundation

public protocol DefaultsProvider {
    func defaultsDictionary(forDomain domain: String) -> [String:AnyObject]?
    func purgeDefaults(forDomain domain: String) -> Void
    func writeDefaults(defaultsDictionary defaults: [String:AnyObject], forDomain domain: String) -> Void
}

extension DefaultsProvider {
    
    public func defaultsDictionary(forDomain domain: String) -> [String:AnyObject]? {
        guard let defaults = NSUserDefaults.standardUserDefaults().persistentDomainForName(domain) else {
            return .None
        }
        return defaults
    }
    
    public func purgeDefaults(forDomain domain: String) -> Void {
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(domain)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func writeDefaults(defaultsDictionary defaults: [String:AnyObject], forDomain domain: String) -> Void {
        NSUserDefaults.standardUserDefaults().setPersistentDomain(defaults, forName: domain)
        NSUserDefaults.standardUserDefaults().synchronize()        
    }
    
}