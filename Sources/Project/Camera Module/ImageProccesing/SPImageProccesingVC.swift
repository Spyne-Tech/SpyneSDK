//
//  SPImageProccesing.swift
//  Spyne
//
//  Created by Vijay on 19/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import KRProgressHUD
import SwiftyGif
import RealmSwift

class SPImageProccesingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Outlet
    @IBOutlet weak var collectionBackground: UICollectionView!
    @IBOutlet weak var viewLoader: UIView!
    @IBOutlet weak var btnStartEditing: UIButton!
    @IBOutlet weak var imgGifPreview: UIImageView!
    @IBOutlet weak var btnIs360Generate: UIButton!
    @IBOutlet weak var btnIsTintWindow: UIButton!
    @IBOutlet weak var btnIsBlurNumberPlate: UIButton!
    @IBOutlet weak var btnWindowCorrection: UIButton!
    @IBOutlet weak var btnStudioEnvirement: UIButton!
    @IBOutlet weak var btnOutdoorEnvirement: UIButton!
    @IBOutlet weak var selectBackgroundLabel: UILabel!
    @IBOutlet weak var generate360Label: UILabel!
    @IBOutlet weak var tintWindowLabel: UILabel!
    @IBOutlet weak var chooseShootEnvironmentLabel: UILabel!
    @IBOutlet weak var sampleOutputLabel: UILabel!
    
    // Variable
    var vmSPImageProccesing = SPImageProccesingVM()
    var totalImages = 0
    var numberPlateModel : NumberPlateModel?
    var selectedNumberPlateId: String?
    var isShadowSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateSetup()
    }
    
    //MARK:- initiate function
    func initiateSetup(){
        localizeString()
        // btnIs360Generate.isSelected = true
        btnStudioEnvirement.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        btnOutdoorEnvirement.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        btnStartEditing.layer.shadowColor = UIColor.appColor?.cgColor
        vmSPImageProccesing.selectedIndex = 0
        vmSPImageProccesing.getCarBeckground(category: "automobiles"){ [self] in
            self.viewLoader.isHidden = true
            PosthogEvent.shared.posthogCapture(identity: "iOS Got Background", properties: [:])
            if self.vmSPImageProccesing.arrCarBackground.count > 0{
                if let url =  URL(string:self.vmSPImageProccesing.arrCarBackground.first?.gifUrl ?? ""){
                    self.imgGifPreview.sd_setImage(with: url, placeholderImage: UIImage())
                    // let loader = UIActivityIndicatorView(style: .medium)
                    // self.imgGifPreview.setGifFromURL(url, customLoader: loader)
                }
                
            }
            collectionBackground.dataSource = self
            collectionBackground.delegate = self
            collectionBackground.reloadData()
            
        } onError: { (errMsg) in
            PosthogEvent.shared.posthogCapture(identity: "iOS Get Background Failed", properties: ["message":errMsg])
            ShowAlert(message: errMsg, theme: .error)
        }
        
    }
    
    func localizeString() {
        selectBackgroundLabel.text = "Select Background"
        self.title = "Background"
        generate360Label.text = "Generate 360"
        tintWindowLabel.text = "Tint Window"
        chooseShootEnvironmentLabel.text = "Choose your Shoot Environment"
        btnStudioEnvirement.setTitle("Studio" , for: .normal)
        btnOutdoorEnvirement.setTitle("Outdoor", for: .normal)
        sampleOutputLabel.text = "Sample 360° Output"
        btnStartEditing.setTitle("Continue" , for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:- Button Action
    @IBAction func btnActionIs360generate(_ sender: UIButton) {
        
        btnIs360Generate.isSelected.toggle()
        
    }
    
    @IBAction func btnActionGenerate360Shoot(_ sender: UIButton) {
        
        if !btnStudioEnvirement.isSelected && !btnOutdoorEnvirement.isSelected{
            ShowAlert(message: Alert.chooseYourShootEnvironment, theme: .warning)
        }else{
            let shootData = Storage.shared.vmShoot
            if btnIs360Generate.isSelected{
                let story = UIStoryboard(name: "ImageProccesing", bundle: Bundle.spyneSDK)
                if let vc = story.instantiateViewController(withIdentifier: "SP360OrderSummaryVC")as? SP360OrderSummaryVC{
//                    vc.skuId = shootData.skuId
//                    vc.vmSPImageProccesing = self.vmSPImageProccesing
//                    vc.shootEnv  = btnStudioEnvirement.isSelected ? 0 : 1
                    
                    vc.skuId = shootData.skuId
                    vc.is360 = String(btnIs360Generate.isSelected)
                    vc.numberPlateId = selectedNumberPlateId
                    vc.isWindowTinted = String(btnIsTintWindow.isSelected)
                    vc.isShadowSelected = isShadowSelected
//                    vc.totalImages = totalImages#if
                    vc.vmSPImageProccesing = self.vmSPImageProccesing
                    vc.shootEnv  = btnStudioEnvirement.isSelected ? 0 : 1
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else{
                updateTotalFrames()
            }
            
            
        }
    }
    
    @IBAction func btnActionBlurNumberPlate(_ sender: UIButton) {
        btnIsBlurNumberPlate.isSelected.toggle()
        
    }
    
    @IBAction func btnActionTintWindow(_ sender: UIButton) {
        btnIsTintWindow.isSelected.toggle()
        
    }
    
    
    @IBAction func btnActionBack(_ sender: UIBarButtonItem) {
        //        AppDelegate.navToHome(selectedIndex: 0)
    }
    
    private func updateTotalFrames(){
        let shootData = Storage.shared.vmShoot
        let totalFrames = getTotalClickedImageData(projectId: shootData.projectId)
        vmSPImageProccesing.updateTotalFrames(skuId: shootData.skuId, totalFrames: "\(totalFrames)") {
            PosthogEvent.shared.posthogCapture(identity: "iOS Update Frame Completed", properties: ["sku_id":shootData.skuId])
            self.processTheImages()
        } onError: { message in
            PosthogEvent.shared.posthogCapture(identity: "iOS Update Frame Failed", properties: ["message":message])
            ShowAlert(message: message, theme: .warning)
        }
        
    }
    @IBAction func btnActionShootEnironmentStudioClick(_ sender: UIButton) {
        sender.isSelected.toggle()
        btnOutdoorEnvirement.isSelected = false
        
    }
    @IBAction func btnActionShootEnironmentOutdoorClick(_ sender: UIButton) {
        sender.isSelected.toggle()
        btnStudioEnvirement.isSelected = false
        
    }
    
    func clearShootEnvironment() {
        btnStudioEnvirement.isSelected = false
        btnOutdoorEnvirement.isSelected = false
    }
    
    //Get Total CLicked Images for this project
    func getTotalClickedImageData(projectId:String)->Int{
        
        let predicate = NSPredicate(format: "projectId == '\(projectId)'", "")
        let localRealm = try? Realm()
        if let localData = localRealm{
            let imageData: [RealmImageData] = localData.objects(RealmImageData.self).filter(predicate).map { imgData in
                // Iterate through all the Canteens
                return imgData
            }
            return  imageData.count
        }
        return 0
    }
    
    private func processTheImages(){
        if !btnStudioEnvirement.isSelected && !btnOutdoorEnvirement.isSelected{
            ShowAlert(message: Alert.chooseYourShootEnvironment, theme: .warning)
        }else{
            let shootData = Storage.shared.vmShoot
            
            let backgroundId = vmSPImageProccesing.arrCarBackground[vmSPImageProccesing.selectedIndex].imageId ?? ""
            
            vmSPImageProccesing.processImage(skuId: shootData.skuId, background_id: backgroundId, is360: btnIs360Generate.isSelected ? "true" : "false",isBlurNumPlate: btnIsBlurNumberPlate.isSelected ? "true" : "false", isTintWindow: btnIsTintWindow.isSelected ? "true" : "false", windowCorrection: "false", shootEnv: btnStudioEnvirement.isSelected ? 0 : 1, numberplateID: selectedNumberPlateId ?? "", isShadow: isShadowSelected) {
                
                PosthogEvent.shared.posthogCapture(identity: "iOS Process Completed", properties: ["sku_id":shootData.skuId])
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPDownloadCompletedVC")as? SPDownloadCompletedVC{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } onError: { (message) in
                PosthogEvent.shared.posthogCapture(identity: "iOS Process Failed", properties: ["message":message])
                ShowAlert(message: message, theme: .warning)
            }
            
        }
        
    }
    
    
}

//MARK:- collectionVIew Extention
extension SPImageProccesingVC
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmSPImageProccesing.arrCarBackground.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPImageProccesingSelectBackgroundCell", for: indexPath) as! SPImageProccesingSelectBackgroundCell
        
        if vmSPImageProccesing.selectedIndex == indexPath.row{
            cell.imgselectBackgroungImage.layer.borderColor =  (UIColor.appColor?.cgColor)
            cell.lblselectBackgroungTitle.textColor = UIColor.appColor
            
        }else{
            cell.imgselectBackgroungImage.layer.borderColor = UIColor.clear.cgColor
            cell.lblselectBackgroungTitle.textColor = UIColor.black
        }
        let imageUrl = vmSPImageProccesing.arrCarBackground[indexPath.row].imageUrl
        if let url = URL(string: "\(imageUrl ?? "")"){
            cell.imgselectBackgroungImage.sd_setImage(with: url, placeholderImage: UIImage())
        }
        // cell.imgselectBackgroungImage.backgroundColor = UIColor.appColor
        cell.lblselectBackgroungTitle.text = vmSPImageProccesing.arrCarBackground[indexPath.row].bgName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = collectionView.frame.height
        return CGSize(width: 110 , height: (60  + 48))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        vmSPImageProccesing.selectedIndex = indexPath.row
        collectionBackground.reloadData()
        
        if let url =  URL(string:self.vmSPImageProccesing.arrCarBackground[indexPath.row].gifUrl ?? ""){
            
            self.imgGifPreview.sd_setImage(with: url, placeholderImage: UIImage())
            //let loader = UIActivityIndicatorView(style: .medium)
            //self.imgGifPreview.setGifFromURL(url, customLoader: loader)
        }
        
    }
    
}
