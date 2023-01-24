//
//  RealmSkuData.swift
//  Spyne
//
//  Created by Vijay Parmar on 02/02/22.
//  Copyright © 2022 Spyne. All rights reserved.
//

import Foundation
import RealmSwift
@objcMembers class RealmSkuData: Object {
    
    @Persisted var projectId: String = "" //Reffrence of Project Id
    @Persisted var skuId: String? = ""
    @Persisted var skuName: String? = ""
    @Persisted var completedAngles: Int = 0
    
    convenience init(projectId:String,skuId:String,skuName:String,completedAngles:Int) {
        self.init()
        self.projectId = projectId
        self.skuId = skuId
        self.skuName = skuName
        self.completedAngles = completedAngles
    }
}
