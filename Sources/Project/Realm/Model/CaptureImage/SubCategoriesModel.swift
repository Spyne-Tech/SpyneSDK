//
//  SubCategoriesModel.swift
//  Spyne
//
//  Created by Vijay on 29/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
struct SubCateRoot : Codable {

    let header : Header?
    let msgInfo : MsgInfo?
    let payload : Payload?


    enum CodingKeys: String, CodingKey {
        case header = "header"
        case msgInfo = "msgInfo"
        case payload = "payload"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        header = try values.decodeIfPresent(Header.self, forKey: .header)
        msgInfo = try values.decodeIfPresent(MsgInfo.self, forKey: .msgInfo)
        payload = try values.decodeIfPresent(Payload.self, forKey: .payload)
    }
}
struct Payload : Codable {

    let catData : [CatData]?


    enum CodingKeys: String, CodingKey {
        case catData = "data"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        catData = try values.decodeIfPresent([CatData].self, forKey: .catData)
    }


}

struct CatData : Codable {

    let active : String?
    let catId : String?
    let displayName : String?
    let displayThumbnail : String?
    let prodId : String?


    enum CodingKeys: String, CodingKey {
        case active = "active"
        case catId = "catId"
        case displayName = "displayName"
        case displayThumbnail = "displayThumbnail"
        case prodId = "prodId"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(String.self, forKey: .active)
        catId = try values.decodeIfPresent(String.self, forKey: .catId)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        displayThumbnail = try values.decodeIfPresent(String.self, forKey: .displayThumbnail)
        prodId = try values.decodeIfPresent(String.self, forKey: .prodId)
    }


}

struct MsgInfo : Codable {

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


struct Header : Codable {

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
