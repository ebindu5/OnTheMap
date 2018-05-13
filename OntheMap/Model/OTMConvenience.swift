//
//  OTMConvenience.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/3/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension OTMClient {
    
    func getUserData(_ account_id: String, _ completionHandlerForGetUserData: @escaping(_ success: Bool, _ results: AnyObject?, _ error: NSError?)-> Void){
        let parameters = [String:AnyObject]()
        
        let _ = OTMClient.sharedInstance().taskForGETMethod("/users/\(account_id)", parameters, "UDACITY_API"){
            (results,error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetUserData(false, nil, error)
            } else {
                completionHandlerForGetUserData(true, results, nil)
            }
        }
    }
    
    
    
    func postingSession(_ username : String, _ password: String, _ completionHandlerForPostSession: @escaping (_ success: Bool, _ session_id: String?, _ account_key: String?, _ errorString: String?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let _ = OTMClient.sharedInstance().taskForPOSTMethod(Constants.Methods.session, parameters: parameters, jsonBody: jsonBody, "UDACITY_API"){
            (results,error) in
            
            guard error == nil else{
                 completionHandlerForPostSession(false, nil, nil, (error?.localizedDescription)!)
                return
            }
                if let session = results?[Constants.OTMResponseKeys.Session] as? [String: AnyObject], let session_id = session[Constants.OTMResponseKeys.ID] as? String, let account = results?["account"] as? [String: AnyObject], let account_id = account["key"] as? String{
                    completionHandlerForPostSession(true, session_id, account_id, nil)
                } else {
                    print("Could not find \(Constants.OTMResponseKeys.Session) in \(results!)")
                    completionHandlerForPostSession(false, nil,nil, (error?.localizedDescription)!)
                }
            
        }
    }
    
    
    func deletingSession( _ completionHandlerForDeleteSession: @escaping (_ success: Bool, _ session_id: String?, _ errorString: String?) -> Void){
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            completionHandlerForDeleteSession(true,String(data: newData!, encoding: .utf8)!, nil)
        }
        task.resume()
    }
    
    func alert(_ vc: UIViewController,_  title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func getObjectId( _ completionHandlerForGetObject: @escaping (_ success: Bool, _ result: String?, _ errorString: NSError?) -> Void){
        
        let  method = "GET"
        let parameters = [String: AnyObject]()
        let _ = OTMClient.sharedInstance().taskForGETMethod(method,parameters, "PARSE_API"){
            (results,error) in
            if let error = error {
                completionHandlerForGetObject(false,nil,error)
            } else {
                if let results = results!["results"] as? [AnyObject]{
                    var count = results.count
                    if count == 0{
                        OTMClient.sharedInstance().appdelegate?.objectId = ""
                        completionHandlerForGetObject(true,"",nil)
                    }else{
                        count = count - 1
                        if  let data = results[count] as? [String: AnyObject], let object_id = data["objectId"] as? String{
                            OTMClient.sharedInstance().appdelegate?.objectId = object_id
                            completionHandlerForGetObject(true,object_id,nil)
                            
                        }
                    }
                }
                
            }
        }
    }
    
}
