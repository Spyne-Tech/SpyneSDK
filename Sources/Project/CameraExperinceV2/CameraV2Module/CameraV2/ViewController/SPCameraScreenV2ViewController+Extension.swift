//
//  SPCameraScreenV2ViewController+Extension.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 05/12/22.
//

import UIKit

extension SPCameraScreenV2ViewController {
    
    func createProjectandSku(){
        let projectdta = [
            "project_name": SpyneSDK.shared.skuId,
            "category_id": SpyneSDK.shared.categoryID,
            "foreign_sku_id": SpyneSDK.shared.skuId,
            "source" : "App_ios",
            "superuser_id" : USER.dealerShipId
        ]as [String:Any]
        let skudta = [[
            "sku_name": SpyneSDK.shared.skuId,
            "prod_cat_id": SpyneSDK.shared.categoryID,
            "prod_sub_cat_id" : SPStudioSetupModel.subCategoryID ?? "",
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
            self.skuNameLabel.text = "Project Name: "+(SpyneSDK.shared.skuId)
            self.skuNameLabel.isHidden = false
            self.vmShoot.projectId = skudetail.data.projectID
            self.vmShoot.skuId = skudetail.data.skusList[0].skuID
            // Save data in Realm
            self.realmProjectObject = RealmProjectData(authKey: CLIENT.shared.getUserSecretKey(), prodCatId: self.vmShoot.cat_id, subCatId: self.vmShoot.sub_cat_id, projectId: self.vmShoot.projectId, projectName: self.vmShoot.projectName, skuId: self.vmShoot.skuId, imageCategory: StringCons.exterior, completedAngles: 0, noOfAngles: self.vmShoot.noOfAngles, noOfInteriorAngles: Storage.shared.arrInteriorPopup.count , noOfMisAngles: Storage.shared.arrFocusedPopup.count , interiorSkiped: false, misSkiped: false, is360IntSkiped: false)
            
            try? RealmViewModel.main.realm.safeWrite {
                RealmViewModel.main.realm.add(self.realmProjectObject)
            }
            if  !DraftStorage.isEmptySku{
                
                let realmSkuObject = RealmSkuData(projectId: self.vmShoot.projectId, skuId: self.vmShoot.skuId, skuName: self.vmShoot.skuName, completedAngles: 0)
                
                try? RealmViewModel.main.realm.safeWrite {
                    RealmViewModel.main.realm.add(realmSkuObject)
                    if self.shootType == .Exterior {
                        self.setImageUploadData()
                    } else if self.shootType == .Interior {
                        self.setInteriorImageUploadData()
                    } else {
                        self.setMiscImageUploadData()
                    }
                }
                
            }else{
                let taskToUpdate =
                self.vmRealm.getRealmData(projectId: DraftStorage.draftProjectId)
                if self.shootType == .Exterior {
                    try! self.localRealm?.safeWrite {
                        taskToUpdate?.authKey = CLIENT.shared.getUserSecretKey()
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
                } else if self.shootType == .Interior {
                    try! self.localRealm?.safeWrite {
                        taskToUpdate?.authKey = CLIENT.shared.getUserSecretKey()
                        taskToUpdate?.prodCatId = self.vmShoot.cat_id
                        taskToUpdate?.subCatId = self.vmShoot.sub_cat_id
                        taskToUpdate?.projectId = self.vmShoot.projectId
                        taskToUpdate?.projectName = self.vmShoot.projectName
                        taskToUpdate?.skuId = self.vmShoot.skuId
                        taskToUpdate?.imageCategory = "Interior"
                        taskToUpdate?.completedAngles = 0
                        taskToUpdate?.noOfAngles = self.vmShoot.noOfAngles
                        taskToUpdate?.interiorSkiped = false
                        taskToUpdate?.misSkiped = false
                        taskToUpdate?.is360IntSkiped = false
                        self.setInteriorImageUploadData()
                    }
                } else {
                    try! self.localRealm?.safeWrite {
                        taskToUpdate?.authKey = CLIENT.shared.getUserSecretKey()
                        taskToUpdate?.prodCatId = self.vmShoot.cat_id
                        taskToUpdate?.subCatId = self.vmShoot.sub_cat_id
                        taskToUpdate?.projectId = self.vmShoot.projectId
                        taskToUpdate?.projectName = self.vmShoot.projectName
                        taskToUpdate?.skuId = self.vmShoot.skuId
                        taskToUpdate?.imageCategory = "Miscellaneous"
                        taskToUpdate?.completedAngles = 0
                        taskToUpdate?.noOfAngles = self.vmShoot.noOfAngles
                        taskToUpdate?.interiorSkiped = false
                        taskToUpdate?.misSkiped = false
                        taskToUpdate?.is360IntSkiped = false
                        self.setMiscImageUploadData()
                    }
                }
            }
        } onError: { message in
            ShowAlert(message: message, theme: .warning)
        }
    }
    
    func setImageUploadData() {
        self.uploadImage(capturedImage: self.vmShoot.capturedImage)
    }
    
    func setInteriorImageUploadData() {
        self.uploadInteriorImage(capturedImage: self.vmShoot.capturedImage)
    }
    
    func setMiscImageUploadData() {
        self.uploadMiscImage(capturedImage: self.vmShoot.capturedImage)
    }
    
    func uploadImage(capturedImage:UIImage){
        //get selected overlay Id
        let overlayId =  "\(vmShoot.arrOverLays[vmShoot.selectedAngle].id ?? 0)"
        let clickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        if vmShoot.arrOverLays[vmShoot.selectedAngle].frameSeqNo == 0{
            vmShoot.arrOverLays[vmShoot.selectedAngle].frameSeqNo = (clickedAngleCount ) + 1
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
        setToNextOverlay()
    }
    
    func uploadInteriorImage(capturedImage:UIImage){
        //Calclate Throughout Angles
        let clickedExtAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        let clickedIntAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle}.count
        let clickedAngleCount = clickedExtAngleCount + clickedIntAngleCount
        if Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].frameSeqNo == 0{
            Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].frameSeqNo = clickedAngleCount + 1
        }
        //get selected overlay Id
        let overlayId =  "\(Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].id ?? 0)"
        let imageObject = RealmImageData(userId: USER.userId)
        imageObject.projectId = vmShoot.projectId
        imageObject.skuId = vmShoot.skuId
        imageObject.skuName = vmShoot.skuName
        imageObject.imageCategory = StringCons.interior
        imageObject.overlay_id = overlayId
        imageObject.frame_seq_no = "\(Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].frameSeqNo)"
        imageObject.is_reshoot = false
        imageObject.is_reclick = isReclick
        imageObject.angle = 90
        SpyneSDK.upload.saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(imageObject: imageObject, image: capturedImage, selectedAngle: vmShoot.selectedInteriorAngles, serviceStartedBy: StringCons.interiorImageClick)
        Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].clickedAngle = true
        Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].clickedImage = capturedImage
        setToNextInteriorOverlay()
    }
    
    func uploadMiscImage(capturedImage:UIImage){
        //Calclate Throughout Angles
        let clickedExtAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        let clickedIntAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle}.count
        let clickedFocusAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle}.count
        let clickedAngleCount = clickedExtAngleCount + clickedIntAngleCount + clickedFocusAngleCount
        if Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].frameSeqNo == 0{
            Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].frameSeqNo = clickedAngleCount + 1
        }
        //get selected overlay Id
        let overlayId =  "\(Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].id ?? 0)"
        let imageObject = RealmImageData(userId: USER.userId)
        imageObject.projectId = vmShoot.projectId
        imageObject.skuId = vmShoot.skuId
        imageObject.skuName = vmShoot.skuName
        imageObject.imageCategory = StringCons.miscellaneous
        imageObject.overlay_id = overlayId
        imageObject.frame_seq_no = "\(Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].frameSeqNo)"
        imageObject.is_reshoot = false
        imageObject.is_reclick = isReclick
        imageObject.angle = 90
        Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].clickedImage = capturedImage
        SpyneSDK.upload.saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(imageObject: imageObject, image: capturedImage, selectedAngle: self.vmShoot.selectedFocusAngles, serviceStartedBy: StringCons.interiorImageClick)
        Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].clickedAngle = true
        self.setToNextMiscOverlay()
    }
    
    func setToNextInteriorOverlays() {
        isReclick = false
        let interiorCount = Storage.shared.arrInteriorPopup.count
        //Get clicked angle count
        let clickedAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle}.count
        //Update completed shoot count option
        interiorCountLabel.text = "\(Storage.shared.vmSPOrderNow.arrInteriorCollectionImage.count)/\(Storage.shared.arrInteriorPopup.count)"

        let taskToUpdate = self.vmRealm.getRealmData(skuId: vmShoot.skuId)
        try! self.localRealm?.safeWrite {
            taskToUpdate?.completedAngles = Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].frameSeqNo
        }
        if !DraftStorage.isFromDraft{
            self.vmShoot.selectedInteriorAngles = self.vmShoot.selectedInteriorAngles + 1
            if  self.vmShoot.selectedInteriorAngles <= interiorCount{
                //Scroll Current Selected Angle if Skipped
                for (index,singleOverlay) in Storage.shared.arrInteriorPopup.enumerated(){
                    if !singleOverlay.clickedAngle{
                        self.vmShoot.selectedInteriorAngles = index
                        break
                    }
                }
            }else if clickedAngleCount < interiorCount{
                
                for index in self.vmShoot.selectedInteriorAngles...interiorCount{
                    
                    if !Storage.shared.arrInteriorPopup[index].clickedAngle{
                        self.vmShoot.selectedInteriorAngles = index
                        break
                    }
                }
            }
        }else{
            if  self.vmShoot.selectedInteriorAngles <= interiorCount-1{
                //Scroll Current Selected Angle if Skipped
                for (index,singleOverlay) in Storage.shared.arrInteriorPopup.enumerated(){
                    if !singleOverlay.clickedAngle{
                        self.vmShoot.selectedInteriorAngles = index
                        break
                    }
                }
            }else if clickedAngleCount < interiorCount{
                
                for index in self.vmShoot.selectedInteriorAngles...interiorCount{
                    if !Storage.shared.arrInteriorPopup[index].clickedAngle{
                        self.vmShoot.selectedInteriorAngles = index
                        break
                    }
                    
                }
            }
        }
    }
    
    internal func setToNextOverlay(isFromPanGesture: Bool = false){
        isReclick = false
        self.imgCapturedImage.isHidden = false
        //Get clicked angle count
        let clickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        if clickedAngleCount > 0 {
            
        }
        checkForMendatoryIsClicked()
        exteriorCountLabel.text = "\(clickedAngleCount)/\(vmShoot.arrOverLays.count)"
        //Update completed shoot count option
        let taskToUpdate = vmRealm.getRealmData(skuId:vmShoot.skuId)
        try! self.localRealm?.safeWrite {
            taskToUpdate?.completedAngles = vmShoot.arrOverLays[vmShoot.selectedAngle].frameSeqNo
        }
        if !DraftStorage.isFromDraft{
            if !isFromPanGesture {
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
        
        if clickedAngleCount < vmShoot.arrOverLays.count && shootType == .Exterior{
            if Storage.shared.arrInteriorPopup.count == 0 || Storage.shared.arrInteriorPopup.count == 0{
                //Get Sub Categories if not avaolable
                vmShoot.getProductSubCategories(prod_id: (Storage.shared.getProductCategories()?.prodCatId) ?? "") {
                } onError: { (errMessage) in
                    PosthogEvent.shared.posthogCapture(identity: "iOS Got Subcategories Failed", properties: ["message":errMessage])
                    ShowAlert(message: errMessage, theme: .error)
                }
            }
        }
        self.vmShoot.selectedIndex = (self.vmShoot.selectedAngle ) + 1
        let intriorClickedAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle}.count
        let miscClickedAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle}.count
        if clickedAngleCount < vmShoot.arrOverLays.count {
            self.overlayNameLabel.text = LocalOverlays.ExteriorOverlayData?[vmShoot.selectedAngle].displayName ?? ""
            self.imgCapturedImage.sd_setImage(with: URL(string: LocalOverlays.ExteriorOverlayData?[vmShoot.selectedAngle].displayThumbnail ?? ""))
            self.overlaySideImage.sd_setImage(with: URL(string: LocalOverlays.ExteriorOverlayData?[vmShoot.selectedAngle].displayThumbnail ?? ""))
            self.mendatoryLabel.text = LocalOverlays.ExteriorOverlayData?[vmShoot.selectedAngle].mendatory ?? false ? "Mandatory" : "Non-Mandatory"
        } else if intriorClickedAngleCount >= Storage.shared.arrInteriorPopup.count {
            if miscClickedAngleCount >= Storage.shared.arrFocusedPopup.count {
                Storage.shared.vmShoot = self.vmShoot
                let storyBoard = UIStoryboard(name: "CompleteProject", bundle: Bundle.spyneSDK)
                let vc = storyBoard.instantiateViewController(withIdentifier: "SPCompletingProjectViewController") as! SPCompletingProjectViewController
                self.navigationController?.pushViewController(vc, animated: true  )
            } else {
                vmShoot.selectedAngle = 0
                setToMiscShootType()
            }
        }
        else {
            vmShoot.selectedAngle = 0
            setToInteriorShootType()
        }
    }
    
    internal func setToNextInteriorOverlay(isFromPanGesture: Bool = false){
        isReclick = false
        let interiorCount = Storage.shared.arrInteriorPopup.count
        
        //Get clicked angle count
        let clickedAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle}.count
        interiorCountLabel.text = "\(clickedAngleCount)/\(Storage.shared.arrInteriorPopup.count)"
        //Update completed shoot count option
        let taskToUpdate = self.vmRealm.getRealmData(skuId: vmShoot.skuId)
        try! self.localRealm?.safeWrite {
            taskToUpdate?.completedAngles = Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].frameSeqNo
        }
        checkForMendatoryIsClicked()
        if !DraftStorage.isFromDraft{
            if !isFromPanGesture {
                self.vmShoot.selectedInteriorAngles = self.vmShoot.selectedInteriorAngles + 1
                if  self.vmShoot.selectedInteriorAngles <= interiorCount{
                    //Scroll Current Selected Angle if Skipped
                    for (index,singleOverlay) in Storage.shared.arrInteriorPopup.enumerated(){
                        if !singleOverlay.clickedAngle{
                            self.vmShoot.selectedInteriorAngles = index
                            break
                        }
                    }
                }else if clickedAngleCount < interiorCount{
                    
                    for index in self.vmShoot.selectedInteriorAngles...interiorCount{
                        
                        if !Storage.shared.arrInteriorPopup[index].clickedAngle{
                            self.vmShoot.selectedInteriorAngles = index
                            break
                        }
                    }
                }
            }
        }else{
            if  self.vmShoot.selectedInteriorAngles <= interiorCount-1{
                //Scroll Current Selected Angle if Skipped
                for (index,singleOverlay) in Storage.shared.arrInteriorPopup.enumerated(){
                    if !singleOverlay.clickedAngle{
                        self.vmShoot.selectedInteriorAngles = index
                        break
                    }
                }
            }else if clickedAngleCount < interiorCount{
                
                for index in self.vmShoot.selectedInteriorAngles...interiorCount{
                    if !Storage.shared.arrInteriorPopup[index].clickedAngle{
                        self.vmShoot.selectedInteriorAngles = index
                        break
                    }
                    
                }
            }
        }
        let exteriorClickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        let miscClickedAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle}.count
        if clickedAngleCount < Storage.shared.arrInteriorPopup.count && shootType == .Interior {
            self.imgCapturedImage.image = nil
            self.overlayNameLabel.text = Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].displayName ?? ""
            self.overlaySideImage.sd_setImage(with: URL(string: Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].displayThumbnail ?? ""))
            self.mendatoryLabel.text = Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].mendatoy ?? false ? "Mandatory" : "Non-Mandatory"
        }
        else {
            interiorImage.setImage(UIImage(systemName: "checkmark.circle")!)
            interiorLeading.image = nil
            interiorLeading.backgroundColor = UIColor(hexAlpha: "00C488")
            if miscClickedAngleCount >= Storage.shared.arrFocusedPopup.count {
                if exteriorClickedAngleCount >= vmShoot.arrOverLays.count {
                    Storage.shared.vmShoot = self.vmShoot
                    let storyBoard = UIStoryboard(name: "CompleteProject", bundle: Bundle.spyneSDK)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "SPCompletingProjectViewController") as! SPCompletingProjectViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    vmShoot.selectedInteriorAngles = 0
                    setToExteriorShootType()
                }
            } else {
                vmShoot.selectedInteriorAngles = 0
                setToMiscShootType()
            }
        }
    }
    
    internal func setToNextMiscOverlay(isFromPanGesture: Bool = false){
        
        isReclick = false
        
        let focusedCount = Storage.shared.arrFocusedPopup.count
        //Get clicked angle count
        let clickedAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle}.count
        miscCountLabel.text = "\(clickedAngleCount)/\(Storage.shared.arrFocusedPopup.count)"

        //Update completed shoot count option
        let taskToUpdate = getRealmData()
        try! self.localRealm?.safeWrite {
            taskToUpdate?.completedAngles = Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].frameSeqNo
        }
        checkForMendatoryIsClicked()
        if !DraftStorage.isFromDraft{
            if !isFromPanGesture {
                self.vmShoot.selectedFocusAngles = self.vmShoot.selectedFocusAngles + 1
                if  self.vmShoot.selectedFocusAngles <= focusedCount{
                    //Scroll Current Selected Angle if Skipped
                    for (index,singleOverlay) in Storage.shared.arrFocusedPopup.enumerated(){
                        if !singleOverlay.clickedAngle{
                            self.vmShoot.selectedFocusAngles = index
                            break
                        }
                    }
                }else if clickedAngleCount < focusedCount{
                    
                    for index in self.vmShoot.selectedFocusAngles...focusedCount{
                        if !Storage.shared.arrFocusedPopup[index].clickedAngle{
                            self.vmShoot.selectedFocusAngles = index
                            break
                        }
                    }
                }
            }
        }else{
            if  self.vmShoot.selectedFocusAngles <= focusedCount-1{
                //Scroll Current Selected Angle if Skipped
                for (index,singleOverlay) in Storage.shared.arrFocusedPopup.enumerated(){
                    if !singleOverlay.clickedAngle{
                        self.vmShoot.selectedFocusAngles = index
                        break
                    }
                }
            }else if clickedAngleCount < focusedCount{
                
                for index in self.vmShoot.selectedFocusAngles...focusedCount{
                    if !Storage.shared.arrFocusedPopup[index].clickedAngle{
                        self.vmShoot.selectedFocusAngles = index
                        break
                    }
                    
                }
            }
        }
        let exteriorClickedAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        let interiorClickedAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle}.count
        if clickedAngleCount < Storage.shared.arrFocusedPopup.count && shootType == .Misc {
            self.imgCapturedImage.image = nil
            self.overlayNameLabel.text = Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].displayName ?? ""
            self.overlaySideImage.sd_setImage(with: URL(string: Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].displayThumbnail ?? ""))
            self.mendatoryLabel.text = Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].mendatoy ?? false ? "Mandatory" : "Non-Mandatory"
        } else if exteriorClickedAngleCount < vmShoot.arrOverLays.count {
            vmShoot.selectedFocusAngles = 0
            setToExteriorShootType()
            miscImage.setImage(UIImage(systemName: "checkmark.circle")!)
        } else if interiorClickedAngleCount < Storage.shared.arrInteriorPopup.count {
            vmShoot.selectedFocusAngles = 0
            setToInteriorShootType()
            miscImage.setImage(UIImage(systemName: "checkmark.circle")!)
        } else {
            miscImage.setImage(UIImage(systemName: "checkmark.circle")!)
            Storage.shared.vmShoot = self.vmShoot
            let storyBoard = UIStoryboard(name: "CompleteProject", bundle: Bundle.spyneSDK)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SPCompletingProjectViewController") as! SPCompletingProjectViewController
            self.navigationController?.pushViewController(vc, animated: true  )
        }
    }
    
    func checkForMendatoryIsClicked() {
        let clickedMendatoryExteriorAngleCount = vmShoot.arrOverLays.filter{$0.clickedAngle}.count
        let totalMendatoryExteriorAngleCount = vmShoot.arrOverLays.count
        let clickedMendatoryInteriorAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle && ($0.mendatoy ?? false)}.count
        let totalMendatoryInteriorAngleCount = Storage.shared.arrInteriorPopup.filter{$0.mendatoy ?? false}.count
        let clickedMendatoryMiscAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle && ($0.mendatoy ?? false)}.count
        let totalMendatoryMiscAngleCount = Storage.shared.arrFocusedPopup.filter{$0.mendatoy ?? false}.count
        if clickedMendatoryInteriorAngleCount == totalMendatoryInteriorAngleCount && totalMendatoryInteriorAngleCount > 0 {
            interiorImage.setImage(UIImage(systemName: "checkmark.circle")!)
            interiorImage.tintColor = UIColor(hexAlpha: "00C488")
            interiorLeading.image = nil
            interiorLeading.backgroundColor = UIColor(hexAlpha: "00C488")
        }
        if clickedMendatoryMiscAngleCount == totalMendatoryMiscAngleCount && totalMendatoryMiscAngleCount > 0 {
            miscImage.setImage(UIImage(systemName: "checkmark.circle")!)
            miscImage.tintColor = UIColor(hexAlpha: "00C488")
        }
        if clickedMendatoryExteriorAngleCount == totalMendatoryExteriorAngleCount && clickedMendatoryInteriorAngleCount == totalMendatoryInteriorAngleCount && clickedMendatoryMiscAngleCount == totalMendatoryMiscAngleCount {
            backButton.setImage(UIImage(named: "CamExTick",in: Bundle.spyneSDK, with: nil), for: .normal)
        }
    }
    
    func moveToExterior() {
        self.shootType = .Exterior
        self.overlaySideImage.sd_setImage(with: URL(string: vmShoot.arrOverLays[vmShoot.selectedAngle].displayThumbnail ?? ""))
        self.mendatoryLabel.text = vmShoot.arrOverLays[vmShoot.selectedAngle].mendatory ?? false ? "Mandatory" : "Non-Mandatory"
        self.overlayNameLabel.text = vmShoot.arrOverLays[vmShoot.selectedAngle].displayName ?? ""
        self.imgCapturedImage.sd_setImage(with: URL(string: vmShoot.arrOverLays[vmShoot.selectedAngle].displayThumbnail ?? ""))
    }
    
    func moveToInterior() {
        self.shootType = .Interior
        self.imgCapturedImage.image = nil
        self.overlayNameLabel.text = Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].displayName ?? ""
        self.overlaySideImage.sd_setImage(with: URL(string: Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].displayThumbnail ?? ""))
        self.mendatoryLabel.text = Storage.shared.arrInteriorPopup[vmShoot.selectedInteriorAngles].mendatoy ?? false ? "Mandatory" : "Non-Mandatory"
        shootStatus.onExterior = false
        shootStatus.onMisc = false
        shootStatus.onInterior = true
        configureShootStatusView()
    }
    
    func moveToMisc() {
        self.shootType = .Misc
        self.imgCapturedImage.image = nil
        self.overlayNameLabel.text = Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].displayName ?? ""
        self.overlaySideImage.sd_setImage(with: URL(string: Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].displayThumbnail ?? ""))
        self.mendatoryLabel.text = Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].mendatoy ?? false ? "Mandatory" : "Non-Mandatory"
        shootStatus.onExterior = false
        shootStatus.onMisc = false
        shootStatus.onInterior = true
        configureShootStatusView()
    }
}

extension SPCameraScreenV2ViewController {
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

extension SPCameraScreenV2ViewController: SPDrawerDismissDelegate {
    func dismissDrawer() {
        for item in mainView.subviews {
            if item.tag == 10010 {
                item.fadeOut() {_ in
                    item.removeFromSuperview()
                    self.cameraForegroundView.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    
}
