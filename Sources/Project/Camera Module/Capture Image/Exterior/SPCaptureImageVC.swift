//
//  SPCaptureImageVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 23/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import AVFoundation
import KRProgressHUD
import SDWebImage
import CoreMotion
import RealmSwift
import Toast_Swift

class SPCaptureImageVC: UIViewController{
    
    //Outlet
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
    @IBOutlet weak var collectionProductCategories: UICollectionView!
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
    @IBOutlet weak var selectSubCatLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var showOverLayLabel: UILabel!
    @IBOutlet weak var showCameraLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var showGyroLabel: UILabel!
    
    
    // Variable
    var is360Interior = false
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var vmShoot = SPShootViewModel()
    let sequence = MaterialShowcaseSequence()
    var isFirstCLick = false
    var isShowcaseDone = false
    var cameraDevice: AVCaptureDevice!
    var realmProjectObject = RealmProjectData()
    let localRealm = try? Realm()
    var vmRealm = RealmViewModel()
    var isReclick = false
    var skuNameFromClientApp = ""
    
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
        //Change Iphone Orientaion 💡
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        selectSubCatLabel.text = "Select the cars subcategory" 
        settingButton.setTitle("Settings" , for: .normal)
        backButton.setTitle("Back" , for: .normal)
        showOverLayLabel.text = "Show Overlay" 
        showCameraLabel.text = "Show Camera Grid" 
        showGyroLabel.text = "Show Gyrometer" 
        initialSetup()
    
        if DraftStorage.isFromDraft{
            
            if vmShoot.skuId != ""{
                self.btnAngles.setTitle("  " + "Angles"  + " \(self.vmShoot.selectedAngle)/\(self.vmShoot.noOfAngles)  ", for: .normal)
                self.btnAngles.isUserInteractionEnabled = false
                self.btnGallery.isUserInteractionEnabled = true
                self.btnSkuId.setTitle(self.vmShoot.skuName, for: .normal)
               
                self.isFirstCLick = true
                self.getOverlays(frames:vmShoot.noOfAngles)
            }else{
                self.btnAngles.setTitle("  " + "Angles"  + " 1/\(self.vmShoot.noOfAngles)  ", for: .normal)
                self.btnAngles.isUserInteractionEnabled = true
                self.btnGallery.isUserInteractionEnabled = true
                self.btnSkuId.setTitle(self.vmShoot.skuName, for: .normal)
                self.isFirstCLick = false
               // self.getOverlays(frames:vmShoot.noOfAngles)
                getProductSubCategory()
            }
    
        }else{
            getProductSubCategory()
        }
    
        attachZoom(viewGyrometer)
        attachFocus(viewGyrometer)
        attachExposure(viewGyrometer)
        self.cameraSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      //  AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
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
        collectionProductCategories.delegate = self
        collectionProductCategories.dataSource = self
        collectionOverlays.delegate = self
        collectionOverlays.dataSource = self
        
        viewSkuId.borderColor = UIColor.appColor
        btnSkuId.setTitleColor(UIColor.appColor, for: .normal)
        btnAngles.setTitleColor(UIColor.appColor, for: .normal)
        btnAngles.setTitle("  " + "Angles"  + " 1/\(vmShoot.noOfAngles)  ", for: .normal)
        btnAngles.borderColor = UIColor.appColor
        btnAngles.tintColor = UIColor.appColor
        
        notificationCenter()
        
