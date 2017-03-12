//
//  MainTableViewController.swift
//  MBaasKitTest
//
//  Created by Timothy Barnard on 26/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit
import MBaaSKit

class MainTableViewController: RCTableViewController {

    var allFriends = [Friends]()
    
    override func viewWillAppear(_ animated: Bool) {
        //self.getConfigVersion()
        self.getAllFriends()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.tableView.tableFooterView = UIView()
        self.setupTableViewController(className: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllFriends() {
        
        self.allFriends.getAllInBackground(ofType: Friends.self) { (completed, friends) in
            
            DispatchQueue.main.async {
                if completed {
                    self.allFriends = friends
                    self.tableView.reloadData()
                    print("retrieved")
                }
            }
        }
    }
    
    func getConfigVersion() {
        
        RCConfigManager.getConfigVersion { (complete, message) in
            DispatchQueue.main.async {
                if complete {
                    print("config recieve")
                }
            }
        }
    }
    
    @IBAction func addNewFriend(_ sender: Any) {
        
        self.performSegue(withIdentifier: "editFriend", sender: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allFriends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! RCTableViewCell
        
        cell.setupCellView(className: self, name: "cell")
        
        cell.textLabel?.text = self.allFriends[indexPath.row].name
        cell.detailTextLabel?.text = self.allFriends[indexPath.row].country
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editFriend", sender: self.allFriends[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: false)

    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert { 
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
     MARK: - Navigation

     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "editFriend" {
            
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.friend = sender as? Friends
            }
        }
    }
    
    @IBAction func updateConfigFile(_ sender: Any) {
        self.addAlertSheet()
    }
    
    func showMessage(title:String, message: String ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
    
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
}

extension MainTableViewController {
    
    func updateViews() {
        RCConfigManager.updateConfigFileNames(fileType: .config)
        RCConfigManager.updateNavigationBar(className: self,objectName: "navBar");
        self.tableView.reloadData()
        self.setupTableViewController(className: self)
    }
    
    func addAlertSheet( ) {
        TBAnalytics.send(self)
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        for (_, theme ) in RCConfigManager.getThemesList().enumerated() {
            
            let langAction = UIAlertAction(title: theme, style: .default, handler: { (action) -> Void in
                self.getDiffLanguage(theme: theme)
            })
            
            alertController.addAction(langAction)
        }
        
        let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }
        
        alertController.addAction(buttonCancel)
        
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.sourceView = self.view
        //alertController.popoverPresentationController?.sourceRect = sender.
        
        present(alertController, animated: true, completion: nil)
    }
    
    func getDiffLanguage( theme: String ) {
        
        //if RCNetwork.isInternetAvailable() {
        RCConfigManager.getConfigThemeVersion(theme: theme) { ( complete, message) in
            DispatchQueue.main.async {
                if complete {
                    print(theme)
                    self.updateViews()
                    self.showMessage(title: "Theme", message: theme + " successfully downloaded")
                }
            }
        }
        
    }

    
}
