//
//  SPCategoryModel.swift
//  Spyne SDK
//
//  Created by Akash Verma on 03/08/22.
//

import Foundation
import UIKit

class CategoryMasterRoot: Codable {
    var data: [CategoryMasterData]
    var message: String

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
    }
    init(data: [CategoryMasterData], message: String) {
        self.data = data
        self.message = message
        
    }

    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.decodeIfPresent([CategoryMasterData].self, forKey: .data) ?? []
        let message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.init(data: data, message: message)
        
    }
}

@objcMembers class CategoryMasterData: Codable {
    dynamic var categoryId: String = ""
    dynamic var enableSingleProcessing: Bool = false
    dynamic var isActive: Bool = false
    dynamic var categoryName: String = ""
    dynamic var enterpriseId: String = ""
    dynamic var displayThumbnail: String = ""
    dynamic var colorCode: String = ""
    dynamic var descriptionField: String = ""
    dynamic var isThreeSixty: Bool = false
    dynamic var enableBackgroundSelection: Bool = false
    dynamic var fetchBackground: Bool = false
    dynamic var changeSkuBackgroundAfterShoot: Bool = false
    dynamic var orientation: String = ""
    dynamic var subcat_label: String = ""
    dynamic var isVideoShootAllowed: Bool = false
    dynamic var videoShoot: CategoryMasterVideoShoot?
    dynamic var shootExperience: CategoryMasterShootExperience?
    dynamic var numberPlate: [NumberPlateCategoryModel]?
    var imageCategories: [String]?
    var processParams: [CategoryMasterProcessParam]?
    var interior: [CategoryMasterInterior]?
    var miscellaneous: [CategoryMasterInterior]?
    var sdkInterior: [SubCategoryInterior]?
    var sdkMisc: [SubCategoryInterior]?
    var backgrounds: [CategoryMasterBackground]?
    var subCategories: [CategoryMasterSubCategory]?
    var crousel: [CategoryMasterCrousel]?

    func getProcessData() -> [CategoryMasterProcessParam] {
        return processParams ?? []
    }
    func getInterior() -> [CategoryMasterInterior] {
        return interior ?? []
    }
    func getMiscellaneous() -> [CategoryMasterInterior] {
        return miscellaneous ?? []
    }
    func getCrousel() -> [CategoryMasterCrousel] {
        return crousel ?? []
    }
    func getBackgrounds() -> [CategoryMasterBackground] {
        return backgrounds ?? []
    }
    
    func getSubCategories() -> [CategoryMasterSubCategory] {
        return subCategories ?? []
    }

