//
//  ViewController.swift
//  MBaasKitTest
//
//  Created by Timothy Barnard on 26/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit
import MBaaSKit

class ViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfCounty: UITextField!
    @IBOutlet weak var sendFriend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendFriend.isEnabled = false
        self.tfName.delegate = self
        self.tfAge.delegate = self
        self.tfDOB.delegate = self
        self.tfCountry.delegate = self
        self.tfCounty.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sendFriend(_ sender: Any) {
        
        let newFriend = Friends(name: self.tfName.text!,
                                age: Int(self.tfAge.text!)!,
                                dob: self.tfDOB.text!,
                                country: self.tfCountry.text!,
                                county: self.tfCounty.text!)
        
        newFriend.sendInBackground("") { (sent, data) in
            DispatchQueue.main.async {
                if sent {
                    print("sent")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.sendFriend.isEnabled = ( self.tfName.text != "" ) &&
            ( self.tfDOB.text != "") &&
            ( self.tfAge.text != "") &&
            ( self.tfCountry.text != "" ) &&
            ( self.tfCounty.text != "")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
