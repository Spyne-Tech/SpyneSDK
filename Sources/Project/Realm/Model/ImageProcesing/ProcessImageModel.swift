//
//  ProcessImageModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 06/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
struct ProcessImageRootClass : Codable {

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
struct ProcessImageErrorRootClass : Codable {

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
