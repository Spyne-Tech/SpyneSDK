//
//  RealmeProjectData.swift
//  Spyne
//
//  Created by Vijay Parmar on 02/09/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProjectData: Object {
    
    @Persisted var authKey: String = ""
    @Persisted var prodCatId: String = ""
    @Persisted var subCatId = ""
    @Persisted var projectId: String = ""
    @Persisted var projectName = ""
    @Persisted var skuId: String? = ""
    @Persisted var imageCategory: String = ""
    @Persisted var completedAngles: Int = 0
    @Persisted var noOfAngles: Int = 0
    @Persisted var noOfInteriorAngles: Int = 0
    @Persisted var noOfMisAngles: Int = 0
    @Persisted var interiorSkiped: Bool = false
    @Persisted var misSkiped: Bool = false
    @Persisted var is360IntSkiped: Bool = false
    
    convenience init(authKey:String,prodCatId:String,subCatId:String,projectId: String,projectName:String,skuId:String,imageCategory:String,completedAngles:Int,noOfAngles:Int,noOfInteriorAngles:Int,noOfMisAngles:Int,interiorSkiped:Bool,misSkiped:Bool,is360IntSkiped:Bool) {
        
        self.init()
        self.authKey = authKey
        self.prodCatId = prodCatId
        self.subCatId = subCatId
        self.projectId = projectId
        self.projectName = projectName
        self.skuId = skuId
        self.imageCategory = imageCategory
        self.completedAngles = completedAngles
        self.noOfAngles = noOfAngles
        self.noOfInteriorAngles = noOfInteriorAngles
        self.noOfMisAngles = noOfMisAngles
        self.interiorSkiped = interiorSkiped
        self.misSkiped = misSkiped
        self.is360IntSkiped = is360IntSkiped
        
    }
}