    enum CodingKeys: String, CodingKey {
        case categoryId = "prod_cat_id"
        case enableSingleProcessing = "enable_single_processing"
        case isActive = "is_active"
        case categoryName = "category_name"
        case enterpriseId = "enterprise_id"
        case displayThumbnail = "display_thumbnail"
        case colorCode = "color_code"
        case descriptionField = "description"
        case isThreeSixty = "is_threeSixty"
        case enableBackgroundSelection = "enable_background_selection"
        case fetchBackground = "fetch_background"
        case changeSkuBackgroundAfterShoot = "change_sku_background_after_shoot"
        case orientation = "orientation"
        case isVideoShootAllowed = "is_video_shoot_allowed"
        case subcat_label = "subcat_label"
        case videoShoot = "video_shoot"
        case shootExperience = "shoot_experience"
        case numberPlate = "numberPlateList"
        case imageCategories = "image_categories"
        case processParams = "process_params"
        case interior = "interiorNotinUse"
        case miscellaneous = "MiscNotinUse"
        case backgrounds = "backgrounds"
        case subCategories = "sub_categories"
        case crousel = "crousel"
        case sdkInterior = "interior"
        case sdkMisc = "Misc"

    }
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId) ?? ""
        enableSingleProcessing = try values.decodeIfPresent(Bool.self, forKey: .enableSingleProcessing) ?? false
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName) ?? ""
        enterpriseId = try values.decodeIfPresent(String.self, forKey: .enterpriseId) ?? ""
        displayThumbnail = try values.decodeIfPresent(String.self, forKey: .displayThumbnail) ?? ""
        colorCode = try values.decodeIfPresent(String.self, forKey: .colorCode) ?? ""
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField) ?? ""
        isThreeSixty = try values.decodeIfPresent(Bool.self, forKey: .isThreeSixty) ?? false
        enableBackgroundSelection = try values.decodeIfPresent(Bool.self, forKey: .enableBackgroundSelection) ?? false
        fetchBackground = try values.decodeIfPresent(Bool.self, forKey: .fetchBackground) ?? false
        changeSkuBackgroundAfterShoot = try values.decodeIfPresent(Bool.self, forKey: .changeSkuBackgroundAfterShoot) ?? false
        orientation = try values.decodeIfPresent(String.self, forKey: .orientation) ?? ""
        subcat_label = try values.decodeIfPresent(String.self, forKey: .subcat_label) ?? ""
        isVideoShootAllowed = try values.decodeIfPresent(Bool.self, forKey: .isVideoShootAllowed) ?? false
        videoShoot = try values.decodeIfPresent(CategoryMasterVideoShoot.self, forKey: .videoShoot)
        shootExperience = try values.decodeIfPresent(CategoryMasterShootExperience.self, forKey: .shootExperience)
        numberPlate = try values.decodeIfPresent([NumberPlateCategoryModel].self, forKey: .numberPlate)
        crousel = try values.decodeIfPresent([CategoryMasterCrousel].self, forKey: .crousel) ?? []
        imageCategories = try values.decodeIfPresent([String].self, forKey: .imageCategories) ?? []
        processParams = try values.decodeIfPresent([CategoryMasterProcessParam].self, forKey: .processParams) ?? []
        interior = try values.decodeIfPresent([CategoryMasterInterior].self, forKey: .interior) ?? []
        miscellaneous = try values.decodeIfPresent([CategoryMasterInterior].self, forKey: .miscellaneous) ?? []
        backgrounds = try values.decodeIfPresent([CategoryMasterBackground].self, forKey: .backgrounds) ?? []
        subCategories = try values.decodeIfPresent([CategoryMasterSubCategory].self, forKey: .subCategories) ?? []
        sdkInterior = try values.decode([SubCategoryInterior].self, forKey: .sdkInterior)
        sdkMisc = try values.decode([SubCategoryInterior].self, forKey: .sdkMisc)
    }

}

@objcMembers class CategoryMasterVideoShoot: Codable {
    
    dynamic var minimumDuration : Int = 0
    dynamic var videoFrameSelection : Bool = false
    var videoFrames: [Int]?


    enum CodingKeys: String, CodingKey {
        case minimumDuration = "minimum_duration"
        case videoFrameSelection = "video_frame_selection"
        case videoFrames = "video_frames"
    }
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        minimumDuration = try values.decodeIfPresent(Int.self, forKey: .minimumDuration) ?? 0
        videoFrameSelection = try values.decodeIfPresent(Bool.self, forKey: .videoFrameSelection) ?? false
        videoFrames = try values.decodeIfPresent([Int].self, forKey: .videoFrames) ?? []
    }
}
                                            
@objcMembers class CategoryMasterSubCategory: Codable {
    dynamic var  prodSubCatId: String = ""
    dynamic var  prodCatId: String = ""
    dynamic var  subCatName: String = ""
    dynamic var  displayThumbnail: String = ""
    dynamic var  cameraSettings: CategoryMasterCameraSetting?
    dynamic var  brightness: Int = 0
    dynamic var  focus: Int = 0
    dynamic var  exposer: Int = 0
    dynamic var  enableTapFocuseExposure: Int = 0
    var overlays: [CategoryMasterOverlay]?

