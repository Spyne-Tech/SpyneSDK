//
//  AgnosticCatagoryModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 17/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation

struct AgnosticCatagoryRootClass : Codable {

    let data : AgnosticCatagoryData?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(AgnosticCatagoryData.self, forKey: .data)
            //try AgnosticCatagoryData(from: decoder)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }


}
struct AgnosticCatagoryData : Codable {

    let is360Enable : Int?
    let beforeAfter : Int?
    let camAngles : Int?
    let camClickGyroRed : Int?
    let camEnableExposure : Int?
    let camEnableTapFocus : Int?
    let camGridlines : Int?
    let camGyro : Int?
    let camGyroAzimuth : Int?
    let camGyroAzimuthAbs : String?
    let camGyroAzimuthVar : Int?
    let camGyroPitch : Int?
    let camGyroPitchVar : Int?
    let camGyroRoll : Int?
    let camGyroRollVar : Int?
    let camNumAngles : Int?
    let camOrientation : String?
    let camOverlays : Int?
    let cmGyroPitchAbs : String?
    let cmGyroRollAbs : String?
    let createdAt : String?
    let enterpriseId : String?
    let humanModels : Int?
    let id : Int?
    let isActive : Int?
    let isMultiSku : Int?
    let marketPlace : Int?
    let processSku : Int?
    let prodCatId : String?
    let prodSubCatId : String?
    let shootInstructions : String?
    let subCategories : Int?
    let updatedAt : String?


    enum CodingKeys: String, CodingKey {
        case is360Enable = "360_enable"
        case beforeAfter = "before_after"
        case camAngles = "cam_angles"
        case camClickGyroRed = "cam_click_gyro_red"
        case camEnableExposure = "cam_enable_exposure"
        case camEnableTapFocus = "cam_enable_tap_focus"
        case camGridlines = "cam_gridlines"
        case camGyro = "cam_gyro"
        case camGyroAzimuth = "cam_gyro_azimuth"
        case camGyroAzimuthAbs = "cam_gyro_azimuth_abs"
        case camGyroAzimuthVar = "cam_gyro_azimuth_var"
        case camGyroPitch = "cam_gyro_pitch"
        case camGyroPitchVar = "cam_gyro_pitch_var"
        case camGyroRoll = "cam_gyro_roll"
        case camGyroRollVar = "cam_gyro_roll_var"
        case camNumAngles = "cam_num_angles"
        case camOrientation = "cam_orientation"
        case camOverlays = "cam_overlays"
        case cmGyroPitchAbs = "cm_gyro_pitch_abs"
        case cmGyroRollAbs = "cm_gyro_roll_abs"
        case createdAt = "created_at"
        case enterpriseId = "enterprise_id"
        case humanModels = "human_models"
        case id = "id"
        case isActive = "is_active"
        case isMultiSku = "is_multi_sku"
        case marketPlace = "market_place"
        case processSku = "process_sku"
        case prodCatId = "prod_cat_id"
        case prodSubCatId = "prod_sub_cat_id"
        case shootInstructions = "shoot_instructions"
        case subCategories = "sub_categories"
        case updatedAt = "updated_at"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is360Enable = try values.decodeIfPresent(Int.self, forKey: .is360Enable)
        beforeAfter = try values.decodeIfPresent(Int.self, forKey: .beforeAfter)
        camAngles = try values.decodeIfPresent(Int.self, forKey: .camAngles)
        camClickGyroRed = try values.decodeIfPresent(Int.self, forKey: .camClickGyroRed)
        camEnableExposure = try values.decodeIfPresent(Int.self, forKey: .camEnableExposure)
        camEnableTapFocus = try values.decodeIfPresent(Int.self, forKey: .camEnableTapFocus)
        camGridlines = try values.decodeIfPresent(Int.self, forKey: .camGridlines)
        camGyro = try values.decodeIfPresent(Int.self, forKey: .camGyro)
        camGyroAzimuth = try values.decodeIfPresent(Int.self, forKey: .camGyroAzimuth)
        camGyroAzimuthAbs = try values.decodeIfPresent(String.self, forKey: .camGyroAzimuthAbs)
        camGyroAzimuthVar = try values.decodeIfPresent(Int.self, forKey: .camGyroAzimuthVar)
        camGyroPitch = try values.decodeIfPresent(Int.self, forKey: .camGyroPitch)
        camGyroPitchVar = try values.decodeIfPresent(Int.self, forKey: .camGyroPitchVar)
        camGyroRoll = try values.decodeIfPresent(Int.self, forKey: .camGyroRoll)
        camGyroRollVar = try values.decodeIfPresent(Int.self, forKey: .camGyroRollVar)
        camNumAngles = try values.decodeIfPresent(Int.self, forKey: .camNumAngles)
        camOrientation = try values.decodeIfPresent(String.self, forKey: .camOrientation)
        camOverlays = try values.decodeIfPresent(Int.self, forKey: .camOverlays)
        cmGyroPitchAbs = try values.decodeIfPresent(String.self, forKey: .cmGyroPitchAbs)
        cmGyroRollAbs = try values.decodeIfPresent(String.self, forKey: .cmGyroRollAbs)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        enterpriseId = try values.decodeIfPresent(String.self, forKey: .enterpriseId)
        humanModels = try values.decodeIfPresent(Int.self, forKey: .humanModels)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isActive = try values.decodeIfPresent(Int.self, forKey: .isActive)
        isMultiSku = try values.decodeIfPresent(Int.self, forKey: .isMultiSku)
        marketPlace = try values.decodeIfPresent(Int.self, forKey: .marketPlace)
        processSku = try values.decodeIfPresent(Int.self, forKey: .processSku)
        prodCatId = try values.decodeIfPresent(String.self, forKey: .prodCatId)
        prodSubCatId = try values.decodeIfPresent(String.self, forKey: .prodSubCatId)
        shootInstructions = try values.decodeIfPresent(String.self, forKey: .shootInstructions)
        subCategories = try values.decodeIfPresent(Int.self, forKey: .subCategories)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }


}
