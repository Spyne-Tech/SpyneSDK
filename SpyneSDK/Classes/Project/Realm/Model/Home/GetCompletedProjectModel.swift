//
//  getCompletedProjectModel.swift
//  Spyne
//
//  Created by Vijay on 05/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation


struct CompletedProjectRootClass : Codable {

    let count : Int?
    let data : [CompletedProjectData]?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case count = "count"
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        data = try values.decodeIfPresent([CompletedProjectData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}

struct CompletedProjectData : Codable {

    let createdDate : String?
    let skuId : String?
    let skuName : String?
    let status : String?
    let thumbnail : String?
    let totalExterior : Int?
    let totalFocus : Int?
    let totalImages : Int?
    let totalInterior : Int?
    let paid : String?
    let project_name : String?
    enum CodingKeys: String, CodingKey {
        case createdDate = "created_date"
        case skuId = "sku_id"
        case skuName = "sku_name"
        case status = "status"
        case thumbnail = "thumbnail"
        case totalExterior = "total_exterior"
        case totalFocus = "total_focus"
        case totalImages = "total_images"
        case totalInterior = "total_interior"
        case paid = "paid"
        case project_name = "project_name"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
        skuId = try values.decodeIfPresent(String.self, forKey: .skuId)
        skuName = try values.decodeIfPresent(String.self, forKey: .skuName)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        totalExterior = try values.decodeIfPresent(Int.self, forKey: .totalExterior)
        totalFocus = try values.decodeIfPresent(Int.self, forKey: .totalFocus)
        totalImages = try values.decodeIfPresent(Int.self, forKey: .totalImages)
        totalInterior = try values.decodeIfPresent(Int.self, forKey: .totalInterior)
        paid = try values.decodeIfPresent(String.self, forKey: .paid)
    }


}
