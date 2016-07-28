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
    
    
    func ParseMenu(JSON:AnyObject) -> Array<OptionsData>{
       
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

    
       return self.options
}
    
  
    func ParseReportJason(JSON:AnyObject) -> NSMutableArray{
        result=NSMutableArray();
        options=[OptionsData]();
        let response = JSON as! NSDictionary
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
    
    
    
        return self.result
        
}
    
    
    
}
