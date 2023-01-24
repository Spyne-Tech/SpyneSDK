//
//  SPCameraScreenV2ViewController.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 27/11/22.
//

import UIKit
import AVFoundation
import Realm
import CoreMotion
import RealmSwift

//MARK: - Class - SPCameraScreenV2ViewController
/// Main class developed for the New camera Experience
class SPCameraScreenV2ViewController: UIViewController {
    
    //MARK: Main Parent Views
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var configurationViews: UIView!
    
    //MARK: - IBOutlets
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet var overlayInfoView: UIView!
    @IBOutlet var cameraForegroundView: UIView!
    @IBOutlet weak var overlayNameLabel: UILabel!
    @IBOutlet weak var imgCapturedImage: UIImageView!
    @IBOutlet weak var overlaySideImage: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var skuNameLabel: UILabel!
    
    
    ///Shoot type configuration View
    @IBOutlet weak var exteriorView: UIView!
    @IBOutlet weak var interiorView: UIView!
    @IBOutlet weak var miscButtonView: UIView!
    @IBOutlet weak var exteriorImage: UIImageView!
    @IBOutlet weak var exteriorLeadingImage: UIImageView!
    @IBOutlet weak var interiorImage: UIImageView!
    @IBOutlet weak var interiorLeading: UIImageView!
    @IBOutlet weak var miscImage: UIImageView!
    @IBOutlet weak var exteriorCountLabel: UILabel!
    @IBOutlet weak var interiorCountLabel: UILabel!
    @IBOutlet weak var miscCountLabel: UILabel!
    @IBOutlet weak var mendatoryLabel: UILabel!
    
    ///Gyrometer configuration
    @IBOutlet weak var viewGyrometer: UIView!
    @IBOutlet weak var imgGyroFrame: UIImageView!
    @IBOutlet weak var viewGyroline: UIView!
    @IBOutlet weak var conLineVerticleContainer: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var gyroMeterValueLabel: UILabel!
    
    //MARK: - AV Components
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureSession: AVCaptureSession!
    var cameraDevice: AVCaptureDevice!
    var stillImageOutput: AVCapturePhotoOutput!
    var device = AVCaptureDevice.default(for: .video)
    
    //MARK: - GyroMeter
    let motionManager = CMMotionManager()
    
    //MARK: - Focus and Exosure
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
    
    //MARK: - Realm
    let localRealm = try? Realm()
    
    //MARK: - Variables
    var shootType = ShootType.Exterior
    var shootStatus = SPStudioShootStatusModel(onExterior: true, exteriorDone: false, onInterior: false, interiorDone: false, onMisc: false, miscDone: false)
    var exteriorOverlays = getExteriorOverlayData()
    var interiorOverlays = getInteriorOverlayData()
    var miscOverlays = getMisclenousOverlayData()
    var drawerUpdateCellDelegate: SPOverlayDrawerContentUpdateDelegate?
    var interiorPopUp = true
    var miscPopUpShow = true
        
    //MARK: - To be refractored
    // Variable
    var is360Interior = false
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var vmShoot = SPShootViewModel()
    var vmOrderNow = SPOrderNowVM()
    let sequence = MaterialShowcaseSequence()
    var isFirstCLick = false
    var isShowcaseDone = false
    var realmProjectObject = RealmProjectData()
    var vmRealm = RealmViewModel()
    var isReclick = false
    
