//
//  AngleClassifierPopupV3.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 03/01/23.
//

import UIKit
import KRProgressHUD

enum AngleClasifierErrorType {
    case crop
    case angle
    case distance
    case light
    case reflection
    case missing
}

//MARK: - AngleClassifierPopupV3 popup for the Angle classifier
class AngleClassifierPopupV3: UIViewController {

    //MARK: IBoutlets
    ///clickedImageVIew for the clicked image
    @IBOutlet weak var clickedImageVIew: UIImageView!
    @IBOutlet weak var baseImageVieqw: UIView!
    
    ///loaderView will show the loader
    @IBOutlet weak var loaderView: UIView!
    
    ///Cropped Side Views
    @IBOutlet weak var topCropView: UIView!
    @IBOutlet weak var leftCropView: UIView!
    @IBOutlet weak var bottomCropView: UIView!
    @IBOutlet weak var rightCropView: UIView!
    
    ///status View outlets
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusSymbolImageView: UIImageView!
    @IBOutlet weak var statusTextLabel: UILabel!
    
    /// issue reasons outlet
    @IBOutlet weak var issueReasonImageView: UIImageView!
    @IBOutlet weak var whatToDoNowLabel: UILabel!
    @IBOutlet weak var solutionLabel: UILabel!
    
    /// Buttons outlet
    @IBOutlet weak var reshootButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK: - Class Variables
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
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SpyneSDK.shared.orientationLock = .landscapeRight
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        configureUI()
        inititalSetUp()
    }
    
    func inititalSetUp() {
        let flippedCapturedImage = UIImage(cgImage: imgCapturedPic.cgImage!, scale: imgCapturedPic.scale, orientation: UIImage.Orientation.up)
        self.finalImage = flippedCapturedImage
        if isFromExterior{
            overLayImage = imgImageWithOverlay
            self.clickedImageVIew.image = flippedCapturedImage
        }else{
            overLayImage = flippedCapturedImage
        }
            let angleClassifierUploadImage =  AngleClassifierUploadImageModel(image_file: flippedCapturedImage, required_angle: frameAngle?.toInt() ?? 0, crop_check: true)
            vmShoot.angleClassifierUpload(angleClassifierUploadImageModel: angleClassifierUploadImage) { [self] in
                // to check for crop
                if !(vmShoot.angleClassifierData?.data?.cropArray?.top ?? false) && !(vmShoot.angleClassifierData?.data?.cropArray?.bottom ?? false) && !(vmShoot.angleClassifierData?.data?.cropArray?.left ?? false) &&
                    !(vmShoot.angleClassifierData?.data?.cropArray?.right ?? false) {
                } else {
                    showError(errorType: .crop)
                    return
                }
                
                // to check for angle
                if vmShoot.angleClassifierData?.data?.carAngle == false {
                    showError(errorType: .angle)
                    return
                }
                
                // to check for distance
                if vmShoot.angleClassifierData?.data?.distance == "far" && vmShoot.angleClassifierData?.data?.distance == "bad"{
                    showError(errorType: .distance)
                    return
                }
                
                // to check for light
//                if !(vmShoot.angleClassifierData?.data?.exposure == "Med") {
//                    showError(errorType: .light)
//                    return
//                }
                
                // to check for reflection
                if vmShoot.angleClassifierData?.data?.reflection != "low" && vmShoot.angleClassifierData?.data?.reflection != nil {
                    showError(errorType: .reflection)
                    return
                }
                
                // to check for missing object
                if vmShoot.angleClassifierData?.data?.validCategory == false {
                    showError(errorType: .missing)
                    return
                }
                // Show valid pop up
                showValidImageClicked()
            } onError: { message in
                if message == "Bad Request"{
                    ShowAlert(message: "Image Passed", theme: .success)
                    self.confirmButtonTapped()
                } else {
                    ShowAlert(message: message, theme: .error)
                    self.reshootButttonTapped()
                }
            }
    }
    
    //MARK: Class methods
    func configureUI() {
        clickedImageVIew.cornerRadius = 6.0
        baseImageVieqw.dropShadowforView(color: .black, opacity: 0.5, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
    }
    
    func showValidImageClicked() {
        confirmButtonTapped()
    }
    
    func showError(errorType: AngleClasifierErrorType) {
        switch errorType {
        case .crop:
            showCrop()
        case .angle:
            showAngleError()
        case .distance:
            showDistanceError()
        case .light:
            showLightError()
        case .reflection:
            showReflectionError()
        case .missing:
            showObjectMissingError()
        }
    }
    
    func showCrop() {
        if vmShoot.angleClassifierData?.data?.cropArray?.top ?? false {
            topCropView.isHidden = false
        }
        if vmShoot.angleClassifierData?.data?.cropArray?.left ?? false {
            leftCropView.isHidden = false
        }
        if vmShoot.angleClassifierData?.data?.cropArray?.bottom ?? false {
            bottomCropView.isHidden = false
        }
        if vmShoot.angleClassifierData?.data?.cropArray?.right ?? false {
            rightCropView.isHidden = false
        }
        statusSymbolImageView.image = UIImage(named: AngleClasifierConstants.CROSS_IMAGE, in: Bundle.spyneSDK, compatibleWith: nil)
        issueReasonImageView.image = UIImage(named: "cropv3", in: Bundle.spyneSDK, compatibleWith: nil)
        statusTextLabel.text = AngleClasifierConstants.CROPPED_IMAGE
        solutionLabel.text = AngleClasifierConstants.CROPPED_WTDN
        loaderView.isHidden = true
    }
    
    func showAngleError() {
        statusSymbolImageView.image = UIImage(named: AngleClasifierConstants.CROSS_IMAGE, in: Bundle.spyneSDK, compatibleWith: nil)
        issueReasonImageView.image = UIImage(named: "angleNotMatching", in: Bundle.spyneSDK, compatibleWith: nil)
        statusTextLabel.text = AngleClasifierConstants.ANGLE_NOT_MATCHING
        solutionLabel.text = AngleClasifierConstants.ANGLE_NOT_MATCHING_WTDN
        loaderView.isHidden = true
    }
    
    func showDistanceError() {
        statusSymbolImageView.image = UIImage(named: AngleClasifierConstants.CROSS_IMAGE, in: Bundle.spyneSDK, compatibleWith: nil)
        issueReasonImageView.image = UIImage(named: "farDistance", in: Bundle.spyneSDK, compatibleWith: nil)
        if vmShoot.angleClassifierData?.data?.distance == "far" {
            statusTextLabel.text = AngleClasifierConstants.CAR_IS_TOO_CLOSE
            solutionLabel.text = AngleClasifierConstants.CAR_IS_TOO_CLOSE_WTDN
        } else if vmShoot.angleClassifierData?.data?.distance == "bad" {
            statusTextLabel.text = AngleClasifierConstants.CAR_IS_FAR
            solutionLabel.text = AngleClasifierConstants.CAR_IS_FAR_WTDN
        }
        loaderView.isHidden = true
    }
    
    func showLightError() {
        statusSymbolImageView.image = UIImage(named: AngleClasifierConstants.CROSS_IMAGE, in: Bundle.spyneSDK, compatibleWith: nil)
        issueReasonImageView.image = UIImage(named: "tooBright", in: Bundle.spyneSDK, compatibleWith: nil)
        if vmShoot.angleClassifierData?.data?.exposure == "" {
            statusTextLabel.text = AngleClasifierConstants.SUROUNDING_TO_DIM
            solutionLabel.text = AngleClasifierConstants.SUROUNDING_TO_DIM_WTDN
        } else if vmShoot.angleClassifierData?.data?.exposure == "" {
            statusTextLabel.text = AngleClasifierConstants.SUROUNDING_TO_BRIGHT
            solutionLabel.text = AngleClasifierConstants.SUROUNDING_TO_BRIGHT_WTDN
        }
        loaderView.isHidden = true
    }
    
    func showReflectionError() {
        statusSymbolImageView.image = UIImage(named: AngleClasifierConstants.CROSS_IMAGE, in: Bundle.spyneSDK, compatibleWith: nil)
        issueReasonImageView.image = UIImage(named: "tooMuchReflection", in: Bundle.spyneSDK, compatibleWith: nil)
            statusTextLabel.text = AngleClasifierConstants.TOO_MUCH_REFLECTION
        solutionLabel.text = AngleClasifierConstants.TOO_MUCH_REFLECTION_WTDN
        loaderView.isHidden = true
    }
    
    func showObjectMissingError() {
        statusSymbolImageView.image = UIImage(named: AngleClasifierConstants.CROSS_IMAGE, in: Bundle.spyneSDK, compatibleWith: nil)
        issueReasonImageView.image = UIImage(named: "warningV3", in: Bundle.spyneSDK, compatibleWith: nil)
            statusTextLabel.text = AngleClasifierConstants.OBJECT_NOT_DETECTED
        solutionLabel.text = AngleClasifierConstants.OBJECT_NOT_DETECTED_WTDN
        loaderView.isHidden = true
        continueButton.isHidden = true
    }
    
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
    
    //MARK: - IBActions
    @IBAction func continueButtonTapped(_ sender: Any) {
        confirmButtonTapped()
    }
    
    @IBAction func reshootButtonDidTapped(_ sender: Any) {
        reshootButttonTapped()
    }
    
    
}

extension UIView {

  // OUTPUT 1
  func dropShadowforView(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadowforView(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
