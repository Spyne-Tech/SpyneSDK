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
extension SPReshootCameraVC{

    func uploadImage(capturedImage:UIImage){
        
        vmShoot.projectId = Storage.shared.vmSPOrderNow.arrImages[vmShoot.selectedAngle].projectID ?? ""
        vmShoot.skuId = Storage.shared.vmSPOrderNow.arrImages[vmShoot.selectedAngle].skuID ?? ""
        vmShoot.skuName = Storage.shared.strReshhotSkuName
        let imageCategory = Storage.shared.vmSPOrderNow.arrImages[vmShoot.selectedAngle].imageCategory ?? ""
        
        
        let taskToUpdate = getRealmData()
        try! self.localRealm?.safeWrite {
            taskToUpdate?.completedAngles = self.vmShoot.selectedAngle
        }
        
        //get selected overlay Id
        let overlayId =  "\(Storage.shared.vmSPOrderNow.arrOverlayByIds[vmShoot.selectedAngle].id ?? 0)"
        let clickedAngleCount = Storage.shared.vmSPOrderNow.arrOverlayByIds.filter{$0.clickedAngle}.count
        
        if Storage.shared.vmSPOrderNow.arrOverlayByIds[vmShoot.selectedAngle].frameSeqNo == 0{
            Storage.shared.vmSPOrderNow.arrOverlayByIds[vmShoot.selectedAngle].frameSeqNo = clickedAngleCount + 1
        }
        
        let imageObject = RealmImageData(userId: USER.userId)
        
        imageObject.projectId = vmShoot.projectId
        imageObject.skuId = vmShoot.skuId
        imageObject.skuName = vmShoot.skuName
        imageObject.imageCategory = imageCategory
        imageObject.overlay_id = overlayId
        imageObject.frame_seq_no = "\(Storage.shared.vmSPOrderNow.arrOverlayByIds[vmShoot.selectedAngle].orderNumber)"
        imageObject.is_reshoot = true
        imageObject.is_reclick = false
        imageObject.angle = 90
        let seqNo = Storage.shared.vmSPOrderNow.arrOverlayByIds[vmShoot.selectedAngle].frameSeqNo ?? 0 //Int(imageObject.frame_seq_no) ?? 0
        
        SpyneSDK.upload.saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(imageObject: imageObject, image: capturedImage, selectedAngle: seqNo - 1, serviceStartedBy: StringCons.reshootExterior)
     
        Storage.shared.vmSPOrderNow.arrOverlayByIds[vmShoot.selectedAngle].clickedAngle = true
        Storage.shared.vmSPOrderNow.arrOverlayByIds[vmShoot.selectedAngle].clickedImage = capturedImage
        setToNextOverlay()
        
    }
    
    internal func setToNextOverlay(){
        
        isReclick = false
        
        //Get clicked angle count
        let clickedAngleCount = Storage.shared.vmSPOrderNow.arrOverlayByIds.filter{$0.clickedAngle}.count
        
        self.vmShoot.selectedAngle = self.vmShoot.selectedAngle + 1
        
        if  self.vmShoot.selectedAngle == Storage.shared.vmSPOrderNow.arrOverlayByIds.count{
            //Scroll Current Selected Angle if Skipped
            for (index,singleOverlay) in Storage.shared.vmSPOrderNow.arrOverlayByIds.enumerated(){
                if !singleOverlay.clickedAngle{
                    self.vmShoot.selectedAngle = index
                    break
                }
            }
        }else if clickedAngleCount < Storage.shared.vmSPOrderNow.arrOverlayByIds.count{
            
            for index in self.vmShoot.selectedAngle...Storage.shared.vmSPOrderNow.arrOverlayByIds.count{
                if !Storage.shared.vmSPOrderNow.arrOverlayByIds[index].clickedAngle{
                    self.vmShoot.selectedAngle = index
                    break
                }
                
            }
        }
        
      
        
        if clickedAngleCount < Storage.shared.vmSPOrderNow.arrOverlayByIds.count{
            self.btnAngles.setTitle("  " + "Angles"  + " \(clickedAngleCount+1)/\(self.vmShoot.noOfAngles)  ", for: .normal)
            if Storage.shared.vmSPOrderNow.arrImages[self.vmShoot.selectedAngle].imageCategory == "Exterior"{
                self.viewGyrometer.isHidden = false
                
            }else{
                self.viewGyrometer.isHidden = true
                self.btnCapture.isUserInteractionEnabled = true
                self.btnGallery.isUserInteractionEnabled = true
                self.btnCapture.tintColor = UIColor.white
             
            }
            
            if vmShoot.selectedAngle % 3 == 0 || DraftStorage.isFromDraft{
                scrolloNextCell(collectionView: collectionOverlays)
            }
            setOverlayImage()
            collectionOverlays.reloadData()
        }else{
            
            SPImageProcessingNavigationVC.isReshoot = true
            let story = UIStoryboard(name: "ImageProccesing", bundle: Bundle.spyneSDK)
            if let vc = story.instantiateViewController(withIdentifier: "SPDownloadCompletedVC")as? SPDownloadCompletedVC{
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func scrolloNextCell(collectionView:UICollectionView)  {
        let cellSize = CGSize(width: self.collectionOverlays.frame.width, height: self.collectionOverlays.frame.height)
        //get current content Offset of the Collection view
        let contentOffset = collectionOverlays!.contentOffset
        
        //scroll to next cell
        collectionOverlays!.scrollRectToVisible(CGRect(x: contentOffset.x , y: contentOffset.y + cellSize.height, width: cellSize.width, height: cellSize.height), animated: true)
        
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
    
    func getRealmData(fromProjectId:String)->RealmProjectData?{
        
        let predicate = NSPredicate(format: "projectId == '\(fromProjectId)'", "")
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