        switchGrid.isOn = USER.isGrid
        switchOverlay.isOn = USER.isOverlay
        switchGyrometer.isOn = USER.isGyrometer

//        setSettingValues()
        
    }
    
    
    //MARK:- Motion Detection
    func getMotion(){
        
        if motionManager.isGyroAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] (motion, error) -> Void in
                
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
    
    //MARK:- 1. Get Sub Categories
    func getProductSubCategory()  {
        vmShoot.getProductSubCategories(prod_id: (Storage.shared.getProductCategories()?.prodCatId) ?? "") {
            self.collectionProductCategories.reloadData()
            PosthogEvent.shared.posthogCapture(identity: "iOS Got Subcategories", properties: [:])
            if !self.isShowcaseDone{
                self.isShowcaseDone = true
                self.showCase()
            }
        } onError: { (errMessage) in
            PosthogEvent.shared.posthogCapture(identity: "iOS Got Subcategories Failed", properties: ["message":errMessage])
            ShowAlert(message: errMessage, theme: .error)
        }
    }
    
    //MARK:- 2. Get Overlays
    func getOverlays(frames:Int){
        vmShoot.getOverlays(prod_id: vmShoot.cat_id, prod_sub_cat_id: vmShoot.sub_cat_id, no_of_frames: "\(frames)") {
            
            PosthogEvent.shared.posthogCapture(identity: "iOS Get Overlays Initiated", properties: ["angles":"\(frames)","prod_sub_cat_id":self.vmShoot.sub_cat_id])
            
            PosthogEvent.shared.posthogCapture(identity: "iOS Get Overlays Initiated", properties: ["angles":"\(frames)"])
            self.setSettingValues()
            if self.vmShoot.arrOverLays.count > 0{
                self.collectionOverlays.isHidden = false
            }
            
            if DraftStorage.isFromDraft{
                for comparedOverlay in Storage.shared.vmSPOrderNow.arrImages{
                    for (index,overlay) in self.vmShoot.arrOverLays.enumerated(){
                        if (comparedOverlay.overlayID ?? 0) == overlay.id{
                            self.vmShoot.arrOverLays[index].clickedAngle = true
                            self.vmShoot.arrOverLays[index].imageUrl = comparedOverlay.inputImageLresURL
                            self.vmShoot.arrOverLays[index].frameSeqNo = overlay.frameSeqNo
                            
                        }
                    }
                }
                self.setToNextOverlay()
            }else{
                self.setOverlayImage()
            }
            
            self.collectionOverlays.reloadData()
    
            
        } onError: { (error) in
            PosthogEvent.shared.posthogCapture(identity: "iOS Got Overlays Failed", properties: ["message":error])
            print(error)
        }
    }
    
    func showCase(){
        let storyboard = UIStoryboard.init(name: "Camera", bundle: Bundle.spyneSDK)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SPCameraInfoPopup") as? SPCameraInfoPopup{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.btnNextTapped = {
                if USER.isCameraFirstTime{
                    USER.isCameraFirstTime = false
                    self.dismiss(animated: true, completion: nil)
                    self.showcaseSubCat()
                }else{
                    self.viewIndicator.isHidden = false
                    self.dismiss(animated: true, completion: nil)
                    if self.vmShoot.projectName == "" {
                        self.didSubmitSKUTapped(skuName: self.skuNameFromClientApp)
//                        self.createSKUPopup()
                    }
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
        btnCapture.isUserInteractionEnabled = true
        btnGallery.isUserInteractionEnabled = true
    }
    
    // MARK:- Showcase flow Initialization
    func showcaseSubCat(){
        
        PosthogEvent.shared.posthogCapture(identity: "iOS Show Hint", properties: [:])
        let showcaseSubCat = MaterialShowcase()
        showcaseSubCat.setTargetView(collectionView: collectionProductCategories, section: 0, item: 1)
        showcaseSubCat.targetHolderRadius = 0
        showcaseSubCat.backgroundPromptColor = UIColor.black
        showcaseSubCat.backgroundAlpha = 0.9
//        showcaseSubCat.primaryTextFont = UIFont.popinsMedium(witSize: 16)
//        showcaseSubCat.secondaryTextFont = UIFont.popinsMedium(witSize: 16)
        showcaseSubCat.primaryTextAlignment = .center
        showcaseSubCat.primaryText = Alert.showcaseSubCatText
        showcaseSubCat.secondaryText = "Got it" 
        showcaseSubCat.backgroundColor = UIColor.appColor
        showcaseSubCat.delegate = self
        showcaseSubCat.show {
            
        }
    }
    
    func showcaseAngle(){
        let showcaseAngle = MaterialShowcase()
        showcaseAngle.setTargetView(view: viewAngle)
        //  showcaseAngle.setTargetView(button: self.btnAngles, tapThrough: false)
        showcaseAngle.targetHolderRadius = 0
        showcaseAngle.backgroundPromptColor = UIColor.black
        showcaseAngle.backgroundAlpha = 0.9
//        showcaseAngle.primaryTextFont = UIFont.popinsMedium(witSize: 16)
//        showcaseAngle.secondaryTextFont = UIFont.popinsMedium(witSize: 16)
        showcaseAngle.primaryTextAlignment = .center
        showcaseAngle.primaryText = Alert.showcaseAngleText
        showcaseAngle.secondaryText = "Got it" 
        showcaseAngle.delegate = self
        showcaseAngle.show {
            
        }
    }
    
    func showcaseSKU(){
        let showcaseSKU = MaterialShowcase()
        showcaseSKU.setTargetView(view: self.viewSkuId)
        showcaseSKU.targetHolderRadius = 0
        showcaseSKU.backgroundPromptColor = UIColor.black
        showcaseSKU.backgroundAlpha = 0.9
        showcaseSKU.backgroundViewType = .full // default is .circle
//        showcaseSKU.primaryTextFont = UIFont.popinsMedium(witSize: 16)
//        showcaseSKU.secondaryTextFont = UIFont.popinsMedium(witSize: 16)
        showcaseSKU.primaryTextAlignment = .center
        showcaseSKU.primaryText = Alert.showcaseSKUText
        showcaseSKU.secondaryText = "Got it" 
        showcaseSKU.delegate = self
        showcaseSKU.show {
            
        }
    }
    
    
    func showcaseGallary(){
        let showcaseOverlay = MaterialShowcase()
        showcaseOverlay.setTargetView(button: self.btnGallery, tapThrough: false)
        showcaseOverlay.backgroundPromptColor = UIColor.black
        showcaseOverlay.backgroundAlpha = 0.9
//        showcaseOverlay.primaryTextFont = UIFont.popinsMedium(witSize: 16)
//        showcaseOverlay.secondaryTextFont = UIFont.popinsMedium(witSize: 16)
        showcaseOverlay.primaryTextAlignment = .center
        showcaseOverlay.primaryText = Alert.showcaseGallaryText
        showcaseOverlay.secondaryText = "Got it" 
        showcaseOverlay.delegate = self
        showcaseOverlay.show {
            
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
                AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
                if DraftStorage.isFromDraft{
//                    AppDelegate.navToHome(selectedIndex: 2)
                }else{
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
//                    if var viewControllers = self.navigationController?.viewControllers
//                       {
//                           for controller in viewControllers
//                           {
//                               if controller is SPCategoryListVC
//                               {
//                                   (controller as! SPCategoryListVC).isBackFromCamera = true
//                                   self.navigationController?.popViewController(animated: true)
//                               }
//                           }
//                       }
                }
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
    }
    
    @IBAction func switchActionGridLines(_ sender: UISwitch) {
        USER.isGrid = sender.isOn
        setSettingValues()
    }
    
    @IBAction func switchActionGyrometer(_ sender: UISwitch) {
        USER.isGyrometer = sender.isOn
        setSettingValues()
    }
    
    @IBAction func btnActionOverlay(_ sender: UIButton) {
        imgOverlayPic.isHidden = !btnOverlay.isSelected
        btnOverlay.isSelected.toggle()
        setOverlayImage()
    }
    
    @IBAction func btnActionTackPic(_ sender: UIButton) {
        
        checkCameraAccess()
  
    }
    
    @IBAction func btnActionSKU(_ sender: UIButton) {
        
    }
    
    @IBAction func btnActionAngles(_ sender: UIButton) {
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPInterialShootNoOfShotPopup") as? SPInterialShootNoOfShotPopup{
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//            vc.selectedRow = vmShoot.selectedRowOfNoOfShotPopup!
//            vc.delegate = self
//            self.tabBarController?.tabBar.isHidden = true
//            self.present(vc, animated: true, completion: nil)
//        }
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

    func isSettingView(isHidden:Bool){
        viewOverlay.isHidden = isHidden
        viewGyroSwitch.isHidden = isHidden
        viewCamGrid.isHidden = isHidden
        btnClose.isHidden = isHidden
        
    }
    
    func setOverlayImage(){
        if vmShoot.selectedAngle < vmShoot.arrOverLays.count{
            let overrlay = vmShoot.arrOverLays[vmShoot.selectedAngle].displayThumbnail ?? ""
            if let url = URL(string: overrlay){
                imgOverlayPic.sd_setImage(with: url, placeholderImage: UIImage())
            }
        }
    }
    
    func navToInterialShootCamera() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SPinteriorshootCameraVC") as! SPinteriorshootCameraVC
        vc.vmShoot = vmShoot
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navToFocusShootCamera() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SPShootFocusImagesVC") as! SPShootFocusImagesVC
        vc.vmShoot = vmShoot
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showInterialShootPopup() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPInterialShootPopup") as? SPInterialShootPopup{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.strTitle = "(1/1) Interior Shoots" 
            vc.arrImages = Storage.shared.arrInteriorPopup
            vc.btnDidConfirmTapped = { [self] in
                navToInterialShootCamera()
            }
            vc.btnDidSkipTapped = { [self] in
                let taskToUpdate = vmRealm.getRealmData(skuId: vmShoot.skuId)
                //Add  Skip Interior = true in realm database
                try! self.localRealm?.safeWrite {
                    taskToUpdate?.interiorSkiped = true
                }
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPInterialShootPopup") as? SPInterialShootPopup{
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    self.tabBarController?.tabBar.isHidden = true
                    vc.strTitle = "(2/2) Miscellaneous Shoots" 
                    vc.arrImages = Storage.shared.arrFocusedPopup
                    vc.btnDidConfirmTapped = { [self] in
                        self.dismiss(animated: true, completion: nil)
                        navToFocusShootCamera()
                    }
                    vc.btnDidSkipTapped = { [self] in
                        self.dismiss(animated: true, completion: nil)
                        let taskToUpdate = vmRealm.getRealmData(skuId: vmShoot.skuId)
                        //Add  Skip Miscelineous = true in realm database
                        try! self.localRealm?.safeWrite {
                            taskToUpdate?.misSkiped = true
                        }
                        
                        Storage.shared.vmShoot = self.vmShoot
                        let story = UIStoryboard(name: "ImageProccesing", bundle:Bundle.spyneSDK)
                        if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func show360InteriorPopup(){
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SP360InteriorPopupVC") as? SP360InteriorPopupVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.btnSkipTapped = { [self] in
                let taskToUpdate = self.vmRealm.getRealmData(skuId: self.vmShoot.skuId)
                //Add  Skip Miscelineous = true in realm database
                try! self.localRealm?.safeWrite {
                    taskToUpdate?.is360IntSkiped = true
                }
                let story = UIStoryboard(name: "ImageProccesing", bundle:Bundle.spyneSDK)
                if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                    AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            vc.btnSelectTapped = {
                self.is360Interior = true
                let imagePicker = UIImagePickerController()
                imagePicker.delegate  = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func hideProductCollectionAndDisableBtnAngle() {
        collectionProductCategories.isHidden = true
        btnAngles.isEnabled = false
        btnSkuId.isEnabled = false
    }
}

//MARK:- Material Showcase
extension SPCaptureImageVC: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
        if(showcase.primaryText == Alert.showcaseSubCatText) {
            showcaseAngle()
        } else if(showcase.primaryText == Alert.showcaseAngleText) {
            showcaseSKU()
        }
        else if (showcase.primaryText == Alert.showcaseOverlayText){
            showcaseGallary()
        }else {
            self.viewIndicator.isHidden = false
            if self.vmShoot.projectName == ""{
                self.didSubmitSKUTapped(skuName: self.skuNameFromClientApp)
//                self.createSKUPopup()
            }
        }
    }
}

//MARK:- AngleSelectionDelegate
extension SPCaptureImageVC: AngleSelectionDelegate {
    func didSelectAngle(noOfAngeles: Int, selectedRow:Int) {
        btnAngles.setTitle("  " + "Angles"  + " 1/\(noOfAngeles)  ", for: .normal)
        vmShoot.noOfAngles = noOfAngeles
        SPShootViewModel.shared.noOfAngles = noOfAngeles
        vmShoot.selectedRowOfNoOfShotPopup = selectedRow
        //Update completed shoot count option
        let taskToUpdate = vmRealm.getRealmData(projectId: vmShoot.projectId)
        try! self.localRealm?.safeWrite {
            taskToUpdate?.noOfAngles = noOfAngeles
        }
        getOverlays(frames:noOfAngeles)
    }
    
}
