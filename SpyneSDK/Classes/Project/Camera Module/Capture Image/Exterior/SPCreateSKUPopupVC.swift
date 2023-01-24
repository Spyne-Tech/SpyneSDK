//
//  SPCreateSKUPopupVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 14/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

import UIKit


protocol CreateSKUDelegate {
    
    func didSubmitSKUTapped(skuName:String)
    
}

class SPCreateSKUPopupVC: UIViewController {

    @IBOutlet weak var txtSKUName: SPTextField!
    @IBOutlet weak var txtProjectName: SPTextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var delegate :CreateSKUDelegate?
    var projectName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)

    }
    
    func initialSetup()  {
        txtProjectName.delegate = self
        txtSKUName.delegate = self
        txtProjectName.valueType = .alphaNumeric
        txtSKUName.valueType = .alphaNumeric
        txtProjectName.text = projectName
        txtSKUName.textColor = UIColor.appColor
        btnSubmit.setTitleColor(UIColor.white, for: .normal)
        label.text = "Enter Any Unique Car ID" 
        btnSubmit.setTitle("Submit" , for: .normal)
    }
    
    @IBAction func btnActionSubmit(_ sender: UIButton) {
        if txtSKUName.text! != ""{
            delegate?.didSubmitSKUTapped(skuName: txtSKUName.text!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension SPCreateSKUPopupVC:UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
     
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

         // Verify all the conditions
         if let sdcTextField = textField as? SPTextField {
             return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
         }
        return true
     }
}
