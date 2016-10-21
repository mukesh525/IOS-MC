//
//  PushNoAnimationSegue.swift
//  MCube
//
//  Created by Mukesh Jha on 12/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class PushNoAnimationSegue: UIStoryboardSegue {

    override func perform() {
        let sources = source as UIViewController
        if let navigation = sources.navigationController {
            navigation.pushViewController(destination as UIViewController, animated: false)
        }
    }
}
