//
//  File.swift
//  Spyne
//
//  Created by Vijay Parmar on 23/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit
class SPImageProcessingNavigationVC: UINavigationController {

    static var isReshoot = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//              appDelegate.myOrientation = .portrait
        
        
        if SPImageProcessingNavigationVC.isReshoot{
            
            SPImageProcessingNavigationVC.isReshoot = false
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SPDownloadCompletedVC")as? SPDownloadCompletedVC{
                self.setViewControllers([vc], animated: true)
            }
            
        }else{
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                self.setViewControllers([vc], animated: true)
            }
        }
    }
}
