//
//  CommonMessageModel.swift
//  Spyne
//
//  Created by Akash Verma on 01/07/22.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
struct CommonMessageRootClass : Codable {

    let message : String?
    let status : Int?
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}
