//
//  SPBaseVC.swift
//  Spyne
//
//  Created by Vijay on 24/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPBaseVC: UIViewController {

    class BaseVC: UIViewController {
        // Set the shouldAutorotate to False
        override open var shouldAutorotate: Bool {
           return false
        }

        // Specify the orientation.
        override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .landscape
        }
    }
}
