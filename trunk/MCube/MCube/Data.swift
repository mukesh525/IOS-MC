//
//  Data.swift
//  MCube
//
//  Created by Mukesh Jha on 04/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class Data: NSObject {
    var callId:String?
    var callFrom:String?
    var callerName:String?
    var groupName:String?
    var callTime:NSDate?
    var status:String?
    var dataId:String?
    var audioLink:String?
    var callTimeString:String?
    var startTime:String?
    var empName:String?
    
    override init() {
        
    }
    
    init(callId:String,
         callFrom:String,
    callerName:String,
    groupName:String,
    status:String,
    dataId:String,
    audioLink:String,
    callTimeString:String) {
       
        self.callId=callId;
        self.callFrom=callFrom;
        self.callerName=callerName;
        self.groupName=groupName;
        self.status=status;
        self.dataId=dataId;
        self.audioLink=audioLink;
        self.callTimeString=callTimeString;
    
    
    }
    
    
}
