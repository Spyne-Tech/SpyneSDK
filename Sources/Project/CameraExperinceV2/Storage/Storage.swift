//
//  Storage.swift
//

import Foundation
import UIKit

class DraftStorage{
    static var isFromDraft = false
    static var isExteriorCompleted = false
    static var isInteriorCompleted = false
    static var isMisCompleted = false
    static var isEmptySku = false
    static var draftProjectId = String()
    
    
    static func reset(){
        DraftStorage.isFromDraft = false
        DraftStorage.isExteriorCompleted = false
        DraftStorage.isInteriorCompleted = false
        DraftStorage.isMisCompleted = false
        DraftStorage.isEmptySku = false
        DraftStorage.draftProjectId = ""
    }
    
}


class Storage{

    static let shared = Storage()
    private let defaults = UserDefaults.standard
    
    var vmSPOrderNow = SPOrderNowVM()
    var vmShoot = SPShootViewModel()
    var arrInteriorPopup = [SubCategoryInterior]()
    var arrFocusedPopup = [SubCategoryInterior]()
    var strReshhotSkuName = String()
    var totalDrafts = 0
    var totalOngoing = 0
    var totalCompleted = 0
    
    func setAgnosticCatagory(agnosticCatagoryObject credit : AgnosticCatagoryData){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(credit) {
            defaults.set(encoded, forKey: "agnosticCatagory")
        }
    }
    
    func getAgnosticCatagory() -> AgnosticCatagoryData?{
        if let creditObj = defaults.object(forKey: "agnosticCatagory") as? Data {
            let decoder = JSONDecoder()
            if let agnosticCatagory = try? decoder.decode(AgnosticCatagoryData.self, from: creditObj) {
                return agnosticCatagory
            }
        }
        return nil
    }
    
    
    func setPresignedUrlData(presignedUrlData urlData : GetPresignedURLData){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(urlData) {
            defaults.set(encoded, forKey: "presignedUrlData")
        }
    }
    
    func getPresignedUrlData() -> GetPresignedURLData?{
        if let urlDataObj = defaults.object(forKey: "presignedUrlData") as? Data {
            let decoder = JSONDecoder()
            if let urlData = try? decoder.decode(GetPresignedURLData.self, from: urlDataObj) {
                return urlData
            }
        }
        return nil
    }
    
    
    func setUser(userObject user :LoginRootClass){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: "User")
        }
    }
    func setCredit(creditObject credit :UserCreditData){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(credit) {
            defaults.set(encoded, forKey: "credit")
        }
    }
  
    func setProductCategories( CategoryData categories :CategoryData){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(categories) {
            defaults.set(encoded, forKey: "categories")
        }
    }
    
    func getProductCategories() -> CategoryData?{
        if let categoriesObj = defaults.object(forKey: "categories") as? Data {
            let decoder = JSONDecoder()
            if let categories = try? decoder.decode(CategoryData.self, from: categoriesObj) {
                return categories
            }
        }
        return nil
    }

    func getUser() -> LoginRootClass?{
        if let user = defaults.object(forKey: "User") as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(LoginRootClass.self, from: user) {
                return user
            }
        }
        return nil
    }
    
    func getCredit() -> UserCreditData?{
        if let creditObj = defaults.object(forKey: "credit") as? Data {
            let decoder = JSONDecoder()
            if let credit = try? decoder.decode(UserCreditData.self, from: creditObj) {
                return credit
            }
        }
        return nil
    }
    
    
    static var checkinImage : UIImage?{
        get{
            if UserDefaults.standard.value(forKey: "checkinImage") != nil{
                
                let imageData = UserDefaults.standard.object(forKey: "checkinImage") as? Data
                    var image: UIImage? = nil
                    if let imageData = imageData {
                        image = UIImage(data: imageData)
                    }
                return image
            }
            return UIImage()
        }
        set{
            if let imageData = newValue{
                UserDefaults.standard.set(imageData.pngData(), forKey: "checkinImage")
            }
            
           
        }
        
    }
 
    static var lastCheckinTimeInSeconds : Int64{
        get{
            if UserDefaults.standard.value(forKey: "lastCheckinTimeInSeconds") != nil{
                return (UserDefaults.standard.value(forKey: "lastCheckinTimeInSeconds") as? Int64)!
            }
            return 0
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "lastCheckinTimeInSeconds")
        }
        
    }
    
    
    static var isCheckinAttandence: Bool{
        get{
            if UserDefaults.standard.value(forKey: "isCheckinAttandence") != nil{
                return (UserDefaults.standard.value(forKey: "isCheckinAttandence") as? Bool)!
            }
            return false
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isCheckinAttandence")
        }
        
    }
    
   
    static var isUploadTriggred: Bool{
        get{
            if UserDefaults.standard.value(forKey: "isUploadTriggred") != nil{
                return (UserDefaults.standard.value(forKey: "isUploadTriggred") as? Bool)!
            }
            return false
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isUploadTriggred")
        }
    }
    
    static var isVideoUploadTriggred: Bool{
        get{
            if UserDefaults.standard.value(forKey: "isUploadTriggred") != nil{
                return (UserDefaults.standard.value(forKey: "isUploadTriggred") as? Bool)!
            }
            return false
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isUploadTriggred")
        }
    }
    
    var appVersion : String{
        get{
            if UserDefaults.standard.value(forKey: "appVersion") != nil{
                return (UserDefaults.standard.value(forKey: "appVersion") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "appVersion")
        }
    }
   
    func clearAllStorage(){
        defaults.removeObject(forKey: "User")
        USER.enterpriseId = ""
        USER.authKey = ""
        USER.userId = ""
        USER.userName = ""
        USER.isLogin = false
        USER.availableCredit = 0
        
    }
}


