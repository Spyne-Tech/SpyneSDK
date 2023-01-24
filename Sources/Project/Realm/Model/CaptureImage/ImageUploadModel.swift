//
//  ImageUploadModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 03/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

//
//  ImageUploadModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 03/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct ImageUploadRootClass : Codable {

    let data : ImageUploadData?
    
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
            case data = "data"
            case message = "message"
            case status = "status"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            data = try values.decodeIfPresent(ImageUploadData.self, forKey: .data)
            message = try values.decodeIfPresent(String.self, forKey: .message)
            status = try values.decodeIfPresent(Int.self, forKey: .status)
        }
   }

struct ImageUploadData : Codable {

        let videoId : String?
        let imageId : String?
        let presignedUrl : String?
    
        enum CodingKeys: String, CodingKey {
            case imageId = "image_id"
            case presignedUrl = "presigned_url"
            case videoId = "video_id"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            imageId = try values.decodeIfPresent(String.self, forKey: .imageId)
            presignedUrl = try values.decodeIfPresent(String.self, forKey: .presignedUrl)
            videoId = try values.decodeIfPresent(String.self, forKey: .videoId)
        }


    }

struct ImageUploadErrorRootClass : Codable {

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
