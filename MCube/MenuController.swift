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
            self.options.add(optiondata)
            
        }
        if(username != nil && useremail != nil ){
            
            
            if let name = UserDefaults.standard.string(forKey: NAME) {
                username.text="Hi \(name)"
            }
            if let email = UserDefaults.standard.string(forKey: EMAIL) {
                useremail.text=email
            }
            
        }
        self.clearsSelectionOnViewWillAppear = false;
       
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat=40
        switch (indexPath as NSIndexPath).row {
        case 0:
            
            return 208
        case 1:
            if let track = UserDefaults.standard.string(forKey: TRACK) {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 2:
            if let track = UserDefaults.standard.string(forKey: IVRS) {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 3:
            if let track = UserDefaults.standard.string(forKey: MCUBEX) {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 4:
            if let track = UserDefaults.standard.string(forKey: LEAD) {
                if(track == "0"){height = 0;}
                else{height = 40;}
            }
            return height
        case 5:
            if let track = UserDefaults.standard.string(forKey: MTRACKER) {
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
        
        if  UserDefaults.standard.string(forKey: TRACK) == "1" {
            select = 1;
        }
        else if  UserDefaults.standard.string(forKey: IVRS) == "1" {
            select = 2;           }
            
        else if  UserDefaults.standard.string(forKey: MCUBEX) == "1" {
            select = 3;
        }
            
        else if UserDefaults.standard.string(forKey: LEAD) == "1" {
            select = 4;
        }
            
        else if  UserDefaults.standard.string(forKey: MTRACKER) == "1" {
            select = 5;
        }
        else{
            select = 6
        }
        
        return select
        
    }
    
    
  override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: LAUNCH) != nil{
            //  print("Loaded First")
            let myPath = IndexPath(row: self.setsection(), section: 0)
            self.mytableview.selectRow(at: myPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            UserDefaults.standard.removeObject(forKey: LAUNCH)
            UserDefaults.standard.synchronize()
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if ( (indexPath as NSIndexPath).row == 0 ){ return nil};
        if ( (indexPath as NSIndexPath).row == 7 ){ return nil};
        return indexPath
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = IndexPath(row: (indexPath as NSIndexPath).row , section: 0)
        switch (indexPath as NSIndexPath).row {
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
        mytableview.selectRow(at: path, animated: false, scrollPosition: UITableViewScrollPosition.none)
        
        if((indexPath as NSIndexPath).row == 8){
            self.performSegue(withIdentifier: "settings", sender: self)
        }
        else{
           self.performSegue(withIdentifier: "push", sender: self)
        }
      
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
    
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
