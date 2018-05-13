//
//  OTMClient.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/8/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation


class OTMClient {
    
    static func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, _ api_name: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request : URLRequest!
        
        if api_name == "UDACITY_API" {
            request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }else{
            request =   URLRequest(url: URL(string: ( "https://parse.udacity.com/parse/classes/StudentLocation" + method ))!)
            if api_name == "PUT"{
                request.httpMethod = "PUT"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }else{
                request.httpMethod = "POST"
            }
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        request.httpBody = jsonBody.data(using: .utf8)
        /* 4. Make the request */
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                //                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Username/Password incorrect")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if api_name == "UDACITY_API"{
                let range = Range(5..<data.count)
                data = data.subdata(in: range) /* subset response data! */
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        return task
        
        
    }
    
    // given raw JSON, return a usable Foundation object
    static func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    static func taskForGETMethod(_ method: String, _ parameters: [String:AnyObject], _ api_name: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        var request = NSMutableURLRequest(url: OTMURLFromParameters(parameters, api_name, withPathExtension: method))
        
        if api_name == "PARSE_API" {
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        /* 4. Make the request */
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if api_name == "UDACITY_API"{
                let range = Range(5..<data.count)
                data = data.subdata(in: range)
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        task.resume()
        return task
    }
    
    // create a URL from parameters
    static  func OTMURLFromParameters(_ parameters: [String:AnyObject], _ api_name : String, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.OTM.ApiScheme
        
        if api_name == "UDACITY_API" {
            components.host = Constants.OTM.ApiHost_Udacity
            components.path = Constants.OTM.ApiPath_Udacity + (withPathExtension ?? "")
        }else if api_name == "PARSE_API" {
            components.host = Constants.OTM.ApiHost_Parse
            
            if withPathExtension == "GET"{
                components.path = Constants.OTM.ApiPath_Parse
            }else{
                components.path = Constants.OTM.ApiPath_Parse + (withPathExtension ?? "")
            }
        }
        
        if withPathExtension == "GET"{
            components.query =  "where={\"uniqueKey\": \"\((StudentsDatasource.accountId)!)\"}"
        }else{
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    static func getStudentLocations( _ completionHandlerForGetStudentLocations: @escaping (_ success: Bool, _ locations : [StudentInformation], _ errorString: String?) -> Void) {
        
        
        let parameters = ["order" : "-updatedAt", "limit" : 100] as [String : AnyObject]
        
        let _ =  taskForGETMethod("", parameters, "PARSE_API") { (results, error) in
            
            if error != nil {
                completionHandlerForGetStudentLocations(false, [], "Unable to get student location Information")
            } else {
                if let results = results?["results"] as? [[String:AnyObject]]{
                    for studentInfo  in results{
                        if StudentsDatasource.locations == nil{
                            StudentsDatasource.locations = [StudentInformation(dictionary: studentInfo)]
                        }else{
                            StudentsDatasource.locations?.append(StudentInformation(dictionary: studentInfo))
                        }
                        
                    }
                    completionHandlerForGetStudentLocations(true, StudentsDatasource.locations!, nil)
                } else {
                    print("Could not find \(Constants.OTMResponseKeys.Session) in \(results!)")
                    completionHandlerForGetStudentLocations(false, [], "Unable to get student location Information")
                }
            }
            
        }
        
    }
    
    
    
    
}
