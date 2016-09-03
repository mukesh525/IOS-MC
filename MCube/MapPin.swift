//
//  MapPin.swift
//  MCube
//
//  Created by Mukesh Jha on 03/09/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import MapKit

class MapPin : MKPointAnnotation {
    var name: String
    var type: String
    var time: String
    var date: String
    var number: String
    
    
    init(name: String,type:String,time:String,date:String,number:String) {
        self.name = name
        self.type = type
        self.time = time
        self.date = date
        self.number=number
    }}