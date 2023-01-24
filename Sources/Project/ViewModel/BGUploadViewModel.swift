//
//  BGUploadViewModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 27/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD

class BGUploadViewModel{
    
    //MARK:- Upload Image
    func getPresignedURL(imageData:[String:String],onSuccess: @escaping (ImageUploadData?) -> Void, onError: @escaping (String) -> Void) {
        //KRProgressHUD.show()
    
        Network.request(.uploadImage(imageData:imageData), decodeType: ImageUploadRootClass.self, errorDecodeType: ImageUploadErrorRootClass.self, decoder: JSONDecoder(), success: { result in
           // KRProgressHUD.dismiss()
            onSuccess(result.data)
        }, error: { (_, errorResult,_ ) in
            //KRProgressHUD.dismiss()
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            //KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    
    
    //MARK:- Upload Image
    func uploadAttaendanceImage(imageData:[String:String],onSuccess: @escaping (ImageUploadData?) -> Void, onError: @escaping (String) -> Void) {
        //KRProgressHUD.show()
    
        Network.request(.uploadImage(imageData: imageData), decodeType: ImageUploadRootClass.self, errorDecodeType: ImageUploadErrorRootClass.self, decoder: JSONDecoder(), success: { result in
           // KRProgressHUD.dismiss()
            onSuccess(result.data)
        }, error: { (_, errorResult,_ ) in
            //KRProgressHUD.dismiss()
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            //KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }

    //MARK:- Upload Image
    func uploadImageMarkDone(imageId:String,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        //KRProgressHUD.show()
    
        Network.request(.imageUploadMarkDone(imageId: imageId), decodeType: CommonMessageRootClass.self, errorDecodeType: CommonMessageRootClass.self, decoder: JSONDecoder(), success: { result in
           // KRProgressHUD.dismiss()
            onSuccess()
        }, error: { (_, errorResult,_ ) in
            //KRProgressHUD.dismiss()
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            //KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    
}