    enum CodingKeys: String, CodingKey {
        case prodSubCatId = "prod_sub_cat_id"
        case prodCatId = "prod_cat_id"
        case subCatName = "sub_cat_name"
        case displayThumbnail = "display_thumbnail"
        case cameraSettings = "camera_settings"
        case brightness = "brightness"
        case focus = "focus"
        case exposer = "exposer"
        case enableTapFocuseExposure = "enable_tap_focuse_exposure"
        case overlays = "overlays"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        prodSubCatId = try values.decodeIfPresent(String.self, forKey: .prodSubCatId) ?? ""
        prodCatId = try values.decodeIfPresent(String.self, forKey: .prodCatId) ?? ""
        subCatName = try values.decodeIfPresent(String.self, forKey: .subCatName) ?? ""
        displayThumbnail = try values.decodeIfPresent(String.self, forKey: .displayThumbnail) ?? ""
        cameraSettings = try values.decodeIfPresent(CategoryMasterCameraSetting.self, forKey: .cameraSettings)
        brightness = try values.decodeIfPresent(Int.self, forKey: .brightness) ?? 0
        focus = try values.decodeIfPresent(Int.self, forKey: .focus) ?? 0
        exposer = try values.decodeIfPresent(Int.self, forKey: .exposer) ?? 0
        enableTapFocuseExposure = try values.decodeIfPresent(Int.self, forKey: .enableTapFocuseExposure) ?? 0
        overlays = try values.decodeIfPresent([CategoryMasterOverlay].self, forKey: .overlays) ?? []
    }
}

@objcMembers class CategoryMasterCameraSetting: Codable {
    
    dynamic var  showOverlays: Bool = false
    dynamic var  showGyro: Bool = false
    dynamic var  showGrid: Bool = false
    dynamic var  pitchVar: Int = 0
    dynamic var  rollVar: Int = 0
    var roll: [Int]?
    var pitch: [Int]?

    enum CodingKeys: String, CodingKey {
       
        case showOverlays = "show_overlays"
        case showGyro = "show_gyro"
        case showGrid = "show_grid"
        case pitchVar = "pitch_var"
        case rollVar = "roll_var"
        case pitch = "pitch"
        case roll = "roll"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        showOverlays = try values.decodeIfPresent(Bool.self, forKey: .showOverlays) ?? false
        showGyro = try values.decodeIfPresent(Bool.self, forKey: .showGyro) ?? false
        showGrid = try values.decodeIfPresent(Bool.self, forKey: .showGrid) ?? false
        pitchVar = try values.decodeIfPresent(Int.self, forKey: .pitchVar) ?? 0
        rollVar = try values.decodeIfPresent(Int.self, forKey: .rollVar) ?? 0
        roll = try values.decodeIfPresent([Int].self, forKey: .roll) ?? []
        pitch = try values.decodeIfPresent([Int].self, forKey: .pitch) ?? []
    }
}

 class CategoryMasterOverlay: Codable {
     @objc dynamic var id: Int = 0
     @objc dynamic var prodCatId: String = ""
     @objc dynamic var prodSubCatId: String = ""
     @objc dynamic var overlayId: String = ""
     @objc dynamic var enterpriseId: String = ""
     @objc dynamic var displayName: String = ""
     @objc dynamic var angleName: String = ""
     @objc dynamic var frameAngle: String = ""
     @objc dynamic var type: String = ""
     @objc dynamic var angles: Int = 0
     @objc dynamic var displayThumbnail: String = ""
     @objc dynamic var pitch: Int = 0
     @objc dynamic var active: Int = 0
     @objc dynamic var priority: Int = 0
     @objc dynamic var createdAt: String = ""
     @objc dynamic var updatedAt: String = ""
    
    dynamic var clickedImage: UIImage? = nil
    dynamic var clickedAngle = false
    dynamic var frameSeqNo = 0


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case prodCatId = "prod_cat_id"
        case prodSubCatId = "prod_sub_cat_id"
        case overlayId = "overlay_id"
        case enterpriseId = "enterprise_id"
        case displayName = "display_name"
        case angleName = "angle_name"
        case frameAngle = "frame_angle"
        case type = "type"
        case angles = "angles"
        case displayThumbnail = "display_thumbnail"
        case pitch = "pitch"
        case active = "active"
        case priority = "priority"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        prodCatId = try values.decodeIfPresent(String.self, forKey: .prodCatId) ?? ""
        prodSubCatId = try values.decodeIfPresent(String.self, forKey: .prodSubCatId) ?? ""
        overlayId = try values.decodeIfPresent(String.self, forKey: .overlayId) ?? ""
        enterpriseId = try values.decodeIfPresent(String.self, forKey: .enterpriseId) ?? ""
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName) ?? ""
        angleName = try values.decodeIfPresent(String.self, forKey: .angleName) ?? ""
        frameAngle = try values.decodeIfPresent(String.self, forKey: .frameAngle) ?? ""
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? ""
        angles = try values.decodeIfPresent(Int.self, forKey: .angles) ?? 0
        displayThumbnail = try values.decodeIfPresent(String.self, forKey: .displayThumbnail) ?? ""
        pitch = try values.decodeIfPresent(Int.self, forKey: .pitch) ?? 0
        active = try values.decodeIfPresent(Int.self, forKey: .active) ?? 0
        priority = try values.decodeIfPresent(Int.self, forKey: .priority) ?? 0
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }
}

