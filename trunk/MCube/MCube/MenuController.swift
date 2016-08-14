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
    var currentType:String = TRACK
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for _ in 0..<10 {
            
            let optiondata = OptionsData();
            optiondata.id="1"
            optiondata.value = "Mukesh"
            self.options.addObject(optiondata)
            
        }
        if(username != nil && useremail != nil ){
            
            
            if let name = NSUserDefaults.standardUserDefaults().stringForKey(NAME) {
                username.text="Hi \(name)"
            }
            if let email = NSUserDefaults.standardUserDefaults().stringForKey(EMAIL) {
                useremail.text=email
            }
            
        }
        self.clearsSelectionOnViewWillAppear = false;
       
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat=40
        switch indexPath.row {
        case 0:
            
            return 208
        case 1:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey(TRACK) {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 2:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey(IVRS) {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 3:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey(MCUBEX) {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 4:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey(LEAD) {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 5:
            if let track = NSUserDefaults.standardUserDefaults().stringForKey(MTRACKER) {
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
        
        if  NSUserDefaults.standardUserDefaults().stringForKey(TRACK) == "1" {
            select = 1;
        }
        else if  NSUserDefaults.standardUserDefaults().stringForKey(IVRS) == "1" {
            select = 2;           }
            
        else if  NSUserDefaults.standardUserDefaults().stringForKey(MCUBEX) == "1" {
            select = 3;
        }
            
        else if NSUserDefaults.standardUserDefaults().stringForKey(LEAD) == "1" {
            select = 4;
        }
            
        else if  NSUserDefaults.standardUserDefaults().stringForKey(MTRACKER) == "1" {
            select = 5;
        }
        else{
            select = 6
        }
        
        return select
        
    }
    
    
  override func viewWillAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey(LAUNCH) != nil{
            //  print("Loaded First")
            let myPath = NSIndexPath(forRow: self.setsection(), inSection: 0)
            self.mytableview.selectRowAtIndexPath(myPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(LAUNCH)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if ( indexPath.row == 0 ){ return nil};
        if ( indexPath.row == 7 ){ return nil};
        return indexPath
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let path = NSIndexPath(forRow: indexPath.row , inSection: 0)
        switch indexPath.row {
        case 1:
            currentType=TRACK
        case 2:
            currentType=IVRS
        case 3:
             currentType=X
        case 4:
            currentType=LEAD
        case 5:
             currentType=MTRACKER
        case 6:
             currentType=FOLLOWUP
        default:
             currentType=TRACK
        }
        mytableview.selectRowAtIndexPath(path, animated: false, scrollPosition: UITableViewScrollPosition.None)
        
        if(indexPath.row == 8){
            self.performSegueWithIdentifier("settings", sender: self)
        }
        else{
           self.performSegueWithIdentifier("push", sender: self)
        }
      
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nav = segue.destinationViewController as! UINavigationController
    
         if(segue.identifier == "settings"){
            
         }
        else{
        let followupController = nav.topViewController as! ReportViewController
        followupController.type = currentType
        if(currentType == X){
           followupController.CurrentTitle="MCubeX"
         }
         else {
          followupController.CurrentTitle=currentType.capitalizeIt()
        }
     }

    }
    
    
    
}
