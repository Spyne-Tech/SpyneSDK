//
//  CarBackgroundModel.swift
//  Spyne
//
//  Created by Vijay on 04/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//



import Foundation

struct CarBackgroundRootClass : Codable {

    let data : [CarBackgroundData]?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([CarBackgroundData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
}

struct CarBackgroundData : Codable {

    let bgName : String?
    let gifUrl : String?
    let imageCredit : Int?
    let imageId : String?
    let imageUrl : String?


    enum CodingKeys: String, CodingKey {
        case bgName = "bgName"
        case gifUrl = "gifUrl"
        case imageCredit = "imageCredit"
        case imageId = "imageId"
        case imageUrl = "imageUrl"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bgName = try values.decodeIfPresent(String.self, forKey: .bgName)
        gifUrl = try values.decodeIfPresent(String.self, forKey: .gifUrl)
        imageCredit = try values.decodeIfPresent(Int.self, forKey: .imageCredit)
        imageId = try values.decodeIfPresent(String.self, forKey: .imageId)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
    }


}


struct NumberPlateModel: Codable {
    var numberPlateList: [NumberPlateList]?
}

// MARK: - NumberPlateList
struct NumberPlateList: Codable {
    var id: Int?
    var enterpriseID, numberPlateLogoID, numberPlateLogoName: String?
    var numberPlateLogoURL: String?
    var active: Int?
    var createdOn, updatedOn: String?

    enum CodingKeys: String, CodingKey {
        case id
        case enterpriseID = "enterprise_id"
        case numberPlateLogoID = "number_plate_logo_id"
        case numberPlateLogoName = "number_plate_logo_name"
        case numberPlateLogoURL = "number_plate_logo_url"
        case active
        case createdOn = "created_on"
        case updatedOn = "updated_on"
    }
}

//import Foundation
//struct CarBackgroundRootClass : Codable {
//
//    let bgName : String?
//    let gifUrl : String?
//    let imageCredit : Int?
//    let imageId : String?
//    let imageUrl : String?
//
//
//    enum CodingKeys: String, CodingKey {
//        case bgName = "bgName"
//        case gifUrl = "gifUrl"
//        case imageCredit = "imageCredit"
//        case imageId = "imageId"
//        case imageUrl = "imageUrl"
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        bgName = try values.decodeIfPresent(String.self, forKey: .bgName)
//        gifUrl = try values.decodeIfPresent(String.self, forKey: .gifUrl)
//        imageCredit = try values.decodeIfPresent(Int.self, forKey: .imageCredit)
//        imageId = try values.decodeIfPresent(String.self, forKey: .imageId)
//        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
//    }
//
//
//}
