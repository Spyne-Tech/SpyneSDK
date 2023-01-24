//
//  SP360ImageConfirmPopupVC.swift
//  Spyne
//
//  Created by Vijay Parmar on 23/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SP360ImageConfirmPopupVC: UIViewController {
    
    @IBOutlet weak var imgSelectedPic: UIImageView!
    
    var btnReshootTapped : (()->Void)?
    var btnConfirmTapped : (()->Void)?
    var btnSkipTapped : (()->Void)?
    var selectedImage = UIImage()
    var vmShoot = SPShootViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgSelectedPic.image = selectedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    @IBAction func btnActionSkip(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let didTapped = self.btnSkipTapped{
                didTapped()
            }
        }
    }
    
    @IBAction func btnActionReselect(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let didTapped = self.btnReshootTapped{
                didTapped()
            }
        }
    }
    
    @IBAction func btnActionConfirm(_ sender: UIButton) {
        upload()
    }
    
    
    func upload(){

        #warning("Need to add overlay id and frame sequence number")
        
        let imageObject = RealmImageData(userId: USER.userId)
        
        imageObject.projectId = vmShoot.projectId
        imageObject.skuId = vmShoot.skuId
        imageObject.skuName = vmShoot.skuName
        imageObject.imageCategory = "360int"
        imageObject.overlay_id = ""//overlayId
        imageObject.frame_seq_no = "\(Storage.shared.vmSPOrderNow.arrOverlayByIds[vmShoot.selectedAngle].frameSeqNo)"
        imageObject.is_reshoot = true
        imageObject.is_reclick = true
        imageObject.angle = 90
        
        SpyneSDK.upload.saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(imageObject: imageObject, image: selectedImage, selectedAngle: 1, serviceStartedBy: StringCons.imageClick360)
    
       // AppDelegate.upload.saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(project_id: vmShoot.projectId, sku_id: vmShoot.skuId, skuName: vmShoot.skuName, image_category: "360int", image: selectedImage, selectedAngle: 1, overlay_id: "", frame_seq_no: "", is_reshoot: false, is_reclick: false, angle: 90, serviceStartedBy: StringCons.imageClick360 )

        self.dismiss(animated: true) {
            if let didTapped = self.btnConfirmTapped{
                didTapped()
            }
        }
        
//        vmShoot.uploadImageWithProgress(project_id: vmShoot.projectId, sku_id: vmShoot.skuId, image_category: "360int", image: selectedImage, selectedAngle: 1, skuName: vmShoot.skuName) {
//            print("Image Uploaded")
//            self.dismiss(animated: true) {
//                if let didTapped = self.btnConfirmTapped{
//                    didTapped()
//                }
//            }
//        } onError: { (message) in
//            print(message)
//        }

    }
    
    
}
