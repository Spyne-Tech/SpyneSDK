//
//  SP360OrderSummaryVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 29/07/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import SwiftMessages
import KRProgressHUD
import SDDownloadManager

public protocol SP360OrderSummaryVCDelegate {
    func showAlertDataRequest(skuId:String, isShoot: Bool)
}

class SP360OrderSummaryVC: UIViewController {
    
    @IBOutlet weak var viewCategoryItemView: UIView!
    @IBOutlet weak var imgOrderThumbImage: UIImageView!
    @IBOutlet weak var viewDownloadImageView: UIView!
    @IBOutlet weak var lblCreditAvailable: UILabel!
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var lblTotalClickedImages: UILabel!
    @IBOutlet weak var lblSkuName: UILabel!
    @IBOutlet weak var lblImageCount: UILabel!
    @IBOutlet weak var btnCreditAvailable: UIButton!
    @IBOutlet weak var btnStartEditing: UIButton!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var TotalImageswClicked: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    
    //    var vmSPHomeVM = SPHomeVM()
    var vmSPImageProccesing = SPImageProccesingVM()
    var delegate: SP360OrderSummaryVCDelegate?
    
    let directoryName : String = "Spyne"
    private let downloadManager = SDDownloadManager.shared
    var imageCount = 0
    var skuId = String()
    var isFromDounloadPopup = false
    var shootEnv:Int = 0
    static var videoUrl:URL?
    
    var numberPlateId : String?
    var is360 = ""
    var isWindowTinted = ""
    var isShadowSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:-Initial Setup
    func initialSetup(){
        setImageData()
        localizeStrings()
        getUsersCredit()
        self.imgOrderThumbImage.image = SPShootViewModel.shared.capturedImage
        
    }
    
    func localizeStrings() {
        CategoryLabel.text = "Category - Automobile"
        TotalImageswClicked.text = "Total Images Clicked"
        totalCost.text = "Total Cost"
        btnStartEditing.setTitle("Generate Output" , for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        initialSetup()
    }
    
    internal func setImageData(){
        
        let CreditAvailableMessage = NSMutableAttributedString(string: "Credits Available" , attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#898A8D")])
        //         CreditAvailableMessage.append(NSAttributedString(string: "(Top Up)", attributes:[NSAttributedString.Key.font : UIFont.popinsRegular(witSize: 14) , NSAttributedString.Key.foregroundColor: UIColor.appColor ] ))
        
        
        btnCreditAvailable.setAttributedTitle(CreditAvailableMessage, for: .normal)
        viewCategoryItemView.setShadow(width: 0.5, height: 0.5, color: UIColor(hexString: "#000000")!, radius: 2, opacity: 0.4)
        viewDownloadImageView.setShadow(width: 0, height: -0.3, color: UIColor(hexString: "#000000")!, radius: 1, opacity: 0.4)
        
        imageCount = SPShootViewModel.shared.noOfAngles
        
    }
    internal func getUsersCredit(){
        //        vmSPHomeVM.getUsersCreditDetails{
        //            self.setData()
        //            PosthogEvent.shared.posthogCapture(identity: "iOS Fetch Credits", properties: ["email":USER.userEmail])
        //        } onError: { (errMessage) in
        //            PosthogEvent.shared.posthogCapture(identity: "iOS Fetch Credits Failed", properties: ["email":USER.userEmail])
        //            ShowAlert(message: errMessage, theme: .error)
        //        }
    }
    
    internal func updateCredit(){
        //        vmSPHomeVM.updateCredit(credit_used: "\(imageCount)") {
        self.processImages()
        //        } onError: { (message) in
        //            ShowAlert(message: message, theme: .error)
        //        }
    }
    
    
    func setData(){
        
        let credit = Storage.shared.getCredit()
        if imageCount > (credit?.creditAvailable ?? 0){
            btnStartEditing.isUserInteractionEnabled = false
            btnStartEditing.backgroundColor = UIColor.lightGray
        }else{
            btnStartEditing.isUserInteractionEnabled = true
            btnStartEditing.backgroundColor = UIColor.appColor
        }
        self.lblImageCount.text = "\(imageCount) " + "Images"
        self.lblTotalClickedImages.text = "\(imageCount) " + "Images"
        self.lblCreditAvailable.text = "\(credit?.creditAvailable ?? 0) " + "Credit"
        self.lblTotalCost.text = "\(imageCount) " + "Credit"
        
    }
    
    //MARK:- Button Action
    @IBAction func btnActionBack(_ sender: UIBarButtonItem) {
        if isFromDounloadPopup{
            //            SPCarbonKitProjectVC.currentTabIndex = 1
            self.tabBarController?.tabBar.isHidden = false
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActionStartEditing(_ sender: UIButton) {
        
        
        let credit = Storage.shared.getCredit()
        self.processImages()
        
        //        let credit = Storage.shared.getCredit()
        //        if imageCount > (credit?.creditAvailable ?? 0){
        //
        //            ShowAlert(message: Alert.creditRequired, theme: .error)
        //        }else{
        //            updateCredit()
        //        }
        
    }
    
    
    @IBAction func btnActtionTopUp(_ sender: UIButton) {
        
        //        let story = UIStoryboard(name: "Main", bundle: nil)
        //        if let vc = story.instantiateViewController(withIdentifier: "SPPackListingViewController")as? SPPackListingViewController{
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    func processImages(){
        
        let shootData = Storage.shared.vmShoot
        let backgroundId = vmSPImageProccesing.arrCarBackground[vmSPImageProccesing.selectedIndex].imageId ?? ""
        
        vmSPImageProccesing.processImage(skuId: shootData.skuId, background_id: backgroundId, is360: is360 ,isBlurNumPlate: "false", isTintWindow: isWindowTinted, windowCorrection: "false",shootEnv: shootEnv, numberplateID: numberPlateId ?? "", isShadow: self.isShadowSelected) {
            PosthogEvent.shared.posthogCapture(identity: "iOS Process Completed", properties: ["sku_id":shootData.skuId])
            self.markDone()
            //            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPDownloadCompletedVC")as? SPDownloadCompletedVC{
            //                self.navigationController?.pushViewController(vc, animated: true)
            //            }
            
        } onError: { (message) in
            
            PosthogEvent.shared.posthogCapture(identity: "iOS Process Failed", properties: ["message":message])
            
        }
    }
    
    func markDone() {
        let shootData = Storage.shared.vmShoot
        vmSPImageProccesing.updateProjectIds(projectIds: [shootData.projectId], onSuccess: {
            ///      Pop to root View Controller : On Main Screen
            guard let controller = SpyneSDK.referenceVC else{return}
            self.delegate = controller as? any SP360OrderSummaryVCDelegate
            self.navigationController?.popTo(controllerToPop: controller)
            self.delegate?.showAlertDataRequest(skuId: shootData.skuId, isShoot: false)
            
        }, onError: {
            error in
            print(error)
        })
    }
    
}
