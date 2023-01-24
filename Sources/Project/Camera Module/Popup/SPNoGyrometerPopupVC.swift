//
//  SPNoGyrometerPopupVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 01/10/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPNoGyrometerPopupVC: UIViewController {

    var btnOkTapped : (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnActionOk(_ sender: UIButton) {
        
        if let didTapped = btnOkTapped{
            didTapped()
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
