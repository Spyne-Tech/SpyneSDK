//
//  SPImageClassifierImageValidatorView.swift
//  Spyne
//
//  Created by Akash Verma on 06/09/22.
//  Copyright © 2022 Spyne. All rights reserved.
//

import UIKit

//MARK: Protocols
/// ImageValidationClassifierDelegate: Is a call back delegate which tell the view for the button click call back.
protocol ImageValidationClassifierDelegate {
    
    /// reshootButttonTapped: is triggered from the IBAction of reshoot button
    func reshootButttonTapped()
    
    /// confirmButtonTapped: is triggered from the IBAction of confirm button
    func confirmButtonTapped()
}

//MARK: Enums
/// ImageChecks: Will controll the UI of Image checks
enum ImageChecks {
    /// shootAngleISCorrectImageIsCropped: When shoot Angle Is Correct image Is Cropped
    case shootAngleISCorrectImageIsCropped(top:Bool, bottom:Bool, leftSide: Bool, rightSide:Bool)
    
    /// shootAngleIsNotCorrectImageIsCropped: When shoot Angle Is not Correct image Is Cropped
    case shootAngleIsNotCorrectImageIsCropped(top:Bool, bottom:Bool, leftSide: Bool, rightSide:Bool)

    /// shootAngleIsNotCorrectImageIsNotCropped: When shoot Angle Is not Correct image Is not Cropped
    case shootAngleIsNotCorrectImageIsNotCropped
    
    /// shootAngleISCorrectImageIsCropped: When shoot Angle Is Correct image Is not Cropped
    case shootAngleIsCorrectImageIsNotCropped
}

//MARK: Class - SPImageClassifierImageValidatorView
//While revolking the class you have to pass important parameters into the class by method below
//configureVariables(isImageNotCropped: Bool, isImageAngleCorrect:Bool, clickedImage: UIImage, croppedSide: AngleClassifierCropArray, distance: String)
//and delegate to self to that VC so that ImageValidationClassifierDelegate can send call back.
/// SPImageClassifierImageValidatorView: Is a custom view for the hard check which will show if the image is in proper angle or distance and not cropped on either side.
class SPImageClassifierImageValidatorView: UIView {
    
    //MARK: IBOutlets
    /// Content View: Top View
    @IBOutlet var contentView: UIView!
    
    ///clickedPictureImageView: Show isme which has been clicked by the user
    @IBOutlet weak var clickedPictureImageView: UIImageView!
    @IBOutlet weak var overlayImageView: UIImageView!
    
    ///Image croped side IBOutlets
    @IBOutlet weak var topAlignedView: UIView!
    @IBOutlet weak var topAlignedImageView: UIImageView!
    @IBOutlet weak var leftAlignedView: UIView!
    @IBOutlet weak var leftAlignedImageView: UIImageView!
    @IBOutlet weak var bottomAlignedView: UIView!
    @IBOutlet weak var bottomAlignedImageView: UIImageView!
    @IBOutlet weak var rightAlignedView: UIView!
    @IBOutlet weak var rightAlignedImageView: UIImageView!
    
    ///Instructions View Outlets
    @IBOutlet weak var ParentViewOfInstructionsImageView: UIView!
    @IBOutlet weak var instructionsImageView: UIImageView!
    
    /// Image validator View
    @IBOutlet weak var imageValidatorParentView: UIView!
    @IBOutlet weak var imageStatusImageView: UIImageView!
    @IBOutlet weak var imageStatusLabel: UILabel!
    
    /// Image checks Outlets
    @IBOutlet weak var angleImageView: UIImageView!
    @IBOutlet weak var angleStatusLabel: UILabel!
    @IBOutlet weak var croppedImageView: UIImageView!
    @IBOutlet weak var croppedStatusLabel: UILabel!
    
    ///Image resolution View
    @IBOutlet weak var ImageResolutionLabel: UILabel!
    @IBOutlet weak var reshootButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK: Class variables
    ///delegate: Is used for the call back trigger method.
    var delegate: ImageValidationClassifierDelegate?
    
