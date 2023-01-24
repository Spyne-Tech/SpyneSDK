//
//  SPShootViewModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 27/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import KRProgressHUD


class SPShootViewModel {
    
    //Ecom Variables
    var arrImages = [EcomImage]()
    
    //: Ecom Variables
    var shootId = String()
    var categoryName = ""
    var isInterialScreen = false
    
    var skuId = String()
    var selectedIndex:Int?
    var interialFrameNumber:Int?
    
    //stores the angles details
    var arrFocusImages  = [FocusImage]()
    var arrInterialAngles = [Angles]()
    var arrFocusAngles = [Angles]()
    
    var selectedRowOfNoOfShotPopup:Int? = 0
    var selectedAngle:Int = 0
    var selectedInteriorAngles:Int = 0
    var selectedFocusAngles:Int = 0
    
    var projectId = String()
    var cat_id = String()
    var sub_cat_id = String()
    var noOfAngles = 8
    var capturedImage = UIImage()
    var arrCatData =  [SubCategoryData]()
    var projectName = String()
    var skuName = "SKU001"
    var arrOverLays = [OverlayData]()
    var angleClassifierData : AngleClassifierRoot?
    //var to manage frame sequense for reshoot reclick
    var frameSeqNo = 1
    
    static var shared = SPShootViewModel()
    
    //MARK:- Get Sub Categories
    func getProductSubCategories(prod_id: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        Network.request(.getProductSubCategories(prod_id: prod_id), decodeType: SubCategoryRootClass.self, errorDecodeType: SubCategoryRootClass.self, decoder: JSONDecoder(), success: { result in
            print(result)
            KRProgressHUD.dismiss()
            if result.status == 200{
                self.arrCatData = result.data ?? []
                if self.arrCatData.count > 0{
                    self.cat_id = self.arrCatData.first?.prodCatId ?? ""
                    self.sub_cat_id = self.arrCatData.first?.prodSubCatId ?? ""
                }
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
    
    //MARK:- Get Overlays
    func getOverlays(prod_id: String,prod_sub_cat_id:String,no_of_frames:String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        Network.request(.getOverlays(prod_id: prod_id, prod_sub_cat_id: prod_sub_cat_id, no_of_frames: no_of_frames), decodeType: OverlayRootClass.self, errorDecodeType: OverlayRootClass.self, decoder: JSONDecoder(), success: { result in
            print(result)
            KRProgressHUD.dismiss()
            if result.status == 200{
                self.arrOverLays = result.data ?? []
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

    func createProjectandSku(projectdta:[String:Any],skudta:[[String:Any]], onSuccess: @escaping (_ skudetail : CreateProjectandSku) -> Void, onError: @escaping (String) -> Void) {
        Network.request(.createOfflineProject(projectdta: projectdta, skudta: skudta) , decodeType: CreateProjectandSku.self, errorDecodeType: CreateProjectandSku.self, decoder: JSONDecoder(), success: { result in
          KRProgressHUD.dismiss()
            self.projectId = result.data.projectID
            self.skuName = result.data.skusList[0].skuName
            self.skuId = result.data.skusList[0].skuID
          onSuccess(result)
        }, error: { (_, errorResult,_ ) in
          KRProgressHUD.dismiss()
          onError(Alert.SomethingWrong)
        }, failure: { error in
          KRProgressHUD.dismiss()
          onError(error.localizedDescription)
        }, completion: {
        })
      }
    
    //MARK:- Create Project
    func createProject(productCatId:String,projectName:String,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        Network.request(.createProject(productCatId: productCatId, productName: projectName), decodeType: CreateProjectRootClass.self, errorDecodeType: CreateProjectRootClass.self, decoder: JSONDecoder(), success: { result in
            KRProgressHUD.dismiss()
            if result.status == 200{
                SPShootViewModel.shared.projectId = result.projectId ?? ""
                self.projectId = result.projectId ?? ""
                onSuccess()
            } else {
                onError(result.message ??  Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            KRProgressHUD.dismiss()
            onError(errorResult?.message ??  Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    //MARK: - Angle Classifier Upload
    func  angleClassifierUpload(angleClassifierUploadImageModel:AngleClassifierUploadImageModel,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        Network.request(.angleClassifierUpload(angleClassifierUploadImageModel: angleClassifierUploadImageModel), decodeType: AngleClassifierRoot.self, errorDecodeType: AngleClassifierRoot.self, decoder: JSONDecoder(), success: { result in
            self.angleClassifierData = result
                onSuccess()
        }, error: { (_, errorResult,_ ) in
            onError(errorResult?.message ??  Alert.SomethingWrong)
        }, failure: { error in
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    //MARK:- Create SKU
    func createSKU(project_id: String, prod_cat_id: String, prod_sub_cat_id: String, sku_name: String,total_frames:String,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        SPShootViewModel.shared.skuName = sku_name
        Network.request(.createSKU(project_id: project_id, prod_cat_id: prod_cat_id, prod_sub_cat_id: prod_sub_cat_id, sku_name: sku_name, total_frames: total_frames), decodeType: CreateSKURootClass.self, errorDecodeType: CreateSKURootClass.self, decoder: JSONDecoder(), success: { result in
            
            KRProgressHUD.dismiss()
            
            if result.status == 200{
                self.skuId = result.skuId ?? ""
                SPShootViewModel.shared.skuId = result.skuId ?? ""
                
                onSuccess()
            } else {
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            KRProgressHUD.dismiss()
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
            KRProgressHUD.dismiss()
        })
    }
    
    //MARK:- Upload Image
    func uploadImage(imageData:[String:String],onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
            Network.request(.uploadImage(imageData:imageData), decodeType: ImageUploadRootClass.self, errorDecodeType: ImageUploadErrorRootClass.self, decoder: JSONDecoder(), success: { result in
                onSuccess()
        }, error: { (_, errorResult,_ ) in
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            onError(error.localizedDescription)
        }, completion: {
        })
        
    }
    
}
