//
//  SPStudioSetupModel.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 01/12/22.
//

import Foundation

//MARK: - SPStudioSetupModel
struct SPStudioSetupModel {
    static var skuName: String?
    static var categoryId: String?
    static var backgroundId: String?
    static var numberPlateId: String?
    static var subCategoryID: String?
}

//MARK: - SPStudioShootStatusModel
struct SPStudioShootStatusModel {
    var onExterior: Bool
    var exteriorDone: Bool
    var onInterior: Bool
    var interiorDone: Bool
    var onMisc: Bool
    var miscDone:Bool
}

//MARK: - ShootType
enum ShootType {
    case Exterior
    case Interior
    case Misc
}

//MARK: - LocalOverlays
struct LocalOverlays {
    static var ExteriorOverlayData: [OverlayData]?
    static var InteriorOverlaysData: [CategoryMasterInterior]?
    static var MiscelenousOverlayData: [CategoryMasterInterior]?
}

//MARK: - getExteriorOverlayData
func getExteriorOverlayData() -> [OverlayData] {
    return LocalOverlays.ExteriorOverlayData ?? []
}

//MARK: - getInteriorOverlayData
func getInteriorOverlayData() -> [CategoryMasterInterior] {
    return LocalOverlays.InteriorOverlaysData ?? []
}

//MARK: - getMisclenousOverlayData
func getMisclenousOverlayData() -> [CategoryMasterInterior] {
    return LocalOverlays.MiscelenousOverlayData ?? []
}
