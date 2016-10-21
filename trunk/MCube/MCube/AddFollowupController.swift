//
//  AddFollowupViewController.swift
//  MCube
//
//  Created by Mukesh Jha on 22/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire

class AddFollowupController: UIViewController,CustomCellDelegate,UITextFieldDelegate  {
    var currentData:Data!
    var authkey:String?
    var optionsList = [OptionsData]()
    var OptionStringList=[String]()
    var DetailDataList = [DetailData]()
    var ContactNo :String?
    var EmailId :String?
    var type :String?
    @IBOutlet weak var mytableView: UITableView!
    fileprivate var showingActivity = false
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(DetailViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.mytableView?.addSubview(refreshControl)
        if self.refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }
        
        loadDetaildata();
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    


    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitClick(_ sender: UIButton) {
        
        self.UpdateRecords();
        
    }
    
    
    
    func loadDetaildata() {
        
        if !self.refreshControl.isRefreshing{
            self.showActivityIndicator()
        }
        
        Alamofire.request(FOLLOWUP_FORM,method :.post,
            parameters: [AUTHKEY:authkey!]).validate().responseJSON
            {response in switch response.result {
                
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                
                //self.showActivityIndicator()
                if((response.object(forKey: FIELDS)) != nil){
                    self.DetailDataList=[DetailData]()
                    let fields = response.object(forKey: FIELDS) as! NSArray?
                    
                    for field in fields!{
                        let detailData=DetailData();
                        if(((field as AnyObject).object(forKey: NAME)) != nil){
                            detailData.Name=(field as AnyObject).object(forKey: NAME) as? String
                            
                        }
                        if(((field as AnyObject).object(forKey: LABEL)) != nil){
                            detailData.label=(field as AnyObject).object(forKey: LABEL) as? String
                            
                        }
                        
                        if(((field as AnyObject).object(forKey: TYPE)) != nil){
                            detailData.Type=(field as AnyObject).object(forKey: TYPE) as? String
                            
                        }
                        if(((field as AnyObject).object(forKey: VALUE)) != nil){
                            detailData.value=(field as AnyObject).object(forKey: VALUE) as? String
                            
                        }
                        
                        let optionsLabel = [DROPDOWN, RADIO,CHECKBOX]
                        let contained = optionsLabel.contains(detailData.Type!)
                        if(contained){
                            let Options = (field as AnyObject).object(forKey: OPTIONS) as! NSDictionary?
                            self.optionsList=[OptionsData]()
                            self.OptionStringList=[String]()
                            print("Data items count: \(Options!.count)")
                            for (key, value) in Options! {
                                let mOptionsData = OptionsData();
                                mOptionsData.id=key as? String
                                mOptionsData.value=value as? String
                                if(key as? String == detailData.value){
                                    detailData.value=value as? String
                                }
                                
                                if (detailData.Type!.contains(CHECKBOX) && !detailData.value!.contains("")) {
                                    let newString = detailData.value!.replacingOccurrences(of: "\"", with: "")
                                    let toArray = newString.components(separatedBy: ",")
                                    for curentValue in toArray  {
                                        if (key as! String==curentValue) {
                                            mOptionsData.isChecked=true
                                            print(" \(curentValue) is cheked")
                                        }
                                        print(curentValue)
                                    }
                                }
                                self.OptionStringList.append(value as! String)
                                self.optionsList.append(mOptionsData)
                            }
                            detailData.OptionList=self.optionsList;
                            
                            
                        }
                        else {
                            self.optionsList=[OptionsData]()
                            self.OptionStringList=[String]()
                            
                        }
                        
                        detailData.OptionList=self.optionsList
                        detailData.Options=self.OptionStringList
                        
                        if (detailData.Name == CALLFROM) {
                            self.ContactNo = detailData.value;
                        } else if (detailData.Name == CALLFROM) {
                            self.EmailId = detailData.value;
                        }
                        
                        self.DetailDataList.append(detailData);
                        
                        
                    }
                    if self.refreshControl.isRefreshing{
                        self.refreshControl.endRefreshing()
                    }
                    else{
                        self.showActivityIndicator()
                    }
                    
                    self.mytableView.reloadData()
                    print(self.DetailDataList.count)
                    
                }
                
                
                
            case .failure(let error):
                print("Request failed with error: \(error)")
               if (((error as NSError).code == -1009 )||((error as NSError).code == -1001 )) {
                  self.showAlert("No Internet Conncetion")
                }
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                else{
                    self.showActivityIndicator()
                }
                }
        }
        
    }
    
