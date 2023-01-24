//
//  SP360InteriorPopupVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 23/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SP360InteriorPopupVC: UIViewController {

    var btnSkipTapped : (()->Void)?
    var btnSelectTapped : (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    @IBAction func btnActionSkip(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let didTapped = self.btnSkipTapped{
            didTapped()
           }
        }
    }
    
    @IBAction func btnActionSelect(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            if let didTapped = self.btnSelectTapped{
                didTapped()
            }
        }
        
       
    }

}
