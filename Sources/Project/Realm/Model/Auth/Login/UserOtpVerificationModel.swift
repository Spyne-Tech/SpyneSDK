//
//  UserOtpVerification.swift
//  Spyne
//
//  Created by Vijay on 21/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct UserOtpVerification : Codable {

    let data : String?
    let id : String?
    let message : String?
    let status : String?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case id = "id"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}
