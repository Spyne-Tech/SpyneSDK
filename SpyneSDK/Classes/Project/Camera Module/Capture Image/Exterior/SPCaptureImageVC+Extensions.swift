//
//  SPCaptureImageVC+Extensions.swift
//  Spyne
//
//  Created by Vijay Parmar on 27/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
//MARK:- Create Project Extension
extension SPCaptureImageVC:CreateProjectDelegate,CreateSKUDelegate{
    
    //Create Offline SKU
    func createProjectandSku(){
        let projectdta = [
            "project_name": self.vmShoot.projectName,
            "category_id": vmShoot.cat_id,
            "source" : "App_ios",
            "superuser_id" : USER.dealerShipId
        ]as [String:Any]
        let skudta = [[
            "sku_name": self.vmShoot.skuName,
            "prod_cat_id": self.vmShoot.cat_id,
            "prod_sub_cat_id" : self.vmShoot.sub_cat_id,
            "total_frames_no" : "\(vmShoot.arrOverLays.count)",
            "initial_no" : 0,
            "image_present" : 1,
            "video_present" : 0,
            "source" : "App_ios"
        ]]as [[String:Any]]
        let projectData = try! JSONSerialization.data(withJSONObject: projectdta)
        let projectString = NSString(data: projectData, encoding: String.Encoding.utf8.rawValue)
        let skuData = try! JSONSerialization.data(withJSONObject: skudta)
        let skuString = NSString(data: skuData, encoding: String.Encoding.utf8.rawValue)
        print(projectString!)
        print(skuString!)
        vmShoot.createProjectandSku(projectdta: projectdta, skudta: skudta) {skudetail in
            self.vmShoot.projectId = skudetail.data.projectID
            self.vmShoot.skuId = skudetail.data.skusList[0].skuID
            // Save data in Realm
            self.realmProjectObject = RealmProjectData(authKey: USER.authKey, prodCatId: self.vmShoot.cat_id, subCatId: self.vmShoot.sub_cat_id, projectId: self.vmShoot.projectId, projectName: self.vmShoot.projectName, skuId: self.vmShoot.skuId, imageCategory: StringCons.exterior, completedAngles: 0, noOfAngles: self.vmShoot.noOfAngles, noOfInteriorAngles: Storage.shared.arrInteriorPopup.count , noOfMisAngles: Storage.shared.arrFocusedPopup.count , interiorSkiped: false, misSkiped: false, is360IntSkiped: false)
            
            try? RealmViewModel.main.realm.safeWrite {
                RealmViewModel.main.realm.add(self.realmProjectObject)
            }
            if  !DraftStorage.isEmptySku{
                
                let realmSkuObject = RealmSkuData(projectId: self.vmShoot.projectId, skuId: self.vmShoot.skuId, skuName: self.vmShoot.skuName, completedAngles: 0)
                
                try? RealmViewModel.main.realm.safeWrite {
                    RealmViewModel.main.realm.add(realmSkuObject)
                    self.setImageUploadData()
                }
                
            }else{
                let taskToUpdate =
                self.vmRealm.getRealmData(projectId: DraftStorage.draftProjectId)
                
                try! self.localRealm?.safeWrite {
                    taskToUpdate?.authKey = USER.authKey
                    taskToUpdate?.prodCatId = self.vmShoot.cat_id
                    taskToUpdate?.subCatId = self.vmShoot.sub_cat_id
                    taskToUpdate?.projectId = self.vmShoot.projectId
                    taskToUpdate?.projectName = self.vmShoot.projectName
                    taskToUpdate?.skuId = self.vmShoot.skuId
                    taskToUpdate?.imageCategory = "Exterior"
                    taskToUpdate?.completedAngles = 0
                    taskToUpdate?.noOfAngles = self.vmShoot.noOfAngles
                    taskToUpdate?.interiorSkiped = false
                    taskToUpdate?.misSkiped = false
                    taskToUpdate?.is360IntSkiped = false
                    self.setImageUploadData()
                }
            }
        } onError: { message in
            ShowAlert(message: message, theme: .warning)
        }
    }
    
    //Create Project
#warning("This Method Not used anymore..")
    func createProjectPopup(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPCreateProjectPopupVC") as? SPCreateProjectPopupVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            self.tabBarController?.tabBar.isHidden = true
            self.present(vc, animated: true, completion: nil)
        }
    }
