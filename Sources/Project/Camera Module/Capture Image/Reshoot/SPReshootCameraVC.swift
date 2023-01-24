//
//  SPReshootCameraVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 24/10/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import AVFoundation
import KRProgressHUD
import SDWebImage
import CoreMotion
import RealmSwift
import Toast_Swift
import SwiftUI
class SPReshootCameraVC: UIViewController {
    
    // Outlet
    //Gyrometer
    
    @IBOutlet weak var collectionOverlays: UICollectionView!
    @IBOutlet weak var viewGyrometer: UIView!
    @IBOutlet weak var conLineVerticleContainer: NSLayoutConstraint!
    @IBOutlet weak var viewGayroline: UIView!
    @IBOutlet weak var imgGayroFrame: UIImageView!
    @IBOutlet weak var viewCapturedImagde: UIView!
    @IBOutlet weak var viewSkuId: UIView!
    @IBOutlet weak var collectionAngles: UICollectionView!
    @IBOutlet weak var btnAngles: UIButton!
    @IBOutlet weak var btnSkuId: UIButton!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var imgOverlayPic: UIImageView!
    @IBOutlet weak var btnOverlay: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var viewAngle: UIView!
    @IBOutlet weak var viewIndicator: UIView!
    @IBOutlet weak var imgCapturedImage: UIImageView!
    @IBOutlet weak var btnCapture: UIButton!
    
    @IBOutlet weak var switchOverlay: UISwitch!
    @IBOutlet weak var switchGrid: UISwitch!
    @IBOutlet weak var switchGyrometer: UISwitch!
    
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var viewCamGrid: UIView!
    @IBOutlet weak var viewGyroSwitch: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewGridLines: UIView!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var showOverLayButton: UILabel!
    @IBOutlet weak var showCameraButton: UILabel!
    @IBOutlet weak var showGyroButton: UILabel!
    
    // Variable
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var vmShoot = SPShootViewModel()
    
    var isFirstCLick = false
    
    var cameraDevice: AVCaptureDevice!
    var realmProjectObject = RealmProjectData()
    let localRealm = try? Realm()
    let deafultAngles = 8
    var isReclick = false
    
    //Focus and geture
    var previewLayer: AVCaptureVideoPreviewLayer!
    var device = AVCaptureDevice.default(for: .video)
    
    //Gyrometer
    let motionManager = CMMotionManager()
    
    //Focus and Exosure
    var zoomGesture = UIPinchGestureRecognizer()
    var focusGesture = UITapGestureRecognizer()
    var exposureGesture = UIPanGestureRecognizer()
    var lastFocusRectangle: CAShapeLayer?
    var lastFocusPoint: CGPoint?
    var exposureValue: Float = 0.1 // EV
    var translationY: Float = 0
    var startPanPointInPreviewLayer: CGPoint?
    let exposureDurationPower: Float = 4.0 // the exposure slider gain
    let exposureMininumDuration: Float64 = 1.0 / 2000.0
    var zoomScale = CGFloat(1.0)
    var beginZoomScale = CGFloat(1.0)
    var maxZoomScale = CGFloat(1.0)
    /// Property to set focus mode when tap to focus is used (_focusStart).
    open var focusMode: AVCaptureDevice.FocusMode = .continuousAutoFocus
    /// Property to set exposure mode when tap to focus is used (_focusStart).
    open var exposureMode: AVCaptureDevice.ExposureMode = .continuousAutoExposure
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingButton.setTitle("Settings" , for: .normal)
        showOverLayButton.text = "Show Overlay" 
        showCameraButton.text = "Show Camera Grid" 
        showGyroButton.text = "Show Gyrometer" 
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        
        initialSetup()
        
