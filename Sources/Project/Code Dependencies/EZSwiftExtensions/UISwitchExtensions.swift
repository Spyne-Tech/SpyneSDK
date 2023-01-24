//
//  UISwitchExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 4/22/16.
//  Copyright © 2016 Goktug Yilmaz. All rights reserved.
//

#if os(iOS)

import UIKit

extension UISwitch {

	/// EZSE: toggles Switch
	public func toggle() {
		self.setOn(!self.isOn, animated: true)
	}
}

extension UITextField{
    
    func setRightImage(rightImage : UIImage? , rightImagePadding : CGFloat = 0 , action: (() -> Void)? = nil){
        
        if rightImage == nil{
            
            self.rightView = nil
        }
        else{
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
            containerView.backgroundColor = .clear
            
            let imageViewRight = UIImageView(frame: CGRect(x: 0 + rightImagePadding, y: 0 + rightImagePadding, width: (self.frame.size.height - (rightImagePadding * 2)), height: (self.frame.size.height - (rightImagePadding * 2))))
            
            imageViewRight.contentMode = .scaleAspectFit
            imageViewRight.image = rightImage
            containerView.addSubview(imageViewRight)
            
            if let action = action{
                
                containerView.isUserInteractionEnabled = true
                containerView.addGestureRecognizer(BindableGestureRecognizer(action: {
                   action()
                }))
            }
            
            self.rightView = containerView
            self.rightViewMode = .always
        }
    }
    
    func setLeftImage(leftImage : UIImage? , leftImagePadding : CGFloat = 0){
        
        if leftImage == nil{
            
            self.leftView = nil
        }
        else{
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
            containerView.backgroundColor = .clear
            
            let imageViewRight = UIImageView(frame: CGRect(x: 0 + leftImagePadding, y: 0 + leftImagePadding, width: (self.frame.size.height - (leftImagePadding * 2)), height: (self.frame.size.height - (leftImagePadding * 2))))
            
            imageViewRight.contentMode = .scaleAspectFit
            imageViewRight.image = leftImage
            containerView.addSubview(imageViewRight)
            
            self.leftView = containerView
            self.leftViewMode = .always
        }
    }
}

#endif
