//
//  SPShootFocusImagesVC + Camera Delegate.swift
//  Spyne
//
//  Created by Vijay Parmar on 06/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
extension SPShootFocusImagesVC:AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let  image = UIImage(data: imageData)  else { return }
        let flippedCapturedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImage.Orientation.up)
       // imgOriginalImage.image = flippedCapturedImage
        imgCapturedImage.contentMode = .scaleAspectFill
        imgCapturedImage.image = flippedCapturedImage
        vmShoot.capturedImage = imgCapturedImage.image!
    
        self.displayShootSelectionPopup(image:vmShoot.capturedImage)
    }
    
    //Clicked Image Confirm Dialog
    func displayShootSelectionPopup(image:UIImage) {
   
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPShootSelectionPopup") as? SPShootSelectionPopup{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.strTitle = Storage.shared.arrFocusedPopup[vmShoot.selectedFocusAngles].displayName ?? ""
           // vc.frameAngle = vmShoot.arrOverLays[vmShoot.selectedAngle].frameAngle ?? ""
            vc.imgCapturedPic = image
            vc.imgImageWithOverlay = image
            self.imgCapturedImage.image = nil
            vc.btnDidReshootTapped = {
                PosthogEvent.shared.posthogCapture(identity: "iOS Reshoot", properties: ["project_id":self.vmShoot.projectId,"sku_id":self.vmShoot.skuId,"image_type":"Interior"])
            }
            vc.btnDidConfirmTapped = {
                PosthogEvent.shared.posthogCapture(identity: "iOS Confirmed", properties: ["project_id":self.vmShoot.projectId,"sku_id":self.vmShoot.skuId,"image_type":"Interior"])
                self.uploadImage(capturedImage: image)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK:- Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated:true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if self.is360Interior{
                if let vc = storyboard?.instantiateViewController(identifier: "SP360ImageConfirmPopupVC")as? SP360ImageConfirmPopupVC{
                    vc.selectedImage = pickedImage
                    vc.vmShoot = self.vmShoot
                    vc.btnSkipTapped = {
                        Storage.shared.vmShoot = self.vmShoot
                        let story = UIStoryboard(name: "ImageProccesing", bundle:Bundle.spyneSDK)
                        if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    vc.btnConfirmTapped = {
                        Storage.shared.vmShoot = self.vmShoot
                        let story = UIStoryboard(name: "ImageProccesing", bundle:Bundle.spyneSDK)
                        if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    vc.btnReshootTapped = {
                        self.is360Interior = true
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate  = self
                        self.present(imagePicker, animated: true, completion: nil)
                        
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                //self.uploadImage(capturedImage: pickedImage)
                self.displayShootSelectionPopup(image:pickedImage)
            }
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated:true, completion: nil)
    }
    
}
