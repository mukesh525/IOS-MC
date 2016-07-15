//
//  SettingsController.swift
//  MCube
//
//  Created by Mukesh Jha on 14/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var LimitText: UITextField!
    @IBOutlet weak var EmpEmail: UILabel!
    @IBOutlet weak var EmpNumber: UILabel!
    @IBOutlet weak var EmpName: UILabel!
    @IBOutlet weak var BusinessName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }    }
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogoutTap(sender: AnyObject) {
    }
   
 
     @IBAction func SaveClick(sender: AnyObject) {
     }
   
}
