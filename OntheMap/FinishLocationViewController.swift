//
//  FinishLocationViewController.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/9/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import CoreLocation
import UIKit
import MapKit

class FinishLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var locationText : String?
    var mediaURL: String?
    var firstName : String?
    var lastName : String?
    let dateformatter = DateFormatter()
    override func viewDidLoad() {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationText!) { (placemark, error) in
            guard  error == nil else{
                OTMClient.sharedInstance().alert(self,"Alert", "Encountered a problem")
                return
            }
            
            guard let location = placemark else{
                OTMClient.sharedInstance().alert(self,"Alert", "No such place exists")
                return
            }
            
            var locCoordinates: CLLocation?
            locCoordinates = location.first?.location
            let annotation = MKPointAnnotation()
            if let coordinates = locCoordinates {
                self.mapView.delegate = self
                let coordinate = coordinates.coordinate
                OTMClient.sharedInstance().appdelegate?.latitude = coordinate.latitude
                OTMClient.sharedInstance().appdelegate?.longitude = coordinate.longitude
                self.firstName =   OTMClient.sharedInstance().appdelegate?.firstName
                self.lastName =   OTMClient.sharedInstance().appdelegate?.lastName
                
                annotation.coordinate = coordinate
                if let firstName = self.firstName, let lastName = self.lastName {
                    annotation.title = "\(firstName) \(lastName)"
                }
                annotation.subtitle = self.mediaURL
                self.mapView.addAnnotation(annotation)
                self.mapView.showAnnotations([annotation], animated: true)
            } else {
                print("Coordinates could not be set.")
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    
    
    @IBAction func updateStudentLocation(_ sender: Any) {
        let jsonBody =  "{\"uniqueKey\": \"\((OTMClient.sharedInstance().appdelegate?.accountId)!)\", \"firstName\": \"\((OTMClient.sharedInstance().appdelegate?.firstName)!)\", \"lastName\": \"\((OTMClient.sharedInstance().appdelegate?.lastName)!)\",\"mapString\": \"\((self.locationText)!)\", \"mediaURL\": \"\(mediaURL!)\",\"latitude\": \((OTMClient.sharedInstance().appdelegate?.latitude)!), \"longitude\": \((OTMClient.sharedInstance().appdelegate?.longitude)!)}"
        let parameters = [String: AnyObject]()
        let objectId = OTMClient.sharedInstance().appdelegate?.objectId
        var api_name : String? = nil
        var method : String? = nil
        
        if  !((objectId?.isEmpty)!) {
            api_name = "PUT"
            method = "/\((objectId)!)"
            
        }else{
            api_name = "POST"
            method = ""
        }
        
        _ = OTMClient.sharedInstance().taskForPOSTMethod(method!, parameters: parameters, jsonBody: jsonBody, api_name!) { (results, error) in
            
            guard error == nil else{
                OTMClient.sharedInstance().alert(self, "Alert", (error?.localizedDescription)!)
                return
            }
            
            guard let results = results else{
                OTMClient.sharedInstance().alert(self, "Alert", "Can't update data")
                return
            }
            print(results)
            
            if api_name == "PUT"{
                if let updatedAt = results["updatedAt"] as? String {
                    performUIUpdatesOnMain {
                        OTMClient.sharedInstance().appdelegate?.updatedAt = self.dateformatter.date(from: updatedAt)
                    }
                }
            }else{
                if let _ = results["objectId"] as? String, let createdAt = results["createdAt"] as? String {
                    performUIUpdatesOnMain {
                        OTMClient.sharedInstance().appdelegate?.createdAt = self.dateformatter.date(from: createdAt)
                    }
                }
            }
            
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
}
