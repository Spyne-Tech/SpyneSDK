//
//  SPAngleClasifierV2ViewController.swift
//  Spyne
//
//  Created by Akash Verma on 06/09/22.
//  Copyright © 2022 Spyne. All rights reserved.
//

import UIKit
import KRProgressHUD

//MARK: Class SPAngleClasifierV2ViewController
/// SPAngleClasifierV2ViewController is a View controller holding the views which will give the validation and qualty of the image.
class SPAngleClasifierV2ViewController: UIViewController {

    //MARK: IBOutlets
    /// ParentView is a top most view.
    @IBOutlet weak var parentView: UIView!
    
    /// imageValidatorView: Is a custom view of SPImageClassifierImageValidatorView which will deal with the angle and distance and crop functionality
    @IBOutlet weak var imageValidatorView: SPImageClassifierImageValidatorView!
    
    ///imageQualityValidatorView: is a custom view of SPImageQualityValidatorPopUpView which will deal with the exposure and brightness
    @IBOutlet weak var imageQualityValidatorView: SPImageQualityValidatorPopUpView!
    
    ///loaderView: This will stay on the view untill the angle-classifier give the response
    @IBOutlet weak var loaderView: UIView!

    
    //MARK: Class variables
    ///strTitle : for the title
    var strTitle = String()
    
    ///imgCapturedPic: Captured image pic is being passed from the initilizer of the view
    var imgCapturedPic = UIImage()
    
    ///imgImageWithOverlay: overlay image pic is being passed from the initilizer of the view
    var imgImageWithOverlay = UIImage()
    
    ///isFromExterior: is the check for the exterior image overlay
    var isFromExterior = false
    
    ///frameAngle: Is string value which is basically being used when to check in the API
    var frameAngle:String?
    
    ///vmShoot: Is the object for callling the API in SPShootViewModel
    var vmShoot = SPShootViewModel()
    
    ///finalImage: Is for local file image usage
    var finalImage = UIImage()
    
    ///overLayImage: Is for local file overlay image usage
    var overLayImage = UIImage()
    
    //Callback variables
    ///btnDidConfirmTapped: complition handler for the confirm tapped button
    var btnDidConfirmTapped:(()->Void)?
    
    ///btnDidReshootTapped: complition handler for the reshoot tapped button
    var btnDidReshootTapped:(()->Void)?
    
    //MARK: View controller life cycle methods
    ///ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        inititalSetUp()
        imageQualityValidatorView.delegate = self
        imageValidatorView.delegate = self
        loaderView.isHidden = false
        imageQualityValidatorView.isHidden = true
        imageValidatorView.isHidden = true
    }
    
    //MARK: Class methods
    ///inititalSetUp: is the method which basically initilaizes the whole view and cals the API
    func inititalSetUp() {
//        KRProgressHUD.show()
        let flippedCapturedImage = UIImage(cgImage: imgCapturedPic.cgImage!, scale: imgCapturedPic.scale, orientation: UIImage.Orientation.up)
        self.finalImage = flippedCapturedImage
        if isFromExterior{
            overLayImage = imgImageWithOverlay
        }else{
            overLayImage = flippedCapturedImage
        }
            let angleClassifierUploadImage =  AngleClassifierUploadImageModel(image_file: flippedCapturedImage, required_angle: frameAngle?.toInt() ?? 0, crop_check: true)
            vmShoot.angleClassifierUpload(angleClassifierUploadImageModel: angleClassifierUploadImage) { [self] in
                imageValidatorView.isHidden = false
                loaderView.isHidden = true
                var isCropped = true
                if !(vmShoot.angleClassifierData?.data?.cropArray?.top ?? false) && !(vmShoot.angleClassifierData?.data?.cropArray?.bottom ?? false) && !(vmShoot.angleClassifierData?.data?.cropArray?.left ?? false) &&
                    !(vmShoot.angleClassifierData?.data?.cropArray?.right ?? false) {
                    isCropped = false
                } else {
                    isCropped = true
                }
                if (vmShoot.angleClassifierData?.data?.carAngle ??  false) && ((vmShoot.angleClassifierData?.data?.distance) ?? "" ==  "good") && !isCropped {
                    imageValidatorView.isHidden = true
                    imageQualityValidatorView.isHidden = false
                    imageQualityValidatorView.settingLocalVariables(reflection: vmShoot.angleClassifierData?.data?.reflection ?? "", exposure: vmShoot.angleClassifierData?.data?.exposure ?? "", capturedImage: flippedCapturedImage)
                } else {
                    imageQualityValidatorView.isHidden = true
                    imageValidatorView.isHidden = false
                    imageValidatorView.configureVariables(isImageNotCropped: !isCropped , isImageAngleCorrect: vmShoot.angleClassifierData?.data?.carAngle ??  false, clickedImage: self.finalImage, croppedSide: vmShoot.angleClassifierData?.data?.cropArray, distance: vmShoot.angleClassifierData?.data?.distance ?? "", overlayImage: self.overLayImage)
                }
            } onError: { message in
                if message == "Bad Request"{
                    ShowAlert(message: "Image Passed", theme: .success)
                    self.confirmButtonTappedQualityView()
                } else {
                    ShowAlert(message: message, theme: .error)
                    self.reshootButttonTappedQualityView()
                    self.reshootButttonTappedQualityView()
                }
            }
    }
}

//MARK: - Extension SPAngleClasifierV2ViewController: ImageQualityValidationClassifierDelegate
extension SPAngleClasifierV2ViewController: ImageQualityValidationClassifierDelegate {
    ///reshootButttonTappedQualityView: reshoot tapped
    func reshootButttonTappedQualityView() {
        self.dismiss(animated: true) {
            if let didTapped = self.btnDidReshootTapped{
                didTapped()
            }
        }
    }
    ///confirmButtonTappedQualityView: confirm tapped
    func confirmButtonTappedQualityView() {
        self.dismiss(animated: true) {
            if let didTapped = self.btnDidConfirmTapped{
                didTapped()
            }
        }
    }
}

//MARK: - Extension SPAngleClasifierV2ViewController: ImageValidationClassifierDelegate
extension SPAngleClasifierV2ViewController: ImageValidationClassifierDelegate {
    ///reshootButttonTappedQualityView: reshoot tapped
    func reshootButttonTapped() {
        self.dismiss(animated: true) {
            if let didTapped = self.btnDidReshootTapped{
                didTapped()
            }
        }
    }
    
    ///confirmButtonTappedQualityView: confirm tapped
    func confirmButtonTapped() {
        self.dismiss(animated: true) {
            if let didTapped = self.btnDidConfirmTapped{
                didTapped()
            }
        }
    }
}
