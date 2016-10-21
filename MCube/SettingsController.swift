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
        
        
        if let name = UserDefaults.standard.string(forKey: NAME) {
            EmpName.text="\(name)"
        }
        if let email = UserDefaults.standard.string(forKey: EMAIL) {
            EmpEmail.text="\(email)"
        }
        if let contact = UserDefaults.standard.string(forKey: EMP_CONTACT) {
            EmpNumber.text="\(contact)"
        }
        if let businessname = UserDefaults.standard.string(forKey: BUSINESS_NAME) {
            BusinessName.text="\(businessname)"
        }
        if let limit = UserDefaults.standard.string(forKey: LIMIT) {
            LimitText.text="\(limit)"
        }
        
        
        
        
    }
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogoutTap(_ sender: AnyObject) {
        self.LogoutAlert()
    }
    
    
    @IBAction func SaveClick(_ sender: AnyObject) {
        if((LimitText.text?.isEmpty) != nil && NSString(string: LimitText.text!).length > 0 && NSString(string: LimitText.text!).length < 4){
            self.navigationController?.view.makeToast("Saved Sucessfully", duration: 2.0, position: .bottom, title: nil, image: nil, style: nil, completion: nil)
            UserDefaults.standard.set(LimitText.text, forKey: LIMIT)
            UserDefaults.standard.synchronize()
        }
            
        else if(NSString(string: LimitText.text!).length > 3) {
            
        self.navigationController?.view.makeToast("Limit must be less than 100", duration: 2.0, position: .bottom, title: nil, image: nil, style: nil, completion: nil)
        }
        else {
            self.navigationController?.view.makeToast("Limit cannot be empty", duration: 2.0, position: .bottom, title: nil, image: nil, style: nil, completion: nil)
          }
    }
    
    
    
    func showAlert(_ mesage :String){
        //dismissViewControllerAnimated(true, completion: nil)
        let alertView = UIAlertController(title: "MCube", message: mesage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    func LogoutAlert (){
        let alertController = UIAlertController(title: "Logout Alert", message:
            "Do you want to logout?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Logout", style: UIAlertActionStyle.default) {
            UIAlertAction in
            UserDefaults.standard.removeObject(forKey: AUTHKEY)
            UserDefaults.standard.synchronize()
            self.performSegue(withIdentifier: "GoLogin", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: false, completion: nil)
        
    }
    
    
}
