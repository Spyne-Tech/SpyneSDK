//
//  ProjectDetailViewModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 19/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import KRProgressHUD

class ProjectDetailViewModel{
    
    var projectDetailData : ProjectDetailData?
    //MARK:- Get Project Details
    func getProjectDetail(projectId:String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.getProjectDetail(projectId:projectId), decodeType: ProjectDetailRootClass.self, errorDecodeType: ProjectDetailRootClass.self, decoder: JSONDecoder(), success: { result in
            print(result)
            KRProgressHUD.dismiss()
            if result.status == 200{
                self.projectDetailData = result.data
                onSuccess()
            } else {
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            print(errorResult?.message as Any)
            KRProgressHUD.dismiss()
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    func skuProcessStatus(projectId:String,backgroundId:String,isShadow:String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.skuProcessStatus(projectId:projectId, backgroundId: backgroundId, isShadow: isShadow), decodeType: CommonMessageRootClass.self, errorDecodeType: CommonMessageRootClass.self, decoder: JSONDecoder(), success: { result in
            print(result)
            KRProgressHUD.dismiss()
            if result.status == 200{
                onSuccess()
            } else {
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            print(errorResult?.message as Any)
            KRProgressHUD.dismiss()
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
}
