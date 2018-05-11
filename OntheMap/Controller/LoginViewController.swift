//
//  LoginViewController.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/3/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var debugText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginEmail.delegate = self
        loginPassword.delegate = self
    }

    @IBAction func signUp(_ sender: Any) {
        let url = "https://www.udacity.com/account/auth#!/signup"
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        OTMClient.sharedInstance().postingSession(loginEmail.text!, loginPassword.text!){
            (success, session_id,account_id, error ) in
            performUIUpdatesOnMain {
                if success {
                    let appdelegate = UIApplication.shared.delegate as? AppDelegate
                   appdelegate?.sessionId =   session_id
                    appdelegate?.accountId = account_id
                    OTMClient.sharedInstance().getUserData(account_id!){ (success, results, error) in
                            if let user = results?["user"] as? [String: AnyObject]{
                                if let firstName = user["first_name"] as? String{
                                    appdelegate?.firstName = firstName
                                }
                                if let lastName = user["last_name"] as? String{
                                    appdelegate?.lastName = lastName
                                }
                                
                                OTMClient.sharedInstance().getObjectId{(success, object_id, error) in
                                    if success{
                                       OTMClient.sharedInstance().appdelegate?.objectId = object_id!
                                    }
                                }
                            } 
                    }
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapTabBarController") as! UITabBarController
                    self.present(controller, animated: true, completion: nil)
                } else {
                   self.debugText.text = error?.localizedDescription
                }
            }
            
        }
    }
    
}

extension LoginViewController{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
//        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        unsubscribeFromAllNotifications()
//    }
//
//    private func keyboardHeight(_ notification: Notification) -> CGFloat {
//        let userInfo = (notification as NSNotification).userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.cgRectValue.height
//    }
//
//    private func resignIfFirstResponder(_ textField: UITextField) {
//        if textField.isFirstResponder {
//            textField.resignFirstResponder()
//        }
//    }
//
//    @objc func keyboardWillShow(_ notification: Notification) {
//            view.frame.origin.y -= keyboardHeight(notification)
//    }
//
//    @ objc func keyboardWillHide(_ notification: Notification) {
//            view.frame.origin.y = 0
//    }
//
//    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
//        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
//    }
//
//    func unsubscribeFromAllNotifications() {
//        NotificationCenter.default.removeObserver(self)
//    }
}

