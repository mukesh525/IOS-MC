
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
        let authkey = NSUserDefaults.standardUserDefaults().stringForKey("authkey")
        Alamofire.request(.POST, "https://mcube.vmc.in/mobapp/getList", parameters:
            ["authKey":authkey!, "limit":(self.param?.Limit!)!,"gid": (self.param?.gid!)!,"ofset":(self.param?.offset!)!,"type":(self.param?.type!)!])
            .validate().responseJSON
            {response in switch response.result {
                
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                self.result=NSMutableArray();
                self.options=[OptionsData]();
                let response = JSON as! NSDictionary
                if(response.objectForKey("groups") != nil){
                    let groups = response.objectForKey("groups") as! NSArray?
                    for group in groups!{
                        let options=OptionsData();
                        if((group.objectForKey("key")) != nil){
                            options.id=group.objectForKey("key") as? String
                        }
                        if((group.objectForKey("val")) != nil){
                            options.value=group.objectForKey("val") as? String
                        }
                        self.options.append(options)
                    }
                    
                }
                if(response.objectForKey("records") != nil){
                    let records = response.objectForKey("records") as! NSArray?
                    for record in records!{
                        let data=Data();
                        if((record.objectForKey("callid")) != nil){
                            callId=record.objectForKey("callid") as? String
                            data.callId=callId;
                        }
                        if((record.objectForKey("callfrom")) != nil){
                            callFrom=record.objectForKey("callfrom") as? String
                            data.callFrom=callFrom;
                        }
                        
                        if((record.objectForKey("callid")) != nil){
                            callId=record.objectForKey("callid") as? String
                            data.callId=callId;
                        }
                        if((record.objectForKey("status")) != nil){
                            status=record.objectForKey("status") as? String
                            data.status=status;
                        }
                        if((record.objectForKey("callername")) != nil){
                            callerName=record.objectForKey("callername") as? String
                            data.callerName=callerName;
                        }
                        if((record.objectForKey("groupname")) != nil){
                            groupName=record.objectForKey("groupname") as? String
                            data.groupName=groupName;
                        }
                        if((record.objectForKey("calltime")) != nil){
                            callTimeString=record.objectForKey("calltime") as? String
                            data.callTimeString=callTimeString;
                            data.callTime=callTimeString!.convertDateFormater()
                        }
                        else if((record.objectForKey("starttime")) != nil){
                            callTimeString=record.objectForKey("starttime") as? String
                            data.startTime=callTimeString;
                            
                        }
                        
                        if((record.objectForKey("empName")) != nil){
                            empName=record.objectForKey("empName") as? String
                            data.empName=empName;
                            
                        }
                        if((record.objectForKey("name")) != nil){
                            callerName=record.objectForKey("name") as? String
                            data.callerName=callerName;
                            
                        }
                         if((record.objectForKey("filename")) != nil){
                            audioLink=record.objectForKey("filename") as? String
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
                            // Util.invokeAlertMethod("", strBody: "\((self.param?.type!)!) _Menu updated successfully.", delegate: nil)
                            print("\((self.param?.type!)!)_Menu updated successfully.")
                        } else {
                            // Util.invokeAlertMethod("", strBody: "Error in updating \((self.param?.type!)!) Menu .", delegate: nil)
                            print("Error in updating \((self.param?.type!)!) Menu")
                        }
                        
                    }
                  
                    if isUpdated {
                       // Util.invokeAlertMethod("", strBody: "\((self.param?.type!)!) updated successfully.", delegate: nil)
                          print("\((self.param?.type!)!) updated successfully.")
                    } else {
                       // Util.invokeAlertMethod("", strBody: "Error in updating \((self.param?.type!)!) .", delegate: nil)
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
