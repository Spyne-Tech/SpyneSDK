//
//  SPImageProccesingVM.swift
//  Spyne
//
//  Created by Vijay on 19/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import KRProgressHUD
class SPImageProccesingVM  {
    
    var arrCarBackground = [CarBackgroundData]()
   
    var selectedIndex = 0
    //MARK:- Get Car Beckground
    func getCarBeckground(category:String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.getBackground(category: category) , decodeType: CarBackgroundRootClass.self, errorDecodeType: CarBackgroundRootClass.self, decoder: JSONDecoder(), success: { result in
            KRProgressHUD.dismiss()
            self.arrCarBackground = result.data ?? []
            onSuccess()
        }, error: { (_, errorResult,_ ) in
            KRProgressHUD.dismiss()
            onError(Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    
    
//    func processImage(skuId:String,background_id:String,is360:String,isBlurNumPlate: String,isTintWindow: String,windowCorrection: String , shootEnv:Int,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
//        KRProgressHUD.show()
//        Network.request(.processImages(skuId: skuId, background_id: background_id, is360: is360,isBlurNumPlate: isBlurNumPlate,isTintWindow: isTintWindow,windowCorrection: windowCorrection,shootEvn: shootEnv) , decodeType: ProcessImageRootClass.self, errorDecodeType: ProcessImageErrorRootClass.self, decoder: JSONDecoder(), success: { result in
//            KRProgressHUD.dismiss()
//                onSuccess()
//        }, error: { (_, errorResult,_ ) in
//            KRProgressHUD.dismiss()
//            onError(Alert.SomethingWrong)
//        }, failure: { error in
//            KRProgressHUD.dismiss()
//            onError(error.localizedDescription)
//        }, completion: {
//        })
//    }
    
    func processImage(skuId:String,background_id:String,is360:String,isBlurNumPlate: String,isTintWindow: String,windowCorrection: String , shootEnv:Int, numberplateID:String ,isShadow:Bool ,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.processImages(skuId: skuId, background_id: background_id, is360: is360,isBlurNumPlate: isBlurNumPlate,isTintWindow: isTintWindow,windowCorrection: windowCorrection,shootEvn: shootEnv, numberPlateLogo: "true", numberplatelogoId: numberplateID, isShadow: isShadow) , decodeType: ProcessImageRootClass.self, errorDecodeType: ProcessImageErrorRootClass.self, decoder: JSONDecoder(), success: { result in
            KRProgressHUD.dismiss()
                onSuccess()
        }, error: { (_, errorResult,_ ) in
            KRProgressHUD.dismiss()
            onError(Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    //Update Total Frames
    func updateTotalFrames(skuId:String,totalFrames:String,  onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.updateTotalFrames(skuId: skuId, totalFrames: totalFrames) , decodeType: CommonMessageRootClass.self, errorDecodeType: CommonMessageRootClass.self, decoder: JSONDecoder(), success: { result in
            KRProgressHUD.dismiss()
                onSuccess()
        }, error: { (_, errorResult,_ ) in
            KRProgressHUD.dismiss()
            onError(Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    func updateProjectIds(projectIds:[String], onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.projectStatusUpdate(projectIdList: projectIds) , decodeType: CommonMessageRootClass.self, errorDecodeType: CommonMessageRootClass.self, decoder: JSONDecoder(), success: { result in
          KRProgressHUD.dismiss()
            onSuccess()
        }, error: { (_, errorResult,_ ) in
          KRProgressHUD.dismiss()
          onError(Alert.SomethingWrong)
        }, failure: { error in
          KRProgressHUD.dismiss()
          onError(error.localizedDescription)
        }, completion: {
        })
      }
    
    

}
