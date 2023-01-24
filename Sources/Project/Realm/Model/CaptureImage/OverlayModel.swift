//
//  OverlayModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 02/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit

struct OverlayRootClass : Codable {

    let data : [OverlayData]?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([OverlayData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}


struct OverlayData : Codable {

    let active : Int?
    let angleName : String?
    let angles : Int?
    let createdAt : String?
    let displayName : String?
    let displayThumbnail : String?
    let enterpriseId : String?
    let frameAngle : String?
    let id : Int?
    let overlayId : String?
    let priority : Int?
    let prodCatId : String?
    let prodSubCatId : String?
    let type : String?
    let updatedAt : String?
    let mendatory : Bool?
    
    var clickedAngle = false
    var frameSeqNo = 0
    var imageUrl : String?
    var clickedImage : UIImage?
    
    enum CodingKeys: String, CodingKey {
        case active = "active"
        case angleName = "angle_name"
        case angles = "angles"
        case createdAt = "created_at"
        case displayName = "display_name"
        case displayThumbnail = "display_thumbnail"
        case enterpriseId = "enterprise_id"
        case frameAngle = "frame_angle"
        case id = "id"
        case overlayId = "overlay_id"
        case priority = "priority"
        case prodCatId = "prod_cat_id"
        case prodSubCatId = "prod_sub_cat_id"
        case type = "type"
        case updatedAt = "updated_at"
        case mendatory = "mandatory"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(Int.self, forKey: .active)
        angleName = try values.decodeIfPresent(String.self, forKey: .angleName)
        angles = try values.decodeIfPresent(Int.self, forKey: .angles)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        displayThumbnail = try values.decodeIfPresent(String.self, forKey: .displayThumbnail)
        enterpriseId = try values.decodeIfPresent(String.self, forKey: .enterpriseId)
        frameAngle = try values.decodeIfPresent(String.self, forKey: .frameAngle)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        overlayId = try values.decodeIfPresent(String.self, forKey: .overlayId)
        priority = try values.decodeIfPresent(Int.self, forKey: .priority)
        prodCatId = try values.decodeIfPresent(String.self, forKey: .prodCatId)
        prodSubCatId = try values.decodeIfPresent(String.self, forKey: .prodSubCatId)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        mendatory = try values.decodeIfPresent(Bool.self, forKey: .mendatory)
    }


}
