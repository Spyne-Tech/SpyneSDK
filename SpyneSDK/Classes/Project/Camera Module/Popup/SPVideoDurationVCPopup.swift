//
//  SPVideoDurationVCPopup.swift
//  Spyne
//
//  Created by Vijay Parmar on 10/02/22.
//  Copyright © 2022 Spyne. All rights reserved.
//

import UIKit

class SPVideoDurationVCPopup: UIViewController {

    var didSelectReshoot : (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnActionReshoot(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let didSelect = self.didSelectReshoot{
                didSelect()
            }
        }
    }
    
}
