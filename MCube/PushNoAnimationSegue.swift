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
        let source = sourceViewController as UIViewController
        if let navigation = source.navigationController {
            navigation.pushViewController(destinationViewController as UIViewController, animated: false)
        }
    }
}
