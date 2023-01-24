
import Foundation
import Moya
import Alamofire
import UIKit

let api_key = CLIENT.shared.getUserApiKey()

enum APIManager {
    case login(email:String,externalId:String,contactNo:String,userName:String)
    case categoryAgnostic(categoryId: String)
    case createProject(productCatId:String,productName:String)
    case createOfflineProject(projectdta : [String:Any] , skudta : [[String:Any]])
    case getProductSubCategories(prod_id:String)
    case getBackground(category: String)
    case updateDownloadStatus(skuId:String)
    case getProjectDetail(projectId:String)
    case skuProcessStatus(projectId:String,backgroundId:String,isShadow:String)
    case getCreditList
    case createOrder(orderId:String,planDiscount:Float,planFinalCost:Float,planId:String,planOrigCost:Float)
    case processImages(skuId:String,background_id:String,is360:String,isBlurNumPlate:String,isTintWindow:String,windowCorrection:String,shootEvn:Int,numberPlateLogo:String, numberplatelogoId:String, isShadow:Bool)
    case updateTotalFrames(skuId:String,totalFrames:String)
    case getOverlays(prod_id:String,prod_sub_cat_id:String,no_of_frames:String)
    case angleClassifierUpload (angleClassifierUploadImageModel:AngleClassifierUploadImageModel)
    case uploadImage(imageData:[String:String])
    case createSKU(project_id:String,prod_cat_id:String,prod_sub_cat_id:String,sku_name:String,total_frames:String)
    case updateUserCredit(credit_id:String,credit_alotted:String)
    case imageUploadMarkDone(imageId:String)
    case getOverlaybyId(overlay_ids:[Int])
    case projectStatusUpdate(projectIdList:[String])
    case getDraftSkuInProject(foreignSkuId: String)
    case getCompletedImages(sku_id:String)
}

extension APIManager: TargetType {
    
    var headers: [String: String]? {
        
        switch self {
        case .categoryAgnostic:
            return nil
        case .login:
            let headerParam = [
                "Accept": "application/json",
                "x-api-key":SpyneSDK.shared.api_key,
                "Connection": "keep-alive"
            ]
            return headerParam
        case .angleClassifierUpload:
            let headerParam = [
                "Accept": "application/json",
                "bearer-token" : CLIENT.shared.getUserSecretKey()
            ]
            return headerParam
        default:
            let headerParam = [
                "Accept": "application/json",
            ]
            return headerParam
        }
    }
    
