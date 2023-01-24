//
//  SPImageQualityValidatorPopUpView.swift
//  Spyne
//
//  Created by Akash Verma on 07/09/22.
//  Copyright © 2022 Spyne. All rights reserved.
//

import UIKit

//MARK: Protocols
/// ImageValidationClassifierDelegate: Is a call back delegate which tell the view for the button click call back.
protocol ImageQualityValidationClassifierDelegate {
    
    /// reshootButttonTappedQualityView: is triggered from the IBAction of reshoot button
    func reshootButttonTappedQualityView()
    
    /// confirmButtonTappedQualityView: is triggered from the IBAction of confirm button
    func confirmButtonTappedQualityView()
}

//MARK: SPImageQualityValidatorPopUpView
/**
 *Below method is needed to be called to initilaize the view and setting the values
 *settingLocalVariables(reflection: String, exposure: String, capturedImage: UIImage)
 *and delegate to self to that VC so that ImageQualityValidationClassifierDelegate can send call back.
 */
class SPImageQualityValidatorPopUpView: UIView {
    
    //MARK: IBOutlets
    /// contentView: superview
    @IBOutlet var contentView: UIView!
    
    /// captureIdmageView: is the ImageView where captured Image isShown
    @IBOutlet weak var captureIdmageView: UIImageView!
    
    //Image Qualtity resolutionView
    ///parentOfResolutionView: is basically fot he border
    @IBOutlet weak var parentOfResolutionView: UIView!
    ///warningImageView: Is a warning image
    @IBOutlet weak var warningImageView: UIImageView!
    ///imageQualityLabel: is a resoltion key for Image Quality
    @IBOutlet weak var imageQualityLabel: UILabel!
    
    // Image Quality Params View
    @IBOutlet weak var imageBrightnessImageiew: UIImageView!
    @IBOutlet weak var imageBrightnessLabel: UILabel!
    @IBOutlet weak var reflectionImageView: UIImageView!
    @IBOutlet weak var reflectionLabel: UILabel!
    
    //Footer labels and buttons
    ///sugestionLabel: is a label which gives the suggestion
    @IBOutlet weak var sugestionLabel: UILabel!
    ///reshootButton: Reshoot button
    @IBOutlet weak var reshootButton: UIButton!
    ///confirmButton: Confirm button
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK: Class Variables
    ///delegate: is a variable will be used for the call backs.
    var delegate: ImageQualityValidationClassifierDelegate?
    
    ///reflection: is a variable coming from the image-classifier API
    var reflection = ""
    
    ///exposure: is a variable coming from the image-classifier API
    var exposure = ""
    
    ///capturedImage: is local variable sent from the initilazier VC.
    var capturedImage = UIImage()
    
    
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
        Bundle.main.loadNibNamed("SPImageQualityValidatorPopUpView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    /// settingLocalVariables: is a method which basically initialises all the values of the file and calls the configureView
    func settingLocalVariables(reflection: String, exposure: String, capturedImage: UIImage) {
        self.reflection = reflection
        self.exposure = exposure
        self.capturedImage = capturedImage
        configureView()
        setImageInCapturedImageView()
        configureQualityResolutionView()
    }
    
    ///setImageInCapturedImageView: is method used to set the image from capturedImage to captureIdmageView
    func setImageInCapturedImageView() {
        captureIdmageView.image = capturedImage
    }
    
    ///configureQualityResolutionView: is used to configure the Resolution view
    func configureQualityResolutionView() {
        if exposure == "Med" && reflection == "low" {
            warningImageView.isHidden = true
            imageQualityLabel.text = "Perfect Image"
            imageQualityLabel.textColor = .green
            parentOfResolutionView.borderColor = .green
            
        } else {
            warningImageView.isHidden = false
            imageQualityLabel.text = "Bad Image"
            imageQualityLabel.textColor = .red
        }
    }
    
    /// configureView: Method is used for the configuration of different views
    func configureView() {
        /// handling for exposure
        if exposure == "Low" {
            imageBrightnessImageiew.image = UIImage(named: "cf_tooDark",in: Bundle.spyneSDK, with: nil)
            imageBrightnessLabel.text = "Image is too dark"
        } else if exposure == "Med" {
            imageBrightnessImageiew.image = UIImage(named: "cf_evenlyExposed",in: Bundle.spyneSDK, with: nil)
            imageBrightnessLabel.text = "Image is evenly Exposed"
        } else if exposure == "High" {
            imageBrightnessImageiew.image = UIImage(named: "cf_tooBright",in: Bundle.spyneSDK, with: nil)
            imageBrightnessLabel.text = "Image is too bright"
        } else {
            imageBrightnessImageiew.image = UIImage(named: "cf_tooBright",in: Bundle.spyneSDK, with: nil)
            imageBrightnessLabel.text = ""
            imageBrightnessImageiew.isHidden = true
            imageBrightnessLabel.isHidden = true
        }
        
        /// handling for reflection
        if reflection == "high" {
            reflectionImageView.image = UIImage(named: "cf_toomuchreflection",in: Bundle.spyneSDK, with: nil)
            reflectionLabel.text = "Too much reflection on subject"
        } else if reflection == "low" {
            reflectionLabel.text = ""
            reflectionImageView.isHidden = true
            reflectionLabel.isHidden = true
        } else {
            reflectionLabel.text = ""
            reflectionImageView.isHidden = true
            reflectionLabel.isHidden = true
        }
    
    }
    
    ///confirmButtonTouchUpInside: is a confirm button tapped action IBAction
    @IBAction func confirmButtonTouchUpInside(_ sender: Any) {
        delegate?.confirmButtonTappedQualityView()
    }
    
    ///reshootButtonTouchUpInside: is a reshoot button tapped action IBAction
    @IBAction func reshootButtonTouchUpInside(_ sender: Any) {
        delegate?.reshootButttonTappedQualityView()
    }
    
}
