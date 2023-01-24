//
//  UIButtonExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
//import SDWebImage

extension UIButton {
	/// EZSwiftExtensions

	// swiftlint:disable function_parameter_count
	public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, target: AnyObject, action: Selector) {
		self.init(frame: CGRect(x: x, y: y, width: w, height: h))
		addTarget(target, action: action, for: UIControl.Event.touchUpInside)
	}
	// swiftlint:enable function_parameter_count

	/// EZSwiftExtensions
	public func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.setBackgroundImage(colorImage, for: forState)
	}
//    func animateLike(completion: complitionBlock? = nil) {
//        if isSelected {
//            UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
//                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//            }, completion: {(_ finished: Bool) -> Void in
//                self.isSelected = !self.isSelected
//                UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
//                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                }, completion: {(_ finished: Bool) -> Void in
//                    if let block = completion {
//                        block()
//                    }
//                })
//            })
//        }
//        else {
//            UIView.animate(withDuration: 0.25, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
//                let tScale = CGAffineTransform(scaleX: 1.6, y: 1.6)
//                let tRotate = CGAffineTransform(rotationAngle: -0.15)
//                self.transform = tScale.concatenating(tRotate)
//            }, completion: {(_ finished: Bool) -> Void in
//                UIView.animate(withDuration: 0.25, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
//                    let tScale = CGAffineTransform(scaleX: 0.2, y: 0.2)
//                    let tRotate = CGAffineTransform(rotationAngle: 0)
//                    self.transform = tScale.concatenating(tRotate)
//                }, completion: {(_ finished: Bool) -> Void in
//                    self.isSelected = !self.isSelected
//                    UIView.animate(withDuration: 0.25, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
//                        let tScale = CGAffineTransform(scaleX: 1.6, y: 1.6)
//                        let tRotate = CGAffineTransform(rotationAngle: 0.15)
//                        self.transform = tScale.concatenating(tRotate)
//                    }, completion: {(_ finished: Bool) -> Void in
//                        UIView.animate(withDuration: 0.25, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
//                            let tScale = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                            let tRotate = CGAffineTransform(rotationAngle: 0)
//                            self.transform = tScale.concatenating(tRotate)
//                        }, completion: {(_ finished: Bool) -> Void in
//                            if let block = completion {
//                                block()
//                            }
//                        })
//                    })
//                })
//            })
//        }
//
//    }
    
    
    
//    func setImage(with url : String?, isShowLoader : Bool = true, placeholderImage: UIImage? = nil){
//        
//        guard let url = url else {
//            return
//        }
//        
//        self.sd_setIndicatorStyle(.gray)
//        self.sd_showActivityIndicatorView()
//        if url != ""{
//            self.sd_setImage(with: URL(string: url), for: .normal, placeholderImage: placeholderImage,  completed: nil)
//        }
//        
//    }
//    
//    func setBackGroundImage(with url : String?, isShowLoader : Bool = true, placeholderImage: UIImage? = nil){
//        
//        guard let url = url else {
//            return
//        }
//        
//        self.sd_setIndicatorStyle(.gray)
//        self.sd_showActivityIndicatorView()
//        if url != ""{
//            self.sd_setBackgroundImage(with: URL(string: url), for: .normal, placeholderImage: placeholderImage,  completed: nil)
//        }
//    }
    
    
}

#endif
