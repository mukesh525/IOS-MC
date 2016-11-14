//  Created by Mukesh Jha on 02/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.

import UIKit
//import SwiftValidator
import Alamofire
import BEMCheckBox




class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailerror: UILabel!
    @IBOutlet weak var passworderror: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMe: BEMCheckBox!
    fileprivate var showingActivity = false
   // let validator = Validator()
    var code:String?
    var authkey:String?
    var message:String?
    
    var empName:String?
    var empEmail:String?
    var ivrs:String?
    var lead:String?
    var mtracker:String?
    var pbx:String?
    var track:String?
    var businessName:String?
    var empContact:String?
    var showpassicon:UIImageView?
    var iconClick : Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loginButton.layer.cornerRadius = 10
        self.email.delegate = self;
        self.password.delegate = self;
        iconClick = true
        self.setShowHideIcon()
        if UserDefaults.standard.string(forKey: EMAIL_FIELD) != nil
            && UserDefaults.standard.string(forKey: PASS_FIELD) != nil
        {
            email.text=UserDefaults.standard.string(forKey: EMAIL_FIELD)
            password.text=UserDefaults.standard.string(forKey: PASS_FIELD)
            
        }
        
    }
    
    
    func imageTapped(_ img: AnyObject)
    {
        // Your action
       
        if(iconClick == true) {
            password.isSecureTextEntry = false
            iconClick = false
            showpassicon = UIImageView(image:UIImage(named: "show")!.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
            
        } else {
            password.isSecureTextEntry = true
            iconClick = true
            showpassicon = UIImageView(image:UIImage(named: "hide")!.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
        }
        
       
        showpassicon!.isUserInteractionEnabled=true;
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LoginViewController.imageTapped(_:)))
        showpassicon!.addGestureRecognizer(tapGestureRecognizer)
        password.rightViewMode = UITextFieldViewMode.always
        password.rightView = showpassicon
        
    }
    

