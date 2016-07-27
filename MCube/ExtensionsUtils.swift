
import UIKit
extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(self.size.width + insets.left + insets.right,
                self.size.height + insets.top + insets.bottom), false, self.scale)
        _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.drawAtPoint(origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
  }
}



extension UIDatePicker {
    func getStringValue() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = DATETIMEFOEMAT
        let formatteddate = dateFormatter.stringFromDate(self.date)
        return formatteddate
    }
}







extension DetailViewController {
    func addLogOutButtonToNavigationBar(triggerToMethodName: String){
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "more"), forState: .Normal)
        button.frame = CGRectMake(20, 0, 30, 25)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: -10)
        
        button .addTarget(self, action:#selector(DetailViewController.moreButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
     func showActivityIndicator(){
        if !self.showingActivity {
            self.navigationController?.view.makeToastActivity(.Center)
        } else {
            self.navigationController?.view.hideToastActivity()
        }
        
        self.showingActivity = !self.showingActivity
        
    }
    
    func showAlert(mesage :String){
        let alertView = UIAlertController(title: TITLE, message: mesage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
   
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -170
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func initializeViews(){
        if let authkey = NSUserDefaults.standardUserDefaults().stringForKey(AUTHKEY) {
            self.authkey=authkey;
        }
        mytableview.delegate = self
        mytableview.dataSource = self
        mytableview.allowsSelection=false
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(DetailViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.mytableview?.addSubview(refreshControl)
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        addLogOutButtonToNavigationBar("more");
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
   }

}






extension ReportViewController{

    func initializeViews(){
        setsection()
        if let savedlimit = NSUserDefaults.standardUserDefaults().stringForKey(LIMIT) {
            self.limit = Int(savedlimit)!;
        }else {self.limit=10}
        if(isLogout){
            isLogout=false;
            LogoutAlert()
        }
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SELECT)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.navigationItem.title = CurrentTitle;
        tableView.allowsSelection = true;
        mytableview.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
        if NSUserDefaults.standardUserDefaults().stringForKey(AUTHKEY) != nil {
            result=ModelManager.getInstance().getData(type)
            options=ModelManager.getInstance().getMenuData(type)
            if(result.count>0 && options.count>0){
                self.playButtons=[UIButton]()
                tableView.reloadData()
            }
            else if(!self.isDownloading){
                
                let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
                self.isDownloading=true;
                self.showActivityIndicator()
                Report(param: param, delegate: self).LoadData();
            }
            
        }
        
        self.refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControll.addTarget(self, action: #selector(ReportViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.mytableview?.addSubview(refreshControll)
        if revealViewController() != nil {
            menubutton.target = revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        self.revealViewController().delegate = self
        if self.refreshControll.refreshing{
            self.refreshControll.endRefreshing()
        }
        
    }
    
    func refresh(sender:AnyObject) {
        if(!self.isDownloading){
            let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
            self.isDownloading=true;
            Report(param: param, delegate: self).LoadData();
            
        }
        else{
            if self.refreshControll.refreshing{
                self.refreshControll.endRefreshing()
            }
        }
    }

    func showAlert(mesage :String){
        let alertView = UIAlertController(title: TITLE, message: mesage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    func setsection() {
        
        if NSUserDefaults.standardUserDefaults().objectForKey(LAUNCHVIEW) != nil{
            NSUserDefaults.standardUserDefaults().removeObjectForKey(LAUNCHVIEW)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if  NSUserDefaults.standardUserDefaults().stringForKey(TRACK) == "1" {
                self.type=TRACK
                self.CurrentTitle=TRACK.capitalizeIt()
            }
            else if NSUserDefaults.standardUserDefaults().stringForKey(IVRS)  == "1"{
                self.type=IVRS
                self.CurrentTitle=IVRS.capitalizeIt()
            }
                
            else if NSUserDefaults.standardUserDefaults().stringForKey(MCUBEX)  == "1"{
                self.type=X
                self.CurrentTitle="MCubeX"
            }
                
            else if NSUserDefaults.standardUserDefaults().stringForKey(LEAD) == "1" {
                self.type=LEAD
                self.CurrentTitle=LEAD.capitalizeIt()
            }
                
            else if NSUserDefaults.standardUserDefaults().stringForKey(MTRACKER) == "1" {
                self.type=MTRACKER
                self.CurrentTitle=MTRACKER.capitalizeIt()
            }
            else{
                self.type=FOLLOWUP
                self.CurrentTitle=FOLLOWUP.capitalizeIt()
            }
         }
     }
        
        
        func filteralert (){
            let option: OptionsData = self.options[SeletedFilterpos];
            let alertController = UIAlertController(title: TITLE, message:
                "No Records available for Group : \(option.value!)", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.SeletedFilterpos=0;
                self.gid="0";
                self.showActivityIndicator()
                let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
                self.isDownloading=true;
                Report(param: param, delegate: self).LoadData();
                
            }
            
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    
    
    
    func LogoutAlert (){
        let alertController = UIAlertController(title: "Logout Alert", message:
            "Do you want to logout?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: LOGOUT.capitalizeIt(), style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSUserDefaults.standardUserDefaults().removeObjectForKey(AUTHKEY)
            NSUserDefaults.standardUserDefaults().synchronize()
            ModelManager.getInstance().deleteAllData();
            self.performSegueWithIdentifier("GoLogin", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: false, completion: nil)
        
    }
    func NoDataAlert (){
        let alertController = UIAlertController(title: TITLE, message:
            "No records available", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
            self.isDownloading=true;
            Report(param: param, delegate: self).LoadData();
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if self.showingActivity {
                self.navigationController?.view.hideToastActivity()
                self.showingActivity = !self.showingActivity
            }
            if self.refreshControll.refreshing{
                self.refreshControll.endRefreshing()
            }
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: false, completion: nil)
        
    }



}

































extension _ArrayType where Generator.Element == DetailData {

    func getParams(currentData:Data,type:String)->[String: AnyObject]?{
        let authkey = NSUserDefaults.standardUserDefaults().stringForKey(AUTHKEY)
        var parameters: [String: AnyObject]? = [:]
        print(self.count)
        parameters![AUTHKEY]=authkey
        parameters![TYPE]=type
        parameters![GROUP_NAME]=(currentData.groupName != nil ? currentData.groupName : currentData.empName)!
        
        for curentValue in  self{
            
            if(curentValue.Type == CHECKBOX){
                var val=[String]()
                for option in curentValue.OptionList{
                    if(option.isChecked){
                        val.append(option.id!)
                    }
                }
                
                if(val.count>0){
                    let joined=val.joinWithSeparator(",")
                    print("\(curentValue.Name!)  :   \(joined)")
                    parameters![curentValue.Name!] = joined
                    
                }else{
                    print("\(curentValue.Name!)  :  null")
                    
                    parameters![curentValue.Name!] = "null"
                    
                    
                }
                
            }else if(curentValue.Type == DROPDOWN){
                print("\(curentValue.Name!)  :   \(curentValue.value!)")
                parameters![curentValue.Name!] = curentValue.value!
            } else {
                print("\(curentValue.Name!)  :   \(curentValue.value!)")
                parameters![curentValue.Name!] = curentValue.value!
            }
            
        }
        print(parameters!.keys.count) // 0
        
        return parameters
        
    }
  

}





extension String {

func getDateFromString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = DATETIMEFOEMAT
    dateFormatter.timeZone = NSTimeZone(name: "UTC")
    guard let date = dateFormatter.dateFromString(self) else {
        assert(false, "no date from string")
        return ""
    }
    dateFormatter.dateFormat = DATETIMEFOEMAT
    let timeStamp = dateFormatter.stringFromDate(date)
    return timeStamp
   }
    
    func getTimeFromString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = DATETIMEFOEMAT
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        guard let date = dateFormatter.dateFromString(self) else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = "hh:mm a"
        let timeStamp = dateFormatter.stringFromDate(date)
        return timeStamp
    }
    
    func convertDateFormater() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = DATETIMEFOEMAT
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.dateFromString(self) else {
            assert(false, "no date from string")
            return NSDate()
        }
        return date
    }
    
     func  capitalizeIt()-> String {
        if isEmpty { return "" }
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).uppercaseString)
        return result    }
    
    
}


