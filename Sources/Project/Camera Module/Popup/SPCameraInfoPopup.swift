//
//  SPCinfirmImagePopup.swift
//  Spyne
//
//  Created by Vijay Parmar on 26/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import SDWebImage
class SPCameraInfoPopup: UIViewController {

   
    @IBOutlet weak var lblTopInfo: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgImageGIF: UIImageView!
    
    var btnNextTapped : (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    func initialSetup(){
        
       // let animatedImage = SDAnimatedImage(named: "ic_create_shoot.gif")
       // imgImageGIF.image = animatedImage
        
        imgImageGIF.image = UIImage.gifImageWithName("ic_create_shoot")
        
        
        let  myAttributeBlack = [NSAttributedString.Key.foregroundColor :UIColor.black]
        let topTitle = NSMutableAttributedString(string: "Shoot" , attributes: myAttributeBlack as [NSAttributedString.Key : Any])
        let myAttributeOrange = [ NSAttributedString.Key.foregroundColor :UIColor.appColor]
        let outdoor = NSMutableAttributedString(string: " " + "Outdoors"  + " ", attributes: myAttributeOrange as [NSAttributedString.Key : Any])
        let title2 = NSMutableAttributedString(string: "avoid  irregular reflections" , attributes: myAttributeBlack as [NSAttributedString.Key : Any])
        topTitle.append(outdoor)
        topTitle.append(title2)
        lblTopInfo.attributedText = topTitle
        
        
        let bottomTitle = NSMutableAttributedString(string: "Move" , attributes: myAttributeBlack as [NSAttributedString.Key : Any])
        let left = NSMutableAttributedString(string: " " + "Left"  + " ", attributes: myAttributeOrange as [NSAttributedString.Key : Any])

        let bottomTitle2 = NSMutableAttributedString(string: "after each shot" , attributes: myAttributeBlack as [NSAttributedString.Key : Any])
        bottomTitle.append(left)
        bottomTitle.append(bottomTitle2)
       
        btnNext.backgroundColor = UIColor.appColor
        btnNext.setTitleColor(UIColor.white, for: .normal)
        btnNext.setTitle("Continue" , for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)

    }
    
    @IBAction func btnActionNext(_ sender: UIButton) {
        if let didNextTapped = btnNextTapped{
            didNextTapped()
        }
    }
    
    
}
