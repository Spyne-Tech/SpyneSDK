//
//  CreateProject.swift
//  Spyne
//
//  Created by Vijay Parmar on 27/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct CreateProjectRootClass : Codable {

    let message : String?
    let projectId : String?
    let status : Int?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case projectId = "project_id"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        projectId = try values.decodeIfPresent(String.self, forKey: .projectId)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }

}

// MARK: - Create Project and SKu
struct CreateProjectandSku: Codable {
  let message: String
  let data: Projectdta
}

// MARK: - DataClass
struct Projectdta: Codable {
  let projectID: String
  let draftAvailable: Bool
  let skusList: [SkusList]
  enum CodingKeys: String, CodingKey {
    case projectID = "project_id"
    case draftAvailable, skusList
  }
}
// MARK: - SkusList
struct SkusList: Codable {
  let skuName, skuID, localID: String
  enum CodingKeys: String, CodingKey {
    case skuName = "sku_name"
    case skuID = "sku_id"
    case localID = "local_id"
  }
}
