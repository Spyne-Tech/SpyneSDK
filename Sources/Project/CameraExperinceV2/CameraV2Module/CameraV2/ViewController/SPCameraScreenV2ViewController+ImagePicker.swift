//
//  SPCameraScreenV2ViewController+ImagePicker.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 01/12/22.
//

import UIKit
import AVFoundation

extension SPCameraScreenV2ViewController:AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //MARK:- Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated:true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let flippedCapturedImage = UIImage(cgImage: pickedImage.cgImage!, scale: pickedImage.scale, orientation: UIImage.Orientation.up)
            if self.is360Interior{
                if let vc = storyboard?.instantiateViewController(identifier: "SP360ImageConfirmPopupVC")as? SP360ImageConfirmPopupVC{
                    vc.selectedImage = pickedImage
                    vc.vmShoot = self.vmShoot
                    vc.btnSkipTapped = {
                        let story = UIStoryboard(name: "ImageProccesing", bundle:nil)
                        if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    vc.btnConfirmTapped = {
                        let story = UIStoryboard(name: "ImageProccesing", bundle:nil)
                        if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
                            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
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
                imgCapturedImage.contentMode = .scaleAspectFill
                imgCapturedImage.image = flippedCapturedImage
                vmShoot.capturedImage = imgCapturedImage.image!
                displayShootSelectionPopup(image: imgCapturedImage.image!)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated:true, completion: nil)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let  image = UIImage(data: imageData)  else { return }
        guard Reachability.isConnectedToNetwork() else {return}
        
        let flippedCapturedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImage.Orientation.up)
        vmShoot.capturedImage = flippedCapturedImage
        PosthogEvent.shared.posthogCapture(identity: "iOS Image Captured", properties: ["project_id":vmShoot.projectId,"sku_id":vmShoot.skuId,"image_type":"Exterior"])
        if shootType == .Exterior {
            displayShootSelectionPopup(image: flippedCapturedImage)
        } else if shootType == .Interior || shootType == .Misc {
            forInteriorDisplayShootSelectionWithoutangleClasifierPopup(image: flippedCapturedImage)
        }
    }
    
    func forInteriorDisplayShootSelectionWithoutangleClasifierPopup(image: UIImage) {
            let storyboard = UIStoryboard(name: "Camera", bundle: Bundle.spyneSDK)
            if let vc = storyboard.instantiateViewController(withIdentifier: "SPShootSelectionPopup") as? SPShootSelectionPopup{
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.tabBarController?.tabBar.isHidden = true
                vc.imgCapturedPic = image
                vc.imgImageWithOverlay = image
                self.imgCapturedImage.image = nil
                vc.btnDidReshootTapped = {
                    PosthogEvent.shared.posthogCapture(identity: "iOS Reshoot", properties: ["project_id":self.vmShoot.projectId,"sku_id":self.vmShoot.skuId,"image_type":"Interior"])
                }
                vc.btnDidConfirmTapped = {
                    PosthogEvent.shared.posthogCapture(identity: "iOS Confirmed", properties: ["project_id":self.vmShoot.projectId,"sku_id":self.vmShoot.skuId,"image_type":"Interior"])
                    if self.isFirstCLick == false{
                        self.isFirstCLick = true
                        self.createProjectandSku()
                    }else{
                        if self.shootType == .Interior {
                            vc.strTitle = Storage.shared.arrInteriorPopup[self.vmShoot.selectedInteriorAngles].displayName ?? ""
                            self.uploadInteriorImage(capturedImage: image)
                        } else if self.shootType == .Misc {
                            vc.strTitle = Storage.shared.arrFocusedPopup[self.vmShoot.selectedFocusAngles].displayName ?? ""
                            self.uploadMiscImage(capturedImage: image)
                        }
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    
    func displayShootSelectionWithoutangleClasifierPopup(image:UIImage)  {
      // Create Image from view
      imgCapturedImage.image = self.cameraForegroundView.takeSnapshotOfView()
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPShootSelectionWithoutAngleClassifier") as? SPShootSelectionWithoutAngleClassifier{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.strTitle = vmShoot.arrOverLays[vmShoot.selectedAngle].displayName ?? ""
            vc.frameAngle = vmShoot.arrOverLays[vmShoot.selectedAngle].frameAngle ?? ""
            vc.imgCapturedPic = image
            vc.isFromExterior = true
            if let imageFromView = self.cameraForegroundView.takeSnapshotOfView(){
                vc.imgImageWithOverlay = imageFromView
            }
            imgCapturedImage.image = nil
            vc.btnDidReshootTapped = {
                PosthogEvent.shared.posthogCapture(identity: "iOS Reshoot", properties: ["project_id":self.vmShoot.projectId,"sku_id":self.vmShoot.skuId,"image_type":"Exterior"])
            }
            vc.btnDidConfirmTapped = {
                PosthogEvent.shared.posthogCapture(identity: "iOS Confirmed", properties: ["project_id":self.vmShoot.projectId,"sku_id":self.vmShoot.skuId,"image_type":"Exterior"])
                if self.isFirstCLick == false{
                    self.isFirstCLick = true
                    self.createProjectandSku()
                }else{
                    self.uploadImage(capturedImage:self.vmShoot.capturedImage)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func displayShootSelectionPopup(image:UIImage) {
      // Create Image from view
        self.imgCapturedImage.isHidden = true
        let storyBoard = UIStoryboard(name: "AngleClasifier", bundle: Bundle.spyneSDK)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AngleClassifierPopupV3") as? AngleClassifierPopupV3 {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            vc.strTitle = vmShoot.arrOverLays[vmShoot.selectedAngle].displayName ?? ""
            vc.frameAngle = vmShoot.arrOverLays[vmShoot.selectedAngle].frameAngle ?? ""
            vc.imgCapturedPic = image
            vc.isFromExterior = true
            vc.btnDidReshootTapped = {
                self.imgCapturedImage.isHidden = false
                PosthogEvent.shared.posthogCapture(identity: "iOS Reshoot", properties: ["project_id":self.vmShoot.projectId,"sku_id":self.vmShoot.skuId,"image_type":"Exterior"])
            }
            vc.btnDidConfirmTapped = {
                PosthogEvent.shared.posthogCapture(identity: "iOS Confirmed", properties: ["project_id":self.vmShoot.projectId,"sku_id":self.vmShoot.skuId,"image_type":"Exterior"])
                if self.isFirstCLick == false{
                    self.isFirstCLick = true
                    self.createProjectandSku()
                }else{
                    self.uploadImage(capturedImage:self.vmShoot.capturedImage)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
}
