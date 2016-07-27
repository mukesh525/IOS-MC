
//  Created by Mukesh Jha on 26/07/16.
import UIKit
import Alamofire

protocol ReportDownload {
    func OnFinishDownload(result:NSMutableArray,param:Params)
    func OnError(error:NSError)
}


class Report: NSObject {
  var result:NSMutableArray=NSMutableArray();
  var param:Params?
  var delegate: ReportDownload?
  var options :Array<OptionsData> = Array<OptionsData>()
   
  init(param:Params,delegate: ReportDownload) {
        self.param=param;
       self.delegate=delegate;
    }
  func LoadData(){
        var callId:String?
        var callFrom:String?
        var callerName:String?
        var groupName:String?
        var status:String?
        var audioLink:String?
        var callTimeString:String?
        var empName:String?
        let authkey = NSUserDefaults.standardUserDefaults().stringForKey(AUTHKEY)
    
        Alamofire.request(.POST, GETLIST, parameters:
            [AUTHKEY:authkey!, LIMIT:(self.param?.Limit!)!,GROUP_ID: (self.param?.gid!)!,OFSET:(self.param?.offset!)!,TYPE:(self.param?.type!)!])
            .validate().responseJSON
            {response in switch response.result {
                
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                self.result=NSMutableArray();
                self.options=[OptionsData]();
                let response = JSON as! NSDictionary
                if(response.objectForKey(GROUPS) != nil){
                    let groups = response.objectForKey(GROUPS) as! NSArray?
                    for group in groups!{
                        let options=OptionsData();
                        if((group.objectForKey(KEY)) != nil){
                            options.id=group.objectForKey(KEY) as? String
                        }
                        if((group.objectForKey(VAL)) != nil){
                            options.value=group.objectForKey(VAL) as? String
                        }
                        self.options.append(options)
                    }
                    
                }
                if(response.objectForKey(RECORDS) != nil){
                    let records = response.objectForKey(RECORDS) as! NSArray?
                    for record in records!{
                        let data=Data();
                        if((record.objectForKey(CALLID)) != nil){
                            callId=record.objectForKey(CALLID) as? String
                            data.callId=callId;
                        }
                        if((record.objectForKey(CALLFROM)) != nil){
                            callFrom=record.objectForKey(CALLFROM) as? String
                            data.callFrom=callFrom;
                        }
                        if((record.objectForKey(STATUS)) != nil){
                            status=record.objectForKey(STATUS) as? String
                            data.status=status;
                        }
                        if((record.objectForKey(CALLER_NAME)) != nil){
                            callerName=record.objectForKey(CALLER_NAME) as? String
                            data.callerName=callerName;
                        }
                        if((record.objectForKey(GROUPNAME)) != nil){
                            groupName=record.objectForKey(GROUPNAME) as? String
                            data.groupName=groupName;
                        }
                        if((record.objectForKey(CALLTIME)) != nil){
                            callTimeString=record.objectForKey(CALLTIME) as? String
                            data.callTimeString=callTimeString;
                            data.callTime=callTimeString!.convertDateFormater()
                        }
                        else if((record.objectForKey(STARTTIME)) != nil){
                            callTimeString=record.objectForKey(STARTTIME) as? String
                            data.startTime=callTimeString;
                            
                        }
                        
                        if((record.objectForKey(EMPNAME)) != nil){
                            empName=record.objectForKey(EMPNAME) as? String
                            data.empName=empName;
                            
                        }
                        if((record.objectForKey(NAME)) != nil){
                            callerName=record.objectForKey(NAME) as? String
                            data.callerName=callerName;
                            
                        }
                         if((record.objectForKey(FILENAME)) != nil){
                            audioLink=record.objectForKey(FILENAME) as? String
                            data.audioLink=audioLink;
                        }
                        
                        self.result.addObject(data)
                    }
                    
                    
                    
                }
                if(!(self.param?.isfilter)!){
                    var isUpdated:Bool=false;
                    var ismenu:Bool=false;
                    
                    
                    if(self.param?.isMore == true && (self.param?.filterpos)! == 0){
                       isUpdated = ModelManager.getInstance().insertData((self.param?.type)!, isDelete: false, Datas: self.result,isMore:self.param?.isMore == true)
                    }
                    else
                    {
                     isUpdated = ModelManager.getInstance().insertData((self.param?.type!)!, isDelete: true, Datas: self.result,isMore:self.param?.isMore == true)
                      ismenu = ModelManager.getInstance().insertMenu((self.param?.type!)!, Options: self.options)
                        
                        if ismenu {
                           print("\((self.param?.type!)!)_Menu updated successfully.")
                        } else {
                            print("Error in updating \((self.param?.type!)!) Menu")
                        }
                   }
                   if isUpdated {
                        print("\((self.param?.type!)!) updated successfully.")
                    } else {
                        print("Error in updating \((self.param?.type!)!).")
                    }
                }
                
                self.delegate?.OnFinishDownload(self.result,param: self.param!)
                
            case .Failure(let error):
                 self.delegate?.OnError(error)
                }
                

              
                
        }
        
    }
 
    
    
    

}
