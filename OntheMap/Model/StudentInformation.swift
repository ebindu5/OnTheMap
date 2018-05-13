//
//  StudentInformation.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct StudentInformation{
    
    
    var firstName: String?
    var lastName : String?
    var permissions : [AnyObject]?
    var latitude : Double?
    var longitude: Double?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var mediaURL: String?
    var mapString : String?
    
    
    init(dictionary: [String: Any]) {
        
        if let mapString = dictionary["mapString"] as? String {
            self.mapString = mapString
        }
        
        if let mediaURL = dictionary["mediaURL"] as? String {
            self.mediaURL = mediaURL
        }
        
        
        if let firstName = dictionary["firstName"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = dictionary["lastName"] as? String {
            self.lastName = lastName
        }
        
        if let permissions = dictionary["permissions"] as? [AnyObject] {
            self.permissions = permissions
        }
        
        if let latitude = dictionary["latitude"] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = dictionary["longitude"] as? Double {
            self.longitude = longitude
        }
        
        if let objectId = dictionary["objectId"] as? String {
            self.objectId = objectId
        }
        
        if let createdAt = dictionary["createdAt"] as? Date {
            self.createdAt = createdAt
        }
        
        if let updatedAt = dictionary["updatedAt"] as? Date {
            self.updatedAt = updatedAt
        }
        
    }
    
}
