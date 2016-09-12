//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let sharedInstance = ModelManager()

class ModelManager: NSObject {
    
    var database: FMDatabase? = nil

    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
           sharedInstance.database = FMDatabase(path: Util.getPath("mcubeios.db"))
        }
        return sharedInstance
    }
    
    
    func createTable(tablename:String) -> Bool {
        sharedInstance.database!.open()
        let sqlStatement = "CREATE TABLE IF NOT EXISTS \(tablename) ( _id INTEGER PRIMARY KEY AUTOINCREMENT,callid TEXT,callfrom TEXT,dataid TEXT, callername TEXT,groupname TEXT,calltime  TEXT,status TEXT,audio TEXT,location TEXT)"
        let sqlStatement1 = "CREATE TABLE IF NOT EXISTS \(tablename)_menu (_id INTEGER PRIMARY KEY AUTOINCREMENT, optionid TEXT,optionname TEXT,isCheked TEXT )"
        let isCreated = sharedInstance.database!.executeUpdate(sqlStatement, withArgumentsInArray:nil)
        let isCreatedmenu = sharedInstance.database!.executeUpdate(sqlStatement1, withArgumentsInArray:nil)
        sharedInstance.database!.close()
        if(!isCreated || !isCreatedmenu){
            NSLog("Error %d: %@",sharedInstance.database!.lastErrorCode(), sharedInstance.database!.lastErrorMessage())
        }
        return isCreated
    }
    
    
    
    
    func insertData(tablename:String,isDelete:Bool,Datas:NSMutableArray,isMore:Bool) -> Bool {
        createTable(tablename)
        if(isDelete){
        deleteData(tablename,isMore: isMore)
        }
        var isInserted:Bool=false;
        let empty:String="N/A"
        sharedInstance.database!.open()
        for i in 0 ..< Datas.count {
        let data: Data = Datas[i] as! Data
            isInserted = sharedInstance.database!.executeUpdate("INSERT INTO \(tablename) (callid,callfrom,dataid,callername,groupname,calltime,status,audio) VALUES (?,?,?,?,?,?,?,?.?)", withArgumentsInArray: [data.callId!, data.callFrom!,"N/A",data.callerName == nil ?"UNKNOWN":data.callerName!,data.groupName == nil ? data.empName!:data.groupName!,data.callTimeString == nil ? data.startTime!:data.callTimeString!,data.status == nil ? "UNKNOWN":data.status!,data.audioLink == nil ? empty:data.audioLink!,data.location == nil ? "0,0":data.location!])
            
        }
        
        if(!isInserted && Datas.count > 0){
            NSLog("Error %d: %@",sharedInstance.database!.lastErrorCode(), sharedInstance.database!.lastErrorMessage())
        }
    
       sharedInstance.database!.close()
        return isInserted
     
    }
    
    
    func insertMenu(tablename:String,Options:Array<OptionsData>) -> Bool
     {
        createTable(tablename)
       // deleteData(tablename)
        var isInserted:Bool=false
        let empty:String="N/A"
        sharedInstance.database!.open()
        for option in Options {
            isInserted = sharedInstance.database!.executeUpdate("INSERT INTO \(tablename)_menu (optionid,optionname,isCheked) VALUES (?,?,?)", withArgumentsInArray: [option.id!,option.value!,empty])
            
        }
        
        if(!isInserted){
            NSLog("Error %d: %@",sharedInstance.database!.lastErrorCode(), sharedInstance.database!.lastErrorMessage())
        }
        
        sharedInstance.database!.close()
        return isInserted
        
    }

    func getMenuData(tablename:String) -> Array<OptionsData>
    {
        var options = [OptionsData]()
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM \(tablename)_menu", withArgumentsInArray: nil)
       
        if (resultSet != nil) {
            while resultSet.next() {
                let data :OptionsData=OptionsData()
                data.id = resultSet.stringForColumn("optionid")
                data.value = resultSet.stringForColumn("optionname")
                 options.append(data)
            }
        }
        sharedInstance.database!.close()
        return options
        
    }

    
    
    
     func getData(tablename:String)-> NSMutableArray
     {  let empty:String="N/A"
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM \(tablename)", withArgumentsInArray: nil)
        let resultData : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let data : Data = Data()
                data.callId = resultSet.stringForColumn("callid")
                data.callFrom = resultSet.stringForColumn("callfrom")
                data.dataId = resultSet.stringForColumn("dataid")
                data.callerName = resultSet.stringForColumn("callername")
                if(tablename == "mtracker"){
                    data.empName = resultSet.stringForColumn("groupname")
                    data.startTime = resultSet.stringForColumn("calltime")
                }else{
                    data.groupName = resultSet.stringForColumn("groupname")
                    data.callTimeString = resultSet.stringForColumn("calltime")
                
                }
                data.status = resultSet.stringForColumn("status")
                if(resultSet.stringForColumn("audio") != empty){
                data.audioLink = resultSet.stringForColumn("audio")
                }
                resultData.addObject(data)
            }
        }
       sharedInstance.database!.close()
        return resultData
    }
    
        func deleteAllData(){
        
            sharedInstance.database!.open()
            var sucess:Bool=false;
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM track",withArgumentsInArray: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM track_menu",withArgumentsInArray: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM lead",withArgumentsInArray: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM lead_menu",withArgumentsInArray: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM ivrs",withArgumentsInArray: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM ivrs_menu",withArgumentsInArray: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM x",withArgumentsInArray: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM x_menu",withArgumentsInArray: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM followup",withArgumentsInArray: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM followup_menu",withArgumentsInArray: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM mtracker",withArgumentsInArray: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM mtracker_menu",withArgumentsInArray: nil)
            sharedInstance.database!.close()
            if(sucess){
                print(" cleared sucessfullly")
            }
            
        
        
        }
  
    
    func deleteData(table:String,isMore:Bool){
        sharedInstance.database!.open()
        var sucessmenu:Bool=false;
        let sucess=sharedInstance.database!.executeUpdate("DELETE FROM \(table)",withArgumentsInArray: nil)
        if(!isMore){
         sucessmenu=sharedInstance.database!.executeUpdate("DELETE FROM \(table)_menu",withArgumentsInArray: nil)
        }
        sharedInstance.database!.close()
        if(sucess && sucessmenu){
        print("\(table) cleared sucessfullly")
        }
//        if(sucessmenu){
//         print("\(table)_menu cleared sucessfullly")
//        }
    
     }
   
    func updateStudentData(studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE student_info SET Name=?, Marks=? WHERE RollNo=?", withArgumentsInArray: [studentInfo.Name, studentInfo.Marks, studentInfo.RollNo])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteStudentData(studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM student_info WHERE RollNo=?", withArgumentsInArray: [studentInfo.RollNo])
        sharedInstance.database!.close()
        return isDeleted
    }

    func getAllStudentData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM student_info", withArgumentsInArray: nil)
        let marrStudentInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let studentInfo : StudentInfo = StudentInfo()
                studentInfo.RollNo = resultSet.stringForColumn("RollNo")
                studentInfo.Name = resultSet.stringForColumn("Name")
                studentInfo.Marks = resultSet.stringForColumn("Marks")
                marrStudentInfo.addObject(studentInfo)
            }
        }
        sharedInstance.database!.close()
        return marrStudentInfo
    }
}
