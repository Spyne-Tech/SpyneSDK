//
//  SPDownloadCompletedSecondVC.swift
//  Spyne
//
//  Created by Vijay on 21/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPDownloadCompletedSecondVC: UIViewController {

    // Outlet
    @IBOutlet weak var btnGotoHome: UIButton!
    @IBOutlet weak var lblDownloadCompleted: UILabel!
    @IBOutlet weak var btnStartNewShoot: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    
    }
    
    // MARK:- Function
    func initialSetup()  {
        lblDownloadCompleted.textColor = UIColor.appColor
        btnGotoHome.setTitleColor(UIColor.appColor, for: .normal)
        btnGotoHome.setBackgroundColor(.white, forState: .highlighted)
        btnGotoHome.setBackgroundColor(.white, forState: .normal)
//        btnStartNewShoot.setTitleColor(.white, for: .selected)
//        btnStartNewShoot.setTitleColor(.white, for: .focused)
//        btnStartNewShoot.setTitleColor(.white, for: .highlighted)
//        btnStartNewShoot.setTitleColor(.white, for: .normal)
    }
    
    
    //MARK:- Button Action
    
    
    @IBAction func btnActionBack(_ sender: UIBarButtonItem) {
//        AppDelegate.navToHome(selectedIndex: 0)
    }
    
 
    @IBAction func gotoHome(_ sender: UIButton) {
//        AppDelegate.navToHome(selectedIndex: 0)
    }
    
    @IBAction func startNewShoot(_ sender: UIButton) {
    }
    
}
