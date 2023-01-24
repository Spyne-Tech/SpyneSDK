//
//  SPShootFocusImagesVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 01/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
class SPShootFocusImagesVC:UIViewController{
    
    
    // Outlet
    @IBOutlet weak var collectionAngles: UICollectionView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var collectionFocusImages: UICollectionView!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var viewAngle: UIView!
    @IBOutlet weak var btnAngles: UIButton!
    @IBOutlet weak var imgCapturedImage: UIImageView!
    
    // Variable
    var is360Interior = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        
        initialSetup()
        attachZoom(viewCamera)
        attachFocus(viewCamera)
        attachExposure(viewCamera)
        
    }
    
    
    //MARK:- initial Setup
    func initialSetup()  {
        
        btnAngles.setTitleColor(UIColor.appColor, for: .normal)
        btnAngles.borderColor = UIColor.appColor
        btnAngles.tintColor = UIColor.appColor
        btnAngles.setTitle("  " + "Angles"  + " 1/\(Storage.shared.arrFocusedPopup.count)  ", for: .normal)
        vmShoot.selectedFocusAngles = 0
        collectionFocusImages.delegate = self
        collectionFocusImages.dataSource = self
        btnSkip.setTitleColor(UIColor.appColor, for: .normal)
        btnSkip.tintColor = UIColor.appColor
        btnSkip.setTitle("End Shoot" , for: .normal)
        
        cameraSetup()
        notificationCenter()
        if DraftStorage.isFromDraft{
            if Storage.shared.arrFocusedPopup.count == 0{
                vmShoot.getProductSubCategories(prod_id: vmShoot.cat_id) {
                    
                    self.setClickedAngle()
                } onError: { (errMessage) in
                    ShowAlert(message: errMessage, theme: .error)
                }
            }else{
                self.setClickedAngle()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
    
    //MARK:- Function
    func setClickedAngle(){
        for comparedOverlay in Storage.shared.vmSPOrderNow.arrImages{
            for (index,focused) in  Storage.shared.arrFocusedPopup.enumerated(){
                if (comparedOverlay.overlayID ?? 0) == focused.id{
                    Storage.shared.arrFocusedPopup[index].clickedAngle = true
                    for (index1,_) in  Storage.shared.arrInteriorPopup.enumerated(){
                        Storage.shared.arrInteriorPopup[index1].imageUrl = comparedOverlay.inputImageLresURL
                    }
                    Storage.shared.arrFocusedPopup[index].frameSeqNo = focused.frameSeqNo
                    self.collectionFocusImages.reloadData()
                    
                }
            }
        }
        self.setToNextOverlay()
    }
    
    //MARK:- Button Action
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
    
    @IBAction func btnActionTackPic(_ sender: UIButton) {
        
        checkCameraAccess()
        
    }
    
    @IBAction func btnActionChoosePicFromGallery(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate  = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func skipFocusCapture(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPExitShootPopup") as? SPExitShootPopup{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.strTitelString = Alert.skipAnglePopupTitle
            vc.btnDidYesTapped = { [self] in
                
                Storage.shared.vmShoot = self.vmShoot
                
                let taskToUpdate = self.vmRealm.getRealmData(skuId:self.vmShoot.skuId)
                try! self.localRealm?.safeWrite {
                    taskToUpdate?.misSkiped = true
                }
                let story = UIStoryboard(name: "ImageProccesing", bundle:Bundle.spyneSDK)
                if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            vc.btnDidNoTapped = {
                
            }
            self.present(vc, animated: true, completion: nil)
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
    
    
    func show360InteriorPopup(){
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SP360InteriorPopupVC") as? SP360InteriorPopupVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.btnSkipTapped = {
                Storage.shared.vmShoot = self.vmShoot
                
                let story = UIStoryboard(name: "ImageProccesing", bundle:Bundle.spyneSDK)
                
                if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                //AppDelegate.navToImageProccesing()
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
    
    func getRealmData()->RealmProjectData?{
        
        let predicate = NSPredicate(format: "skuId == '\(vmShoot.skuId)'", "")
        if let localData = localRealm{
            let projectData: [RealmProjectData] = localData.objects(RealmProjectData.self).filter(predicate).map { projectData in
                // Iterate through all the Canteens
                return projectData
            }
            return  projectData.first
            
        }
        return nil
        
    }
    
    
}