@objcMembers class CategoryMasterShootExperience: Codable {
    dynamic var showShootInstructions: Bool = false
    dynamic var isMultiSku: Bool = false
    dynamic var frameSelection: Bool = false
    dynamic var perspectiveCropping: Bool = false
    dynamic var hasSubcategories: Bool = false
    dynamic var canChangeSubcategories: Bool = false
    dynamic var addMoreAngles: Bool = false
    dynamic var shootInstructions: CategoryMasterShootInstruction?

    var angles: [Int]?
    var frames: [Int]?

    enum CodingKeys: String, CodingKey {
        case showShootInstructions = "show_shoot_instructions"
        case isMultiSku = "is_multiSku"
        case frameSelection = "frame_selection"
        case perspectiveCropping = "perspective_cropping"
        case hasSubcategories = "has_subcategories"
        case canChangeSubcategories = "can_change_subcategories"
        case addMoreAngles = "add_more_angles"
        case angles = "angles"
        case frames = "frames"
        case shootInstructions = "shoot_instructions"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        showShootInstructions = try values.decodeIfPresent(Bool.self, forKey: .showShootInstructions) ?? false
        isMultiSku = try values.decodeIfPresent(Bool.self, forKey: .isMultiSku) ?? false
        frameSelection = try values.decodeIfPresent(Bool.self, forKey: .frameSelection) ?? false
        perspectiveCropping = try values.decodeIfPresent(Bool.self, forKey: .perspectiveCropping) ?? false
        hasSubcategories = try values.decodeIfPresent(Bool.self, forKey: .hasSubcategories) ?? false
        canChangeSubcategories = try values.decodeIfPresent(Bool.self, forKey: .canChangeSubcategories) ?? false
        addMoreAngles = try values.decodeIfPresent(Bool.self, forKey: .addMoreAngles) ?? false
        shootInstructions = try values.decodeIfPresent(CategoryMasterShootInstruction.self, forKey: .shootInstructions)
        angles = try values.decodeIfPresent([Int].self, forKey: .angles) ?? []
        frames = try values.decodeIfPresent([Int].self, forKey: .frames) ?? []
    }
}

@objcMembers class CategoryMasterShootInstruction: Codable {
    dynamic var cta : String = ""
    dynamic var title : String = ""
    dynamic var url : String = ""

    enum CodingKeys: String, CodingKey {
        case cta = "cta"
        case title = "title"
        case url = "url"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        cta = try values.decodeIfPresent(String.self, forKey: .cta) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
}

@objcMembers class CategoryMasterProcessParam: Codable {
    dynamic var id: Int = 0
    dynamic var defaultValue: Bool = false
    dynamic var fieldName: String = ""
    dynamic var fieldType: String = ""
    dynamic var fieldId: String = ""
    dynamic var isRequired: Bool = false


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case defaultValue = "default_value"
        case fieldName = "field_name"
        case fieldType = "field_type"
        case fieldId = "field_id"
        case isRequired = "is_required"

    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        defaultValue = try values.decodeIfPresent(Bool.self, forKey: .defaultValue) ?? false
        fieldId = try values.decodeIfPresent(String.self, forKey: .fieldId) ?? ""
        fieldName = try values.decodeIfPresent(String.self, forKey: .fieldName) ?? ""
        fieldType = try values.decodeIfPresent(String.self, forKey: .fieldType) ?? ""
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        isRequired = try values.decodeIfPresent(Bool.self, forKey: .isRequired) ?? false
    }
}

@objcMembers class CategoryMasterInterior: Codable {
    dynamic var displayName: String = ""
    dynamic var displayThumbnail: String = ""
    dynamic var id: Int = 0
    dynamic var prodCatId: String = ""
    dynamic var prodSubCatId: String = ""
    
