//
//  DetailViewController.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI
import MBProgressHUD

class DetailViewController: UIViewController,UITableViewDataSource,UIPopoverPresentationControllerDelegate, UITableViewDelegate,CustomCellDelegate,UITextFieldDelegate ,DetailDownload,MoreSelectedDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate{

    @IBOutlet weak var updatebtn: UIButton!
    @IBOutlet weak var addfollowup: UIButton!
    var DetailDataList = Array<DetailData>();
    var optionsList = Array<OptionsData>();
    var OptionStringList=[String]()
    var currentData:Data!
    var showingActivity = false
    var authkey:String?
    var type:String?
    var ContactNo :String?
    var EmailId :String?
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var mytableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViews();
        
        if !self.refreshControl.isRefreshing{
            self.showActivityIndicator()
        }
        DetailDataTask(delegate: self).loadDetaildata(authkey!, type: self.type!, currentData:currentData);

        
    }

    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    func refresh(_ sender:AnyObject) {
      DetailDataTask(delegate: self).loadDetaildata(authkey!, type: self.type!, currentData:currentData);
    }
    
    
    func OnError(_ error: NSError) {
        print("Request failed with error: \(error)")
        if (error.code == -1009) {
           self.showAlert("No Internet Conncetion")
        }
        if self.refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }
        else{
            self.showActivityIndicator()
        }
    }
    
    
    func OnFinishDownload(_ result: Array<DetailData>) {
     
        self.DetailDataList=result;
        if self.refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }
        else{
            self.showActivityIndicator()
        }
        
        self.mytableview.reloadData()
        print(self.DetailDataList.count)
        
        
        
    }
    
     @IBAction func UpdateClick(_ sender: AnyObject) {
        
        if(self.type == FOLLOWUP){
         self.performSegue(withIdentifier: "history", sender: self)
        }else {
            self.UpdateRecords()
        }
        
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if DetailDataList.count == 0{
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No Data Pull Down To Refresh"
            emptyLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        } else {
            tableView.backgroundView=UIView()
            tableView.backgroundView?.backgroundColor = UIColor.clear
            return DetailDataList.count
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let detaildata: DetailData = self.DetailDataList[(indexPath as NSIndexPath).row] 
        
       
          if(detaildata.Type == LABEL)
        {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "LL", for: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
        
        }
        
        else if(detaildata.Type == HIDDEN)
          {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "LL", for: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            
            return UITableViewCell()
            
        }
        
        else if (detaildata.Type==TEXT || detaildata.Type==TEXTAREA) {
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "LT", for: indexPath) as!CustomeCell3
            cell3.label1.text=detaildata.label
            if (NSString(string: detaildata.value!).length > 1){
            cell3.textfiled.text=detaildata.value}
            cell3.delegate=self
            cell3.textfiled.placeholder = detaildata.label!
            cell3.textfiled.delegate=self
     

            return cell3
            
            
        }
        
        else if (detaildata.Type==DROPDOWN || detaildata.Type==RADIO) {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "LP", for: indexPath) as!CustomeCell2
             cell2.label.text=detaildata.label
             cell2.Options=detaildata.Options
            if (NSString(string: detaildata.value!).length > 1){
                cell2.itemAtDefaultPosition=detaildata.value!}
            else{
                cell2.itemAtDefaultPosition = detaildata.OptionList[0].value!
                detaildata.value=detaildata.OptionList[0].id!
             }
             cell2.pickerSelected = { (selectedRow) -> Void in
                detaildata.value=detaildata.OptionList[selectedRow].id
                print("the selected item is \(selectedRow)")
                print("the selected value is \(detaildata.Options[selectedRow])")
                
            }

            return cell2
            
        }
        else if (detaildata.Type == DATE_TIME){
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "LD", for: indexPath) as!CustomeCell5
            cell5.label.text = detaildata.label
            detaildata.value=cell5.dateTimePicker.getStringValue();
            cell5.onDateChnaged = { (selectedRow) -> Void in
                detaildata.value=cell5.dateTimePicker.getStringValue();
            }
            return cell5
            
          }

        
       else if (detaildata.Type == CHECKBOX){
       let cell4 = tableView.dequeueReusableCell(withIdentifier: "Ltabel", for: indexPath) as!CustomeCell4
           cell4.label1.text=detaildata.label
           cell4.optionsList=detaildata.OptionList
           cell4.chekboxTable.reloadData()
            
          return cell4
            
       }
        else {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "LL", for: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
        }

    }
    
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let detaildata: DetailData = self.DetailDataList[(indexPath as NSIndexPath).row]
        let count=CGFloat(detaildata.OptionList.count);
        let chekheight=CGFloat(44);
        if(detaildata.Type == HIDDEN){
         return 0
        }
        else if (detaildata.Type==DROPDOWN || detaildata.Type==RADIO) {
        
        return 100
        }
        else if (detaildata.Type == CHECKBOX){
            return chekheight * count
        }
        else if (detaildata.Type == DATE_TIME){
            return 150
        }
        else{
            return 44
        
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func cellTextChanged(_ cell: CustomeCell3) {
        let indexPath = self.mytableview.indexPathForRow(at: cell.center)!
        let detaildata: DetailData = self.DetailDataList[(indexPath as NSIndexPath).row]
        detaildata.value=cell.textfiled.text!
        print("index \((indexPath as NSIndexPath).row)  value  \(cell.textfiled.text!)")
    }


    func UpdateRecords() {
        var code:String?
        var msg:String?
        self.showActivityIndicator()
        Alamofire.request(POST_DETAIL,method: .post,
            parameters: self.DetailDataList.getParams(self.currentData,type:self.type!,postFollowup: false)).validate().responseJSON
            {response in switch response.result {
                
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                if((response.object(forKey: CODE)) != nil){
                   code=response.object(forKey: CODE) as? String
                    
                }
                if((response.object(forKey: MESSAGE)) != nil){
                    msg=response.object(forKey: MESSAGE) as? String
                    
                }
                
                self.showActivityIndicator()
                if(code == "202" && msg != nil){
                self.showAlert("Records Updated Successfully")
                }else{
                self.showAlert("Something went wrong try again")
                 }
            case .failure(let error):
                print("Request failed with error: \(error)")
                self.showActivityIndicator()
//                if (error == -1009) {
//                    self.showAlert("No Internet Conncetion")
//                }
               }
        }
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ADD_FOLLOWUP{
            let addfollowup = segue.destination as! AddFollowupController
            addfollowup.currentData=self.currentData;
            addfollowup.authkey=self.authkey;
            addfollowup.type=self.type;
        }
        if segue.identifier == HISTORY {
            let navController = segue.destination as! SWRevealViewController
            navController.loadView()
            let secondVc = navController.frontViewController as! UINavigationController
            secondVc.loadView()
            let detailController = secondVc.topViewController as! ReportViewController
            detailController.type = HISTORY
        }
        
        
    }
    
    
    
    
    func moreSelected(_ position: Int) {
        print(position);
        switch position {
        case 0  :
           self.UpdateRecords()
        case 1  :
            self.performSegue(withIdentifier: ADD_FOLLOWUP, sender: self)
        case 2  :
            if let url = URL(string: "tel://\(self.currentData.callFrom)") {
                UIApplication.shared.openURL(url)
                print(url)
            }
        case 3  :
            self.sendSms()
        case 4  :
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        default :
            print("default")
            
    }
}
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendSms(){
     if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = [self.currentData.callFrom!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    
   }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("MCube")
        //mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
       // let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        
        
        let alertController = UIAlertController(title: "Destructive", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        _ = UIAlertAction(title: "Destructive", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            print("Destructive")
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
       // alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        
        
        
       // sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}
