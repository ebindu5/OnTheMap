//
//  SetLocationViewController.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/8/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class SetLocationViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var locationText : UITextField!
    @IBOutlet var mediaURL: UITextField!
    
    @IBAction func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        locationText.delegate = self
        mediaURL.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(OTMClient.sharedInstance().appdelegate?.objectId?.isEmpty)!{
            let alert = UIAlertController(title: "", message: "You have alreay posted a student location. Would you like to overwrite your current location?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func verifyDetails(_ sender: Any) {
        if !mediaURL.hasText  || !locationText.hasText{
            OTMClient.sharedInstance().alert(self,"Alert","Fill all entries")
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishLocationViewController") as? FinishLocationViewController
            
            vc?.locationText = locationText.text
            vc?.mediaURL = mediaURL.text
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