//    override var prefersStatusBarHidden : Bool {
//        return true
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            password.becomeFirstResponder()
            return false
        }
        if textField == password {
            textField.resignFirstResponder()
            //validator.validate(self)
            return false
        }
        return true
    }
    
    
    @IBAction func LoginTap(_ sender: AnyObject) {
         if(validateFields()){
            validationSuccessful()
        }
        
    }
    
    
    
    func validateFields() -> Bool{
        return isValidEmail(testStr: email.text!)&&isValidPassword(testStr: password.text!)
      }
    
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if(!emailTest.evaluate(with: testStr)){
            self.emailerror.text = "Enter valid email"}
        else{
            self.emailerror.text = ""
         }
        
        return emailTest.evaluate(with: testStr)
    }
    
    
    func isValidPassword(testStr:String) -> Bool {
       if( testStr.characters.count<1){
            self.passworderror.text = "Password Cannot Be Empty"
            return false
        }
        else{
            self.passworderror.text = ""
            return true
        }
        
        
    }

    
    
    
    
    
    
    @IBOutlet weak var loginClick: UIButton!
    
    
    
    func validationSuccessful() {
        loginClick.isEnabled=false
        loginClick.setTitle("Authenticating..", for: UIControlState.disabled)
        emailerror.text="";
        passworderror.text="";
        self.showActivityIndicator()
       
        
        
        
        Alamofire.request(LOGIN_URL,method: .post, parameters: [EMAIL:email.text!, PASSWORD:password.text!]).validate().responseJSON
            {response in switch response.result {
                
            case .success(let JSON):
               
                self.loginClick.setTitle("Success..", for: UIControlState.disabled)
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                if((response.object(forKey: CODE)) != nil){
                    self.code=response.object(forKey: CODE)as? String;
                }
                if((response.object(forKey: MESSAGE)) != nil){
                    self.message=response.object(forKey: MESSAGE)as? String;
                    
                }
                if((response.object(forKey: AUTHKEY)) != nil){
                    self.authkey = response.object(forKey: AUTHKEY)! as? String
                }
                
                
                if((response.object(forKey: EMPNAME)) != nil){
                    self.empName = response.object(forKey: EMPNAME)! as? String
                    
                }
                
                if((response.object(forKey: EMPEMAIL)) != nil){
                    self.empEmail = response.object(forKey: EMPEMAIL)! as? String
                    
                }
                
                if((response.object(forKey: IVRS)) != nil){
                    self.ivrs = response.object(forKey: IVRS)! as? String
                    
                }
                
                if((response.object(forKey: LEAD)) != nil){
                    self.lead = response.object(forKey: LEAD)! as? String
                    
                }
                if((response.object(forKey: MTRACKER)) != nil){
                    self.mtracker = response.object(forKey: MTRACKER)! as? String
                    
                }
                if((response.object(forKey: MCUBEX)) != nil){
                    self.pbx = response.object(forKey: MCUBEX)! as? String
                    
                }
                if((response.object(forKey: TRACK)) != nil){
                    self.track = response.object(forKey: TRACK)! as? String
                    
                }
                if((response.object(forKey: BUSINESS_NAME)) != nil){
                    self.businessName = response.object(forKey: BUSINESS_NAME)! as? String
                    
                }
                if((response.object(forKey: EMP_CONTACT)) != nil){
                    self.empContact = response.object(forKey: EMP_CONTACT)! as? String
                    
                }
                
                
                
                //  print("code \(self.code)")
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                if (((error as NSError).code == -1009 )||((error as NSError).code == -1001 )) {
                    self.showAlert("No Internet Conncetion")
                }
                
                self.loginClick.isEnabled=true;
                self.showActivityIndicator()
                }
                if(self.code=="401"||self.code=="400"){
                    if(self.message != nil){
                        self.loginClick.isEnabled=true
                        self.showActivityIndicator()
                        self.showAlert(self.message!)
                    }
                }
                if(self.code=="200"){
                    if(self.message != nil){
                        self.loginClick.setTitle("Success..", for: UIControlState.disabled)
                        // self.showActivityIndicator()
                        UserDefaults.standard.set(self.empName, forKey: NAME)
                        UserDefaults.standard.set(self.empEmail, forKey: EMAIL)
                        UserDefaults.standard.set(self.authkey, forKey: AUTHKEY)
                        UserDefaults.standard.set(self.empContact, forKey: EMP_CONTACT)
                        UserDefaults.standard.set(self.businessName, forKey: BUSINESS_NAME)
                        
                        UserDefaults.standard.set(self.track, forKey: TRACK)
                        UserDefaults.standard.set(self.ivrs, forKey: IVRS)
                        UserDefaults.standard.set(self.lead, forKey: LEAD)
                        UserDefaults.standard.set(self.pbx, forKey: MCUBEX)
                        UserDefaults.standard.set(self.mtracker, forKey: MTRACKER)
                        
                        UserDefaults.standard.set(0,forKey: LAUNCH)
                        UserDefaults.standard.set(0,forKey: LAUNCHVIEW)
                       
                        UserDefaults.standard.synchronize()
                        if let myLoadedString = UserDefaults.standard.string(forKey: NAME) {
                            print(myLoadedString) // "Hello World"
                        }
                        
                        if(self.rememberMe.on){
                            UserDefaults.standard.set(self.email.text, forKey: EMAIL_FIELD)
                            UserDefaults.standard.set(self.password.text, forKey: PASS_FIELD)
                            UserDefaults.standard.synchronize()
                        }
                        else{
                            if UserDefaults.standard.string(forKey: EMAIL_FIELD) != nil
                                && UserDefaults.standard.string(forKey: PASS_FIELD) != nil
                            {
                                UserDefaults.standard.removeObject(forKey: PASS_FIELD)
                                UserDefaults.standard.removeObject(forKey: PASS_FIELD)
                                UserDefaults.standard.synchronize()
                                
                            }
                        }
                        
                         self.loginClick.isEnabled=true
                        self.performSegue(withIdentifier: "login", sender: self)
                        
                    }
                }
                
        }
        
    }
    
    
    
    
    func showActivityIndicator(){
        if !self.showingActivity {
            self.navigationController?.view.makeToastActivity(.center)
        } else {
            self.navigationController?.view.hideToastActivity()
        }
        
        self.showingActivity = !self.showingActivity
        
    }
    
    
    
    
    
    func showAlert(_ mesage :String){
        //dismissViewControllerAnimated(true, completion: nil)
        let alertView = UIAlertController(title: "MCube", message: mesage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    
//    
//    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
//        // turn the fields to red
//        for (field, error) in errors {
//            if let field = field as? UITextField {
//                field.layer.borderColor = UIColor.red.cgColor
//                field.layer.borderWidth = 1.0
//            }
//            error.errorLabel?.text = error.errorMessage // works if you added labels
//            error.errorLabel?.isHidden = false
//        }    }
//
//    
//    
    
    
    
    func setShowHideIcon(){
        
        
        
        let user:UIImage=UIImage(named: "user")!;
        let usericon:UIImageView = UIImageView(image:user.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
        email.leftViewMode = UITextFieldViewMode.always
        email.leftView = usericon
        
        let pass:UIImage=UIImage(named: "pass")!;
        let passicon:UIImageView = UIImageView(image:pass.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
        password.leftViewMode = UITextFieldViewMode.always
        password.leftView = passicon
        
        
        //  let showpass:UIImage=UIImage(named: "show")!;
        showpassicon = UIImageView(image:UIImage(named: "hide")!.imageWithInsets(UIEdgeInsetsMake(0, 5, 0, 5)))
        showpassicon!.isUserInteractionEnabled=true;
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LoginViewController.imageTapped(_:)))
        showpassicon!.addGestureRecognizer(tapGestureRecognizer)
        password.rightViewMode = UITextFieldViewMode.always
        password.rightView = showpassicon
        
    }
}