    dynamic var clickedAngle = false
    dynamic var frameSeqNo = 0
    dynamic var clickedImage : UIImage?
    dynamic var imageUrl : String?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case displayThumbnail = "display_thumbnail"
        case id = "id"
        case prodCatId = "prod_cat_id"
        case prodSubCatId = "prod_sub_cat_id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName) ?? ""
        displayThumbnail = try values.decodeIfPresent(String.self, forKey: .displayThumbnail) ?? ""
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        prodCatId = try values.decodeIfPresent(String.self, forKey: .prodCatId) ?? ""
        prodSubCatId = try values.decodeIfPresent(String.self, forKey: .prodSubCatId) ?? ""
    }
}

@objcMembers class CategoryMasterCrousel: Codable {
    dynamic var afterImage: String = ""
    dynamic var beforeImage: String = ""

    enum CodingKeys: String, CodingKey {
        case afterImage = "after_image"
        case beforeImage = "before_image"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        afterImage = try values.decodeIfPresent(String.self, forKey: .afterImage) ?? ""
        beforeImage = try values.decodeIfPresent(String.self, forKey: .beforeImage) ?? ""
    }
}

@objcMembers class CategoryMasterBackground:  Codable {
    dynamic var backgroundId: String = ""
    dynamic var backgroundName: String = ""
    dynamic var backgroundImageUrl: String = ""
    dynamic var lowResImageUrl: String = ""
    dynamic var gifUrl: String = ""
    dynamic var backgroundCredit: Int = 0
    dynamic var prodCatId: String = ""
    dynamic var prodSubCatId: String = ""

    dynamic var appPosition: Int = 0
    dynamic var webPosition: Int = 0

    enum CodingKeys: String, CodingKey {
        
        case backgroundId = "backgroundId"
        case backgroundName = "bgName"
        case backgroundImageUrl = "backgroundImageUrl"
        case lowResImageUrl = "lowResImageUrl"
        case gifUrl = "gifUrl"
        case backgroundCredit = "backgroundCredit"
        case prodCatId = "prodCatId"
        case prodSubCatId = "prodSubCatId"
        case appPosition = "appPosition"
        case webPosition = "webPosition"
    
    }
    
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        backgroundId = try values.decodeIfPresent(String.self, forKey: .backgroundId) ?? ""
        backgroundName = try values.decodeIfPresent(String.self, forKey: .backgroundName) ?? ""
        backgroundImageUrl = try values.decodeIfPresent(String.self, forKey: .backgroundImageUrl) ?? ""
        lowResImageUrl = try values.decodeIfPresent(String.self, forKey: .lowResImageUrl) ?? ""
        gifUrl = try values.decodeIfPresent(String.self, forKey: .gifUrl) ?? ""
        backgroundCredit = try values.decodeIfPresent(Int.self, forKey: .backgroundCredit) ?? 0
        prodCatId = try values.decodeIfPresent(String.self, forKey: .prodCatId) ?? ""
        prodSubCatId = try values.decodeIfPresent(String.self, forKey: .prodSubCatId) ?? ""
        appPosition = try values.decodeIfPresent(Int.self, forKey: .appPosition) ?? 0
        webPosition = try values.decodeIfPresent(Int.self, forKey: .webPosition) ?? 0
    }

}

struct CategoryModel : Codable {
    
    let data : [CategoryResponseDTO]?
    let message : String?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([CategoryResponseDTO].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
}

struct CategoryResponseDTO : Codable {
    
    let categoryId : String
    let categoryName : String
    let borderColor : String
    let unselectedFillColor : String
    let thumbnail : String
    let selectedFillColor : String
    let priority : Int

    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case categoryName = "category_name"
        case borderColor = "border_color"
        case unselectedFillColor = "unselected_fill_color"
        case thumbnail = "thumbnail"
        case selectedFillColor = "selected_fill_color"
        case priority = "priority"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId) ?? ""
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName) ?? ""
        borderColor = try values.decodeIfPresent(String.self, forKey: .borderColor) ?? ""
        unselectedFillColor = try values.decodeIfPresent(String.self, forKey: .unselectedFillColor) ?? ""
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail) ?? ""
        selectedFillColor = try values.decodeIfPresent(String.self, forKey: .selectedFillColor) ?? ""
        priority = try values.decodeIfPresent(Int.self, forKey: .priority) ?? 0
    }
}

struct NumberPlateCategoryModel: Codable {
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
