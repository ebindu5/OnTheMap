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
    var latitude : Double?
    var longitude: Double?
    
    @IBOutlet weak var loadImageView: UIImageView!
    override func viewDidLoad() {
        
        let geoCoder = CLGeocoder()
        loadImageView.isHidden = false
        geoCoder.geocodeAddressString(locationText!) { (placemark, error) in
            self.loadImageView.isHidden = true
            guard  error == nil else{
                OTMClient.alert(self,"Alert", "Encountered a problem")
                return
            }
            
            guard let location = placemark else{
                OTMClient.alert(self,"Alert", "No such place exists")
                return
            }
            
            var locCoordinates: CLLocation?
            locCoordinates = location.first?.location
            let annotation = MKPointAnnotation()
            if let coordinates = locCoordinates {
                self.mapView.delegate = self
                let coordinate = coordinates.coordinate
                self.latitude = coordinate.latitude
                self.longitude = coordinate.longitude
                self.firstName =   StudentsDatasource.userFirstName
                self.lastName =   StudentsDatasource.userLastName
                
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
        let jsonBody =  "{\"uniqueKey\": \"\((StudentsDatasource.accountId)!)\", \"firstName\": \"\((StudentsDatasource.userFirstName)!)\", \"lastName\": \"\((StudentsDatasource.userLastName)!)\",\"mapString\": \"\((self.locationText)!)\", \"mediaURL\": \"\(mediaURL!)\",\"latitude\": \((self.latitude)!), \"longitude\": \((self.longitude)!)}"
        let parameters = [String: AnyObject]()
        let objectId = StudentsDatasource.objectId
        var api_name : String? = nil
        var method : String? = nil
        
        if  !((objectId?.isEmpty)!) {
            api_name = "PUT"
            method = "/\((objectId)!)"
            
        }else{
            api_name = "POST"
            method = ""
        }
        
        _ = OTMClient.taskForPOSTMethod(method!, parameters: parameters, jsonBody: jsonBody, api_name!) { (results, error) in
            
            guard error == nil else{
                OTMClient.alert(self, "Alert", (error?.localizedDescription)!)
                return
            }
            
            guard results != nil else{
                OTMClient.alert(self, "Alert", "Can't update data")
                return
            }
            
            performUIUpdatesOnMain {
                StudentsDatasource.locations = nil
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
}