    //MARK: - ViewController Life cycle methods
    ///ViewDidLoad: All kind of initialization which is needed to start on the view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuringViewModel()
        setUpUI()
        SpyneSDK.shared.orientationLock = .landscapeRight
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        getMotion()
        setUpGestureRecognizers()
        setupCameraFunctionality()
        configureShootStatusView()
    }
    
    //MARK: - Class Methods
    ///setUpUI: All type of UI Colmponenets configuration to be done here
    func setUpUI() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        gyroMeterValueLabel.clipsToBounds = true
        gyroMeterValueLabel.layer.cornerRadius = 4
        skuNameLabel.clipsToBounds = true
        skuNameLabel.layer.cornerRadius = 4
        let exteriorClickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        let intriorClickedAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle}.count
        let miscClickedAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle}.count
        exteriorCountLabel.text = "\(exteriorClickedAngleCount)/\(vmShoot.arrOverLays.count)"
        interiorCountLabel.text = "\(intriorClickedAngleCount)/\(Storage.shared.arrInteriorPopup.count)"
        miscCountLabel.text = "\(miscClickedAngleCount)/\(Storage.shared.arrFocusedPopup.count)"
        if !DraftStorage.isFromDraft {
            configureOverlayAndOverlayName(overlayModel: exteriorOverlays.first)
        }
    }
    
    /// configureOverlayAndOverlayName: configure UI on the first open
    func configureOverlayAndOverlayName(overlayModel: OverlayData?) {
        guard let overlayModel else { return }
        self.overlaySideImage.sd_setImage(with: URL(string: overlayModel.displayThumbnail ?? ""))
        self.overlayNameLabel.text = overlayModel.displayName ?? ""
        self.imgCapturedImage.sd_setImage(with: URL(string: overlayModel.displayThumbnail ?? ""))
        self.mendatoryLabel.text = overlayModel.mendatory ?? false ? "Mandatory" : "Non-Mandatory"
    }
    
    /// configureOverlayAndOverlayName: configure View model for the Interior shoot
    func configuringViewModel() {
        self.vmShoot.selectedAngle = 0
        self.vmShoot.projectName = SpyneSDK.shared.skuId
        self.vmShoot.cat_id = SpyneSDK.shared.categoryID
        self.vmShoot.sub_cat_id = SPStudioSetupModel.subCategoryID ?? ""
        self.vmShoot.arrOverLays = getExteriorOverlayData()
        self.vmShoot.noOfAngles = getExteriorOverlayData().count
        vmShoot.getProductSubCategories(prod_id: vmShoot.cat_id) {
        } onError: { (errMessage) in
            ShowAlert(message: errMessage, theme: .error)
        }
        oldCodeConfiguration()
        oldCodeInteriorConfiguration()
        oldCodeMiscConfiguration()
    }
    
    /// configureOverlayAndOverlayName: configure View model for the Interior shoot
    func configureInteriorShootViewModel() {
        vmShoot.selectedInteriorAngles = 0
    }
    
    ///oldCodeConfiguration:  old code configuration for the exterior shoot
    func oldCodeConfiguration() {
        if DraftStorage.isFromDraft{
            if vmShoot.skuId != ""{
                self.isFirstCLick = true
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
            } else {
                self.isFirstCLick = false
            }
        }
    }
    
    ///oldCodeInteriorConfiguration: configures the old code
    func oldCodeInteriorConfiguration() {
        if DraftStorage.isFromDraft{
            self.vmOrderNow = Storage.shared.vmSPOrderNow
            if Storage.shared.arrInteriorPopup.count == 0{
                vmShoot.getProductSubCategories(prod_id: vmShoot.cat_id) {
                    self.setInteriorClickedAngle()
                } onError: { (errMessage) in
                    ShowAlert(message: errMessage, theme: .error)
                }
            }else{
                setInteriorClickedAngle()
            }
        }
    }
    
    func oldCodeMiscConfiguration() {
        if DraftStorage.isFromDraft{
            if Storage.shared.arrFocusedPopup.count == 0{
                vmShoot.getProductSubCategories(prod_id: vmShoot.cat_id) {
                    self.setMiscClickedAngle()
                } onError: { (errMessage) in
                    ShowAlert(message: errMessage, theme: .error)
                }
            }else{
                setMiscClickedAngle()
            }
        }
    }
    
    ///setInteriorClickedAngle: configures the interior angles clicked
    func setInteriorClickedAngle(){
        for comparedOverlay in Storage.shared.vmSPOrderNow.arrInteriorCollectionImage{
            for (index,interior) in  Storage.shared.arrInteriorPopup.enumerated(){
                if (comparedOverlay.overlayID ?? 0) == interior.id{
                    Storage.shared.arrInteriorPopup[index].clickedAngle = true
                    Storage.shared.arrInteriorPopup[index].imageUrl = comparedOverlay.inputImageLresURL
                    Storage.shared.arrInteriorPopup[index].frameSeqNo = interior.frameSeqNo
                    interiorPopUp = false
                }
            }
        }
        self.setToNextInteriorOverlays()
    }
    
    func configureMiscShootViewModel() {
        vmShoot.selectedFocusAngles = 0
    }
    
    func setMiscClickedAngle(){
        for comparedOverlay in Storage.shared.vmSPOrderNow.arrMiscellaneousImage{
            for (index,focused) in  Storage.shared.arrFocusedPopup.enumerated(){
                if (comparedOverlay.overlayID ?? 0) == focused.id{
                    Storage.shared.arrFocusedPopup[index].clickedAngle = true
                    Storage.shared.arrFocusedPopup[index].imageUrl = comparedOverlay.inputImageLresURL
                    Storage.shared.arrFocusedPopup[index].frameSeqNo = focused.frameSeqNo
                    miscPopUpShow = false
                }
            }
        }
        self.setToNextMiscOverlay()
    }
    
    ///setUpGestureRecognizers: All type of gesture recognizers enabling
    func setUpGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openOverlayDrawer(_:)))
        overlayInfoView.addGestureRecognizer(tap)
        let exteriorTap = UITapGestureRecognizer(target: self, action: #selector(self.setToExteriorShootType(_:)))
        exteriorView.addGestureRecognizer(exteriorTap)
    }
    
    ///setupCameraFunctionality: It setup the camera - Camera Implemetation has dedicated file : SPCameraScreenV2ViewController+CameraSetup
    func setupCameraFunctionality() {
        attachZoom(cameraView)
        attachFocus(cameraView)
        attachLeftRighSwipe(cameraView)
        self.cameraSetup()
    }
    
    ///configureShootStatusView: configures the image and UI COmponents upojn the selection
    func configureShootStatusView(){
        if self.shootStatus.onExterior {
            self.exteriorImage.image = UIImage(named: "lineCircle",in: Bundle.spyneSDK, with: nil)
            self.exteriorLeadingImage.image = UIImage(named: "dottedLine",in: Bundle.spyneSDK, with: nil)
        } else {
            self.exteriorImage.image = UIImage(named: "dottedCircle",in: Bundle.spyneSDK, with: nil)
            self.exteriorLeadingImage.image = UIImage(named: "dottedLine",in: Bundle.spyneSDK, with: nil)
        }
        if self.shootStatus.exteriorDone {
            self.exteriorImage.image = UIImage(named: "greenCircle",in: Bundle.spyneSDK, with: nil)
            self.exteriorLeadingImage.image = UIImage(named: "greenLine",in: Bundle.spyneSDK, with: nil)
        }
        if self.shootStatus.onInterior {
            self.interiorImage.image = UIImage(named: "lineCircle",in: Bundle.spyneSDK, with: nil)
            self.interiorLeading.image = UIImage(named: "dottedLine",in: Bundle.spyneSDK, with: nil)
        } else {
            self.interiorImage.image = UIImage(named: "dottedCircle",in: Bundle.spyneSDK, with: nil)
            self.interiorLeading.image = UIImage(named: "dottedLine",in: Bundle.spyneSDK, with: nil)
        }
        if self.shootStatus.interiorDone {
            self.interiorImage.image = UIImage(named: "greenCircle",in: Bundle.spyneSDK, with: nil)
            self.interiorLeading.image = UIImage(named: "greenLine",in: Bundle.spyneSDK, with: nil)
        }
        if self.shootStatus.onMisc {
            self.miscImage.image = UIImage(named: "lineCircle",in: Bundle.spyneSDK, with: nil)
        } else {
            self.miscImage.image = UIImage(named: "dottedCircle",in: Bundle.spyneSDK, with: nil)
        }
        if self.shootStatus.miscDone {
            self.miscImage.image = UIImage(named: "greenCircle",in: Bundle.spyneSDK, with: nil)
        }
        let exteriorClickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        if exteriorClickedAngleCount == vmShoot.arrOverLays.count {
            exteriorImage.image = nil
            exteriorImage.setImage(UIImage(systemName: "checkmark.circle")!)
            exteriorLeadingImage.image = nil
            exteriorLeadingImage.backgroundColor = UIColor(hexAlpha: "00C488")
        }
        let clickedMendatoryInteriorAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle && ($0.mendatoy ?? false)}.count
        let totalMendatoryInteriorAngleCount = Storage.shared.arrInteriorPopup.filter{$0.mendatoy ?? false}.count
        let intriorClickedAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle}.count
        if intriorClickedAngleCount > 0 {
            if clickedMendatoryInteriorAngleCount == totalMendatoryInteriorAngleCount && totalMendatoryInteriorAngleCount > 0 {
                interiorImage.setImage(UIImage(systemName: "checkmark.circle")!)
                interiorImage.tintColor = UIColor(hexAlpha: "00C488")
                interiorLeading.image = nil
                interiorLeading.backgroundColor = UIColor(hexAlpha: "00C488")
            }
            if intriorClickedAngleCount == Storage.shared.arrInteriorPopup.count {
                interiorImage.setImage(UIImage(systemName: "checkmark.circle")!)
                interiorImage.tintColor = UIColor(hexAlpha: "00C488")
                interiorLeading.image = nil
                interiorLeading.backgroundColor = UIColor(hexAlpha: "00C488")
            }
        }
        let clickedMendatoryMiscAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle && ($0.mendatoy ?? false)}.count
        let totalMendatoryMiscAngleCount = Storage.shared.arrFocusedPopup.filter{$0.mendatoy ?? false}.count
        let miscClickedAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle}.count
        if miscClickedAngleCount > 0 {
            if clickedMendatoryMiscAngleCount == totalMendatoryMiscAngleCount && totalMendatoryMiscAngleCount > 0 {
                miscImage.setImage(UIImage(systemName: "checkmark.circle")!)
                miscImage.tintColor = UIColor(hexAlpha: "ffff00")
            }
            if miscClickedAngleCount == Storage.shared.arrFocusedPopup.count {
                miscImage.setImage(UIImage(systemName: "checkmark.circle")!)
                miscImage.tintColor = UIColor(hexAlpha: "00C488")
            }
        }
    }
    
    ///openOverlayDrawer: Is a method which basically adds the custom view to the Viewcontroller
    ///openOverlayDrawer: This view basically shows the clicked Image and upcoming overlays
    @objc func openOverlayDrawer(_ sender: UITapGestureRecognizer? = nil) {
        var containsDrawerView = true
        for item in mainView.subviews {
            if item.tag == 10010 {
                item.fadeOut() {_ in
                    item.removeFromSuperview()
                    self.cameraForegroundView.isUserInteractionEnabled = false
                }
                containsDrawerView = false
            }
        }
        if containsDrawerView {
            let customView = SPOverlaysDrawer(frame: CGRect(x: 180, y: 0, width: UIScreen.main.bounds.width - 180, height: 376))
            self.drawerUpdateCellDelegate = customView
            customView.tag = 10010
            customView.selectedCellDelegate = self
            customView.vmShoot = vmShoot
            customView.dismissDrawerDelegate = self
            customView.commonInit()
            cameraForegroundView.isUserInteractionEnabled = true
            customView.shootType = shootType
            self.mainView.addSubview(customView)
            customView.contentView.fadeIn()
        }
    }
    
    ///setToExteriorShootType: changes the configuration accrodingly to the exterior shoot
    @objc func setToExteriorShootType(_ sender: UITapGestureRecognizer? = nil) {
        moveToExterior()
        motionManager.startGyroUpdates()
        getMotion()
        shootType = .Exterior
        shootStatus.onExterior = true
        shootStatus.onMisc = false
        shootStatus.onInterior = false
        drawerUpdateCellDelegate?.updateDrawerOverlayCells(shootType: .Exterior)
        configureShootStatusView()
    }
    
    ///setToInteriorShootType: changes the configuration accrodingly to the interior shoot
    @objc func setToInteriorShootType(_ sender: UITapGestureRecognizer? = nil) {
        if interiorPopUp {
            //if not shown
            let customView = SPShootSelectionV2PopUpView(frame: CGRect(x: 0, y: 0, width: 390, height: 228))
            customView.delegate = self
            customView.tag = 10011
            popUpView.isUserInteractionEnabled = true
            self.popUpView.addSubview(customView)
            customView.fadeIn()
            customView.center = CGPoint(x: self.popUpView.bounds.midX, y: self.popUpView.bounds.midY)
            customView.setUpValues(shootType: .Interior)
            interiorPopUp = false
        }
        moveToInterior()
        stopMotion()
        shootStatus.onExterior = false
        shootStatus.onMisc = false
        shootStatus.onInterior = true
        drawerUpdateCellDelegate?.updateDrawerOverlayCells(shootType: .Interior)
        configureShootStatusView()
    }
    
    ///setToMiscShootType: changes the configuration accrodingly to the misc shoot
    @objc func setToMiscShootType(_ sender: UITapGestureRecognizer? = nil) {
        if miscPopUpShow {
            //if not shown
            let customView = SPShootSelectionV2PopUpView(frame: CGRect(x: 0, y: 0, width: 390, height: 228))
            customView.delegate = self
            customView.tag = 10011
            popUpView.isUserInteractionEnabled = true
            self.popUpView.addSubview(customView)
            customView.fadeIn()
            customView.center = CGPoint(x: self.popUpView.bounds.midX, y: self.popUpView.bounds.midY)
            customView.setUpValues(shootType: .Misc)
            miscPopUpShow = false
        }
        moveToMisc()
        stopMotion()
        shootType = .Misc
        shootStatus.onExterior = false
        shootStatus.onMisc = true
        shootStatus.onInterior = false
        drawerUpdateCellDelegate?.updateDrawerOverlayCells(shootType: .Misc)
        configureShootStatusView()
    }
    
    ///getMotion: is responsible for the gyroMotion
    func getMotion() {
        if motionManager.isGyroAvailable {
            gyroMeterValueLabel.isHidden = false
            viewGyrometer.isHidden = false
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] (motion, error) -> Void in
                if let attitude = motion?.attitude {
                    let roll = (attitude.roll * 180 / Double.pi) + 90
                    DispatchQueue.main.async{
                        self?.conLineVerticleContainer.constant = CGFloat(roll)
                        let gyroValue = Int(self?.conLineVerticleContainer.constant ?? 0) - 90
                        self?.gyroMeterValueLabel.text = "\(String(describing: gyroValue > 0 ? gyroValue : gyroValue * -1))" + "°"
                        guard let gravity = motion?.gravity else{
                            return
                        }
                        let rotation = atan2(gravity.y, gravity.x) - Double.pi
                        //Change the view's transform from the main thread.
                        self?.viewGyroline.transform = CGAffineTransform(rotationAngle: CGFloat(-1*rotation))
                        
                        let degrees = (rotation * 180 / .pi)+360
                        if (roll > -10 && roll < 10) && (degrees < 10 || degrees > 350){
                            self?.imgGyroFrame.tintColor = UIColor.green
                            self?.viewGyroline.backgroundColor = UIColor.green
                            self?.gyroMeterValueLabel.backgroundColor = UIColor.green
                            self?.captureButton.isUserInteractionEnabled = true
                            self?.captureButton.alpha = 1.0
                            self?.captureButton.tintColor = UIColor.white
                            self?.view.hideAllToasts()
                        }
                        else{
                            self?.showToast(message: Alert.redGyrometerError)
                            self?.imgGyroFrame.tintColor = UIColor.red
                            self?.viewGyroline.backgroundColor = UIColor.red
                            self?.gyroMeterValueLabel.backgroundColor = UIColor.red
                            self?.captureButton.isUserInteractionEnabled = false
                            self?.captureButton.alpha = 0.5
                            self?.captureButton.tintColor = UIColor.lightGray
                        }
                    }
                }
            }
            print("Device motion started")
        }else{
            ShowAlert(message: Alert.gyroScopeNotAvailable, theme: .warning)
        }
    }
    
    func stopMotion() {
        gyroMeterValueLabel.isHidden = true
        motionManager.stopDeviceMotionUpdates()
        captureButton.isUserInteractionEnabled = true
        captureButton.alpha = 1.0
        viewGyrometer.isHidden = true
    }
    
    /// checkCameraAccess: checks for the authorization of camera access
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
    
    ///presentCameraSettings: of not authorized then shows the dialogue box
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "IMPORTANT",
                                                message: "Camera access required for capturing photos!",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        present(alertController, animated: true)
    }
    
    ///startCamera: method which basically takes the camera to forground
    func startCamera(){
#if targetEnvironment(simulator)
        ShowAlert(message: "Simulator not supported camera", theme: .warning)
#else
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
#endif
    }
    
    //MARK: - IBActions
    ///flashLightButtonTouchUpInside: Toggles the torch status
    @IBAction func exteriorButtonTapped(_ sender: Any) {
        setToExteriorShootType()
    }
    
    @IBAction func interiorButtonTapped(_ sender: Any) {
        interiorPopUp = false
        setToInteriorShootType()
    }
    
    @IBAction func miscButtonTapped(_ sender: Any) {
        miscPopUpShow = false
        setToMiscShootType()
    }
    
    ///backButtonTapped: pop to the root
    @IBAction func backButtonTapped(_ sender: Any) {
        DraftStorage.reset()
        SpyneSDK.shared.orientationLock = .portrait
        let exteriorClickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        let interiorTotalMendatory = Storage.shared.arrInteriorPopup.filter{$0.mendatoy ?? false}.count
        let clickedMendatoryInteriorAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle && ($0.mendatoy ?? false)}.count
        let miscTotalMendatory = Storage.shared.arrFocusedPopup.filter{$0.mendatoy ?? false}.count
        let clickedMendatoryMiscAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle && ($0.mendatoy ?? false)}.count
        if exteriorClickedAngleCount == vmShoot.arrOverLays.count && clickedMendatoryInteriorAngleCount >= interiorTotalMendatory && miscTotalMendatory >= miscTotalMendatory {
            Storage.shared.vmShoot = self.vmShoot
            let storyBoard = UIStoryboard(name: "CompleteProject", bundle: Bundle.spyneSDK)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SPCompletingProjectViewController") as! SPCompletingProjectViewController
            self.navigationController?.pushViewController(vc, animated: true  )
        } else {
            self.navigationController?.popTo(controllerToPop: SpyneSDK.referenceVC!)
        }
    }
    
    ///flashLightButtonTouchUpInside: flash light enable and disbale
    @IBAction func flashLightButtonTouchUpInside(_ sender: Any) {
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch {
            do {
                try device.lockForConfiguration()
                if device.torchMode == .on {
                    device.torchMode = .off
                } else {
                    device.torchMode = .on
                }
                device.unlockForConfiguration()
            }
            catch {
                print(SPStringV2.torchError)
            }
        }
    }
    
    ///captureImageButton: On tap of Image capture button
    @IBAction func captureImageButton(_ sender: Any) {
        checkCameraAccess()
    }
    
}

