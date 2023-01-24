//
//  GetPresignedURLModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 30/11/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct GetPresignedURLRootClass : Codable {

    let data : GetPresignedURLData?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(GetPresignedURLData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}

struct GetPresignedURLData : Codable {

    let fileUrl : String?
    let presignedUrl : String?


    enum CodingKeys: String, CodingKey {
        case fileUrl = "file_url"
        case presignedUrl = "presigned_url"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fileUrl = try values.decodeIfPresent(String.self, forKey: .fileUrl)
        presignedUrl = try values.decodeIfPresent(String.self, forKey: .presignedUrl)
    }


}
