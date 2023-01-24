//
//  SPCreateProjectPopupVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 27/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit


protocol CreateProjectDelegate {
    
    func didSubmitTapped(projectName:String)
    
}

class SPCreateProjectPopupVC: UIViewController {

   
    @IBOutlet weak var txtProjectName: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
   
    var delegate :CreateProjectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initialSetup()
       // txtProjectName.isUserInteractionEnabled = false
    }
    
    func initialSetup()  {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        txtProjectName.textColor = UIColor.appColor
        txtProjectName.textColor = UIColor.appColor
        btnSubmit.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    @IBAction func btnActionSubmit(_ sender: UIButton) {
        
        if txtProjectName.text != ""{
            delegate?.didSubmitTapped(projectName: txtProjectName.text!)
            self.dismiss(animated: true, completion: nil)
        }

    }
    
}
