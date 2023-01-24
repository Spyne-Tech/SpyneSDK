//
//  SPShootFocusImagesVC+Extensions.swift
//  Spyne
//
//  Created by Vijay Parmar on 14/12/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit
extension  SPShootFocusImagesVC {
    
    func uploadImage(capturedImage:UIImage){
        
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
        collectionFocusImages.reloadData()
        self.setToNextOverlay()
        //self.setAngles()
        
    }

    internal func setToNextOverlay(){
        
        isReclick = false
        
        let focusedCount = Storage.shared.arrFocusedPopup.count
        //Get clicked angle count
        let clickedAngleCount = Storage.shared.arrFocusedPopup.filter{$0.clickedAngle}.count
        
        //Update completed shoot count option
        let taskToUpdate = getRealmData()
        try! self.localRealm?.safeWrite {
            taskToUpdate?.completedAngles = Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].frameSeqNo
        }
        
        if !DraftStorage.isFromDraft{
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
    
        if clickedAngleCount < Storage.shared.arrFocusedPopup.count{
            self.btnAngles.setTitle("  " + "Angles"  + " \(clickedAngleCount+1)/\(focusedCount)  ", for: .normal)
        }
    
        if clickedAngleCount < focusedCount{
            if vmShoot.selectedAngle % 3 == 0 || DraftStorage.isFromDraft{
                collectionFocusImages.tag = clickedAngleCount
                scrolloNextCell(collectionView: collectionFocusImages)
            }
        }else{
            Storage.shared.vmShoot = self.vmShoot
            let story = UIStoryboard(name: "ImageProccesing", bundle:Bundle.spyneSDK)
            if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    func scrolloNextCell(collectionView:UICollectionView)  {
        //get cell size
        let cellSize =  CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset
        
        collectionView.performBatchUpdates(nil) { (isLoded) in
            if isLoded{
                collectionView.scrollToItem(at:IndexPath(item: self.collectionFocusImages.tag, section: 0), at: [.centeredVertically,.centeredHorizontally], animated: false)
            }
        }
        
        
        
//        if collectionView.contentSize.height <= collectionView.contentOffset.y + cellSize.height
//        {
//            collectionView.performBatchUpdates(nil) { (isLoded) in
//                if isLoded{
//                    collectionView.scrollToItem(at:IndexPath(item: self.collectionFocusImages.tag, section: 0), at: [.centeredVertically,.centeredHorizontally], animated: false)
//                }
//            }
//        } else {
//            
//            collectionFocusImages!.scrollRectToVisible(CGRect(x: contentOffset.x , y: contentOffset.y + cellSize.height, width: cellSize.width, height: cellSize.height), animated: true)
//            
//        }
    }
}
