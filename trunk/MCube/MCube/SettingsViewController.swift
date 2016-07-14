//
//  SettingsViewController.swift
//  MCube
//
//  Created by Mukesh Jha on 14/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var LimitTextField: UITextField!
    @IBOutlet weak var empEmail: UILabel!
    @IBOutlet weak var EmpNumber: UILabel!
    @IBOutlet weak var empBusinessName: UILabel!
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }

  
    @IBAction func LogoutTap(sender: AnyObject) {
    }
    
    
    @IBAction func SaveClick(sender: AnyObject) {
    }

   

}
