//
//  ViewExtention.swift
//  Spyne
//
//  Created by Vijay on 18/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    @IBInspectable
    public var isViewAppColor: Bool{
        get {
            return self.backgroundColor == UIColor.appColor
        }
        set {
            self.backgroundColor = UIColor.appColor
        }
    }
    
    func setShadow(width: CGFloat ,height: CGFloat , color: UIColor , radius: CGFloat , opacity: Float ) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: width, height: height )
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
    }
}
