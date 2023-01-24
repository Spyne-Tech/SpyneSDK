//
//  CreateCollectionModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 27/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct ShootRootClass : Codable {

    let header : ShootHeader?
    let msgInfo : ShootMsgInfo?
    let payload : ShootPayload?

    
    enum CodingKeys: String, CodingKey {
        case header = "header"
        case msgInfo = "msgInfo"
        case payload = "payload"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        header = try values.decodeIfPresent(ShootHeader.self, forKey: .header)
        msgInfo = try values.decodeIfPresent(ShootMsgInfo.self, forKey: .msgInfo)
        payload = try values.decodeIfPresent(ShootPayload.self, forKey: .payload)
    }

}

struct ShootPayload : Codable {
    
    let data : ShootData?
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ShootData.self, forKey: .data)
    }


}

struct ShootData : Codable {

    let backRoundList : String?
    let businessName : String?
    let catId : String?
    let categoryName : String?
    let creationDate : String?
    let deliveryDate : String?
    let expectedDate : String?
    let marketPlace : [String]?
    let numberOfSkus : Int?
    let prodId : String?
    let productName : String?
    let samplePhotoList : String?
    let shootAmount : Float?
    let shootId : String?
    let shootName : String?
    let skus : [String]?
    let status : String?
    let submittedDate : String?
    let updatedAt : String?
    let userId : String?


    enum CodingKeys: String, CodingKey {
        case backRoundList = "backRoundList"
        case businessName = "businessName"
        case catId = "catId"
        case categoryName = "categoryName"
        case creationDate = "creationDate"
        case deliveryDate = "deliveryDate"
        case expectedDate = "expectedDate"
        case marketPlace = "marketPlace"
        case numberOfSkus = "numberOfSkus"
        case prodId = "prodId"
        case productName = "productName"
        case samplePhotoList = "samplePhotoList"
        case shootAmount = "shootAmount"
        case shootId = "shootId"
        case shootName = "shootName"
        case skus = "skus"
        case status = "status"
        case submittedDate = "submittedDate"
        case updatedAt = "updatedAt"
        case userId = "userId"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        backRoundList = try values.decodeIfPresent(String.self, forKey: .backRoundList)
        businessName = try values.decodeIfPresent(String.self, forKey: .businessName)
        catId = try values.decodeIfPresent(String.self, forKey: .catId)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        creationDate = try values.decodeIfPresent(String.self, forKey: .creationDate)
        deliveryDate = try values.decodeIfPresent(String.self, forKey: .deliveryDate)
        expectedDate = try values.decodeIfPresent(String.self, forKey: .expectedDate)
        marketPlace = try values.decodeIfPresent([String].self, forKey: .marketPlace)
        numberOfSkus = try values.decodeIfPresent(Int.self, forKey: .numberOfSkus)
        prodId = try values.decodeIfPresent(String.self, forKey: .prodId)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        samplePhotoList = try values.decodeIfPresent(String.self, forKey: .samplePhotoList)
        shootAmount = try values.decodeIfPresent(Float.self, forKey: .shootAmount)
        shootId = try values.decodeIfPresent(String.self, forKey: .shootId)
        shootName = try values.decodeIfPresent(String.self, forKey: .shootName)
        skus = try values.decodeIfPresent([String].self, forKey: .skus)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        submittedDate = try values.decodeIfPresent(String.self, forKey: .submittedDate)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
    }


}

struct ShootMsgInfo : Codable {

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

struct ShootHeader : Codable {
    
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
