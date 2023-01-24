//
//  SPInteriorShoot+Extensions.swift
//  Spyne
//
//  Created by Vijay Parmar on 13/12/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit
extension SPinteriorshootCameraVC{
    
    
    func uploadImage(capturedImage:UIImage){
        
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
        
        collectionProductCategories.reloadData()
        
        setToNextOverlay()

    }
    
    
    internal func setToNextOverlay(){
        isReclick = false
        let interiorCount = Storage.shared.arrInteriorPopup.count
        
        //Get clicked angle count
        let clickedAngleCount = Storage.shared.arrInteriorPopup.filter{$0.clickedAngle}.count
      
        //Update completed shoot count option
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
    
        
        if clickedAngleCount < Storage.shared.arrInteriorPopup.count{
            self.btnAngles.setTitle("  " + "Angles"  + "\(clickedAngleCount+1)/\(interiorCount)  ", for: .normal)
        }
        
        
        if clickedAngleCount < interiorCount{
            
            if vmShoot.selectedAngle % 3 == 0 || DraftStorage.isFromDraft{
                collectionProductCategories.tag = clickedAngleCount
                scrolloNextCell(collectionView: collectionProductCategories)
            
            }
           
        }else{
            if Storage.shared.arrFocusedPopup.count == 0 || Storage.shared.arrFocusedPopup.count == 0{
                //Get Sub Categories if not avaolable
                    vmShoot.getProductSubCategories(prod_id: (Storage.shared.getProductCategories()?.prodCatId) ?? "") {
                        self.showFocusShootPopup()
                    } onError: { (errMessage) in
                        PosthogEvent.shared.posthogCapture(identity: "iOS Got Subcategories Failed", properties: ["message":errMessage])
                        ShowAlert(message: errMessage, theme: .error)
                    }
            }else{
                self.showFocusShootPopup()
            }
        }
    }
    
    func scrolloNextCell(collectionView:UICollectionView)  {
        let cellSize = CGSize(width: collectionProductCategories.frame.width, height: collectionProductCategories.frame.height)
        
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset

        collectionProductCategories.performBatchUpdates(nil) { (isLoded) in
            
            if isLoded{
                self.collectionProductCategories.scrollToItem(at:IndexPath(item: self.collectionProductCategories.tag, section: 0), at: [.centeredVertically,.centeredHorizontally], animated: false)
            }
        }
    
//          if collectionProductCategories.contentSize.height <= collectionProductCategories.contentOffset.y + cellSize.height
//          {
//              collectionProductCategories.performBatchUpdates(nil) { (isLoded) in
//
//                  if isLoded{
//                      self.collectionProductCategories.scrollToItem(at:IndexPath(item: self.collectionProductCategories.tag, section: 0), at: [.centeredVertically,.centeredHorizontally], animated: false)
//                  }
//              }
//
//          } else {
//
//              collectionProductCategories!.scrollRectToVisible(CGRect(x: contentOffset.x , y: contentOffset.y + cellSize.height, width: cellSize.width, height: cellSize.height), animated: true)
//
//          }
     }
}
