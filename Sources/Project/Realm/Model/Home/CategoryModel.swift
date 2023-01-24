//
//  CategoryModel.swift
//  Spyne
//
//  Created by Vijay on 01/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit

struct CategoryRootModel : Codable {
    
    let data : [CategoryData]?
    let message : String?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([CategoryData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
}

struct CategoryData : Codable {
    
    let active : Int?
    let colorCode : String?
    let createdAt : String?
    let descriptionField : String?
    let displayThumbnail : String?
    let enterpriseId : String?
    let id : Int?
    let priority : Int?
    let prodCatId : String?
    let prodCatName : String?
    let updatedAt : String?
    
    
    enum CodingKeys: String, CodingKey {
        case active = "active"
        case colorCode = "color_code"
        case createdAt = "created_at"
        case descriptionField = "description"
        case displayThumbnail = "display_thumbnail"
        case enterpriseId = "enterprise_id"
        case id = "id"
        case priority = "priority"
        case prodCatId = "prod_cat_id"
        case prodCatName = "prod_cat_name"
        case updatedAt = "updated_at"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(Int.self, forKey: .active)
        colorCode = try values.decodeIfPresent(String.self, forKey: .colorCode)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        displayThumbnail = try values.decodeIfPresent(String.self, forKey: .displayThumbnail)
        enterpriseId = try values.decodeIfPresent(String.self, forKey: .enterpriseId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        priority = try values.decodeIfPresent(Int.self, forKey: .priority)
        prodCatId = try values.decodeIfPresent(String.self, forKey: .prodCatId)
        prodCatName = try values.decodeIfPresent(String.self, forKey: .prodCatName)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}


struct SubCategoryRootClass : Codable {
    
    let data : [SubCategoryData]?
    let interior : [SubCategoryInterior]?
    let message : String?
    let miscellaneous : [SubCategoryInterior]?
    let status : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case interior = "interior"
        case message = "message"
        case miscellaneous = "miscellaneous"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([SubCategoryData].self, forKey: .data)
        interior = try values.decodeIfPresent([SubCategoryInterior].self, forKey: .interior)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        miscellaneous = try values.decodeIfPresent([SubCategoryInterior].self, forKey: .miscellaneous)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
    
}

struct SubCategoryInterior : Codable {
    
    let displayName : String?
    let displayThumbnail : String?
    let id : Int?
    let prodCatId : String?
    let prodSubCatId : String?
    let mendatoy: Bool?
    
    var clickedAngle = false
    var frameSeqNo = 0
    var imageUrl : String?
    var clickedImage : UIImage?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case displayThumbnail = "display_thumbnail"
        case id = "id"
        case prodCatId = "prod_cat_id"
        case prodSubCatId = "prod_sub_cat_id"
        case mendatoy = "mandatory"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        displayThumbnail = try values.decodeIfPresent(String.self, forKey: .displayThumbnail)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        prodCatId = try values.decodeIfPresent(String.self, forKey: .prodCatId)
        prodSubCatId = try values.decodeIfPresent(String.self, forKey: .prodSubCatId)
        mendatoy = try values.decode(Bool.self, forKey: .mendatoy)
    }
    
    
}

struct SubCategoryData : Codable {
    
    let active : Int?
    let createdAt : String?
    let displayThumbnail : String?
    let enterpriseId : String?
    let id : Int?
    let priority : Int?
    let prodCatId : String?
    let prodSubCatId : String?
    let subCatName : String?
    let updatedAt : String?
    
    
    enum CodingKeys: String, CodingKey {
        case active = "active"
        case createdAt = "created_at"
        case displayThumbnail = "display_thumbnail"
        case enterpriseId = "enterprise_id"
        case id = "id"
        case priority = "priority"
        case prodCatId = "prod_cat_id"
        case prodSubCatId = "prod_sub_cat_id"
        case subCatName = "sub_cat_name"
        case updatedAt = "updated_at"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(Int.self, forKey: .active)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        displayThumbnail = try values.decodeIfPresent(String.self, forKey: .displayThumbnail)
        enterpriseId = try values.decodeIfPresent(String.self, forKey: .enterpriseId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        priority = try values.decodeIfPresent(Int.self, forKey: .priority)
        prodCatId = try values.decodeIfPresent(String.self, forKey: .prodCatId)
        prodSubCatId = try values.decodeIfPresent(String.self, forKey: .prodSubCatId)
        subCatName = try values.decodeIfPresent(String.self, forKey: .subCatName)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
    
    
}
