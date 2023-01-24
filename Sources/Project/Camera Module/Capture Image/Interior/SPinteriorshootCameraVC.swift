//
//  SPinteriorshootCameraVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 01/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import AVFoundation
import KRProgressHUD
import RealmSwift
class SPinteriorshootCameraVC: UIViewController {
    
    
  
    // Outlet
    @IBOutlet weak var collectionAngles: UICollectionView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var collectionProductCategories: UICollectionView!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var viewAngle: UIView!
    @IBOutlet weak var btnAngles: UIButton!
    @IBOutlet weak var imgCapturedImage: UIImageView!
    // Variable
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var vmShoot = SPShootViewModel()
    let sequence = MaterialShowcaseSequence()
    var cameraDevice: AVCaptureDevice!
    var vmOrderNow = SPOrderNowVM()
    let localRealm = try? Realm()
    var isReclick = false
    var vmRealm = RealmViewModel()
    //Focus and geture
    var previewLayer: AVCaptureVideoPreviewLayer!
    var device = AVCaptureDevice.default(for: .video)
    
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
    var is360Interior = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        
        initialSetup()
        attachZoom(viewCamera)
        attachFocus(viewCamera)
        attachExposure(viewCamera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    //MARK:- Button Action
    @IBAction func skipInterialCapture(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPExitShootPopup") as? SPExitShootPopup{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.strTitelString = Alert.skipAnglePopupTitle
            vc.btnDidYesTapped = { [self] in
                let taskToUpdate = vmRealm.getRealmData(skuId:vmShoot.skuId)
                try! self.localRealm?.safeWrite {
                    taskToUpdate?.interiorSkiped = true
                }
                self.showFocusShootPopup()
            }
            vc.btnDidNoTapped = {
                
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnActionChoosePicFromGallery(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate  = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func btnActionClose(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPExitShootPopup") as? SPExitShootPopup{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.strTitelString = Alert.exitShootPopupTitle
            vc.btnDidYesTapped = {
                AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
//                AppDelegate.navToHome(selectedIndex: 0)
            }
            vc.btnDidNoTapped = {
                
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        //AppDelegate.navToHome()
        
    }
    @IBAction func btnActionTackPic(_ sender: UIButton) {
        checkCameraAccess()
    }
    
    //MARK:- initial Setup
    func initialSetup()  {
        
        vmShoot.selectedInteriorAngles = 0
        collectionProductCategories.delegate = self
        collectionProductCategories.dataSource = self
        btnSkip.setTitle("Next" , for: .normal)
        btnSkip.setTitleColor(UIColor.appColor, for: .normal)
        btnSkip.tintColor = UIColor.appColor
        
        cameraSetup()
        notificationCenter()
        
        btnAngles.setTitle("  Angles 1/\(Storage.shared.arrInteriorPopup.count)  ", for: .normal)
        btnAngles.setTitleColor(UIColor.appColor, for: .normal)
        btnAngles.borderColor = UIColor.appColor
        btnAngles.tintColor = UIColor.appColor
        
        
        if DraftStorage.isFromDraft{
            self.vmOrderNow = Storage.shared.vmSPOrderNow
            if Storage.shared.arrInteriorPopup.count == 0{
                vmShoot.getProductSubCategories(prod_id: vmShoot.cat_id) {
                    self.setClickedAngle()
                } onError: { (errMessage) in
                    ShowAlert(message: errMessage, theme: .error)
                }
            }else{
                setClickedAngle()
            }
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
        let inputs = captureSession.inputs
        for oldInput:AVCaptureInput in inputs {
            captureSession.removeInput(oldInput)
        }
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
       
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
#endif
        
    }
    
    
    func setClickedAngle(){
        for comparedOverlay in Storage.shared.vmSPOrderNow.arrImages{
            for (index,interior) in  Storage.shared.arrInteriorPopup.enumerated(){
                if (comparedOverlay.overlayID ?? 0) == interior.id{
                    Storage.shared.arrInteriorPopup[index].clickedAngle = true
                    Storage.shared.arrInteriorPopup[index].imageUrl = comparedOverlay.inputImageLresURL
                    Storage.shared.arrInteriorPopup[index].frameSeqNo = interior.frameSeqNo
                    
                }
            }
        }
        self.setToNextOverlay()
    }
    
    func showFocusShootPopup() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPInterialShootPopup") as? SPInterialShootPopup{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.strTitle = "(2/2) Miscellaneous Shoots" 
            vc.arrImages = Storage.shared.arrFocusedPopup
            vc.btnDidConfirmTapped = { [self] in
                
                navToShootFocusImagesVC()
            }
            vc.btnDidSkipTapped = {
                let taskToUpdate = self.vmRealm.getRealmData(skuId: self.vmShoot.skuId)
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
    func navToShootFocusImagesVC()  {
        KRProgressHUD.show()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SPShootFocusImagesVC") as! SPShootFocusImagesVC
        vc.vmShoot = vmShoot
        KRProgressHUD.dismiss()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func show360InteriorPopup(){
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SP360InteriorPopupVC") as? SP360InteriorPopupVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.btnSkipTapped = {
                
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
    
}
