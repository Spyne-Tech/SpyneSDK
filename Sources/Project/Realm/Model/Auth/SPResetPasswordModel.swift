
//
//  SPResetPasswordModel.swift
//  Spyne
//
//  Created by Vijay on 01/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
struct ResetPasswordModel : Codable {

    let data : Data?
    let msg : String?
    let code : String?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case msg = "msg"
        case code = "code"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        code = try values.decodeIfPresent(String.self, forKey: .code)
    }

}
