//
//  ConfirmReshootPopup.swift
//  Spyne
//
//  Created by Vijay Parmar on 21/10/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit

class ConfirmReshootPopupVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lblTitleString: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    
    var btnDidYesTapped:(()->Void)?
    var btnDidNoTapped:(()->Void)?
    var strTitelString:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    func initialSetup()  {
        lblTitleString.text = "Are you sure you want to reshoot this angle?"
        btnNo.backgroundColor = .white
        btnNo.layer.borderWidth = 1
        btnNo.layer.borderColor = UIColor.appColor?.cgColor
        btnNo.setTitleColor(UIColor.appColor, for: .normal)
    }
    
    //MARK:- Button Action
    @IBAction func btnYesTapped(_ sender: UIButton) {
       
        self.dismiss(animated: true) {
            if let didYesTapped = self.btnDidYesTapped{
                didYesTapped()
            }
        }
       // self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnNoTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            if let didNoTapped = self.btnDidNoTapped{
                didNoTapped()
            }
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
}
