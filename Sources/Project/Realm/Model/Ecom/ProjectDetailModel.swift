//
//  ProjectDetailModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 18/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct ProjectDetailRootClass : Codable {

    let data : ProjectDetailData?
    let message : String?
    let status : Int?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ProjectDetailData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }

}

struct ProjectDetailData : Codable {

    let projectId : String?
    let projectName : String?
    let sku : [ProjectDetailSku]?
    let totalImages : Int?
    let totalSku : Int?

    enum CodingKeys: String, CodingKey {
        case projectId = "project_id"
        case projectName = "project_name"
        case sku = "sku"
        case totalImages = "total_images"
        case totalSku = "total_sku"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        projectId = try values.decodeIfPresent(String.self, forKey: .projectId)
        projectName = try values.decodeIfPresent(String.self, forKey: .projectName)
        sku = try values.decodeIfPresent([ProjectDetailSku].self, forKey: .sku)
        totalImages = try values.decodeIfPresent(Int.self, forKey: .totalImages)
        totalSku = try values.decodeIfPresent(Int.self, forKey: .totalSku)
    }

}

struct ProjectDetailSku : Codable {

    let images : [ProjectDetailImage]?
    let skuId : String?
    let skuName : String?
    let totalImages : Int?
    
    enum CodingKeys: String, CodingKey {
        case images = "images"
        case skuId = "sku_id"
        case skuName = "sku_name"
        case totalImages = "total_images"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        images = try values.decodeIfPresent([ProjectDetailImage].self, forKey: .images)
        skuId = try values.decodeIfPresent(String.self, forKey: .skuId)
        skuName = try values.decodeIfPresent(String.self, forKey: .skuName)
        totalImages = try values.decodeIfPresent(Int.self, forKey: .totalImages)
    }

}

struct ProjectDetailImage : Codable {

    let inputHres : String?
    let inputLres : String?
    let outputHres : String?
    let outputLres : String?
    let outputWm : String?
    
    enum CodingKeys: String, CodingKey {
        case inputHres = "input_hres"
        case inputLres = "input_lres"
        case outputHres = "output_hres"
        case outputLres = "output_lres"
        case outputWm = "output_wm"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        inputHres = try values.decodeIfPresent(String.self, forKey: .inputHres)
        inputLres = try values.decodeIfPresent(String.self, forKey: .inputLres)
        outputHres = try values.decodeIfPresent(String.self, forKey: .outputHres)
        outputLres = try values.decodeIfPresent(String.self, forKey: .outputLres)
        outputWm = try values.decodeIfPresent(String.self, forKey: .outputWm)
    }


}
