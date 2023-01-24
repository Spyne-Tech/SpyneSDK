//
//  RealmViewModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 19/11/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import RealmSwift

class RealmViewModel{

    var realm: Realm

    init(){
        self.realm = try! Realm()
    }
    init(configuration: Realm.Configuration) {
        self.realm = try! Realm(configuration: configuration)
    }

    static var main: RealmViewModel {
        return SpyneSDK.shared.realm
    }
    
    //MARK:-Get Project Data
    func getRealmData(projectId:String)->RealmProjectData?{
        
        let predicate = NSPredicate(format: "projectId == '\(projectId)'", "")
       
        let projectData: [RealmProjectData] = realm.objects(RealmProjectData.self).filter(predicate).map { projectData in
                // Iterate through all the Canteens
                return projectData
            }
            return  projectData.first
       
    }
 
    //MARK:-Get Project DatauSIn Sku Id
    func getRealmData(skuId:String)->RealmProjectData?{
        
        let predicate =  NSPredicate(format: "skuId == '\(skuId)'", "")
      
        let projectData: [RealmProjectData] = realm.objects(RealmProjectData.self).filter(predicate).map { projectData in
                // Iterate through all the Canteens
                return projectData
            }
            return  projectData.first
        
    }
 
    
    //MARK:-Get ecom realm sku data
    func getRealmSkuData(skuId:String)->RealmSkuData?{
        
        let predicate = NSPredicate(format: "skuId == '\(skuId)'", "")
       
        let projectData: [RealmSkuData] = realm.objects(RealmSkuData.self).filter(predicate).map { projectData in
                // Iterate through all the Canteens
                return projectData
        }
        return  projectData.first
       
    }
    
    //Get ImageData
    func getRealmImageData(status:Int,skuId:String)->[RealmImageData]{
        
        let predicate = NSPredicate(format: "uploadFlag == \(status) AND skuId == '\(skuId)'", "")
     
        let imageData: [RealmImageData] = realm.objects(RealmImageData.self).filter(predicate).map { imgData in
                // Iterate through all the Canteens
                return imgData
            }
            return  imageData
    }
    
    
    //Get ImageData
    func getRealmVideoData(status:Int,skuId:String)->[RealmVideoData]{
        
        let predicate = NSPredicate(format: "uploadFlag == \(status) AND skuId == '\(skuId)'", "")
     
        let imageData: [RealmVideoData] = realm.objects(RealmVideoData.self).filter(predicate).map { imgData in
                // Iterate through all the Canteens
                return imgData
            }
            return  imageData
    }
    
    
    
    //Get ImageData
    func getRealmAllImageData(skuId:String)->[RealmImageData]{
        
        let predicate = NSPredicate(format: "skuId == '\(skuId)'", "")
     
        let imageData: [RealmImageData] = realm.objects(RealmImageData.self).filter(predicate).map { imgData in
                // Iterate through all the Canteens
                return imgData
            }
            return  imageData
    }
    
    //MARK: - Get Video Data
    func getRealmAllVideoData(skuId:String)->[RealmVideoData]{
        
        let predicate = NSPredicate(format: "skuId == '\(skuId)'", "")
     
        let imageData: [RealmVideoData] = realm.objects(RealmVideoData.self).filter(predicate).map { imgData in
                // Iterate through all the Canteens
                return imgData
            }
            return  imageData
    }
    
    
    
    //MARK: - GET REALM DATA
    func getRealmData(status:Int)->[RealmImageData]{
        let predicate = NSPredicate(format: "uploadFlag == \(status)", "")
        let imageData: [RealmImageData] = realm.objects(RealmImageData.self).filter(predicate).map { imgData in
                // Iterate through all the Canteens
                return imgData
            }
            return  imageData
    }
    
    
    func getRealmVideoData(status:Int)->[RealmVideoData]{
        let predicate = NSPredicate(format: "uploadFlag == \(status)", "")
        let imageData: [RealmVideoData] = realm.objects(RealmVideoData.self).filter(predicate).map { imgData in
                // Iterate through all the Canteens
                return imgData
            }
            return  imageData
    }
    
    
    
    //MARK:- Stored Data
    func storeProjectData(draftProject:ProjectData?, projectSku: ProjectSKU, elements:SkuElements,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
    
        let project = draftProject
    
        let realmEcomProjectObject = RealmProjectData(authKey: USER.authKey, prodCatId: project?.categoryId ?? "", subCatId: project?.subCategoryId ?? "", projectId: project?.projectId ?? "", projectName: project?.projectName ?? "", skuId: projectSku.skuId ?? "", imageCategory: project?.category ?? "", completedAngles: elements.completedAngles, noOfAngles: elements.noOfAngles,noOfInteriorAngles: elements.noOfInteriorAngles,noOfMisAngles: elements.noOfMisAngles, interiorSkiped:elements.interiorSkiped , misSkiped: elements.misSkiped, is360IntSkiped: elements.is360IntSkiped)
    
        let projectDataRef = ThreadSafeReference(to:realmEcomProjectObject)
        
        if let projectData = realm.resolve(projectDataRef){
            try? realm.safeWrite {
                realm.add(projectData)
                onSuccess()
            }
        }
    }
    
