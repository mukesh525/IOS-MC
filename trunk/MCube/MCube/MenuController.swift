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
        
        
       
        
        if(username != nil && useremail != nil ){
            
            
            if let name = NSUserDefaults.standardUserDefaults().stringForKey("name") {
               username.text="Hi \(name)"
            }
            if let email = NSUserDefaults.standardUserDefaults().stringForKey("email") {
                useremail.text=email 
            }
           
        }
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
  override  func viewDidAppear(animated: Bool){
//    do {
//        let myPath = NSIndexPath(forRow: 1, inSection: 0)
//        if(self.mytableview != nil){
//            mytableview.selectRowAtIndexPath(myPath, animated: false, scrollPosition: UITableViewScrollPosition.None)}
//        } catch _ {
//      
//    }
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

//    
//    // MARK: - Table view data source
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // Return the number of sections.
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // Return the number of rows in the section.
//        return options.count
//    }
//
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("filter", forIndexPath: indexPath) as! FilterCell
//        let data: OptionsData = self.options[indexPath.row] as! OptionsData
//        cell.layer.cornerRadius=15
//        cell.layer.borderColor = UIColor.orangeColor().CGColor
//        cell.layer.borderWidth = 2
//        cell.backgroundColor = UIColor.clearColor()
//        cell.filter.text=data.value
//        
//       return cell
//    }
// 
//
//  
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return NO if you do not want the specified item to be editable.
//        return true
//    }
//  
//
//   
//    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }
//    
//
// 
//    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "sw_right")
//        {
//            let someText = "Text"
//            let rvc:FollowUpViewController = segue.destinationViewController as! FollowUpViewController
//            rvc.programVar = someText
//        }    }
//   

}
