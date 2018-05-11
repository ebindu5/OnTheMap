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
    
    var locations = [[String: AnyObject]]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    //
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OTMClient.sharedInstance().getStudentLocations({ (success, locations, error) in
            if success{
                performUIUpdatesOnMain {
                    self.locations = (OTMClient.sharedInstance().appdelegate?.locations)!
                    OTMClient.sharedInstance().appdelegate?.locations =  locations
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        OTMClient.sharedInstance().deletingSession { (success, message, error) in
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
        
        OTMClient.sharedInstance().getStudentLocations({ (success, locations, error) in
            if success{
                OTMClient.sharedInstance().appdelegate?.locations =  locations
            }
        })
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath)
        let location = locations[(indexPath as NSIndexPath).row]
        if let firstname = location["firstName"], let lastname = location["lastName"] {
            cell.textLabel?.text = (firstname as! String) + " " + (lastname as! String)
        }
        if let mediaURL = location["mediaURL"]{
            cell.detailTextLabel?.text = mediaURL as? String
        }
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var can_not_open = true
        let location = locations[(indexPath as NSIndexPath).row]
        if let mediaURL = location["mediaURL"], let url = URL(string: mediaURL as! String){
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