    //MARK:-Ecom Store SKU Data
    func storeSkuData(draftProject:ProjectData?, projectSku : ProjectSKU?,onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        let project = draftProject
      
        let realmSkuObject = RealmSkuData(projectId: project?.projectId ?? "", skuId: projectSku?.skuId ?? "", skuName: projectSku?.skuName ?? "", completedAngles: projectSku?.totalImagesCaptured ?? 0)
        
        let imageDataRef = ThreadSafeReference(to:realmSkuObject)
        
        if let imageData = realm.resolve(imageDataRef){
            try? realm.safeWrite {
                realm.add(imageData)
                onSuccess()
            }
        }
    }
    
    func getRealmData(predicate:NSPredicate)->[RealmImageData]{
        let imageData: [RealmImageData] = realm.objects(RealmImageData.self).filter(predicate).map { imgData in
                // Iterate through all the cantens
                return imgData
            }
        return  imageData
    }
    
    func getRealmVideoData(predicate:NSPredicate)->[RealmVideoData]{
        let imageData: [RealmVideoData] = realm.objects(RealmVideoData.self).filter(predicate).map { imgData in
                // Iterate through all the cantens
                return imgData
            }
        return  imageData
    }
    
    func getSingleRealmImageData(status:Int)->RealmImageData?{
        let predicate = NSPredicate(format: "uploadFlag == \(status)", "")
        let imageData: [RealmImageData] = realm.objects(RealmImageData.self).filter(predicate).map { imgData in
                // Iterate through all the Canteens
                return imgData
            }
            return  imageData.first
    }
    
    
    func getSingleRealmVideoData(status:Int)->RealmVideoData?{
        let predicate = NSPredicate(format: "uploadFlag == \(status)", "")
        let imageData: [RealmVideoData] = realm.objects(RealmVideoData.self).filter(predicate).map { imgData in
                // Iterate through all the Canteens
                return imgData
            }
            return  imageData.first
    }
    
    
    
    func skipImage(imageData:RealmImageData?,skipFlag:Int)->Int{
        
        let imageDataRef = ThreadSafeReference(to:imageData!)
        
        if let imageData = realm.resolve(imageDataRef){
            try? realm.safeWrite {
                imageData.uploadFlag = skipFlag
            }
        }
        
        return realm.objects(RealmImageData.self).filter("uploadFlag != 1").count
        
    }
    
    
    func skipVideo(imageData:RealmVideoData?,skipFlag:Int)->Int{
        
        let imageDataRef = ThreadSafeReference(to:imageData!)
        
        if let imageData = realm.resolve(imageDataRef){
            try? realm.safeWrite {
                imageData.uploadFlag = skipFlag
            }
        }
        
        return realm.objects(RealmVideoData.self).filter("uploadFlag != 1").count
        
    }
    
    
    func totalRemainingUpload()->Int{
        let  predicate = NSPredicate(format: "uploadFlag != \(1)", "")
        let arrImagesRemaining = getRealmData(predicate: predicate)
        return arrImagesRemaining.count
    }
    
    func totalRemainingUploadVideo()->Int{
        let  predicate = NSPredicate(format: "uploadFlag != \(1)", "")
        let arrImagesRemaining = getRealmVideoData(predicate: predicate)
        return arrImagesRemaining.count
    }
    
    
    func getRemainingAbove(imageData:RealmImageData?)->Int{
        return realm.objects(RealmImageData.self).filter("itemId > \(imageData?.itemId ?? 0) && uploadFlag != \(1)").count
    }
    
    
    
    func getRemainingAboveVideo(imageData:RealmVideoData?)->Int{
        return realm.objects(RealmVideoData.self).filter("itemId > \(imageData?.itemId ?? 0) && uploadFlag != \(1)").count
    }
    
    
    
    func getRemainingBelow(imageData:RealmImageData?)->Int{
        return realm.objects(RealmImageData.self).filter("itemId < \(imageData?.itemId ?? 0) && uploadFlag != \(1)").count
    }
    
    
    func getRemainingBelowVideo(imageData:RealmVideoData?)->Int{
        return realm.objects(RealmVideoData.self).filter("itemId < \(imageData?.itemId ?? 0) && uploadFlag != \(1)").count
    }
    
    func getRemainingAboveSkipped(imageData:RealmImageData?)->Int{
        return realm.objects(RealmImageData.self).filter("itemId < \(imageData?.itemId ?? 0) && uploadFlag != \(1)").count
    }
    
    func getRemainingAboveSkippedVideo(imageData:RealmVideoData?)->Int{
        return realm.objects(RealmVideoData.self).filter("itemId < \(imageData?.itemId ?? 0) && uploadFlag != \(1)").count
    }
    
    func totalRemainingMarkDone(status:Int)->Int{
        //Mark not done
        let predicate = NSPredicate(format: "uploadFlag != \(1)")
        let arrMarkDoneRemaining = getRealmData(predicate: predicate)
        return arrMarkDoneRemaining.count
        
    }
    
