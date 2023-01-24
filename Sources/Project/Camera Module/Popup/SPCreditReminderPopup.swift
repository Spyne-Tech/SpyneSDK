//
//  SPCreditReminderPopup.swift
//  Spyne
//
//  Created by Vijay on 22/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPCreditReminderPopup: SPBaseVC {

    //Outlet
    @IBOutlet weak var lblRemainingCredits: UILabel!
    
    @IBOutlet weak var lblRequestCreditOnWhatsapp: UILabel!
    // Variable
    //var vmSPHomeVM = SPHomeVM()
    var strRemainingCredits:String?
    var didCloseTapped:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblRemainingCredits.textColor = UIColor.appColor
        lblRequestCreditOnWhatsapp.textColor = UIColor.appColor
//        getUsersCredit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblRemainingCredits.text = strRemainingCredits
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
//MARK:- Button Action
    @IBAction func popupClose(_ sender: UIButton) {
        
        if let didTapped = didCloseTapped{
            didTapped()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestCreditOnWhatsapp(_ sender: UIButton) {
        print("Request Whatsapp ")
    }
    
//    func getUsersCredit(){
//        vmSPHomeVM.getUsersCreditDetails{
//            let credit = Storage.shared.getCredit()
//            self.lblRemainingCredits.text = "\((credit?.creditAvailable)!) Credits remaining"
//        } onError: { (errMessage) in
//            ShowAlert(message: errMessage, theme: .error)
//        }
//    }

}
