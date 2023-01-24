//
//  ConfigurationViewModel.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 29/11/22.
//

import Foundation

//MARK: Configurator
class Configurator {
    
    ///getSubcategories: Returns subCategories
    func getSubcategories() -> [CategoryMasterSubCategory] {
        let subCategories = Storage.shared.getCatagoryMasterData()?.data.first?.subCategories ?? []
        return subCategories
    }
    
    ///getBackgrounds: Returns background
    func getBackgrounds() -> [CategoryMasterBackground]{
        let backGrounds = Storage.shared.getCatagoryMasterData()?.data.first?.backgrounds ?? []
        return backGrounds
    }

    ///getNumberPlates: returns number plate
    func getNumberPlates() -> [NumberPlateCategoryModel] {
        let numberPlates = Storage.shared.getCatagoryMasterData()?.data.first?.numberPlate ?? []
        return numberPlates
    }
    
    ///getFrames: returns Frame
    func getFrames() -> Int {
//        let masterModel = Storage.shared.getCatagoryMasterData()
//        let frames = masterModel?.data.first?.shootExperience?.frames
//        let frame = frames?.first ?? 0
        return SpyneSDK.shared.frameNumber
    }
    
    ///getOverlays: get the overlays from the backend
    func getOverlays(prod_id: String,prod_sub_cat_id:String,no_of_frames:String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        Network.request(.getOverlays(prod_id: prod_id, prod_sub_cat_id: prod_sub_cat_id, no_of_frames: no_of_frames), decodeType: OverlayRootClass.self, errorDecodeType: OverlayRootClass.self, decoder: JSONDecoder(), success: { result in
            print(result)
            if result.status == 200{
                LocalOverlays.ExteriorOverlayData = result.data ?? []
                onSuccess()
            } else {
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            print(errorResult?.message as Any)
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
}
