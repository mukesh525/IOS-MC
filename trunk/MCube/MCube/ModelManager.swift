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
    
    
    func createTable(_ tablename:String) -> Bool {
        sharedInstance.database!.open()
        let sqlStatement = "CREATE TABLE IF NOT EXISTS \(tablename) ( _id INTEGER PRIMARY KEY AUTOINCREMENT,callid TEXT,callfrom TEXT,dataid TEXT, callername TEXT,groupname TEXT,calltime  TEXT,status TEXT,audio TEXT,location TEXT)"
        let sqlStatement1 = "CREATE TABLE IF NOT EXISTS \(tablename)_menu (_id INTEGER PRIMARY KEY AUTOINCREMENT, optionid TEXT,optionname TEXT,isCheked TEXT )"
        let isCreated = sharedInstance.database!.executeUpdate(sqlStatement, withArgumentsIn:nil)
        let isCreatedmenu = sharedInstance.database!.executeUpdate(sqlStatement1, withArgumentsIn:nil)
        sharedInstance.database!.close()
        if(!isCreated || !isCreatedmenu){
            NSLog("Error %d: %@",sharedInstance.database!.lastErrorCode(), sharedInstance.database!.lastErrorMessage())
        }
        return isCreated
    }
    
    
    
    
    func insertData(_ tablename:String,isDelete:Bool,Datas:NSMutableArray,isMore:Bool) -> Bool {
        createTable(tablename)
        if(isDelete){
        deleteData(tablename,isMore: isMore)
        }
        var isInserted:Bool=false;
        let empty:String="N/A"
        sharedInstance.database!.open()
        for i in 0 ..< Datas.count {
        let data: Data = Datas[i] as! Data
            isInserted = sharedInstance.database!.executeUpdate("INSERT INTO \(tablename) (callid,callfrom,dataid,callername,groupname,calltime,status,audio,location) VALUES (?,?,?,?,?,?,?,?,?)", withArgumentsIn: [data.callId!, data.callFrom!,"N/A",data.callerName == nil ?"UNKNOWN":data.callerName!,data.groupName == nil ? data.empName!:data.groupName!,data.callTimeString == nil ? data.startTime!:data.callTimeString!,data.status == nil ? "UNKNOWN":data.status!,data.audioLink == nil ? empty:data.audioLink!,data.location == nil ? "0":data.location!])
            
        }
        
        if(!isInserted && Datas.count > 0){
            NSLog("Error while inserting  %d: %@",sharedInstance.database!.lastErrorCode(), sharedInstance.database!.lastErrorMessage())
        }
    
       sharedInstance.database!.close()
        return isInserted
     
    }
    
    
    func insertMenu(_ tablename:String,Options:Array<OptionsData>) -> Bool
     {
        createTable(tablename)
       // deleteData(tablename)
        var isInserted:Bool=false
        let empty:String="N/A"
        sharedInstance.database!.open()
        for option in Options {
            isInserted = sharedInstance.database!.executeUpdate("INSERT INTO \(tablename)_menu (optionid,optionname,isCheked) VALUES (?,?,?)", withArgumentsIn: [option.id!,option.value!,empty])
            
        }
        
        if(!isInserted){
            NSLog("Error %d: %@",sharedInstance.database!.lastErrorCode(), sharedInstance.database!.lastErrorMessage())
        }
        
        sharedInstance.database!.close()
        return isInserted
        
    }

    func getMenuData(_ tablename:String) -> Array<OptionsData>
    {
        var options = [OptionsData]()
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM \(tablename)_menu", withArgumentsIn: nil)
       
        if (resultSet != nil) {
            while resultSet.next() {
                let data :OptionsData=OptionsData()
                data.id = resultSet.string(forColumn: "optionid")
                data.value = resultSet.string(forColumn: "optionname")
                 options.append(data)
            }
        }
        sharedInstance.database!.close()
        return options
        
    }

    
    
    
     func getData(_ tablename:String)-> NSMutableArray
     {  let empty:String="N/A"
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM \(tablename)", withArgumentsIn: nil)
        let resultData : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let data : Data = Data()
                data.callId = resultSet.string(forColumn: "callid")
                data.callFrom = resultSet.string(forColumn: "callfrom")
                data.dataId = resultSet.string(forColumn: "dataid")
                data.callerName = resultSet.string(forColumn: "callername")
                data.location = resultSet.string(forColumn: "location")

                if(tablename == "mtracker"){
                    data.empName = resultSet.string(forColumn: "groupname")
                    data.startTime = resultSet.string(forColumn: "calltime")
                }else{
                    data.groupName = resultSet.string(forColumn: "groupname")
                    data.callTimeString = resultSet.string(forColumn: "calltime")
                
                }
                data.status = resultSet.string(forColumn: "status")
                if(resultSet.string(forColumn: "audio") != empty){
                data.audioLink = resultSet.string(forColumn: "audio")
                }
                resultData.add(data)
            }
        }
       sharedInstance.database!.close()
        return resultData
    }
    
        func deleteAllData(){
        
            sharedInstance.database!.open()
            var sucess:Bool=false;
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM track",withArgumentsIn: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM track_menu",withArgumentsIn: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM lead",withArgumentsIn: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM lead_menu",withArgumentsIn: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM ivrs",withArgumentsIn: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM ivrs_menu",withArgumentsIn: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM x",withArgumentsIn: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM x_menu",withArgumentsIn: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM followup",withArgumentsIn: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM followup_menu",withArgumentsIn: nil)
            
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM mtracker",withArgumentsIn: nil)
            sucess=sharedInstance.database!.executeUpdate("DELETE FROM mtracker_menu",withArgumentsIn: nil)
            sharedInstance.database!.close()
            if(sucess){
                print(" cleared sucessfullly")
            }
            
        
        
        }
  
    
    func deleteData(_ table:String,isMore:Bool){
        sharedInstance.database!.open()
        var sucessmenu:Bool=false;
        let sucess=sharedInstance.database!.executeUpdate("DELETE FROM \(table)",withArgumentsIn: nil)
        if(!isMore){
         sucessmenu=sharedInstance.database!.executeUpdate("DELETE FROM \(table)_menu",withArgumentsIn: nil)
        }
        sharedInstance.database!.close()
        if(sucess && sucessmenu){
        print("\(table) cleared sucessfullly")
        }
//        if(sucessmenu){
//         print("\(table)_menu cleared sucessfullly")
//        }
    
     }
   
    func updateStudentData(_ studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE student_info SET Name=?, Marks=? WHERE RollNo=?", withArgumentsIn: [studentInfo.Name, studentInfo.Marks, studentInfo.RollNo])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteStudentData(_ studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM student_info WHERE RollNo=?", withArgumentsIn: [studentInfo.RollNo])
        sharedInstance.database!.close()
        return isDeleted
    }

    func getAllStudentData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM student_info", withArgumentsIn: nil)
        let marrStudentInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let studentInfo : StudentInfo = StudentInfo()
                studentInfo.RollNo = resultSet.string(forColumn: "RollNo")
                studentInfo.Name = resultSet.string(forColumn: "Name")
                studentInfo.Marks = resultSet.string(forColumn: "Marks")
                marrStudentInfo.add(studentInfo)
            }
        }
        sharedInstance.database!.close()
        return marrStudentInfo
    }
}
