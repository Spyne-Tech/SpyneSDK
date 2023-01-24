//
//  CheckInModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 30/11/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
struct CheckInRootClass : Codable {

    let data : CheckInData?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(CheckInData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}


struct CheckInData : Codable {

    let checkinTime : String?
    let checkout_time : String?

    enum CodingKeys: String, CodingKey {
        case checkinTime = "checkin_time"
        case checkout_time = "checkout_time"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checkinTime = try values.decodeIfPresent(String.self, forKey: .checkinTime)
        checkout_time = try values.decodeIfPresent(String.self, forKey: .checkout_time)
    }


}