    var baseURL: URL {
        switch self {
        case
            .createProject,.getProductSubCategories,.getBackground,.getProjectDetail,.skuProcessStatus,.getCreditList,.updateTotalFrames,.getOverlays,.createSKU,.updateUserCredit,.getOverlaybyId:
            return URL(string:"\(StringCons.baseURL)/api/v2/")!
        case .updateDownloadStatus,.uploadImage,.imageUploadMarkDone:
            return URL(string: "\(StringCons.baseURL)/api/v4/")!
        case .projectStatusUpdate,.createOfflineProject,.processImages,.getDraftSkuInProject,.getCompletedImages:
            return URL(string: "\(StringCons.baseURL)/api/nv1/")!
        case .createOrder :
            return URL(string: "https://payment.spyne.ai/")!
        default:
            return URL(string:"\(StringCons.baseURL)/api/")!
            
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "fv1/users/sdk/auth"
        case .categoryAgnostic:
            return "nv1/category-agnostic/get-category-data"
        case .createProject:
            return "project/create/v2"
        case .getProductSubCategories:
            return "prod/sub/fetch/v2"
        case .getBackground:
            return "backgrounds/fetchEnterpriseBgs/v2"
        case .updateDownloadStatus:
            return "update-download-status"
        case .getProjectDetail:
            return "project/getSkuPerProject"
        case .skuProcessStatus :
            return "sku/skuProcessStatus"
        case .getCreditList:
            return "payment/fetch-plans-ios"
        case .createOrder :
            return "order/credit/"
        case .processImages:
            return "category-agnostic/create-image-process-environment"
        case .updateTotalFrames:
            return "sku/updateTotalFrames"
        case .getOverlays:
            return "overlays/fetch"
        case .angleClassifierUpload:
            return "fv1/image/angle-classifier"
        case .uploadImage:
            return "image/upload"
        case .createSKU:
            return "sku/create/v2"
        case .updateUserCredit:
            return "credit/insert"
        case .imageUploadMarkDone:
            return "image/mark-done"
        case .getOverlaybyId:
            return "overlays/fetch-ids"
        case .projectStatusUpdate:
            return "app/project-status-update"
        case .createOfflineProject:
            return "projects/offline-create-project-skus"
        case .getDraftSkuInProject:
            return "app/get-sku-project"
        case .getCompletedImages:
            return "app/get-images-by-sku-id"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categoryAgnostic,.getProductSubCategories,.getBackground,.getProjectDetail,.getCreditList,.updateTotalFrames,.getOverlays,.getOverlaybyId,.getDraftSkuInProject,.getCompletedImages:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let email,let externalId,let contactNo,let userName):
            return ["external_id":externalId]
        case .categoryAgnostic(let categoryID):
            return ["auth_key" : CLIENT.shared.getUserSecretKey(),
                    "categoryId": categoryID]
        case .createProject(let productCatId,let productName):
            return ["prod_cat_id":productCatId,"project_name":productName,"auth_key":CLIENT.shared.getUserSecretKey(),"source":"App_ios"]
        case .getProductSubCategories( let prod_id):
            return ["auth_key": CLIENT.shared.getUserSecretKey(), "prod_id":"cat_d8R14zUNE"]
        case .getBackground(let category):
            return ["category":category,"auth_key":CLIENT.shared.getUserSecretKey(),"enterprise_id":"TaD1VC1Ko"]
        case .updateDownloadStatus(let skuId):
            return ["user_id":CLIENT.shared.getUserSecretKey(),"sku_id":skuId,"enterprise_id":"TaD1VC1Ko" ,"download_hd":"true"]
        case .getProjectDetail(let projectId):
            return [
                "auth_key" : CLIENT.shared.getUserSecretKey(),
                "project_id" : projectId
            ]
        case .skuProcessStatus(let projectId,let backgroundId,let isShadow):
            return [
                "auth_key" : CLIENT.shared.getUserSecretKey(),
                "project_id" : projectId,
                "background_id" : backgroundId,
                "shadow" : isShadow
            ]
        case .getCreditList:
            return ["auth_key":CLIENT.shared.getUserSecretKey()]
            
        case .createOfflineProject(projectdta: let projectdta, skudta: let skudta):
            return [
                    "auth_key" : CLIENT.shared.getUserSecretKey(),
                    "project_data" : projectdta,
                    "sku_data" : skudta
                  ]
        case .createOrder(let orderId,let planDiscount,let planFinalCost,let planId,let planOrigCost):
            
            return [
                "active": false,
                "currency": "USD",
                "orderId": orderId,
                "planDiscount": planDiscount.round(to: 2),
                "planFinalCost": planFinalCost.round(to: 2),
                "planId": planId,
                "planOrigCost": planOrigCost.round(to: 2),
                "status": "CREATED",
                "subscriptionType": "New",
                "userId": CLIENT.shared.getUserSecretKey()
            ]
//        case .processImages(let skuId,let background_id,let is360,let isBlurNumPlate,let isTintWindow,let windowCorrection,let shootEnv):
//            return ["sku_id":skuId,"background_id":background_id,"auth_key":CLIENT.shared.getUserSecretKey(),"is_360":is360,"number_plate_blur":isBlurNumPlate,"window_correction":windowCorrection, "shoot_evn":shootEnv]
            
        case .processImages(let skuId,let background_id,let is360,let isBlurNumPlate,let isTintWindow,let windowCorrection,let shootEnv , let numberPlateLogo, let numberplatelogoId,let isShadow):
            
            if numberplatelogoId != "" {
                return ["skuId":skuId,"backgroundId":background_id,"auth_key":CLIENT.shared.getUserSecretKey(),"is360":is360, "shootEvn":shootEnv , "numberPlateLogoId" : numberplatelogoId, "numberPlateLogo": true, "tyreProcessing": isShadow]
            } else {
            return ["skuId":skuId,"backgroundId":background_id,"auth_key":CLIENT.shared.getUserSecretKey(),"is360":is360,"window_correction":windowCorrection, "shootEvn":shootEnv , "numberPlateLogo" : numberPlateLogo, "tyreProcessing": isShadow]
            }
        case .updateTotalFrames(let skuId,let totalFrames):
              return [
                "auth_key" : CLIENT.shared.getUserSecretKey(),
                "sku_id" : skuId,
                "total_frames" : totalFrames
              ]
        case .getOverlays(let prod_id,let prod_sub_cat_id,let no_of_frames):
            return ["auth_key": CLIENT.shared.getUserSecretKey(), "prod_id":prod_id,"prod_sub_cat_id":prod_sub_cat_id,"no_of_frames":no_of_frames]
        case .angleClassifierUpload:
            return nil
        case .uploadImage(let imageData):
            return imageData
        case .createSKU(let project_id,let prod_cat_id,let prod_sub_cat_id,let sku_name,let total_frames):
            return ["project_id":project_id,"prod_cat_id":prod_cat_id,"prod_sub_cat_id":prod_sub_cat_id,"sku_name":sku_name,"auth_key":CLIENT.shared.getUserSecretKey(),"total_frames":total_frames,"source":"App_ios"]
        case .updateUserCredit(let credit_id,let credit_alotted):
            return [
                "auth_key" : CLIENT.shared.getUserSecretKey(),
                "credit_id" : credit_id,
                "credit_alotted" : credit_alotted
            ]
        case .imageUploadMarkDone(let imageId):
            
            return [
                "auth_key" : CLIENT.shared.getUserSecretKey(),
                "image_id" : imageId
            ]
        case .getOverlaybyId(let overlayIds):
            return [
                "overlay_ids":String(describing: overlayIds),
                "auth_key" : CLIENT.shared.getUserSecretKey()
            ]
        case .projectStatusUpdate(let projectIds):
            return [
                "auth_key" : CLIENT.shared.getUserSecretKey(),
                "projectIdList" : projectIds
            ]
        case .getDraftSkuInProject(let foreignSkuId):
            return [
                "foreign_sku_id" : foreignSkuId,
                "auth_key" : CLIENT.shared.getUserSecretKey()
            ]
        case .getCompletedImages(let sku_id):
            return ["auth_key":CLIENT.shared.getUserSecretKey() ,"skuId":sku_id]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login,.categoryAgnostic,.createProject,.getProductSubCategories,.getBackground,.updateDownloadStatus,.getProjectDetail,.skuProcessStatus,.getCreditList,.createOrder,.processImages,.updateTotalFrames,.getOverlays,.angleClassifierUpload,.uploadImage,.createSKU,.createOfflineProject,.updateUserCredit,.imageUploadMarkDone,.projectStatusUpdate,.getOverlaybyId,.getDraftSkuInProject,.getCompletedImages:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        switch self {
        case .angleClassifierUpload(let angleClassifierUploadImageModel):
          
            var multipartFormData = [Moya.MultipartFormData]()
            
            multipartFormData.append(Moya.MultipartFormData(provider: .data(angleClassifierUploadImageModel.required_angle?.description.data(using: String.Encoding.utf8) ?? Data()), name: "required_angle"))
            
            multipartFormData.append(Moya.MultipartFormData(provider: .data(angleClassifierUploadImageModel.crop_check?.description.data(using: String.Encoding.utf8) ?? Data()), name: "crop_check"))
            // capture Image
            let captureImage = angleClassifierUploadImageModel.image_file
            let captureImageData = captureImage?.jpegData(compressionQuality: 0.01)
            let faceImageMultipartFormData = Moya.MultipartFormData(provider: .data(captureImageData!), name: "image_file", fileName: "\(Date().toString(format: "ddMMyyhhmmssMs"))01.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(faceImageMultipartFormData)
            
            return .uploadMultipart(multipartFormData)
        default:
            if parameters != nil {
                return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
            } else {
                return .requestPlain
            }
        }
    }
}

extension String {
    var utf8Encoded: Data { return data(using: .utf8)! }
}
