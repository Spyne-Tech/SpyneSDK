//
//  CompleteProjectViewModel.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 12/12/22.
//

import Foundation
import KRProgressHUD

class CompleteProjectViewModel {
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
    
    func processImage(skuId:String,background_id:String,is360:String,isBlurNumPlate: String,isTintWindow: String,windowCorrection: String , shootEnv:Int, numberplateID:String ,isShadow:Bool ,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.processImages(skuId: skuId, background_id: background_id, is360: is360,isBlurNumPlate: isBlurNumPlate,isTintWindow: isTintWindow,windowCorrection: windowCorrection,shootEvn: shootEnv, numberPlateLogo: isBlurNumPlate, numberplatelogoId: numberplateID, isShadow: isShadow) , decodeType: ProcessImageRootClass.self, errorDecodeType: ProcessImageErrorRootClass.self, decoder: JSONDecoder(), success: { result in
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