    ///isImageNotCropped: is passed from the view initializer having bool value
    var isImageNotCropped = false
    
    ///isImageAngleICorrect: is passed from the view initializer having bool value
    var isImageAngleICorrect = false
    
    /// configuredImageChecks: is setupped in methods: configureImageCheckOutlets
    var configuredImageChecks: ImageChecks?
    
    ///croppedSide: Cropped side is comming into the Model: AngleClassifierCropArray from Angle-classifier API.
    var croppedSide: AngleClassifierCropArray?
    
    /// clickedImage: Clicked image from the camera
    var clickedImage: UIImage?
    
    ///overLayImage: Overlay image will get set over the clicked image
    var overlayImage = UIImage()
    
    ///distance: is comming from the backend
    var distance: String?
    
    //MARK: Initializers
    ///overriding the init of frame so that view can maintain its own frame from the common init.
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    ///overriding the frame init requires the coder init.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //MARK: Class functions
    /// commonInit: Commoninit is a private initializer which will initialize the whole view.
    private func commonInit() {
        Bundle.main.loadNibNamed("SPImageClassifierImageValidatorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    /// configureVariables: will configure all the variables
    func configureVariables(isImageNotCropped: Bool, isImageAngleCorrect:Bool, clickedImage: UIImage, croppedSide: AngleClassifierCropArray?, distance: String, overlayImage: UIImage) {
        self.isImageNotCropped = isImageNotCropped
        self.isImageAngleICorrect = isImageAngleCorrect
        self.clickedImage = clickedImage
        self.croppedSide = croppedSide
        self.distance = distance
        self.overlayImage = overlayImage
        configureUI()
    }
    
    /// configureUI: will configure the whole UI of the pop up.
    func configureUI() {
        setClickedImage()
        setOverLayImage()
        configuredImageChecksMethod()
    }
    
    ///setOverLayImage: will configure the overlay
    func setOverLayImage() {
        overlayImageView.image = overlayImage
    }
    
    /// setClickedImage: will set the image into the image View
    func setClickedImage() {
        guard let image = clickedImage else { return }
        self.clickedPictureImageView.image = image
    }
    
    ///configuredImageChecksMethod: This Method decides which enum value to be set.
    func configuredImageChecksMethod() {
        if isImageNotCropped && isImageAngleICorrect {
            self.configuredImageChecks = .shootAngleIsCorrectImageIsNotCropped
        } else if isImageNotCropped && !isImageAngleICorrect {
            self.configuredImageChecks = .shootAngleIsNotCorrectImageIsNotCropped
        } else if !isImageNotCropped && isImageAngleICorrect  {
            self.configuredImageChecks = .shootAngleISCorrectImageIsCropped(top: croppedSide?.top ?? false, bottom: croppedSide?.bottom  ?? false , leftSide: croppedSide?.left ?? false, rightSide: croppedSide?.right ?? false)
        } else {
            self.configuredImageChecks = .shootAngleIsNotCorrectImageIsCropped(top: croppedSide?.top ?? false, bottom: croppedSide?.bottom  ?? false , leftSide: croppedSide?.left ?? false, rightSide: croppedSide?.right ?? false)
        }
        configureFooterButtons()
        configureInstructionsImage()
        configureImageCheckOutlets(configuredImageChecksEnum: configuredImageChecks ?? ImageChecks.shootAngleIsCorrectImageIsNotCropped)
    }
    
    ///configureImageCheckOutlets: Configures the UI outlets in Image checks.
    func configureImageCheckOutlets(configuredImageChecksEnum: ImageChecks) {
        switch configuredImageChecksEnum {
        case .shootAngleISCorrectImageIsCropped(let top, let bottom, let leftSide, let rightSide):
            setCroppedLayout(top: top, bottom: bottom, leftSide: leftSide, rightSide: rightSide)
            angleImageView.image = UIImage(named: "cf_correctangle",in: Bundle.spyneSDK, with: nil)
            croppedImageView.image = UIImage(named: "cf_imageCropped",in: Bundle.spyneSDK, with: nil)
            angleStatusLabel.text = "Shoot  angle is correct"
            croppedStatusLabel.text = "Image is cropped"
        case .shootAngleIsNotCorrectImageIsCropped(let top, let bottom, let leftSide, let rightSide):
            setCroppedLayout(top: top, bottom: bottom, leftSide: leftSide, rightSide: rightSide)
            angleImageView.image = UIImage(named: "cf_wrongangle",in: Bundle.spyneSDK, with: nil)
            croppedImageView.image = UIImage(named: "cf_imageCropped",in: Bundle.spyneSDK, with: nil)
            angleStatusLabel.text = "Wrong shooting angle"
            croppedStatusLabel.text = "Image is cropped"
        case .shootAngleIsNotCorrectImageIsNotCropped:
            angleStatusLabel.text = "Wrong shooting angle"
            croppedStatusLabel.text = "Image is in frame"
            angleImageView.image = UIImage(named: "cf_wrongangle",in: Bundle.spyneSDK, with: nil)
            croppedImageView.image = UIImage(named: "cf_correctCrop",in: Bundle.spyneSDK, with: nil)
        case .shootAngleIsCorrectImageIsNotCropped:
            angleStatusLabel.text = "Shoot  angle is correct"
            croppedStatusLabel.text = "Image is in frame"
            angleImageView.image = UIImage(named: "cf_correctangle",in: Bundle.spyneSDK, with: nil)
            croppedImageView.image = UIImage(named: "cf_correctCrop",in: Bundle.spyneSDK, with: nil)
        }
    }
    
    ///configureInstructionsImage: Will set the Image according to the isImageNotCropped and
    func configureInstructionsImage() {
        if distance == "good" {
            instructionsImageView.image = UIImage(named: "cf_correctPosition",in: Bundle.spyneSDK, with: nil)
        } else if distance == "bad" {
            instructionsImageView.image = UIImage(named: "cf_comeCloser",in: Bundle.spyneSDK, with: nil)
        }
    }
    
    /// setCroppedLayout: method sets the red flag for the top bottom left and right side of the cropped side image
    func setCroppedLayout(top:Bool, bottom:Bool, leftSide: Bool, rightSide:Bool) {
        topAlignedView.isHidden = !top
        topAlignedImageView.isHidden = !top
        bottomAlignedView.isHidden = !bottom
        bottomAlignedImageView.isHidden = !bottom
        leftAlignedView.isHidden = !leftSide
        leftAlignedImageView.isHidden = !leftSide
        rightAlignedView.isHidden = !rightSide
        rightAlignedImageView.isHidden = !rightSide
    }
    
    ///configureFooterButtons: confirm and reshoot button configuration
    func configureFooterButtons(){
        confirmButton.isHidden = false
        ImageResolutionLabel.isHidden = true
        if isImageNotCropped && isImageAngleICorrect {
            imageValidatorParentView.borderColor = UIColor(hexString: "00C488", alpha: 1)
//            confirmButton.isHidden = false
//            ImageResolutionLabel.isHidden = true
            imageStatusLabel.text = "Valid Image"
            imageStatusImageView.isHidden = true
            imageStatusLabel.textColor = UIColor(hexString: "00C488", alpha: 1)
        } else {
//            confirmButton.isHidden = true
//            ImageResolutionLabel.isHidden = false
            imageStatusLabel.text = "Image Invalid"
            imageStatusImageView.image = UIImage(named: "cf_warning",in: Bundle.spyneSDK, with: nil)
            imageStatusLabel.textColor = .systemRed
            imageValidatorParentView.borderColor = .systemRed
        }
    }
    
   //MARK: IBActions
    /// reshootButtonTouchUpInside: triggers when reshoot button tapped and fires delegate to send call back to the view
    @IBAction func reshootButtonTouchUpInside(_ sender: Any) {
        delegate?.reshootButttonTapped()
    }
    
    /// reshootButtonTouchUpInside: triggers when reshoot button tapped and fires delegate to send call back to the view
    @IBAction func confirmButtonTouchUpInside(_ sender: Any) {
        delegate?.confirmButtonTapped()
    }
    
}
