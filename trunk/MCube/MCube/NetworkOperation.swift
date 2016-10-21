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
  let networkOperationCompletionHandler: (_ responseObject: AnyObject?, _ error: NSError?) -> ()
   weak var request: Alamofire.Request?
    
    init(type:String, networkOperationCompletionHandler: @escaping (_ responseObject: AnyObject?, _ error: NSError?) -> ()) {
        self.type = type
        self.networkOperationCompletionHandler = networkOperationCompletionHandler
        super.init()
    }
    
    // when the operation actually starts, this is the method that will be called
    
    override func main() {
        
        let authkey = UserDefaults.standard.string(forKey: AUTHKEY)
        request =  Alamofire.request(GETLIST,method:.post, parameters:
            [AUTHKEY:authkey!, LIMIT:"10",GROUP_ID: "0",OFSET:"0",TYPE:type!])
            .validate()
            .responseJSON {response in
               // print("Background Result for type \(self.type!) and \(result.count)")
                self.networkOperationCompletionHandler(response.result.value as AnyObject?, response.result.error as NSError?)
                self.completeOperation()
            }
        
        

    }
    
    override func cancel() {
        request?.cancel()
        super.cancel()
    }
}
