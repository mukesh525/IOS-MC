//
//  NetworkOperation.swift
//  MCube
//
//  Created by Mukesh Jha on 28/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Alamofire
import UIKit
class NetworkOperation : ConcurrentOperation {
    
  var type:String?
  let networkOperationCompletionHandler: (responseObject: AnyObject?, error: NSError?) -> ()
   weak var request: Alamofire.Request?
    
    init(type:String, networkOperationCompletionHandler: (responseObject: AnyObject?, error: NSError?) -> ()) {
        self.type = type
        self.networkOperationCompletionHandler = networkOperationCompletionHandler
        super.init()
    }
    
    // when the operation actually starts, this is the method that will be called
    
    override func main() {
        
        let authkey = NSUserDefaults.standardUserDefaults().stringForKey(AUTHKEY)
         request =  Alamofire.request(.POST, GETLIST, parameters:
            [AUTHKEY:authkey!, LIMIT:"10",GROUP_ID: "0",OFSET:"0",TYPE:type!])
            .validate()
            .responseJSON {response in
               // print("Background Result for type \(self.type!) and \(result.count)")
                self.networkOperationCompletionHandler(responseObject: response.result.value, error: response.result.error)
                self.completeOperation()
            }
        
        

    }
    
    override func cancel() {
        request?.cancel()
        super.cancel()
    }
}