#warning("This Method Not used anymore..")
    func didSubmitTapped(projectName: String) {
        vmShoot.projectName = projectName
        vmShoot.createProject(productCatId: vmShoot.cat_id, projectName: projectName) {
            self.createSKUPopup()
        } onError: { (message) in
            print(message)
        }
    }
    
    // Create SKU
    func createSKUPopup(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPCreateSKUPopupVC") as? SPCreateSKUPopupVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.projectName =  self.vmShoot.projectName
            vc.delegate = self
            self.tabBarController?.tabBar.isHidden = true
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func didSubmitSKUTapped(skuName: String) {
        
        self.vmShoot.skuName = skuName.removingWhitespaces()
        self.vmShoot.projectName = skuName.removingWhitespaces()
        self.imgOverlayPic.isHidden = false
        self.btnSkuId.setTitle(self.vmShoot.skuName, for: .normal)
        
        vmShoot.createProject(productCatId: vmShoot.cat_id, projectName: self.vmShoot.skuName) {
            PosthogEvent.shared.posthogCapture(identity: "iOS Create Project", properties: ["project_name":self.vmShoot.skuName.removingWhitespaces()])
            
            // Save data in Realm
            self.realmProjectObject = RealmProjectData(authKey: USER.authKey, prodCatId: self.vmShoot.cat_id, subCatId: self.vmShoot.sub_cat_id, projectId: self.vmShoot.projectId, projectName: self.vmShoot.projectName, skuId: self.vmShoot.skuId, imageCategory: StringCons.exterior, completedAngles: 0, noOfAngles: self.vmShoot.noOfAngles, noOfInteriorAngles: Storage.shared.arrInteriorPopup.count , noOfMisAngles: Storage.shared.arrFocusedPopup.count , interiorSkiped: false, misSkiped: false, is360IntSkiped: false)
            
            try? RealmViewModel.main.realm.safeWrite {
                RealmViewModel.main.realm.add(self.realmProjectObject)
            }
            
        } onError: { (message) in
            PosthogEvent.shared.posthogCapture(identity: "iOS Create Project Failed", properties: ["message":message])
            ShowAlert(message: message, theme: .warning)
            self.createSKUPopup()
        }
        
    }
    //
    //    func createSKU(){
    //         let skuName = self.vmShoot.skuName.removingWhitespaces()
    //        btnSkuId.setTitle(skuName, for: .normal)
    //        vmShoot.createSKU(project_id: vmShoot.projectId, prod_cat_id: vmShoot.cat_id, prod_sub_cat_id: vmShoot.sub_cat_id, sku_name: skuName, total_frames: "\(vmShoot.noOfAngles)"){
    //            PosthogEvent.shared.posthogCapture(identity: "iOS Create SKU", properties: ["sku_name":"\(skuName)","project_id":self.vmShoot.projectId,"prod_sub_cat_id":self.vmShoot.sub_cat_id])
    //
    //            if  !DraftStorage.isEmptySku{
    //
    //                let realmSkuObject = RealmSkuData(projectId: self.vmShoot.projectId, skuId: self.vmShoot.skuId, skuName: self.vmShoot.skuName, completedAngles: 0)
    //
    //                try? RealmViewModel.main.realm.safeWrite {
    //                    RealmViewModel.main.realm.add(realmSkuObject)
    //                    self.setImageUploadData()
    //                }
    //
    //            }else{
    //                let taskToUpdate =
    //                self.vmRealm.getRealmData(projectId: DraftStorage.draftProjectId)
    //
    //                try! self.localRealm?.safeWrite {
    //                    taskToUpdate?.authKey = USER.authKey
    //                    taskToUpdate?.prodCatId = self.vmShoot.cat_id
    //                    taskToUpdate?.subCatId = self.vmShoot.sub_cat_id
    //                    taskToUpdate?.projectId = self.vmShoot.projectId
    //                    taskToUpdate?.projectName = self.vmShoot.projectName
    //                    taskToUpdate?.skuId = self.vmShoot.skuId
    //                    taskToUpdate?.imageCategory = "Exterior"
    //                    taskToUpdate?.completedAngles = 0
    //                    taskToUpdate?.noOfAngles = self.vmShoot.noOfAngles
    //                    taskToUpdate?.interiorSkiped = false
    //                    taskToUpdate?.misSkiped = false
    //                    taskToUpdate?.is360IntSkiped = false
    //                    self.setImageUploadData()
    //                }
    //            }
    //
    //        } onError: { (message) in
    //            PosthogEvent.shared.posthogCapture(identity: "iOS Create SKU Failed", properties: ["message":message])
    //            ShowAlert(message: message, theme: .warning)
    //        }
    //    }
    
    func setImageUploadData(){
        
        self.uploadImage(capturedImage: self.vmShoot.capturedImage)
        
    }
    
    func uploadImage(capturedImage:UIImage){
        
        //get selected overlay Id
        let overlayId =  "\(vmShoot.arrOverLays[vmShoot.selectedAngle].id ?? 0)"
        let clickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        
        if vmShoot.arrOverLays[vmShoot.selectedAngle].frameSeqNo == 0{
            vmShoot.arrOverLays[vmShoot.selectedAngle].frameSeqNo = clickedAngleCount + 1
        }
        
        let imageObject = RealmImageData(userId: USER.userId)
        
        imageObject.projectId = vmShoot.projectId
        imageObject.skuId = vmShoot.skuId
        imageObject.skuName = vmShoot.skuName
        imageObject.imageCategory = StringCons.exterior
        imageObject.overlay_id = overlayId
        imageObject.frame_seq_no = "\(vmShoot.arrOverLays[vmShoot.selectedAngle].frameSeqNo)"
        imageObject.is_reshoot = false
        imageObject.is_reclick = isReclick
        imageObject.angle = 90
        
        SpyneSDK.upload.saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(imageObject: imageObject, image: capturedImage, selectedAngle: self.vmShoot.selectedAngle, serviceStartedBy: StringCons.exteriorImageClick)
        
        vmShoot.arrOverLays[vmShoot.selectedAngle].clickedAngle = true
        vmShoot.arrOverLays[vmShoot.selectedAngle].clickedImage = capturedImage
        collectionOverlays.reloadData()
        setToNextOverlay()
        
    }
    
    internal func setToNextOverlay(){
        
        isReclick = false
        
        //Get clicked angle count
        let clickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        
        //Update completed shoot count option
        
        let taskToUpdate = vmRealm.getRealmData(skuId:vmShoot.skuId)
        try! self.localRealm?.safeWrite {
            taskToUpdate?.completedAngles = vmShoot.arrOverLays[vmShoot.selectedAngle].frameSeqNo
        }
        
        if !DraftStorage.isFromDraft{
            self.vmShoot.selectedAngle = self.vmShoot.selectedAngle + 1
            if  self.vmShoot.selectedAngle <= vmShoot.arrOverLays.count{
                //Scroll Current Selected Angle if Skipped
                for (index,singleOverlay) in vmShoot.arrOverLays.enumerated(){
                    if !singleOverlay.clickedAngle{
                        self.vmShoot.selectedAngle = index
                        break
                    }
                }
            }else if clickedAngleCount < vmShoot.arrOverLays.count{
                for index in self.vmShoot.selectedAngle...vmShoot.arrOverLays.count{
                    if !vmShoot.arrOverLays[index].clickedAngle{
                        self.vmShoot.selectedAngle = index
                        break
                    }
                }
            }
        }else{
            if  self.vmShoot.selectedAngle <= vmShoot.arrOverLays.count-1{
                //Scroll Current Selected Angle if Skipped
                for (index,singleOverlay) in vmShoot.arrOverLays.enumerated(){
                    if !singleOverlay.clickedAngle{
                        self.vmShoot.selectedAngle = index
                        break
                    }
                }
            }else if clickedAngleCount < vmShoot.arrOverLays.count{
                
                for index in self.vmShoot.selectedAngle...vmShoot.arrOverLays.count{
                    if !vmShoot.arrOverLays[index].clickedAngle{
                        self.vmShoot.selectedAngle = index
                        break
                    }
                }
            }
        }
        
        if clickedAngleCount < self.vmShoot.noOfAngles{
            self.btnAngles.setTitle("  " + "Angles"  + " \(clickedAngleCount+1)/\(self.vmShoot.noOfAngles)  ", for: .normal)
        }
        
        if clickedAngleCount < vmShoot.arrOverLays.count{
            
            if vmShoot.selectedAngle % 3 == 0 || DraftStorage.isFromDraft{
                collectionOverlays.tag = clickedAngleCount
                self.scrolloNextCell(collectionView: collectionOverlays)
            }
            setOverlayImage()
            
        }else{
            if Storage.shared.arrInteriorPopup.count == 0 || Storage.shared.arrInteriorPopup.count == 0{
                //Get Sub Categories if not avaolable
                vmShoot.getProductSubCategories(prod_id: (Storage.shared.getProductCategories()?.prodCatId) ?? "") {
                    self.showInterialShootPopup()
                } onError: { (errMessage) in
                    PosthogEvent.shared.posthogCapture(identity: "iOS Got Subcategories Failed", properties: ["message":errMessage])
                    ShowAlert(message: errMessage, theme: .error)
                }
            }else{
                self.showInterialShootPopup()
            }
        }
    }
    
    func scrolloNextCell(collectionView:UICollectionView)  {
        
        let cellSize = CGSize(width: self.collectionOverlays.frame.width, height: self.collectionOverlays.frame.height)
        //get current content Offset of the Collection view
        let contentOffset = collectionOverlays!.contentOffset
        
        if collectionView.contentSize.height <= collectionView.contentOffset.y + cellSize.height
        {
            collectionView.performBatchUpdates(nil) { (isLoded) in
                if isLoded{
                    collectionView.scrollToItem(at:IndexPath(item: collectionView.tag, section: 0), at: [.centeredVertically,.centeredHorizontally], animated: false)
                }
            }
        } else {
            //scroll to next cell
            collectionOverlays!.scrollRectToVisible(CGRect(x: contentOffset.x , y: contentOffset.y + cellSize.height, width: cellSize.width, height: cellSize.height), animated: true)
        }
    }
    
}
