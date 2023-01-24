//
//  CheckForDraftModel.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 22/12/22.
//

import Foundation

// MARK: - CheckForDraft
struct CheckForDraft: Codable {
    var message: String
    var data: DraftData
}

import Foundation

// MARK: - DataClass
struct DraftData: Codable {
    var projectData: ProjectData
    var skuData: ProjectSKU
}

// MARK: - ProjectData
struct DraftProjectData: Codable {
    var totalSku: Int
    var projectName, projectID, status, categoryID: String
    var category, createdOn, localID: String
    var processedImages, totalImages: Int

    enum CodingKeys: String, CodingKey {
        case totalSku = "total_sku"
        case projectName = "project_name"
        case projectID = "project_id"
        case status
        case categoryID = "category_id"
        case category
        case createdOn = "created_on"
        case localID = "local_id"
        case processedImages = "processed_images"
        case totalImages = "total_images"
    }
}

// MARK: - SkuData
struct SkuData: Codable {
    var totalImagesCaptured: Int
    var skuName, status: String
    var createdOn: String
    var totalFramesNo: Int
    var skuID, projectID, categoryID, subCategoryID: String
    var subCategory: String
    var processedImages, exteriorClick: Int
    var is360: Bool
    var localID: String
    var totalCredit, paidCredit: Int
    var isPaid: Bool

    enum CodingKeys: String, CodingKey {
        case totalImagesCaptured = "total_images_captured"
        case skuName = "sku_name"
        case status
        case createdOn = "created_on"
        case totalFramesNo = "total_frames_no"
        case skuID = "sku_id"
        case projectID = "project_id"
        case categoryID = "category_id"
        case subCategoryID = "sub_category_id"
        case subCategory = "sub_category"
        case processedImages = "processed_images"
        case exteriorClick = "exterior_click"
        case is360 = "is_360"
        case localID = "local_id"
        case totalCredit = "total_credit"
        case paidCredit = "paid_credit"
        case isPaid = "is_paid"
    }
}
