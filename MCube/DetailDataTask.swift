//  DetailDataTask.swift
//  MCube

//  Created by Mukesh Jha on 27/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.


import UIKit
import Alamofire

protocol DetailDownload {
    func OnFinishDownload(_ result:Array<DetailData>)
    func OnError(_ error:NSError)
}
class DetailDataTask: NSObject {
    var delegate: DetailDownload?
    var DetailDataList = Array<DetailData>();
    var optionsList = Array<OptionsData>();
    
    var OptionStringList=[String]()

    init(delegate: DetailDownload) {
        self.delegate=delegate;
    }
    
   func loadDetaildata(_ authkey:String,type:String,currentData:Data) {
        
      Alamofire.request(GET_DETAIL_URL,method: .post,
            parameters: [AUTHKEY:authkey,TYPE:type, CALLID:currentData.callId!, GROUPNAME:(currentData.groupName != nil ? currentData.groupName :currentData.empName)!]).validate().responseJSON
            {response in switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                  if((response.object(forKey: FIELDS)) != nil){
                  self.DetailDataList  = Array<DetailData>();
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
                        
                        let optionsLabel = [DROPDOWN,RADIO,CHECKBOX]
                        print(detailData.Type!)
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
                                    //   value = "check1,check3";
                                    let newString = detailData.value!.replacingOccurrences(of: "\"", with: "")
                                    let toArray = newString.components(separatedBy: ",")
                                    print(newString)
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
                        self.DetailDataList.append(detailData);
                        
                        
                    }
                }
                 self.delegate?.OnFinishDownload(self.DetailDataList)
                
                
            case .failure(let error):
                self.delegate?.OnError(error as NSError)

                }
        }
        
    }

}
