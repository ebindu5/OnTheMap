//
//  SetLocationViewController.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/8/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SetLocationViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var locationText : UITextField!
    @IBOutlet var mediaURL: UITextField!
    @IBOutlet weak var loadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadImageView.isHidden = true
        locationText.delegate = self
        mediaURL.delegate = self
        if !(StudentsDatasource.objectId!.isEmpty){
            let alert = UIAlertController(title: "", message: "You have alreay posted a student location. Would you like to overwrite your current location?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func verifyDetails(_ sender: Any) {
        if !mediaURL.hasText  || !locationText.hasText{
            OTMClient.alert(self,"Alert","Fill all entries")
        }else{
            
             self.loadImageView.isHidden = false
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(locationText.text!) { (placemark, error) in
                guard  error == nil else{
                    OTMClient.alert(self,"Alert", "Encountered a problem")
                    self.loadImageView.isHidden = true
                    return
                }
                
                guard let location = placemark  else{
                    OTMClient.alert(self,"Alert", "No such place exists")
                     self.loadImageView.isHidden = true
                    return
                }
            
                performUIUpdatesOnMain {
                    self.loadImageView.isHidden = true
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishLocationViewController") as? FinishLocationViewController
                    var locCoordinates: CLLocation?
                    locCoordinates = location.first?.location
                    if let coordinates = locCoordinates {
                        let coordinate = coordinates.coordinate
                        vc?.coordinate = coordinates.coordinate
                        vc?.latitude = coordinate.latitude
                        vc?.longitude = coordinate.longitude
                        vc?.firstName =   StudentsDatasource.userFirstName
                        vc?.lastName =   StudentsDatasource.userLastName
                    } else {
                       OTMClient.alert(self,"Alert", "Coordinates could not be set")
                    }
                     vc?.locationText = self.locationText.text
                    vc?.mediaURL = self.mediaURL.text
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
           
            }
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
                resignIfFirstResponder(locationText)
                resignIfFirstResponder(mediaURL)
    }

}

extension SetLocationViewController{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - keyboard subscribe
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - keyboard unsubscribe
    func unsubscribeFromKeyboardNotifications() {
        // Removes all observers at once
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - keyboard show
    @objc func keyboardWillShow(_ notification:Notification) {
        let keyBoardHeight = getKeyboardHeight(notification)
        scrollView.contentInset.bottom = keyBoardHeight
    }
    
    // MARK: - keyboard hide
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: - keyboard Height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    

    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
}
