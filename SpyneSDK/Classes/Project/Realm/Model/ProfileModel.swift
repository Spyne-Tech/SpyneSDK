//
//  ProfileModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 18/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct UserProfileRootClass : Codable {

    let data : UserProfileData?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(UserProfileData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}

struct UserProfileData : Codable {

    let contactNo : String?
    let creditAllotted : Int?
    let creditAvailable : Int?
    let creditUsed : Int?
    let emailId : String?
    let enterpriseId : String?
    let userId : String?
    let userName : String?


    enum CodingKeys: String, CodingKey {
        case contactNo = "contact_no"
        case creditAllotted = "credit_allotted"
        case creditAvailable = "credit_available"
        case creditUsed = "credit_used"
        case emailId = "email_id"
        case enterpriseId = "enterprise_id"
        case userId = "user_id"
        case userName = "user_name"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contactNo = try values.decodeIfPresent(String.self, forKey: .contactNo)
        creditAllotted = try values.decodeIfPresent(Int.self, forKey: .creditAllotted)
        creditAvailable = try values.decodeIfPresent(Int.self, forKey: .creditAvailable)
        creditUsed = try values.decodeIfPresent(Int.self, forKey: .creditUsed)
        emailId = try values.decodeIfPresent(String.self, forKey: .emailId)
        enterpriseId = try values.decodeIfPresent(String.self, forKey: .enterpriseId)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
    }


}
