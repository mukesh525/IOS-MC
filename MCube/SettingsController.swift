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
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        if let name = NSUserDefaults.standardUserDefaults().stringForKey("name") {
            EmpName.text="\(name)"
        }
        if let email = NSUserDefaults.standardUserDefaults().stringForKey("email") {
            EmpEmail.text="\(email)"
        }
        if let contact = NSUserDefaults.standardUserDefaults().stringForKey("empContact") {
            EmpNumber.text="\(contact)"
        }
        if let businessname = NSUserDefaults.standardUserDefaults().stringForKey("businessName") {
            BusinessName.text="\(businessname)"
        }
        if let limit = NSUserDefaults.standardUserDefaults().stringForKey("limit") {
            LimitText.text="\(limit)"
        }
        
        
        
        
    }
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogoutTap(sender: AnyObject) {
        self.LogoutAlert()
    }
    
    
    @IBAction func SaveClick(sender: AnyObject) {
        if((LimitText.text?.isEmpty) != nil && NSString(string: LimitText.text!).length > 0 && NSString(string: LimitText.text!).length < 4){
            self.navigationController?.view.makeToast("Saved Sucessfully", duration: 2.0, position: .Bottom, title: nil, image: nil, style: nil, completion: nil)
            NSUserDefaults.standardUserDefaults().setObject(LimitText.text, forKey: "limit")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
            
        else if(NSString(string: LimitText.text!).length > 3) {
            
        self.navigationController?.view.makeToast("Limit must be less than 100", duration: 2.0, position: .Bottom, title: nil, image: nil, style: nil, completion: nil)
        }
        else {
            self.navigationController?.view.makeToast("Limit cannot be empty", duration: 2.0, position: .Bottom, title: nil, image: nil, style: nil, completion: nil)
          }
    }
    
    
    
    func showAlert(mesage :String){
        //dismissViewControllerAnimated(true, completion: nil)
        let alertView = UIAlertController(title: "MCube", message: mesage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    func LogoutAlert (){
        let alertController = UIAlertController(title: "Logout Alert", message:
            "Do you want to logout?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Logout", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSUserDefaults.standardUserDefaults().removeObjectForKey("authkey")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.performSegueWithIdentifier("GoLogin", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: false, completion: nil)
        
    }
    
    
}
