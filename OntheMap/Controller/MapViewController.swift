//
//  MapViewController.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/3/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!

    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if StudentsDatasource.locations != nil{
            self.reloadMap()
        }else{
            studentLocations()
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        OTMClient.deletingSession { (success, message, error) in
            if success{
                print("success")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                performUIUpdatesOnMain {
                    self.present(vc!, animated: false, completion: nil)
                }
            }
        }
    }
    
    
    
    @IBAction func refreshData(_ sender: Any) {
        studentLocations()
        reloadMap()
    }
    
    func reloadMap(){
        if !annotations.isEmpty {
            mapView.removeAnnotations(annotations)
            annotations.removeAll()
        }
        
        for dictionary in StudentsDatasource.locations! {
            
            var lat = Double()
            var long = Double()
            var mediaURL = String()
            var first = String()
            var last = String()
            
            if let lati = self.nullToNil(value: dictionary.latitude as AnyObject){
                lat = CLLocationDegrees(lati as! Double)
            }
            
            if let longi = self.nullToNil(value: dictionary.longitude as AnyObject){
                long = CLLocationDegrees(longi as! Double)
            }
            
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            if  let firstn = self.nullToNil(value: dictionary.firstName as AnyObject) {
                first = firstn as! String
            }
            
            if  let lastn = self.nullToNil(value: dictionary.lastName as AnyObject) {
                last = lastn as! String
            }
            
            
            if  let media = self.nullToNil(value: dictionary.mediaURL as AnyObject)  {
                mediaURL = media as! String
            }
            
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            self.annotations.append(annotation)
            
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(self.annotations)
    }
    
    func studentLocations(){
        OTMClient.getStudentLocations { (success, locations, error) in
            performUIUpdatesOnMain {
                if success{
                    self.reloadMap()
                }else{
                    OTMClient.alert(self, "Error", error!)
                }
            }
        }
        
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    
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
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}

extension MapViewController{
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    } 
}
