//
//  Constants.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/3/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class Constants: NSObject {

   
    // MARK: OTM
    struct OTM {
        static let ApiScheme = "https"
        static let ApiHost_Udacity = "udacity.com"
        static let ApiPath_Udacity = "/api"
        static let ApiHost_Parse = "parse.udacity.com"
        static let ApiPath_Parse = "/parse/classes/StudentLocation"
    }
    
    // MARK: Methods
    struct Methods {
        // MARK: Account
        static let session = "/session"
        
    }
    
    // MARK: OTM Parameter Keys
    struct OTMParameterKeys {
        static let Username = "username"
        static let Password = "password"
    }
    

    // MARK: OTM Response Keys
    struct OTMResponseKeys {
        static let ID = "id"
        static let Session = "session"
//        static let UserID = "id"
//        static let Results = "results"
    }
        

    
    
        
}