        self.cameraSetup()
        attachZoom(viewGyrometer)
        attachFocus(viewGyrometer)
        attachExposure(viewGyrometer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        if self.captureSession != nil{
            self.captureSession.stopRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK:- Intial Setup
    func initialSetup(){
        
        btnCapture.isUserInteractionEnabled = false
        btnGallery.isUserInteractionEnabled = false
        btnOverlay.isSelected = false
        
        collectionAngles.registerNIB(cellName: "SPAngleCountCollectionViewCell")
        collectionOverlays.delegate = self
        collectionOverlays.dataSource = self
        
        self.btnSkuId.setTitle(Storage.shared.strReshhotSkuName, for: .normal)
        
        var arrIds = [Int]()
        
        for outputImage in Storage.shared.vmSPOrderNow.arrImages{
            arrIds.append(outputImage.overlayID ?? 0)
        }

        self.vmShoot.noOfAngles = arrIds.count
    
        Storage.shared.vmSPOrderNow.getOverlaybyId(overlayIds: arrIds) {
            if arrIds.count == (Storage.shared.vmSPOrderNow.arrOverlayByIds.count){
                for (index,outputImage) in Storage.shared.vmSPOrderNow.arrImages.enumerated(){
                    Storage.shared.vmSPOrderNow.arrOverlayByIds[index].frameSeqNo = Int(outputImage.frameSeqNo ?? "0") ?? 0
                }
            }
            
            if Storage.shared.vmSPOrderNow.arrImages[self.vmShoot.selectedAngle].imageCategory == "Exterior"{
                self.viewGyrometer.isHidden = false
                
            }else{
                self.viewGyrometer.isHidden = true
                self.btnCapture.isUserInteractionEnabled = true
                self.btnGallery.isUserInteractionEnabled = true
                self.btnCapture.tintColor = UIColor.white
             
            }
            self.setOverlayImage()
            self.collectionOverlays.reloadData()
        } onError: { (message) in
            ShowAlert(message: message, theme: .warning)
        }

        viewSkuId.borderColor = UIColor.appColor
        btnSkuId.setTitleColor(UIColor.appColor, for: .normal)
        btnAngles.setTitleColor(UIColor.appColor, for: .normal)
        btnAngles.setTitle("  " + "Angles"  + " 1/\(self.vmShoot.noOfAngles)  ", for: .normal)
        btnAngles.borderColor = UIColor.appColor
        btnAngles.tintColor = UIColor.appColor
        
        notificationCenter()
        setSettingValues()
    }
    
    //MARK:- Motion Detection
    func getMotion(){
        
        if motionManager.isGyroAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] (motion, error) -> Void in
                
                DispatchQueue.main.async {
                    if (self?.viewGyrometer.isHidden ?? false) == false{
                        
                        if let attitude = motion?.attitude {
                            let roll = (attitude.roll * 180 / Double.pi) + 90
                            let yaw = (attitude.yaw * 180 / Double.pi)
                            DispatchQueue.main.async{
                                self?.conLineVerticleContainer.constant = CGFloat(roll)
                                guard let gravity = motion?.gravity else{
                                    return
                                }
                                let rotation = atan2(gravity.y, gravity.x) - Double.pi
                                //Change the view's transform from the main thread.
                                self?.viewGayroline.transform = CGAffineTransform(rotationAngle: CGFloat(-1*rotation))
                                let degrees = (rotation * 180 / .pi)+360
                                if (roll > -10 && roll < 10) && (degrees < 10 || degrees > 350){
                                    self?.imgGayroFrame.tintColor = UIColor.green
                                    self?.viewGayroline.backgroundColor = UIColor.green
                                    self?.btnCapture.isUserInteractionEnabled = true
                                    self?.btnCapture.tintColor = UIColor.white
                                    self?.view.hideAllToasts()
                                }
                                else{
                                    self?.showToast(message: Alert.redGyrometerError)
                                    self?.imgGayroFrame.tintColor = UIColor.red
                                    self?.viewGayroline.backgroundColor = UIColor.red
                                    self?.btnCapture.isUserInteractionEnabled = false
                                    self?.btnCapture.tintColor = UIColor.lightGray
                                    
                                }
                            }
                        }
                    }
            
                }

            }
            print("Device motion started")
        }else{
            ShowAlert(message: Alert.gyroScopeNotAvailable, theme: .warning)
        }
        
    }
    
    func notificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openedAgain), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func openedAgain() {
        self.cameraSetup() //This is your function that contains the setup for your camera.
    }
    
    @objc func willResignActive() {
        print("Entered background")
        if captureSession != nil{
            let inputs = captureSession.inputs
            for oldInput:AVCaptureInput in inputs {
                captureSession.removeInput(oldInput)
            }
        }
    }
    
    
    //MARK:- Button Actions
    @IBAction func btnActionClose(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPExitShootPopup") as? SPExitShootPopup{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.strTitelString = Alert.exitShootPopupTitle
            vc.btnDidYesTapped = {
                self.dismiss(animated: true, completion: nil)
//                AppDelegate.navToHome(selectedIndex: 0)
            }
            vc.btnDidNoTapped = {
                self.dismiss(animated: true, completion: nil)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnActionChoosePicFromGallery(_ sender: Any) {
        hideProductCollectionAndDisableBtnAngle()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate  = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func btnActionOverlay(_ sender: UIButton) {
        imgOverlayPic.isHidden = !btnOverlay.isSelected
        btnOverlay.isSelected.toggle()
        
    }
    
    @IBAction func btnActionTackPic(_ sender: UIButton) {
        
        checkCameraAccess()
    }
    
    @IBAction func btnActionSKU(_ sender: UIButton) {
        
    }
    
    @IBAction func btnActionAngles(_ sender: UIButton) {
        
    }
    
    //MARK: - Setting Button Click
    @IBAction func btnActionSettings(_ sender: Any) {
        isSettingView(isHidden:false)
    }

    @IBAction func btnActionCloseSetting(_ sender: UIButton) {
        isSettingView(isHidden:true)
        
    }
    
    
    @IBAction func switchActionOvertlay(_ sender: UISwitch) {
        USER.isOverlay = sender.isOn
        setSettingValues()
        setOverlayImage()
    }
    
    @IBAction func switchActionGridLines(_ sender: UISwitch) {
        USER.isGrid = sender.isOn
        setSettingValues()
    }
    
    @IBAction func switchActionGyrometer(_ sender: UISwitch) {
        USER.isGyrometer = sender.isOn
        setSettingValues()
    }
    
    //MARK: - Function
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
            presentCameraSettings()
        case .authorized:
            print("Authorized, proceed")
            startCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    self.startCamera()
                } else {
                    print("Permission denied")
                    self.presentCameraSettings()
                }
            }
        @unknown default:
            presentCameraSettings()
        }
    }
    
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "IMPORTANT",
                                      message: "Camera access required for capturing photos!",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings" , style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        present(alertController, animated: true)
    }
    
    
    func startCamera(){
        
#if targetEnvironment(simulator)
        ShowAlert(message: "Simulator not supported camera", theme: .warning)
#else
        hideProductCollectionAndDisableBtnAngle()
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
#endif
        
    }
    
    func hideProductCollectionAndDisableBtnAngle() {
        btnAngles.isEnabled = false
        btnSkuId.isEnabled = false
    }
    
    func setSettingValues(){
        
        //Set Grid
        viewGridLines.isHidden =  USER.isGrid ? false : true
       
        //Set Overlay
        imgOverlayPic.isHidden = !USER.isOverlay
        btnOverlay.isSelected.toggle()
        setOverlayImage()
        
        if USER.isGyrometer{
            getMotion()
            viewGyrometer.isHidden = false
        }else{
            motionManager.stopDeviceMotionUpdates()
            viewGyrometer.isHidden = true
            self.imgGayroFrame.tintColor = UIColor.green
            self.viewGayroline.backgroundColor = UIColor.green
            self.btnCapture.isUserInteractionEnabled = true
            self.btnCapture.tintColor = UIColor.white
            self.view.hideAllToasts()
        }
        
        
    }
    
    func setOverlayImage(){
        if vmShoot.selectedAngle < Storage.shared.vmSPOrderNow.arrOverlayByIds.count{
            let overrlay = Storage.shared.vmSPOrderNow.arrOverlayByIds[vmShoot.selectedAngle].displayThumbnail ?? ""//vmShoot.arrOverLays[vmShoot.selectedAngle].displayThumbnail ?? ""
            if let url = URL(string: overrlay){
                imgOverlayPic.sd_setImage(with: url, placeholderImage: UIImage())
            }
        }
    }

    
    
    func isSettingView(isHidden:Bool){
        
        viewOverlay.isHidden = isHidden
        viewGyroSwitch.isHidden = isHidden
        viewCamGrid.isHidden = isHidden
        btnClose.isHidden = isHidden
    }
    
    
}