    func showAlert(_ mesage :String){
        let alertView = UIAlertController(title: TITLE, message: mesage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    func showActivityIndicator(){
        if !self.showingActivity {
            self.navigationController?.view.makeToastActivity(.center)
        } else {
            self.navigationController?.view.hideToastActivity()
        }
        
        self.showingActivity = !self.showingActivity
        
    }
    
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        loadDetaildata();
    }
    
    
    //MARK: - Tableview Delegate & Datasource
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
            //tableView.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
            tableView.backgroundView=UIView()
            tableView.backgroundView?.backgroundColor = UIColor.clear
            return DetailDataList.count
        }
        
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let detaildata: DetailData = self.DetailDataList[(indexPath as NSIndexPath).row]
        
        
        if(detaildata.Type == LABEL)
        {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "LL1", for: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
            
        }
            
        else if(detaildata.Type == HIDDEN)
        {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "LL1", for: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            
            return UITableViewCell()
            
        }
            
        else if (detaildata.Type==TEXT || detaildata.Type==TEXTAREA) {
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "LT1", for: indexPath) as!CustomeCell3
            cell3.label1.text=detaildata.label
            if (NSString(string: detaildata.value!).length > 1){
                cell3.textfiled.text=detaildata.value}
            cell3.delegate=self
            cell3.textfiled.placeholder = detaildata.label!
            cell3.textfiled.delegate=self
            //   cell3.onEditingBegin = {(selectedRow) -> Void in   }
            
            return cell3
            
            
        }
            
        else if (detaildata.Type==DROPDOWN || detaildata.Type==RADIO) {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "LP1", for: indexPath) as!CustomeCell2
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
           
                
            }
            return cell2
            
        }
            
        else if (detaildata.Type == CHECKBOX){
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "Ltabel1", for: indexPath) as!CustomeCell4
            cell4.label1.text=detaildata.label
            cell4.optionsList=detaildata.OptionList
            cell4.chekboxTable.reloadData()
            
            return cell4
            
        }
        else if (detaildata.Type == DATE_TIME){
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "LD1", for: indexPath) as!CustomeCell5
            cell5.label.text = detaildata.label
            detaildata.value=cell5.dateTimePicker.getStringValue();
            cell5.onDateChnaged = { (selectedRow) -> Void in
                detaildata.value=cell5.dateTimePicker.getStringValue();
            }
            return cell5
            
        }
            
        else {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "LL1", for: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
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
        let indexPath = self.mytableView.indexPathForRow(at: cell.center)!
        let detaildata: DetailData = self.DetailDataList[(indexPath as NSIndexPath).row]
        detaildata.value=cell.textfiled.text!
        print("index \((indexPath as NSIndexPath).row)  value  \(cell.textfiled.text!)")
    }
    
    func UpdateRecords() {
        var code:String?
        var msg:String?
        self.showActivityIndicator()
        Alamofire.request(POST_DETAIL,method:.post,
            parameters: self.DetailDataList.getParams(self.currentData,type:self.type!,postFollowup: true)).validate().responseJSON
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
                 if (((error as NSError).code == -1009 )||((error as NSError).code == -1001 )) {
                    self.showAlert("No Internet Conncetion")
                }
                }
        }
    }
    
    
}

    
    
    
    
    
    
    
    
    
    

