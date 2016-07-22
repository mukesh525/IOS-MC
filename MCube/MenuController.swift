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
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat=40
        switch indexPath.row {
        case 0:
            
            return 208
        case 1:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey("track") {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 2:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey("ivrs") {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 3:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey("pbx") {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 4:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey("lead") {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 5:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey("mtracker") {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
            
        case 6:
            return 40;
        case 7:
            return 20;
        default:
            return height
        }
        
        
        
        
    }
    
    func setsection() ->Int{
        var select:Int=1
        
        if  NSUserDefaults.standardUserDefaults().stringForKey("track") == "1" {
            select = 1;
        }
        else if  NSUserDefaults.standardUserDefaults().stringForKey("ivrs") == "1" {
            select = 2;           }
            
        else if  NSUserDefaults.standardUserDefaults().stringForKey("pbx") == "1" {
            select = 3;
        }
            
        else if NSUserDefaults.standardUserDefaults().stringForKey("lead") == "1" {
            select = 4;
        }
            
        else if  NSUserDefaults.standardUserDefaults().stringForKey("mtracker") == "1" {
            select = 5;
        }
        else{
            select = 6
        }
        
        return select
        
    }
    
    
  override func viewWillAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey("launch") != nil{
            //  print("Loaded First")
            let myPath = NSIndexPath(forRow: self.setsection(), inSection: 0)
            self.mytableview.selectRowAtIndexPath(myPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            NSUserDefaults.standardUserDefaults().removeObjectForKey("launch")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if ( indexPath.row == 0 ){ return nil};
        if ( indexPath.row == 7 ){ return nil};
        return indexPath
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
                followupController.offset=0
                path = NSIndexPath(forRow: 6 , inSection: 0)
                
            }
            else if(segue.identifier == "track"){
                followupController.type = "track"
                followupController.CurrentTitle="Track"
                followupController.offset=0
                path = NSIndexPath(forRow: 1 , inSection: 0)
                
                
            }
            else if(segue.identifier == "lead"){
                followupController.type = "lead"
                followupController.CurrentTitle="Lead"
                followupController.offset=0
                path = NSIndexPath(forRow: 4 , inSection: 0)
                
            }
            else if(segue.identifier == "x"){
                followupController.type = "x"
                followupController.CurrentTitle="MCubeX"
                followupController.offset=0
                path = NSIndexPath(forRow: 3 , inSection: 0)
                
                
            }
            else if(segue.identifier == "ivrs"){
                followupController.type = "ivrs"
                followupController.CurrentTitle="IVRS"
                followupController.offset=0
                path = NSIndexPath(forRow: 2 , inSection: 0)
                
                
            }
            else if(segue.identifier == "mtracker"){
                followupController.type = "mtracker"
                followupController.CurrentTitle="Mtracker"
                followupController.offset=0
                path = NSIndexPath(forRow: 5 , inSection: 0)
                
                
            }
            else if(segue.identifier == "logout"){
                followupController.isLogout = true;
                
            }
            mytableview.selectRowAtIndexPath(path, animated: false, scrollPosition: UITableViewScrollPosition.None)
            
        }
    }
    
    
    
}
