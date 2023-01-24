//
//  SPShootSelectionWithoutAngleClassifier.swift
//  Spyne
//
//  Created by Akash Verma on 01/08/22.
//  Copyright © 2022 Spyne. All rights reserved.
//

import UIKit

class SPShootSelectionWithoutAngleClassifier: SPBaseVC {
    //Outlet
    @IBOutlet weak var imgOriginalImage: UIImageView!
    @IBOutlet weak var imgProssesdImage: UIImageView!
    @IBOutlet weak var btnReshoot: UIButton!
    @IBOutlet weak var lblSideViewName: UILabel!
    @IBOutlet weak var imgOverlayImage: UIImageView!
    
    var btnDidConfirmTapped:(()->Void)?
    var btnDidReshootTapped:(()->Void)?
    var strTitle = String()
    var frameAngle:String?
    var imgCapturedPic = UIImage()
    var imgImageWithOverlay = UIImage()
    var isFromExterior = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)

        let flippedCapturedImage = UIImage(cgImage: imgCapturedPic.cgImage!, scale: imgCapturedPic.scale, orientation: UIImage.Orientation.up)
        imgOriginalImage.image = flippedCapturedImage
       
        if isFromExterior{
            imgProssesdImage.image = imgImageWithOverlay
        }else{
            imgProssesdImage.image = flippedCapturedImage
        }
        

        imgOverlayImage.isHidden = true
       
    }
    // MARK:- Function
    func initialSetup()  {
        
        btnReshoot.layer.borderColor = UIColor.appColor?.cgColor
        btnReshoot.layer.borderWidth = 1
        btnReshoot.layer.cornerRadius = 5
        btnReshoot.tintColor = UIColor.appColor
        lblSideViewName.text = strTitle
        lblSideViewName.textColor = UIColor.appColor
    }
    
    
    //MARK:- Button Action
    @IBAction func reshoot(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let didTapped = self.btnDidReshootTapped{
                didTapped()
            }
        }
    }
    
    @IBAction func conform(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let didTapped = self.btnDidConfirmTapped{
                didTapped()
            }
        }
       
    }
    

}
