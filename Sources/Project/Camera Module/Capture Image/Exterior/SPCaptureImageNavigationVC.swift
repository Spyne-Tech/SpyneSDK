//
//  SPCaptureImageNavigationVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 23/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPCaptureImageNavigationVC: UINavigationController {
    
    static var isReshoot = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.myOrientation = .landscapeRight
        if SPCaptureImageNavigationVC.isReshoot{
            SPCaptureImageNavigationVC.isReshoot = false
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SPReshootCameraVC")as? SPReshootCameraVC{
                self.setViewControllers([vc], animated: true)
            }
        }else{
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SPCaptureImageVC")as? SPCaptureImageVC{
                self.setViewControllers([vc], animated: true)
            }
        }
        
    }
    
}
