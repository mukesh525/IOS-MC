//
//  Params.swift
//  MCube
//
//  Created by Mukesh Jha on 26/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class Params: NSObject {

    var Limit:Int?
    var gid:String?
    var offset:Int?
    var type:String?
    var isfilter:Bool=false
    var isMore:Bool=false
    var isSync:Bool=false
    var filterpos: Int?
  
    override init() {
        
    }
    
    init(Limit:Int,gid:String,offset:Int,type:String,isfilter:Bool,isMore:Bool,isSync:Bool,filterpos:Int) {
        
        self.Limit=Limit;
        self.gid=gid;
        self.offset=offset;
        self.type=type;
        self.isfilter=isfilter;
        self.isMore=isMore;
        self.isSync=isSync;
        self.filterpos=filterpos;
       
        
    }
    
    
}
