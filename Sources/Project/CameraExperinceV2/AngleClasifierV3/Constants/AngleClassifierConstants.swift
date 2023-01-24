//
//  AngleClassifierConstants.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 04/01/23.
//

import Foundation

struct AngleClasifierConstants {
    
    static let CROSS_IMAGE = "crossv3"
    static let EXCLAIMATION_MARK_IMAGE = ""
    
    static let CROPPED_IMAGE = "Cropped Image"
    static let CROPPED_WTDN = "Please make sure the car is in frame and reshoot."
    
    static let ANGLE_NOT_MATCHING = "Angle not matching properly"
    static let ANGLE_NOT_MATCHING_WTDN = "Car angle not matching with overlay.  Please  re-align and reshoot."
    
    static let CAR_IS_FAR = "Car is far away"
    static let CAR_IS_TOO_CLOSE = "Car is too close"
    static let CAR_IS_FAR_WTDN = "Car is at distance.  Please move towards the car and reshoot."
    static let CAR_IS_TOO_CLOSE_WTDN = "Car is at close distance.  Please move away from the car and reshoot."
    
    static let SUROUNDING_TO_BRIGHT = "Surrounding too bright"
    static let SUROUNDING_TO_DIM = "Surrounding too dim"
    static let SUROUNDING_TO_BRIGHT_WTDN = "Image is too bright. Please move the car and reshoot."
    static let SUROUNDING_TO_DIM_WTDN = "Image is too dim. Please move the car and reshoot."

    
    static let TOO_MUCH_REFLECTION = "Reflection detected on car"
    static let TOO_MUCH_REFLECTION_WTDN = "Too much reflection on the car. Please move the car and reshoot."
    
    static let OBJECT_NOT_DETECTED = "Object not detected"
    static let OBJECT_NOT_DETECTED_WTDN = "Object was not detected. Please try reshooting again."
}
