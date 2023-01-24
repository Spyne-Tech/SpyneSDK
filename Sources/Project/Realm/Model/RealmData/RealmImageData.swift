//
//  RealmImageData.swift
//  Spyne
//
//  Created by Vijay Parmar on 24/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import RealmSwift


/* 1.Store image to local DB, when user click on confirm image, with required upload parameters(project id,sku id, image category, sequence number, path, upload flag = 0) here 0 indicate image not uploaded */

class RealmImageData: Object {
   
    @Persisted var itemId:  Int = 0
    @Persisted var userId: String = ""
    @Persisted var projectId: String = ""
    @Persisted var skuId: String = ""
    @Persisted var skuName: String = ""
    @Persisted var imageCategory: String = ""
    @Persisted var path: String = ""
    @Persisted var imageName: String = ""
    @Persisted var uploadFlag: Int = 0
    @Persisted var overlay_id: String = ""
    @Persisted var frame_seq_no: String = ""
    @Persisted var is_reclick: Bool = false
    @Persisted var is_reshoot: Bool = false
    @Persisted var angle: Int = 0
    @Persisted var uploadType: String = ""
    @Persisted var presignedUrl: String = ""
    @Persisted var gcpUpload: Bool = false
   
    @Persisted var imageId:  String = ""
    @Persisted var roll:  String = ""
    @Persisted var pitch:  String = ""
    @Persisted var tags:  String = ""
    @Persisted var data:  String = ""
    @Persisted var debugData:  String = ""
    @Persisted var response:  String = ""
    @Persisted var retryCount:  Int = 0
    
  
    convenience init(userId:String) {
        
        self.init()
        self.itemId = incrementID()
        self.userId = USER.userId

    }
    
    
    func incrementID() -> Int {
         
        return (realm?.objects(RealmImageData.self).max(ofProperty: "itemId") as Int? ?? 0) + 1
    }
    
}



class RealmVideoData: Object {
   
    @Persisted var itemId:  Int = 0
    @Persisted var userId: String = ""
    @Persisted var projectId: String = ""
    @Persisted var skuId: String = ""
    @Persisted var skuName: String = ""
    @Persisted var videoCategory: String = ""
    @Persisted var path: String = ""
    @Persisted var videoName: String = ""
    @Persisted var uploadFlag: Int = 0
    @Persisted var overlay_id: String = ""
    @Persisted var frame_seq_no: String = ""
    @Persisted var is_reclick: Bool = false
    @Persisted var is_reshoot: Bool = false
    @Persisted var angle: Int = 0
    @Persisted var uploadType: String = ""
    @Persisted var presignedUrl: String = ""
    @Persisted var gcpUpload: Bool = false
   
    @Persisted var videoId:  String = ""
    @Persisted var roll:  String = ""
    @Persisted var pitch:  String = ""
    @Persisted var tags:  String = ""
    @Persisted var data:  String = ""
    @Persisted var debugData:  String = ""
    @Persisted var response:  String = ""
    @Persisted var retryCount:  Int = 0
    
  
    convenience init(userId:String) {
        
        self.init()
        self.itemId = incrementID()
        self.userId = USER.userId

    }
    
    
    func incrementID() -> Int {
         
        return (realm?.objects(RealmImageData.self).max(ofProperty: "itemId") as Int? ?? 0) + 1
    }
    
}
