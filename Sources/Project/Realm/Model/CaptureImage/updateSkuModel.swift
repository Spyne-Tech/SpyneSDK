//
//  updateSkuModel.swift
//  Spyne
//
//  Created by Vijay on 29/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct updateSkuRoot : Codable {

    let header : updateSkuHeader?
    let msgInfo : updateSkuMsgInfo?
    let payload : updateSkuPayload?


    enum CodingKeys: String, CodingKey {
        case header = "header"
        case msgInfo = "msgInfo"
        case payload = "payload"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        header = try values.decodeIfPresent(updateSkuHeader.self, forKey: .header)
        msgInfo = try values.decodeIfPresent(updateSkuMsgInfo.self, forKey: .msgInfo)
        payload = try values.decodeIfPresent(updateSkuPayload.self, forKey: .payload)
    }
}

struct updateSkuPayload : Codable {

    let data : updateSkuData?


    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(updateSkuData.self, forKey: .data)
    }
}

struct updateSkuData : Codable {

    let extraFrames : Int?
    let shootId : String?
    let skuId : String?
    let skuName : String?
    let frames : updateSkuFrames?

    enum CodingKeys: String, CodingKey {
        case extraFrames = "extraFrames"
        case frames = "frames"
        case shootId = "shootId"
        case skuId = "skuId"
        case skuName = "skuName"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        extraFrames = try values.decodeIfPresent(Int.self, forKey: .extraFrames)
        frames = try values.decodeIfPresent(updateSkuFrames.self, forKey: .frames)
        shootId = try values.decodeIfPresent(String.self, forKey: .shootId)
        skuId = try values.decodeIfPresent(String.self, forKey: .skuId)
        skuName = try values.decodeIfPresent(String.self, forKey: .skuName)
    }
}

struct updateSkuMsgInfo : Codable {

    let msg : String?
    let msgCode : String?
    let msgDescription : String?


    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case msgCode = "msgCode"
        case msgDescription = "msgDescription"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        msgCode = try values.decodeIfPresent(String.self, forKey: .msgCode)
        msgDescription = try values.decodeIfPresent(String.self, forKey: .msgDescription)
    }
}

struct updateSkuHeader : Codable {

    let appId : String?
    let tokenId : String?
    
    enum CodingKeys: String, CodingKey {
        case appId = "appId"
        case tokenId = "tokenId"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        appId = try values.decodeIfPresent(String.self, forKey: .appId)
        tokenId = try values.decodeIfPresent(String.self, forKey: .tokenId)
    }
}



struct updateSkuFrames : Codable {

    let focusImages : [FocusImage]?
    let frameId : String?
    let frameImages : [FocusImage]?
    let id : String?
    let interiorImages : [FocusImage]?
    let prodId : String?
    let totalFrames : Int?


    enum CodingKeys: String, CodingKey {
        case focusImages = "focusImages"
        case frameId = "frameId"
        case frameImages = "frameImages"
        case id = "id"
        case interiorImages = "interiorImages"
        case prodId = "prodId"
        case totalFrames = "totalFrames"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        focusImages = try values.decodeIfPresent([FocusImage].self, forKey: .focusImages)
        frameId = try values.decodeIfPresent(String.self, forKey: .frameId)
        frameImages = try values.decodeIfPresent([FocusImage].self, forKey: .frameImages)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        interiorImages = try values.decodeIfPresent([FocusImage].self, forKey: .interiorImages)
        prodId = try values.decodeIfPresent(String.self, forKey: .prodId)
        totalFrames = try values.decodeIfPresent(Int.self, forKey: .totalFrames)
    }
}


struct FocusImage : Codable {

    let displayImage : String?
    let frameNumber : Int?

    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage"
        case frameNumber = "frameNumber"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayImage = try values.decodeIfPresent(String.self, forKey: .displayImage)
        frameNumber = try values.decodeIfPresent(Int.self, forKey: .frameNumber)
    }
}


struct ImageRoot: Codable {
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "image"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }
    
}
