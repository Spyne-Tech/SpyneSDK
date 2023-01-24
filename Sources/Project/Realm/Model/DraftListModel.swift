//
//  DraftListModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 24/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct ProjectRootClass<T : Codable> : Codable {
    
    let data : [T]?
    let message : String?
    let status : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([T].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
    
}


struct ProjectData : Codable {
    
    let category : String?
    let categoryId : String?
    let createdOn : String?
    let processedImages : Int?
    let projectId : String?
    let projectName : String?
    let status : String?
    let subCategory : String?
    let subCategoryId : String?
    let totalImages : Int?
    let totalSku : Int?
    let localId: String?
    let thumbnail: String?
    let projectCategory: String?
    let expectedNoOfSkus: String?
    let shootLocation: String?
    let preferedSlot: String?
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case categoryId = "category_id"
        case createdOn = "created_on"
        case processedImages = "processed_images"
        case projectId = "project_id"
        case projectName = "project_name"
        case status = "status"
        case subCategory = "sub_category"
        case subCategoryId = "sub_category_id"
        case totalImages = "total_images"
        case totalSku = "total_sku"
        case localId = "local_id"
        case thumbnail = "thumbnail"
        case projectCategory = "project_category"
        case expectedNoOfSkus = "expected_no_of_skus"
        case shootLocation = "shoot_location"
        case preferedSlot = "prefered_slot"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn)
        processedImages = try values.decodeIfPresent(Int.self, forKey: .processedImages)
        projectId = try values.decodeIfPresent(String.self, forKey: .projectId)
        projectName = try values.decodeIfPresent(String.self, forKey: .projectName)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        subCategory = try values.decodeIfPresent(String.self, forKey: .subCategory)
        subCategoryId = try values.decodeIfPresent(String.self, forKey: .subCategoryId)
        totalImages = try values.decodeIfPresent(Int.self, forKey: .totalImages)
        totalSku = try values.decodeIfPresent(Int.self, forKey: .totalSku)
        localId = try values.decodeIfPresent(String.self, forKey: .localId)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        projectCategory = try values.decodeIfPresent(String.self, forKey: .projectCategory)
        expectedNoOfSkus = try values.decodeIfPresent(String.self, forKey: .expectedNoOfSkus)
        shootLocation = try values.decodeIfPresent(String.self, forKey: .shootLocation)
        preferedSlot = try values.decodeIfPresent(String.self, forKey: .preferedSlot)
    }
    
    
}


struct ProjectSKU : Codable {
    
    let totalImagesCaptured: Int?
    let skuName : String?
    let status : String?
    let createdOn : String?
    let totalFramesNo: Int?
    let skuId : String?
    let categoryId : String?
    let subCategoryId: String?
    let subCategory: String?
    let displayImage: String?
    let processedImages : Int?
    let exteriorClick: Int?
    let is360 : Bool?
    let localId: String?
    let isPaid: Bool?
    let totalCredit: Int?
    let paidCredit: Int?
    let projectID: String?
    let qcStatus: String?

    
    enum CodingKeys: String, CodingKey {
        case totalImagesCaptured = "total_images_captured"
        case skuName = "sku_name"
        case status = "status"
        case createdOn = "created_on"
        case totalFramesNo = "total_frames_no"
        case skuId = "sku_id"
        case categoryId = "category_id"
        case subCategoryId = "sub_category_id"
        case subCategory = "sub_category"
        case displayImage = "display_image"
        case processedImages = "processed_images"
        case exteriorClick = "exterior_click"
        case is360 = "is_360"
        case localId = "local_id"
        case isPaid = "is_paid"
        case totalCredit = "total_credit"
        case paidCredit = "paid_credit"
        case projectID = "project_id"
        case qcStatus = "qc_status"
        }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalImagesCaptured = try values.decodeIfPresent(Int.self, forKey: .totalImagesCaptured)
        skuName = try values.decodeIfPresent(String.self, forKey: .skuName)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn)
        totalFramesNo = try values.decodeIfPresent(Int.self, forKey: .totalFramesNo)
        skuId = try values.decodeIfPresent(String.self, forKey: .skuId)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
        subCategoryId = try values.decodeIfPresent(String.self, forKey: .subCategoryId)
        subCategory = try values.decodeIfPresent(String.self, forKey: .subCategory)
        displayImage = try values.decodeIfPresent(String.self, forKey: .displayImage)
        processedImages = try values.decodeIfPresent(Int.self, forKey: .processedImages)
        exteriorClick = try values.decodeIfPresent(Int.self, forKey: .exteriorClick)
        is360 = try values.decodeIfPresent(Bool.self, forKey: .is360)
        localId = try values.decodeIfPresent(String.self, forKey: .localId)
        isPaid = try values.decodeIfPresent(Bool.self, forKey: .isPaid)
        totalCredit = try values.decodeIfPresent(Int.self, forKey: .totalCredit)
        paidCredit = try values.decodeIfPresent(Int.self, forKey: .paidCredit)
        projectID = try values.decodeIfPresent(String.self, forKey: .projectID)
        qcStatus = try values.decodeIfPresent(String.self, forKey: .qcStatus)
    }


        
    }
    