struct USER{
    
    static var enterpriseId : String{
        get{
            if UserDefaults.standard.value(forKey: "enterpriseId") != nil{
                return (UserDefaults.standard.value(forKey: "enterpriseId") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "enterpriseId")
        }
    }
    
    var notificationToken : String{
        get{
            if UserDefaults.standard.value(forKey: "notificationToken") != nil{
                return (UserDefaults.standard.value(forKey: "notificationToken") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "notificationToken")
        }
    }
    
    static var dealerShipId : String{
        get{
            if UserDefaults.standard.value(forKey: "dealerShipId") != nil{
                return (UserDefaults.standard.value(forKey: "dealerShipId") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "dealerShipId")
        }
    }

    static var checkQC : Bool {
        get{
          if UserDefaults.standard.value(forKey: "checkQC") != nil{
            return (UserDefaults.standard.value(forKey: "checkQC") as? Bool)!
          }
          return false
        }
        set{
          UserDefaults.standard.set(newValue, forKey: "checkQC")
        }
      }

    static var currentLang : String{
         get{
             if UserDefaults.standard.value(forKey: "currentLang") != nil{
                 return (UserDefaults.standard.value(forKey: "currentLang") as? String)!
             }
             return "en"
         }
         set{
             UserDefaults.standard.set(newValue, forKey: "currentLang")
         }
         
     }
    
    static var authKey : String{
        get{
            if UserDefaults.standard.value(forKey: "authKey") != nil{
                return (UserDefaults.standard.value(forKey: "authKey") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "authKey")
        }
        
    }
    
    static var userId : String{
        get{
            if UserDefaults.standard.value(forKey: "userId") != nil{
                return (UserDefaults.standard.value(forKey: "userId") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userId")
        }
        
    }
    
    static var userName : String{
        get{
            if UserDefaults.standard.value(forKey: "userName") != nil{
                return (UserDefaults.standard.value(forKey: "userName") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userName")
        }
        
    }
    
    static var tokenId : String{
        get{
            if UserDefaults.standard.value(forKey: "tokenId") != nil{
                return (UserDefaults.standard.value(forKey: "tokenId") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "tokenId")
        }
        
    }
    
    static var userEmail : String{
        get{
            if UserDefaults.standard.value(forKey: "userEmail") != nil{
                return (UserDefaults.standard.value(forKey: "userEmail") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userEmail")
        }
        
    }
   
    static var isLogin : Bool{
        get{
            if UserDefaults.standard.value(forKey: "isLogin") != nil{
                return (UserDefaults.standard.value(forKey: "isLogin") as? Bool)!
            }
            return false
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isLogin")
        }
        
    }
   
    static var isFirstTime : Bool{
        get{
            if UserDefaults.standard.value(forKey: "isFirstTime") != nil{
                return (UserDefaults.standard.value(forKey: "isFirstTime") as? Bool)!
            }
            return true
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isFirstTime")
        }
        
    }
    
    static var isCameraFirstTime : Bool{
        get{
            if UserDefaults.standard.value(forKey: "isCameraFirstTime") != nil{
                return (UserDefaults.standard.value(forKey: "isCameraFirstTime") as? Bool)!
            }
            return true
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isCameraFirstTime")
        }
        
    }
    
    static var isShowCaseFirstTime : Bool{
        get{
            if UserDefaults.standard.value(forKey: "isShowCaseFirstTime") != nil{
                return (UserDefaults.standard.value(forKey: "isShowCaseFirstTime") as? Bool)!
            }
            return true
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isShowCaseFirstTime")
        }
        
    }
    
    static var appId : String{
        get{
            if UserDefaults.standard.value(forKey: "appId") != nil{
                return (UserDefaults.standard.value(forKey: "appId") as? String)!
            }
            return ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "appId")
        }
        
    }
    
    static var availableCredit : Int{
        get{
            if UserDefaults.standard.value(forKey: "availableCredit") != nil{
                return (UserDefaults.standard.value(forKey: "availableCredit") as? Int)!
            }
            return 0
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "availableCredit")
        }
        
    }
    
    static var isFirstTimeHome : Bool{
        get{
            if UserDefaults.standard.value(forKey: "isFirstTimeHome") != nil{
                return (UserDefaults.standard.value(forKey: "isFirstTimeHome") as? Bool)!
            }
            return true
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isFirstTimeHome")
        }
        
    }
    
    
    static var isOverlay : Bool{
        get{
            if UserDefaults.standard.value(forKey: "isOverlay") != nil{
                return (UserDefaults.standard.value(forKey: "isOverlay") as? Bool)!
            }
            return true
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isOverlay")
        }
        
    }
    
    
    static var isGrid : Bool{
        get{
            if UserDefaults.standard.value(forKey: "isGrid") != nil{
                return (UserDefaults.standard.value(forKey: "isGrid") as? Bool)!
            }
            return false
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isGrid")
        }
        
    }
    
    static var isGyrometer : Bool{
        get{
            if UserDefaults.standard.value(forKey: "isGyrometer") != nil{
                return (UserDefaults.standard.value(forKey: "isGyrometer") as? Bool)!
            }
            return true
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isGyrometer")
        }
        
    }
  
}

extension Storage {
    
    func setCatagoryMasterData(categoryMasterData object: CategoryMasterRoot) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            defaults.set(encoded, forKey: "CatagoryMasterData")
        }
    }
    
    func getCatagoryMasterData() -> CategoryMasterRoot? {
        if let creditObj = defaults.object(forKey: "CatagoryMasterData") as? Data {
            let decoder = JSONDecoder()
            if let agnosticCatagory = try? decoder.decode(CategoryMasterRoot.self, from: creditObj) {
                return agnosticCatagory
            }
        }
        return nil
    }
}
