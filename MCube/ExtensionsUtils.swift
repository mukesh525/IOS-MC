
import UIKit


extension UIImage {
    func imageWithInsets(_ insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                height: self.size.height + insets.top + insets.bottom), false, self.scale)
        _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
  }
}



extension UIDatePicker {
    func getStringValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATETIMEFOEMAT
        let formatteddate = dateFormatter.string(from: self.date)
        return formatteddate
    }
}




protocol DismissalDelegate : class{
    func finishedShowing(_ viewController: UIViewController);
}

protocol Dismissable : class{
    weak var dismissalDelegate : DismissalDelegate? { get set }
}

extension DismissalDelegate where Self: UIViewController{
    func finishedShowing(_ viewController: UIViewController) {
        if viewController.isBeingPresented && viewController.presentingViewController == self{
            self.dismiss(animated: true, completion: nil)
            return
        }
        
      //  self.navigationController?.popViewController(animated: true)
    }
}





extension DetailViewController {
    func addLogOutButtonToNavigationBar(_ triggerToMethodName: String){
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "more"), for: UIControlState())
        button.frame = CGRect(x: 20, y: 0, width: 30, height: 25)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: -10)
        
        button .addTarget(self, action:#selector(DetailViewController.moreButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func showActivityIndicator(){
        if !self.showingActivity {
           /// self.navigationController?.view.makeToastActivity(.center)
           self.navigationController?.view.isUserInteractionEnabled = false;
            showProgress()
        } else {
            hideProgress()
           // self.navigationController?.view.hideToastActivity()
            self.navigationController?.view.isUserInteractionEnabled = true;
        }
        
        self.showingActivity = !self.showingActivity
        
    }
    
    func showProgress(){
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "Loading";
        spinnerActivity.contentColor=UIColor.black
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        spinnerActivity.isUserInteractionEnabled = false;
    }
    
    
    func hideProgress(){
       MBProgressHUD.hideAllHUDs(for: self.view, animated: true);
    }

    
    func showAlert(_ mesage :String){
        let alertView = UIAlertController(title: TITLE, message: mesage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
 //   func moreButtonClicked(_ sender:AnyObject) {
//        let popoverContent = (self.storyboard?.instantiateViewController(withIdentifier: "more"))! as! MoreViewController
//        popoverContent.modalPresentationStyle = .popover
//        if let popover = popoverContent.popoverPresentationController {
//           let viewForSource = sender as! UIView
//            popover.sourceView = viewForSource
//            popover.sourceRect = viewForSource.bounds
//            popoverContent.preferredContentSize = CGSize(width: 150,height: 220)
//            popoverContent.delegate=self
//            popover.delegate = self
//        }
//        
//        self.present(popoverContent, animated: true, completion: nil)
        
 //    }
    
  
    
    
    
    
    
    
    
    
    
    @objc(adaptivePresentationStyleForPresentationController:) func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    func initializeViews(){
        if let authkey = UserDefaults.standard.string(forKey: AUTHKEY) {
            self.authkey=authkey;
        }
        mytableview.delegate = self
        mytableview.dataSource = self
        mytableview.allowsSelection=false
        if(type==FOLLOWUP){
         updatebtn.setTitle("History",  for: UIControlState())
         addfollowup.setTitle("New",  for: UIControlState())
        }
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(DetailViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.mytableview?.addSubview(refreshControl)
        if self.refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }
        addLogOutButtonToNavigationBar("more");

   }

}








extension ReportViewController{
    
   func initializeViews(){
        setsection()
        if let savedlimit = UserDefaults.standard.string(forKey: LIMIT) {
            self.limit = Int(savedlimit)!;
        }else {self.limit=10}
        if(isLogout){
            isLogout=false;
           LogoutAlert()
        }
        
        player=nil;
        UserDefaults.standard.removeObject(forKey: SELECT)
        UserDefaults.standard.synchronize()
        self.navigationItem.title = CurrentTitle;
        tableView.allowsSelection = true;
        mytableview.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
        if UserDefaults.standard.string(forKey: AUTHKEY) != nil {
            result=ModelManager.getInstance().getData(type)
            options=ModelManager.getInstance().getMenuData(type)
            if(result.count>0 && options.count>0){
                self.playButtons=[UIButton]()
                tableView.reloadData()
            }
            else if(!self.isDownloading){
                
                let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
                self.isDownloading=true;
                self.showProgress();
                Report(param: param, delegate: self).LoadData();
            }
            
        }
        
        self.refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControll.addTarget(self, action: #selector(ReportViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.mytableview?.addSubview(refreshControll)
        if revealViewController() != nil {
            menubutton.target = revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().delegate = self
            
        }
       
        if self.refreshControll.isRefreshing{
            self.refreshControll.endRefreshing()
        }
        
    }
    
    func refresh(_ sender:AnyObject) {
        
        if(player != nil){
            player = nil;
        }
        self.playButtons.removeAll()
            
        if(!self.isDownloading){
            let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
            self.isDownloading=true;
            Report(param: param, delegate: self).LoadData();
            
        }
        else{
            if self.refreshControll.isRefreshing{
                self.refreshControll.endRefreshing()
            }
        }
    }

    func showAlert(_ mesage :String){
        let alertView = UIAlertController(title: TITLE, message: mesage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    func setsection() {
        
        if UserDefaults.standard.object(forKey: LAUNCHVIEW) != nil{
            UserDefaults.standard.removeObject(forKey: LAUNCHVIEW)
            UserDefaults.standard.synchronize()
            
            if  UserDefaults.standard.string(forKey: TRACK) == "1" {
                self.type=TRACK
                self.CurrentTitle=TRACK.capitalizeIt()
            }
            else if UserDefaults.standard.string(forKey: IVRS)  == "1"{
                self.type=IVRS
                self.CurrentTitle=IVRS.capitalizeIt()
            }
                
            else if UserDefaults.standard.string(forKey: MCUBEX)  == "1"{
                self.type=X
                self.CurrentTitle="MCubeX"
            }
                
            else if UserDefaults.standard.string(forKey: LEAD) == "1" {
                self.type=LEAD
                self.CurrentTitle=LEAD.capitalizeIt()
            }
                
            else if UserDefaults.standard.string(forKey: MTRACKER) == "1" {
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
                "No Records available for Group : \(option.value!)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.SeletedFilterpos=0;
                self.gid="0";
                self.showProgress()
                let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
                self.isDownloading=true;
                Report(param: param, delegate: self).LoadData();
                
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    
    
    
    func LogoutAlert (){
        let alertController = UIAlertController(title: "Logout Alert", message:
            "Do you want to logout?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: LOGOUT.capitalizeIt(), style: UIAlertActionStyle.default) {
            UIAlertAction in
            UserDefaults.standard.removeObject(forKey: AUTHKEY)
            UserDefaults.standard.synchronize()
            ModelManager.getInstance().deleteAllData();
            self.performSegue(withIdentifier: "GoLogin", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
           // self.dismiss(animated: true, completion:nil)
           alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: false, completion: nil)
        
    }
    func NoDataAlert (){
        let alertController = UIAlertController(title: TITLE, message:
            "No records available", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
            self.isDownloading=true;
            Report(param: param, delegate: self).LoadData();
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if self.showingActivity {
                self.navigationController?.view.hideToastActivity()
                self.showingActivity = !self.showingActivity
            }
            if self.refreshControll.isRefreshing{
                self.refreshControll.endRefreshing()
            }
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: false, completion: nil)
        
    }



}


extension Array where Element : DetailData {

    func getParams(_ currentData:Data,type:String,postFollowup:Bool)->[String: Any]?{
        let authkey = UserDefaults.standard.string(forKey: AUTHKEY)
        var parameters: [String: Any]? = [:]
        print(self.count)
        parameters![AUTHKEY]=authkey! as AnyObject?
        parameters![GROUP_NAME]=(currentData.groupName != nil ? currentData.groupName : currentData.empName)!
        if(postFollowup){
            parameters![CALLID]=currentData.callId! as AnyObject?
            print("\(CALLID) :\(currentData.callId!)")
            
            if(type==TRACK){
                  parameters![FTYPE]="calltrack" as AnyObject?
                  print("\(FTYPE) :calltrack ")
            }
            else if(type==LEAD){
                parameters![FTYPE]="leads" as AnyObject?
                print("\(FTYPE) :leads ")
            }
            else if(type==X){
                parameters![FTYPE]=MCUBEX as AnyObject?
                print("\(FTYPE) :calltrack ")
            }
            else{
                parameters![FTYPE] = (type != FOLLOWUP ? type:currentData.groupName!)
                  print("\(FTYPE) :\(type != FOLLOWUP ? type:currentData.groupName!)")
            }
            parameters![TYPE]=FOLLOWUP as AnyObject?
            print("\(TYPE) :\(FOLLOWUP) ")
            
        }else{
            parameters![TYPE]=type as AnyObject?
            print("\(TYPE) :\(type) ")
        }
        
        for curentValue in  self{
            
            if(curentValue.Type == CHECKBOX){
                var val=[String]()
                for option in curentValue.OptionList{
                    if(option.isChecked){
                        val.append(option.id!)
                    }
                }
                
                if(val.count>0){
                    let joined=val.joined(separator: ",")
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
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DATETIMEFOEMAT
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    guard let date = dateFormatter.date(from: self) else {
        assert(false, "no date from string")
        return ""
    }
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
   }
    
    func getTimeFromString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATETIMEFOEMAT
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        guard let date = dateFormatter.date(from: self) else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = "hh:mm a"
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    
    func convertDateFormater() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATETIMEFOEMAT
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        guard let date = dateFormatter.date(from: self) else {
            assert(false, "no date from string")
            return Date()
        }
        return date
    }
    
     func  capitalizeIt()-> String {
        if isEmpty { return "" }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).uppercased())
        return result    }
    
    
}

extension Array {
    
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(_ index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
