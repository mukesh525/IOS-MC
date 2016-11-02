 //
//  Util.swift
//  DemoProject
//
//  Created by Krupa-iMac on 24/07/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    class func getPath(_ fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)

       // print(fileURL.path!)
        
        return fileURL.path
    }
    
    class func copyFile(_ fileName: NSString) {
        
          let dbPath: String = getPath(fileName as String)
          let fileManager : FileManager = FileManager.default
            if !fileManager.fileExists(atPath: dbPath) {
           
            let defaultStorePath : NSString! = Bundle.main.path(forResource: fileName as String, ofType: "db") as NSString!
            var error : NSError?
            if((defaultStorePath) != nil) {
                do {
                    
                   try fileManager.copyItem(atPath: defaultStorePath as String, toPath: dbPath)
                } catch let error1 as NSError {
                    error = error1
                }

         /*   let alert: UIAlertView = UIAlertView()
            if (error != nil) {
                alert.title = "Error Occured"
                alert.message = error?.localizedDescription
            } else {
                alert.title = "Successfully Copy"
                alert.message = "Your database copy successfully"
            }
            alert.delegate = nil
           alert.addButton(withTitle: "Ok")
           // alert.show()
        }*/
    }
      else{
         // print("databse exist")
        }
        }
    }
    
    func invokeAlertMethod(_ strTitle: NSString, strBody: NSString, delegate: AnyObject?) {
        let alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButton(withTitle: "Ok")
        alert.show()
        
        
    }
   
}
