//
//  SPOrderNowVM.swift
//  Spyne
//
//  Created by Vijay on 20/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import KRProgressHUD
class SPOrderNowVM  {
    var arrExteriorCollectionImage = [ProcessedImageData]()
    var arrInteriorCollectionImage = [ProcessedImageData]()
    var arrMiscellaneousImage = [ProcessedImageData]()
    var arrImages = [ProcessedImageData]()
    var arrOverlayByIds = [OverlayByIdData]()
    var isPaid = false
    
    //MARK:- Get Bulk Images
    func getProcessedImages(skuId:String,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.getCompletedImages(sku_id: skuId), decodeType: ProcessedImageRootClass.self, errorDecodeType: ProcessedImageRootClass.self, decoder: JSONDecoder(), success: { result in
            
            KRProgressHUD.dismiss()
        
            if result.staus == 200{
                self.arrImages = result.data ?? []
                self.arrExteriorCollectionImage = []
                self.arrInteriorCollectionImage = []
                self.arrMiscellaneousImage = []
                self.isPaid = (result.paid == "false") ? false : true
                for image in self.arrImages{
                    if image.imageCategory == "Exterior"{
                        self.arrExteriorCollectionImage.append(image)
                        self.arrExteriorCollectionImage.append(image)
                    }else if image.imageCategory == "Interior"{
                        self.arrInteriorCollectionImage.append(image)
                        self.arrInteriorCollectionImage.append(image)
                    }else {
                        self.arrMiscellaneousImage.append(image)
                        self.arrMiscellaneousImage.append(image)
                    }
                    
                }
                onSuccess()
            }else{
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            KRProgressHUD.dismiss()
            onError(errorResult?.message ?? Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    //MARK:- Get Bulk Images
    func getYourProcessedImages(skuId:String,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.getCompletedImages(sku_id: skuId), decodeType: ProcessedImageRootClass.self, errorDecodeType: ProcessedImageRootClass.self, decoder: JSONDecoder(), success: { result in
            if result.staus == 200{
                self.arrImages = result.data ?? []
                self.arrExteriorCollectionImage = []
                self.arrInteriorCollectionImage = []
                self.arrMiscellaneousImage = []
                self.isPaid = (result.paid == "false") ? false : true
                for image in self.arrImages{
                    if image.imageCategory == "Exterior"{
                        self.arrExteriorCollectionImage.append(image)
                      
                    }else if image.imageCategory == "Interior"{
                        self.arrInteriorCollectionImage.append(image)
                       
                    }else {
                        self.arrMiscellaneousImage.append(image)
                       
                    }
                    
                }
                KRProgressHUD.dismiss()
                onSuccess()
            }else{
                KRProgressHUD.dismiss()
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            KRProgressHUD.dismiss()
            onError(errorResult?.message ?? Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    
    //MARK:- Update Download Status
    func updateDownloadStatus(skuId:String,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.updateDownloadStatus(skuId: skuId), decodeType: CommonMessageRootClass.self, errorDecodeType: CommonMessageRootClass.self, decoder: JSONDecoder(), success: { result in
           KRProgressHUD.dismiss()
            if result.status == 200{
               
                onSuccess()
            }else{
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            KRProgressHUD.dismiss()
            onError(errorResult?.message ?? Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    
    //MARK:- Get Overlays by Ids
    func getOverlaybyId(overlayIds:[Int],onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.getOverlaybyId(overlay_ids: overlayIds), decodeType: OverlayByIdRootClass.self, errorDecodeType: OverlayByIdRootClass.self, decoder: JSONDecoder(), success: { result in
           KRProgressHUD.dismiss()
            if result.status == 200{
                self.arrOverlayByIds = (result.data ?? []).reversed()
                onSuccess()
            }else{
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            KRProgressHUD.dismiss()
            onError(errorResult?.message ?? Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
}
