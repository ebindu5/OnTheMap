//
//  LoginViewController.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/3/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var debugText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginEmail.delegate = self
        loginPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func signUp(_ sender: Any) {
        let url = "https://www.udacity.com/account/auth#!/signup"
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        OTMClient.postingSession(loginEmail.text!, loginPassword.text!){
            (success, session_id,account_id, error ) in
            performUIUpdatesOnMain {
                if success {
                    StudentsDatasource.sessionId = session_id
                    StudentsDatasource.accountId = account_id
                    OTMClient.getUserData(account_id!){ (success, results, error) in
                        if let user = results?["user"] as? [String: AnyObject]{
                            if let firstName = user["first_name"] as? String{
                                StudentsDatasource.userFirstName = firstName
                            }
                            if let lastName = user["last_name"] as? String{
                                StudentsDatasource.userLastName = lastName
                            }
                            
                            OTMClient.getObjectId{(success, object_id, error) in
                                if success{
                                    StudentsDatasource.objectId = object_id!
                                }
                            }
                        }
                    }
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapTabBarController") as! UITabBarController
                    self.present(controller, animated: true, completion: nil)
                } else {
                    self.debugText.text = error
                }
            }
            
        }
    }

 @IBAction func userDidTapView(_ sender: AnyObject) {
    resignIfFirstResponder(loginPassword)
    resignIfFirstResponder(loginEmail)
}
    
}

extension LoginViewController{
    
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
    
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    
    
}

