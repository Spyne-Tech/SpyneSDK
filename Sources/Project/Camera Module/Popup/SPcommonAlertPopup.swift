//
//  SPBackGroundSelectionPopup.swift
//  Spyne
//
//  Created by Vijay on 24/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPcommonAlertPopup: SPBaseVC {

    // Outlet
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblDisplayAlert: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
       
    }
    
    //MARK:- Function
    func initialSetup()  {
        btnYes.layer.borderWidth = 1
        btnYes.layer.borderColor = UIColor.appColor?.cgColor
        btnYes.tintColor = UIColor.appColor
        
    }

    //MARK:- Button Action
    @IBAction func exitShot(_ sender: UIButton) {
    }
    
    @IBAction func continueShot(_ sender: UIButton) {
    }
    @IBAction func popupClose(_ sender: UIButton) {
        print("Close")
        self.dismiss(animated: true, completion: nil)
    }
    
}