//MARK: extension SPCameraScreenV2ViewController: SPSelectedCellDelegate
extension SPCameraScreenV2ViewController: SPSelectedCellDelegate {
    ///updateSelectedCell for the index for the cell in the drawer
    func updateSelectedCell(index: Int, shootType: ShootType) {
        switch shootType {
        case .Exterior:
            vmShoot.selectedAngle = index
            self.overlayNameLabel.text = vmShoot.arrOverLays[index].displayName ?? ""
            imgCapturedImage.sd_setImage(with: URL(string: vmShoot.arrOverLays[index].displayThumbnail ?? ""))
            overlaySideImage.sd_setImage(with: URL(string: vmShoot.arrOverLays[index].displayThumbnail ?? ""))
            self.mendatoryLabel.text = vmShoot.arrOverLays[index].mendatory ?? false ? "Mandatory" : "Non-Mandatory"
        case .Interior:
            vmShoot.selectedInteriorAngles = index
            self.overlayNameLabel.text = Storage.shared.arrInteriorPopup[index].displayName ?? ""
            overlaySideImage.sd_setImage(with: URL(string: Storage.shared.arrInteriorPopup[index].displayThumbnail ?? ""))
            self.mendatoryLabel.text = Storage.shared.arrInteriorPopup[index].mendatoy ?? false ? "Mandatory" : "Non-Mandatory"
        case .Misc:
            vmShoot.selectedFocusAngles = index
            overlaySideImage.sd_setImage(with: URL(string: Storage.shared.arrFocusedPopup[index].displayThumbnail ?? ""))
            self.mendatoryLabel.text = Storage.shared.arrFocusedPopup[index].mendatoy ?? false ? "Mandatory" : "Non-Mandatory"
        }
        openOverlayDrawer()
    }
}

extension SPCameraScreenV2ViewController: ShootTypeViewDelegate {
    func skipButtonTapped() {
        let clickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        for item in popUpView.subviews {
            if item.tag == 10011 {
                item.fadeOut() {_ in
                    item.removeFromSuperview()
                }
                self.popUpView.isUserInteractionEnabled = false
            }
        }
        if shootType == .Interior {
            setToMiscShootType()
        } else if shootType == .Misc && vmShoot.arrOverLays.count == clickedAngleCount  {
            // end shoot
        } else {
            setToExteriorShootType()
        }
    }
    
    func shootNowButtonTapped() {
        for item in popUpView.subviews {
            if item.tag == 10011 {
                item.fadeOut() {_ in
                    item.removeFromSuperview()
                    self.popUpView.isUserInteractionEnabled = false
                }
            }
        }
    }
}
