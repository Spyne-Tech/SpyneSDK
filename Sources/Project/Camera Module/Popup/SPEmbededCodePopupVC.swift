//
//  SPEmbededCodePopupVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 04/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPEmbededCodePopupVC: UIViewController {

    @IBOutlet weak var txtCode: UITextView!
    var url = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCode.isEditable = false
        txtCode.text = "<iframe src=\"\(url)\" width=\"100%\" height=\"300\" style=\"border:none;\"> </iframe>"
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnActionCopy(_ sender: UIButton) {
        UIPasteboard.general.string = txtCode.text
        ShowAlert(message: "Code Copied !", theme: .success)
    }
}
