//
//  DraftCompletedImageModel.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 22/12/22.
//

import Foundation

struct ImagesForDraftModel: Codable {
    var message, skuStatus, paid, the360_Data: String
    var draftImageData: [DraftImageData]

    enum CodingKeys: String, CodingKey {
        case message
        case skuStatus = "sku_status"
        case paid
        case the360_Data = "360_data"
        case draftImageData
    }
}

// MARK: - DraftImageData
struct DraftImageData: Codable {
    var id: Int
    var enterpriseID, userID, imageID, imageName: String
    var skuID, projectID, frameSeqNo, imageCategory: String
    var inputImageHresURL: String
    var inputImageLresURL: String
    var isHidden: Int
    var prodCatName, backgroundID, status, source: String
    var tags, createdOn, updatedOn, uploadType: String
    var angle: Int
    var debugData: String
    var overlayID: Int
    var verifiedStatus: String
    var totalCredit, paidCredit: Int
    var locationCoordinates: String
    var frameAngle: Int
    var qcStatus: String

    enum CodingKeys: String, CodingKey {
        case id
        case enterpriseID = "enterprise_id"
        case userID = "user_id"
        case imageID = "image_id"
        case imageName = "image_name"
        case skuID = "sku_id"
        case projectID = "project_id"
        case frameSeqNo = "frame_seq_no"
        case imageCategory = "image_category"
        case inputImageHresURL = "input_image_hres_url"
        case inputImageLresURL = "input_image_lres_url"
        case isHidden = "is_hidden"
        case prodCatName = "prod_cat_name"
        case backgroundID = "background_id"
        case status, source, tags
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case uploadType = "upload_type"
        case angle
        case debugData = "debug_data"
        case overlayID = "overlay_id"
        case verifiedStatus = "verified_status"
        case totalCredit = "total_credit"
        case paidCredit = "paid_credit"
        case locationCoordinates = "location_coordinates"
        case frameAngle = "frame_angle"
        case qcStatus = "qc_status"
    }
}
