//
//  StubUserProfile.swift
//  Pachinko
//
//  Created by Tim Antrobus on 17/10/2015.
//  Copyright © 2015 cloudofpoints. All rights reserved.
//

public enum UserLocation {
    case EU,GB,IE,US
}

public enum UserProduct {
    case Broadband, Landline, Mobile, TV
}

public struct StubUserProfile {
    
    public let firstName: String
    public let surname: String
    public let location: UserLocation
    public let products: [UserProduct]
    
    public init(firstName: String, surname: String, location: UserLocation, products: [UserProduct]) {
        self.firstName = firstName
        self.surname = surname
        self.location = location
        self.products = products
    }
    
    public func isROI() -> Bool {
        return self.location == .IE
    }
    
    public func isTVOnly() -> Bool {
        return self.products.count == 1 && self.products.contains(.TV)
    }
    
    
}
