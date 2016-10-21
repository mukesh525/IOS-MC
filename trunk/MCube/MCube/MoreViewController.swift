//
//  MoreViewController.swift
//  MCube
//
//  Created by Mukesh Jha on 21/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

@objc protocol MoreSelectedDelegate {
    func moreSelected(_ position: Int)
}
class MoreViewController: UITableViewController {
    weak var delegate: MoreSelectedDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true, completion: nil)
        delegate?.moreSelected((indexPath as NSIndexPath).item)
    }
    
}
