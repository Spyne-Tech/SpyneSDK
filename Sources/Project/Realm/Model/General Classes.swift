//
//  General Classes.swift
//  Spyne
//
//  Created by Vijay Parmar on 16/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit

struct Angles{
    var overlayImage : String?
    var frameNo:Int?
    var capturedImage:UIImage?
    var currentAngle:Int?
    var uplodedImageUrl:String?
}

struct EcomImage{
    var image:UIImage
    var overlayId:String
    var frameSeqNo:Int
    var is_reclick:Bool
    var selectedAngle:Int
}

struct Tutorials{
    var title :String!
    var desc :String!
    var backColor : UIColor!
    var decColor :UIColor!
    var videoLink: String?
}

struct BeforeAfterImage{
    var beforeImage : String!
    var afterImage : String!
}

struct EcomProject{
    static var shared = EcomProject()
    var projectId:String?
    var enterpriseId:String?
    var skuDetail:EcomSku?
}

struct EcomSku{
    var prod_cat_id:String?
    var prod_sub_cat_id:String?
    var skuId:String?
    var sku_name:String?
    var images:[UIImage]?
    
}

struct SkuElements{
    var completedAngles: Int
    var noOfAngles:Int
    var noOfInteriorAngles: Int
    var noOfMisAngles: Int
    var interiorSkiped: Bool
    var misSkiped: Bool
    var is360IntSkiped: Bool
}

//MARK:- Structure AppUtility
struct AppUtility {
    ///orientation: is a variable hold the key for orientation
    static var orientationName = "orientation"
    
    //lockOrientation: Method for rotation Camera Screen  in landscape right side.
    /// Parameters: orientation & andRotateTo
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
        } else {
            UIDevice.current.setValue(orientation.toUIInterfaceOrientation.rawValue, forKey: orientationName)
        }
    }
}

//MARK:- Extension UIInterfaceOrientationMask
extension UIInterfaceOrientationMask {
    var toUIInterfaceOrientation: UIInterfaceOrientation {
        switch self {
        case .portrait:
            return UIInterfaceOrientation.portrait
        case .portraitUpsideDown:
            return UIInterfaceOrientation.portraitUpsideDown
        case .landscapeRight:
            return UIInterfaceOrientation.landscapeRight
        case .landscapeLeft:
            return UIInterfaceOrientation.landscapeLeft
        default:
            return UIInterfaceOrientation.unknown
        }
    }
}
