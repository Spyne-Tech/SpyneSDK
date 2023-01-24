//
//  SPLogin.swift
//  Spyne SDK
//
//  Created by Akash Verma on 03/08/22.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let message: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let authKey, secretKey: String?

    enum CodingKeys: String, CodingKey {
        case authKey = "auth_key"
        case secretKey = "secret_key"
    }
}

// MARK: - Login Model
// User login on the behalf of username and at least one of them email/externalID/contactNo/userName.
class SPLoginViewModel {
    
    var arrOverLays = [OverlayData]()
    
    func userLogin(email:String,externalId:String,contactNo:String,userName:String, onSuccess: @escaping (_: LoginModel) -> Void, onError: @escaping (String) -> Void) {
        Network.request(.login(email: email, externalId: externalId, contactNo: contactNo, userName: userName), decodeType: LoginModel.self, errorDecodeType: LoginModel.self, decoder: JSONDecoder(), success: {   result in
            if result.message == SPStrings.success {
                onSuccess(result)
            } else {
                onError(result.message ?? "")
            }
        }, error: { (_, errorResult,_ ) in
            onError(errorResult?.message ?? "")
        }, failure: { error in
        }, completion: {
        })
    }
    
    func getCategoryAgnostic(categoryId: String, onSuccess: @escaping (_: CategoryMasterRoot) -> Void, onError: @escaping (String) -> Void) {
        Network.request(.categoryAgnostic(categoryId: categoryId), decodeType: CategoryMasterRoot.self, errorDecodeType: CategoryMasterRoot.self, success: { model in
            onSuccess(model)
        }, error: {statusCode,data,message in
            onError(message ?? SPStrings.noDataFound)
        }, failure: { error in
            onError(error.response?.debugDescription ?? SPStrings.noDataFound)
        }, completion: {
        })
    }
    
    func getDraftInProjectForSku(projectName: String, onsuccess: @escaping (CheckForDraft) -> Void , onError: @escaping () -> Void ) {
        Network.request(.getDraftSkuInProject(foreignSkuId: projectName), decodeType: CheckForDraft.self, errorDecodeType: CheckForDraft.self, success: { model  in
            onsuccess(model)
        }, error: {statusCode,data,message in
            onError()
        }, failure: { error in
            onError()
        }, completion: {
            
        })
    }
    
    func getCompletedImagesBySkuID(skuName: String, onSuccess: @escaping (ProcessedImageRootClass) -> Void, onError: @escaping (String) -> Void) {
        Network.request(.getCompletedImages(sku_id: skuName), decodeType: ProcessedImageRootClass.self, errorDecodeType: ProcessedImageRootClass.self, success: { model in
            onSuccess(model)
        }, error: {statusCode,data,message in
                onError(message ?? "")
        }, failure: {_ in
            onError("")
        }, completion: {
            
        })
    }
    
}

