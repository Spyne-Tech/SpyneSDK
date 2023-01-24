//
//  SPYourGift.swift
//  Spyne
//
//  Created by Vijay on 21/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPYourGiftVC: UIViewController {

    // Outlet
    @IBOutlet weak var btnWhatsapp: UIButton!
    @IBOutlet weak var lblAttributedEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributedEmailString(emailId: USER.userEmail)
    }
    
    func setAttributedEmailString(emailId: String)  {
        
        let fullAttributerString = NSMutableAttributedString(string: "Your 360 Shot now sent at \n ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black ])
        fullAttributerString.append (NSAttributedString(string: emailId, attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor!]))
        lblAttributedEmail.attributedText = fullAttributerString
        
    }

   
    
    //MARK:- buttont Action
    @IBAction func btnActionBack(_ sender: UIBarButtonItem) {
//        AppDelegate.navToHome(selectedIndex: 0)
    }
    
    @IBAction func shareShotOnWhatsapp(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SPDownloadCompletedSecondVC")as? SPDownloadCompletedSecondVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
