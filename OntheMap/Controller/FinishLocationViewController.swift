//
//  FinishLocationViewController.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/9/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

//import CoreLocation
import UIKit
import MapKit

class FinishLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadImageView: UIImageView!
    var locationText : String?
    var mediaURL: String?
    var firstName : String?
    var lastName : String?
    let dateformatter = DateFormatter()
    var latitude : Double?
    var longitude: Double?
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

            let annotation = MKPointAnnotation()
                self.mapView.delegate = self
                annotation.coordinate = self.coordinate!
                if let firstName = self.firstName, let lastName = self.lastName {
                    annotation.title = "\(firstName) \(lastName)"
                }
                annotation.subtitle = self.mediaURL
                self.mapView.addAnnotation(annotation)
                self.mapView.showAnnotations([annotation], animated: true)
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
    
    
}
