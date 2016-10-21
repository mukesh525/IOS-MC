//
//  ParseJason.swift
//  MCube
//
//  Created by Mukesh Jha on 28/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ParseJason: NSObject {

     var options :Array<OptionsData> = Array<OptionsData>()
     var result:NSMutableArray=NSMutableArray();
     var callId:String?
     var callFrom:String?
     var callerName:String?
     var groupName:String?
     var status:String?
     var audioLink:String?
     var callTimeString:String?
     var empName:String?
    var location:String?
    
    
    func ParseMenu(_ JSON:AnyObject) -> Array<OptionsData>{
       
        let response = JSON as! NSDictionary
        if(response.object(forKey: GROUPS) != nil){
            let groups = response.object(forKey: GROUPS) as! NSArray?
            for group in groups!{
                let options=OptionsData();
                if(((group as AnyObject).object(forKey: KEY)) != nil){
                    options.id=(group as AnyObject).object(forKey: KEY) as? String
                }
                if(((group as AnyObject).object(forKey: VAL)) != nil){
                    options.value=(group as AnyObject).object(forKey: VAL) as? String
                }
                self.options.append(options)
            }
            
        }

    
       return self.options
}
    
  
    func ParseReportJason(_ JSON:AnyObject,type:String) -> NSMutableArray{
        result=NSMutableArray();
        options=[OptionsData]();
        let response = JSON as! NSDictionary
        if(response.object(forKey: RECORDS) != nil){
            let records = response.object(forKey: RECORDS) as! NSArray?
            for record in records!{
                let data=Data();
                if(((record as AnyObject).object(forKey: CALLID)) != nil){
                    callId=(record as AnyObject).object(forKey: CALLID) as? String
                    data.callId=callId;
                }
                if(((record as AnyObject).object(forKey: CALLFROM)) != nil){
                    callFrom=(record as AnyObject).object(forKey: CALLFROM) as? String
                    data.callFrom=callFrom;
                    
                }
                if(((record as AnyObject).object(forKey: STATUS)) != nil){
                    status=(record as AnyObject).object(forKey: STATUS) as? String
                    data.status=status;
                }
                if(((record as AnyObject).object(forKey: CALLER_NAME)) != nil){
                    callerName=(record as AnyObject).object(forKey: CALLER_NAME) as? String
                    data.callerName=callerName;
                }
                if(((record as AnyObject).object(forKey: GROUPNAME)) != nil){
                    groupName=(record as AnyObject).object(forKey: GROUPNAME) as? String
                    data.groupName=groupName;
                }
                if(((record as AnyObject).object(forKey: CALLTIME)) != nil){
                    callTimeString=(record as AnyObject).object(forKey: CALLTIME) as? String
                    data.callTimeString=callTimeString;
                    data.callTime=callTimeString!.convertDateFormater()
                }
                else if(((record as AnyObject).object(forKey: STARTTIME)) != nil){
                    callTimeString=(record as AnyObject).object(forKey: STARTTIME) as? String
                    data.startTime=callTimeString;
                    
                       if(((record as AnyObject).object(forKey: STATUS)) != nil){
                        status=(record as AnyObject).object(forKey: STATUS) as? String
                        if(status == "0" || status == "1" || status == "2"){
                            if(((record as AnyObject).object(forKey: CALLTO)) != nil){
                                data.callFrom=(record as AnyObject).object(forKey: CALLTO) as? String
                        }
                     }
                    
                    }
                }
                
                if(((record as AnyObject).object(forKey: EMPNAME)) != nil){
                    empName=(record as AnyObject).object(forKey: EMPNAME) as? String
                    data.empName=empName;
                    
                }
                if(((record as AnyObject).object(forKey: NAME)) != nil){
                    callerName=(record as AnyObject).object(forKey: NAME) as? String
                    data.callerName=callerName;
                    
                }
                if(((record as AnyObject).object(forKey: FILENAME)) != nil){
                    audioLink=(record as AnyObject).object(forKey: FILENAME) as? String
                    data.audioLink=audioLink;
                }
                if(((record as AnyObject).object(forKey: LOCATION)) != nil){
                    location=(record as AnyObject).object(forKey: LOCATION) as? String
                    data.location=location;
                }
                
                self.result.add(data)
            }
            
                  }
    
    
    
        return self.result
        
}
    
    
    
}