    func totalRemainingMarkDoneVideo(status:Int)->Int{
        //Mark not done
       let predicate = NSPredicate(format: "uploadFlag != \(1)")
        let arrMarkDoneRemaining = getRealmVideoData(predicate: predicate)
        return arrMarkDoneRemaining.count
        
    }
    
    
    func updateSkippedImages()->Int{
        //Update Skipped Images
        let arrOldImages = getRealmData(status: -2)
       
        try? realm.safeWrite {
            for image in arrOldImages{
                let imageDataRef = ThreadSafeReference(to:image)
                if let imageData = realm.resolve(imageDataRef){
                    imageData.uploadFlag = -1
                }
            }
        }
        return arrOldImages.count
    }
    
    
    func updateSkippedVideos()->Int{
        //Update Skipped Images
        let arrOldImages = getRealmVideoData(status: -2)
       
        try? realm.safeWrite {
            for image in arrOldImages{
                let imageDataRef = ThreadSafeReference(to:image)
                if let imageData = realm.resolve(imageDataRef){
                    imageData.uploadFlag = -1
                }
            }
        }
        return arrOldImages.count
    }
    
    
    func updateMarkDoneSkipedImages()->Int{
        
        let predicate = NSPredicate(format: "uploadFlag == \(-1)")
        let arrMarkDoneRemaining = getRealmData(predicate: predicate)
        
        try? realm.safeWrite {
            for image in arrMarkDoneRemaining{
                let imageDataRef = ThreadSafeReference(to:image)
                if let imageData = realm.resolve(imageDataRef){
                    imageData.uploadFlag = -1
                }
                
            }
        }
        
        return arrMarkDoneRemaining.count
        
    }
    
    
    func updateMarkDoneSkipedVideos()->Int{
        
        let predicate = NSPredicate(format: "uploadFlag == \(-1)")
        let arrMarkDoneRemaining = getRealmVideoData(predicate: predicate)
        
        try? realm.safeWrite {
            for image in arrMarkDoneRemaining{
                let imageDataRef = ThreadSafeReference(to:image)
                if let imageData = realm.resolve(imageDataRef){
                    imageData.uploadFlag = -1
                }
                
            }
        }
        
        return arrMarkDoneRemaining.count
        
    }
    
    func markGCPUploaded(imageData:RealmImageData?)->Int{
        let imageDataRef = ThreadSafeReference(to:imageData!)
        guard let imageData = realm.resolve(imageDataRef) else {
           return  0// person now deleted
         }
        try? realm.safeWrite {
            imageData.gcpUpload = true
        }
        return 1
    }
    
    
    func markGCPUploadedVideo(videoData:RealmVideoData?)->Int{
    
        let imageDataRef = ThreadSafeReference(to:videoData!)
        
        guard let imageData = realm.resolve(imageDataRef) else {
           return  0// person now deleted
         }
        try? realm.safeWrite {
            imageData.gcpUpload = true
        }
        return 1
    
    }
    
    
    func addPreSignedUrl(imageData:RealmImageData?)->Int{
        
        let imageDataRef = ThreadSafeReference(to:imageData!)

        guard let imageData = realm.resolve(imageDataRef) else {
           return  0// person now deleted
         }
        try? realm.safeWrite {
            imageData.presignedUrl = imageData.presignedUrl
            imageData.imageId = imageData.imageId
        }
        return realm.objects(RealmImageData.self).filter("presignedUrl != '' && itemId == \(imageData.itemId )").count
    }
    
    
    func addPreSignedUrl(imageData:RealmVideoData?)->Int{
        
        let imageDataRef = ThreadSafeReference(to:imageData!)

        guard let imageData = realm.resolve(imageDataRef) else {
           return  0// person now deleted
         }
        try? realm.safeWrite {
            imageData.presignedUrl = imageData.presignedUrl
            imageData.videoId = imageData.videoId
        }
        return realm.objects(RealmVideoData.self).filter("presignedUrl != '' && itemId == \(imageData.itemId )").count
    }
    
    func markDoneImage(imageData:RealmImageData?)->Int{
    
        let imageDataRef = ThreadSafeReference(to: imageData!)
        
        guard let imageData = realm.resolve(imageDataRef) else {
           return  0// person now deleted
        }
        
        try? realm.safeWrite {
            imageData.uploadFlag = 1
        }
        
        return realm.objects(RealmImageData.self).filter("uploadFlag == 1 && itemId == \(imageData.itemId)").count
    }
    
    
    func markDoneVideo(videoData:RealmVideoData?)->Int{
    
        let imageDataRef = ThreadSafeReference(to: videoData!)
        
        guard let imageData = realm.resolve(imageDataRef) else {
           return  0// person now deleted
        }
        
        try? realm.safeWrite {
            imageData.uploadFlag = 1
        }
        
        return realm.objects(RealmVideoData.self).filter("uploadFlag == 1 && itemId == \(imageData.itemId)").count
    }
    
    
}
