//
//  FetchImagesModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 10/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct ProcessedImageRootClass : Codable {

    let is360Data : String?
    let data : [ProcessedImageData]?
    let message : String?
    let paid : String?
    let skuStatus : String?
    let staus : Int?
    
    enum CodingKeys: String, CodingKey {
        case is360Data = "360_data"
        case data = "data"
        case message = "message"
        case paid = "paid"
        case skuStatus = "sku_status"
        case staus = "staus"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is360Data = try values.decodeIfPresent(String.self, forKey: .is360Data)
        data = try values.decodeIfPresent([ProcessedImageData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        paid = try values.decodeIfPresent(String.self, forKey: .paid)
        skuStatus = try values.decodeIfPresent(String.self, forKey: .skuStatus)
        staus = try values.decodeIfPresent(Int.self, forKey: .staus)
    }

}

struct ProcessedImageData : Codable {
    let id: Int?
    let enterpriseID, userID, imageID, imageName: String?
    let skuID, projectID, frameSeqNo, imageCategory: String?
    let inputImageHresURL: String?
    let inputImageLresURL: String?
    let outputImageHresURL: String?
    let isHidden: Int?
    let outputImageLresURL, outputImageLresWmURL, prodCatName, backgroundID: String?
    let status, source, tags, createdOn: String?
    let updatedOn, uploadType: String?
    let angle: Int?
//    let debugData ,
    let imageScore: Float?
    let outputURLJSON : String?
    let overlayID: Int?
    let verifiedStatus, rejectReason, rejectComment : String?
    let  failedReasons: String?
    let totalCredit, paidCredit , imageRating,aiAngle: Int?
    let enterpriseCRMStatus, enterpriseRejectComment: String?
    let locationCoordinates, enterpriseReshootComment, reshootComment, entityID: String?
    let enterpriseRefundComment: String?
    let frameAngle: Int?
    let qcStatus: String?
    var isSelected = false
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
        case outputImageHresURL = "output_image_hres_url"
        case isHidden = "is_hidden"
        case outputImageLresURL = "output_image_lres_url"
        case outputImageLresWmURL = "output_image_lres_wm_url"
        case prodCatName = "prod_cat_name"
        case backgroundID = "background_id"
        case status, source, tags
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case uploadType = "upload_type"
        case angle
//        case debugData = "debug_data"
        case overlayID = "overlay_id"
        case verifiedStatus = "verified_status"
        case rejectReason = "reject_reason"
        case rejectComment = "reject_comment"
        case imageRating = "image_rating"
        case imageScore = "image_score"
        case failedReasons = "failed_reasons"
        case aiAngle = "ai_angle"
        case totalCredit = "total_credit"
        case paidCredit = "paid_credit"
        case enterpriseCRMStatus = "enterprise_crm_status"
        case enterpriseRejectComment = "enterprise_reject_comment"
        case outputURLJSON = "output_url_json"
        case locationCoordinates = "location_coordinates"
        case enterpriseReshootComment = "enterprise_reshoot_comment"
        case reshootComment = "reshoot_comment"
        case entityID = "entity_id"
        case enterpriseRefundComment = "enterprise_refund_comment"
        case frameAngle = "frame_angle"
        case qcStatus = "qc_status"
    }
}

