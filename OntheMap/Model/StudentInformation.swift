//
//  StudentInformation.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct StudentInformation{
    
    var sessionId : String?
    var accountId : String?
    var firstName: String?
    var lastName : String?
    var permissions : [AnyObject]?
    var latitude : Double?
    var longitude: Double?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    //sessionId : String?, accountId : String?, firstName: String?,  lastName : String?,  permissions : [AnyObject]?,  latitude : Double?, longitude: Double?,  objectId: String?, createdAt: Date?,  updatedAt: Date?
    init(dictionary: [String: Any]) {
        self.sessionId = dictionary["sessionId"] as? String
        self.accountId = dictionary["accountId"] as? String
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.permissions = dictionary["permissions"] as? [AnyObject]
        self.latitude = dictionary["latitude"] as? Double
        self.longitude = dictionary["longitude"] as? Double
        self.objectId = dictionary["objectId"] as? String
        self.createdAt = dictionary["createdAt"] as? Date
        self.updatedAt = dictionary["updatedAt"] as? Date
        
    }
    
}
