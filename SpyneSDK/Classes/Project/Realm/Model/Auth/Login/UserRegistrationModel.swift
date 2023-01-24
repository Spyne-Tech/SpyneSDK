//
//  UserRegistration.swift
//  Spyne
//
//  Created by Vijay on 21/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct UserRootClass : Codable {

    let header : UserHeader?
    let msgInfo : UserMsgInfo?
    let payload : UserPayload?


    enum CodingKeys: String, CodingKey {
        case header = "header"
        case msgInfo = "msgInfo"
        case payload = "payload"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        header =  try values.decodeIfPresent(UserHeader.self, forKey: .header)
        msgInfo = try values.decodeIfPresent(UserMsgInfo.self, forKey: .msgInfo)
        payload = try values.decodeIfPresent(UserPayload.self, forKey: .payload)
    }
}


struct UserPayload : Codable {

    let data : String?


    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(String.self, forKey: .data)
    }


}


struct UserMsgInfo : Codable {

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

struct UserHeader : Codable {

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


