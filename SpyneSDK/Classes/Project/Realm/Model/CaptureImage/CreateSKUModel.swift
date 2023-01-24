//
//  CreateSKUModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 02/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct CreateSKURootClass : Codable {

    let message : String?
    let skuId : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case message = "message"
        case skuId = "sku_id"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        skuId = try values.decodeIfPresent(String.self, forKey: .skuId)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}
