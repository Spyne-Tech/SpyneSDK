//
//  SPShootSelectionPopup.swift
//  Spyne
//
//  Created by Vijay on 24/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit


class SPShootSelectionPopup: SPBaseVC {
    //Outlet
    @IBOutlet weak var imgOriginalImage: UIImageView!
    @IBOutlet weak var imgProssesdImage: UIImageView!
    @IBOutlet weak var btnReshoot: UIButton!
    @IBOutlet weak var lblSideViewName: UILabel!
    @IBOutlet weak var imgOverlayImage: UIImageView!
    @IBOutlet weak var viewValidCategoryMainContainer: UIView!
    @IBOutlet weak var viewValidAngleMainContainer: UIView!
    @IBOutlet weak var viewValidCatMessageContainer: UIView!
    @IBOutlet weak var viewValidAngleMessageContainer: UIView!
    @IBOutlet weak var lblValidCategoryMessage: UILabel!
    @IBOutlet weak var viewResponse: UIView!
    @IBOutlet weak var viewCheckingTime: UIView!
    @IBOutlet weak var lblShootMessage: UILabel!
    @IBOutlet weak var lblValidAngleMessage: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var viewAngleClassifireContainer: UIView!
    
    var btnDidConfirmTapped:(()->Void)?
    var btnDidReshootTapped:(()->Void)?
    var strTitle = String()
    var imgCapturedPic = UIImage()
    var imgImageWithOverlay = UIImage()
    var isFromExterior = false
    var frameAngle:String?
    var vmShoot = SPShootViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        viewAngleClassifireContainer.isHidden = false
        let flippedCapturedImage = UIImage(cgImage: imgCapturedPic.cgImage!, scale: imgCapturedPic.scale, orientation: UIImage.Orientation.up)
        imgOriginalImage.image = flippedCapturedImage
        if isFromExterior{
            imgProssesdImage.image = imgImageWithOverlay
        }else{
            imgProssesdImage.image = flippedCapturedImage
        }
        if frameAngle == nil || frameAngle == ""{
            btnConfirm.isEnabled = true
            viewAngleClassifireContainer.isHidden = true
        }else{
            let angleClassifierUploadImage =  AngleClassifierUploadImageModel(image_file: flippedCapturedImage, required_angle: frameAngle?.toInt() ?? 0, crop_check: true)
            vmShoot.angleClassifierUpload(angleClassifierUploadImageModel: angleClassifierUploadImage) { [self] in
                viewCheckingTime.isHidden = true
                viewResponse.isHidden = false
                if (vmShoot.angleClassifierData?.data?.validAngle ?? false) == true && (vmShoot.angleClassifierData?.data?.validCategory ?? false) == true{
                    btnConfirm.isEnabled = true
                    lblShootMessage.text = StringCons.yourImageIsPerfectYouAreGoodToGo 
                
                    viewValidCategoryMainContainer.isHidden = false
                    viewValidCatMessageContainer.backgroundColor = .systemGreen
                    lblValidCategoryMessage.text = StringCons.yourImageIsInFrame 
                    
                    viewValidAngleMainContainer.isHidden = false
                    viewValidAngleMessageContainer.backgroundColor = .systemGreen
                    lblValidAngleMessage.text = StringCons.imageMatchingTheAngle 
                }else{
                    if (vmShoot.angleClassifierData?.data?.validCategory ?? true) == false{
                        viewValidCategoryMainContainer.isHidden = false
                        viewValidCatMessageContainer.backgroundColor = .red
                        lblValidCategoryMessage.text = vmShoot.angleClassifierData?.message
                        lblShootMessage.text = StringCons.pleaseReshoot 
                    }
                    if (vmShoot.angleClassifierData?.data?.validAngle ?? true) == false{
                        viewValidAngleMainContainer.isHidden = false
                        viewValidAngleMessageContainer.backgroundColor = .red
                        lblValidAngleMessage.text = StringCons.yourAngleIsInvalid
                        lblShootMessage.text = StringCons.pleaseReshoot 
                    }
                }
            } onError: { message in
                ShowAlert(message: message, theme: .error)
            }
        }
        imgOverlayImage.isHidden = true
    }
    
    // MARK:- Function
    func initialSetup()  {
        viewCheckingTime.isHidden = false
        viewResponse.isHidden = true
        btnReshoot.setTitle("Reshoot" , for: .normal)
        btnConfirm.setTitle("Confirm" , for: .normal)
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
