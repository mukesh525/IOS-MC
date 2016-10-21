//
//  OverflowController.swift
//  MCube
//
//  Created by Mukesh Jha on 17/08/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
@objc protocol OverflowSelectedDelegate  {
    func overflowSelected(_ position: Int,CurrentData:Data)
}


class OverflowController: UITableViewController  {
    weak var delegate: OverflowSelectedDelegate?
    var CurrentData:Data!
    var `Type`:String!
     weak var dismissalDelegate: DismissalDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
         delegate?.overflowSelected((indexPath as NSIndexPath).row,CurrentData: CurrentData)
//        if(indexPath.row == 2){
//            dismissalDelegate?.finishedShowing(self)
//        }else{
//            delegate?.overflowSelected(indexPath.row,CurrentData: CurrentData)}
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if ((indexPath as NSIndexPath).row == 2 && Type != MTRACKER){
            return 0;
        }
        else{
          return 44
        }
        
    }

    
    
}
