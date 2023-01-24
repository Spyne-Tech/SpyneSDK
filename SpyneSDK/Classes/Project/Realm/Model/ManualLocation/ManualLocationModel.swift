//
//  ManualLocationModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 29/11/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct ManualLocationRootClass : Codable {

    let data : [ManualLocationData]?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ManualLocationData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}

struct ManualLocationData : Codable {

    let coordinates : ManualLocationCoordinate?
    let id : Int?
    let locationId : String?
    let locationName : String?
    let thresholdDistanceInMeters : Int?


    enum CodingKeys: String, CodingKey {
        case coordinates = "coordinates"
        case id = "id"
        case locationId = "location_id"
        case locationName = "location_name"
        case thresholdDistanceInMeters = "threshold_distance_in_meters"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        coordinates = try values.decodeIfPresent(ManualLocationCoordinate.self, forKey: .coordinates)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        locationId = try values.decodeIfPresent(String.self, forKey: .locationId)
        locationName = try values.decodeIfPresent(String.self, forKey: .locationName)
        thresholdDistanceInMeters = try values.decodeIfPresent(Int.self, forKey: .thresholdDistanceInMeters)
    }


}


struct ManualLocationCoordinate : Codable {

    let city : String?
    let country : String?
    let latitude : Float?
    let longitude : Float?
    let postalCode : String?


    enum CodingKeys: String, CodingKey {
        case city = "city"
        case country = "country"
        case latitude = "latitude"
        case longitude = "longitude"
        case postalCode = "postalCode"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        latitude = try values.decodeIfPresent(Float.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Float.self, forKey: .longitude)
        postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
    }


}
