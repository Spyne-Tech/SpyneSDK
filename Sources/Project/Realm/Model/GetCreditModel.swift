//
//  GetCreditModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 07/07/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct GetCreditListRootClass : Codable {

    let data : [GetCreditListData]?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([GetCreditListData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}

struct GetCreditListData : Codable {

    let creditId : String?
    let credits : Int?
    let planType : String?
    let price : String?
    let pricePerImage : String?
    let rackPrice : String?
    let rackPricePerImage : String?


    enum CodingKeys: String, CodingKey {
        case creditId = "creditId"
        case credits = "credits"
        case planType = "planType"
        case price = "price"
        case pricePerImage = "pricePerImage"
        case rackPrice = "rackPrice"
        case rackPricePerImage = "rackPricePerImage"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        creditId = try values.decodeIfPresent(String.self, forKey: .creditId)
        credits = try values.decodeIfPresent(Int.self, forKey: .credits)
        planType = try values.decodeIfPresent(String.self, forKey: .planType)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        pricePerImage = try values.decodeIfPresent(String.self, forKey: .pricePerImage)
        rackPrice = try values.decodeIfPresent(String.self, forKey: .rackPrice)
        rackPricePerImage = try values.decodeIfPresent(String.self, forKey: .rackPricePerImage)
    }


}


struct CreateOrderRootClass : Codable {

    let active : Bool?
    let createdAt : String?
    let currency : String?
    let id : Int?
    let orderId : String?
    let planDiscount : Float?
    let planFinalCost : Float?
    let planId : String?
    let planOrigCost : Float?
    let razorpayOrderId : String?
    let razorpayPaymentId : String?
    let status : String?
    let subscriptionType : String?
    let updatedAt : String?
    let userId : String?


    enum CodingKeys: String, CodingKey {
        case active = "active"
        case createdAt = "createdAt"
        case currency = "currency"
        case id = "id"
        case orderId = "orderId"
        case planDiscount = "planDiscount"
        case planFinalCost = "planFinalCost"
        case planId = "planId"
        case planOrigCost = "planOrigCost"
        case razorpayOrderId = "razorpayOrderId"
        case razorpayPaymentId = "razorpayPaymentId"
        case status = "status"
        case subscriptionType = "subscriptionType"
        case updatedAt = "updatedAt"
        case userId = "userId"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        planDiscount = try values.decodeIfPresent(Float.self, forKey: .planDiscount)
        planFinalCost = try values.decodeIfPresent(Float.self, forKey: .planFinalCost)
        planId = try values.decodeIfPresent(String.self, forKey: .planId)
        planOrigCost = try values.decodeIfPresent(Float.self, forKey: .planOrigCost)
        razorpayOrderId = try values.decodeIfPresent(String.self, forKey: .razorpayOrderId)
        razorpayPaymentId = try values.decodeIfPresent(String.self, forKey: .razorpayPaymentId)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        subscriptionType = try values.decodeIfPresent(String.self, forKey: .subscriptionType)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
    }


}



