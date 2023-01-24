//
//  AngleClassifierModel.swift
//  Spyne
//
//  Created by Rajesh Shiyal on 03/06/22.
//  Copyright © 2022 Spyne. All rights reserved.
//


import Foundation
import UIKit
struct AngleClassifierRoot : Codable {

    let data : AngleClassifierData?
    let message : String?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(AngleClassifierData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }


}

struct AngleClassifierData : Codable {
    
    let cropArray : AngleClassifierCropArray?
    let validAngle, carAngle : Bool?
    let validCategory : Bool?
    let distance, reflection, exposure: String?


    enum CodingKeys: String, CodingKey {
        case cropArray = "crop_array"
        case validAngle = "valid_angle"
        case validCategory = "valid_category"
        case carAngle = "car_angle"
        case distance, reflection, exposure
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cropArray = try values.decodeIfPresent(AngleClassifierCropArray.self, forKey: .cropArray)
        validAngle = try values.decodeIfPresent(Bool.self, forKey: .validAngle)
        validCategory = try values.decodeIfPresent(Bool.self, forKey: .validCategory)
        carAngle = try values.decodeIfPresent(Bool.self, forKey: .carAngle)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        reflection = try values.decodeIfPresent(String.self, forKey: .reflection)
        exposure = try values.decodeIfPresent(String.self, forKey: .exposure)
    }
}

struct AngleClassifierCropArray : Codable {

    let bottom : Bool?
    let left : Bool?
    let right : Bool?
    let top : Bool?


    enum CodingKeys: String, CodingKey {
        case bottom = "bottom"
        case left = "left"
        case right = "right"
        case top = "top"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bottom = try values.decodeIfPresent(Bool.self, forKey: .bottom)
        left = try values.decodeIfPresent(Bool.self, forKey: .left)
        right = try values.decodeIfPresent(Bool.self, forKey: .right)
        top = try values.decodeIfPresent(Bool.self, forKey: .top)
    }
}
struct AngleClassifierUploadImageModel {
    var image_file: UIImage?
    var required_angle:Int?
    var crop_check:Bool?

    
    init(image_file: UIImage? = nil , required_angle:Int? , crop_check:Bool? ) {
        self.image_file = image_file
        self.required_angle = required_angle
        self.crop_check = crop_check
       
    }
}
