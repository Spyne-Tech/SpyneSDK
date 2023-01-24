//
//  SPInterialShootPopup.swift
//  Spyne
//
//  Created by Vijay on 24/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPInterialShootNamePopup: SPBaseVC {

    // Outlet
    @IBOutlet weak var txtName: UITextField!
    
    //variable
    var vcSPCaptureImageVC = SPCaptureImageVC()
    var btnDidSave : ((_ skuName:String)->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)

    }
    
    // MARK:- Button Action
    @IBAction func saveName(_ sender: UIButton) {
       
        if (!txtName.text!.isBlank)
        {
            if let didSave = btnDidSave{
                didSave(self.txtName.text!)
            }            
        }
        self.dismiss(animated: true, completion: nil)
    
    }
    
}
