//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
class MenuController: UITableViewController {
    
    @IBOutlet var FilterTable: UITableView!
    @IBOutlet var filtertableview: UITableView!
    @IBOutlet var mytableview: UITableView!
    //   @IBOutlet var mytableview: UITableView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var useremail: UILabel!
    var options:NSMutableArray=NSMutableArray();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for _ in 0..<10 {
            
            let optiondata = OptionsData();
            optiondata.id="1"
            optiondata.value = "Mukesh"
            self.options.addObject(optiondata)
            
        }
        
      //  self.mytableview.allowsSelection=true;
        if(username != nil && useremail != nil ){
            
            
            if let name = NSUserDefaults.standardUserDefaults().stringForKey("name") {
                username.text="Hi \(name)"
            }
            if let email = NSUserDefaults.standardUserDefaults().stringForKey("email") {
                useremail.text=email
            }
            
        }
        
        //tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: .None)
        self.clearsSelectionOnViewWillAppear = false;
        
      
        
    }
    override func viewDidAppear(animated: Bool) {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("launch") != nil{
                        print("Loaded First")
                        let myPath = NSIndexPath(forRow: 1, inSection: 0)
                        self.mytableview.selectRowAtIndexPath(myPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("launch")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
            }
    

    

    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nav = segue.destinationViewController as! UINavigationController
        
        if(segue.identifier == "settings")   {
            
        
        }
        else{
         
        let followupController = nav.topViewController as! FollowUpViewController
        var path = NSIndexPath(forRow: 0 , inSection: 0)
        
        if(segue.identifier == "followup"){
            followupController.type = "followup"
            followupController.CurrentTitle="Follow Up"
            path = NSIndexPath(forRow: 6 , inSection: 0)
            
        }
        else if(segue.identifier == "track"){
            followupController.type = "track"
            followupController.CurrentTitle="Track"
            path = NSIndexPath(forRow: 1 , inSection: 0)
            
            
        }
        else if(segue.identifier == "lead"){
            followupController.type = "lead"
            followupController.CurrentTitle="Lead"
             path = NSIndexPath(forRow: 4 , inSection: 0)
            
        }
        else if(segue.identifier == "x"){
            followupController.type = "x"
            followupController.CurrentTitle="MCubeX"
             path = NSIndexPath(forRow: 3 , inSection: 0)

            
        }
        else if(segue.identifier == "ivrs"){
            followupController.type = "ivrs"
            followupController.CurrentTitle="IVRS"
            path = NSIndexPath(forRow: 2 , inSection: 0)

            
        }
        else if(segue.identifier == "mtracker"){
            followupController.type = "mtracker"
            followupController.CurrentTitle="Mtracker"
            path = NSIndexPath(forRow: 5 , inSection: 0)

            
        }
        else if(segue.identifier == "logout"){
            followupController.isLogout = true;
    
        }
        mytableview.selectRowAtIndexPath(path, animated: false, scrollPosition: UITableViewScrollPosition.None)
        
    }
  }
    
    
    
}
