//
//  SPExitShootPopup.swift
//  Spyne
//
//  Created by Vijay on 04/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPExitShootPopup: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lblTitleString: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
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
        btnNo.setTitle("No" , for: .normal)
        btnYes.setTitle("Yes" , for: .normal)
        lblTitleString.text = strTitelString
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
