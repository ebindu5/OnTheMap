//
//  MapTableViewController.swift
//  OntheMap
//
//  Created by NISHANTH NAGELLA on 5/8/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MapTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if StudentsDatasource.locations != nil {
            tableView.reloadData()
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
        tableView.reloadData()
    }
    
    func studentLocations(){
        OTMClient.getStudentLocations({ (success, locations, error) in
            guard error == nil else{
                OTMClient.alert(self, "Error", error!)
                return
            }
            if success{
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (StudentsDatasource.locations?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath)
        let location = StudentsDatasource.locations![(indexPath as NSIndexPath).row]
        if let firstname = location.firstName, let lastname = location.lastName {
            cell.textLabel?.text = (firstname ) + " " + (lastname )
        }
        if let mediaURL = location.mediaURL{
            cell.detailTextLabel?.text = mediaURL
        }
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var can_not_open = true
        let location = StudentsDatasource.locations![(indexPath as NSIndexPath).row]
        if let mediaURL = location.mediaURL, let url = URL(string: mediaURL ){
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                can_not_open = false
            }
        }
        
        if can_not_open {
            let alert = UIAlertController(title: "Alert", message: "Invalid Media URL", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

}
