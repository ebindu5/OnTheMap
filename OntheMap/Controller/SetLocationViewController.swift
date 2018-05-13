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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var locationText : UITextField!
    @IBOutlet var mediaURL: UITextField!
    var currentTextField : UITextField!
    @IBAction func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        locationText.delegate = self
        mediaURL.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        if !(OTMClient.sharedInstance().appdelegate?.objectId?.isEmpty)!{
            let alert = UIAlertController(title: "", message: "You have alreay posted a student location. Would you like to overwrite your current location?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
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
    
    
}

extension SetLocationViewController{
    
   @IBAction func userDidTapView(_ sender: AnyObject) {
//        resignIfFirstResponder(usernameTextField)
//        resignIfFirstResponder(passwordTextField)
    }
    
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
//        if (currentTextField == locationText){
//            view.frame.origin.y -= locationText.frame.origin.y
//        }else{
//            view.frame.origin.y -= mediaURL.frame.origin.y
//        }
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
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == locationText{
//            currentTextField = locationText
//        }else if textField == mediaURL{
//            currentTextField = mediaURL
//        }
//
//    }
    
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
