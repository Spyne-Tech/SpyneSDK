//
//  SPDownloadCompletedVC.swift
//  Spyne
//
//  Created by Vijay on 19/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import SDWebImage

class SPDownloadCompletedVC: UIViewController {

   
    @IBOutlet weak var lblFeaturedText: UILabel!
    @IBOutlet weak var imgImageProcessing: UIImageView!
    @IBOutlet weak var btnOngoingProject: UIButton!
    @IBOutlet weak var startNewShootButton: UIButton!
    
    var arrAnimatelabels = [NSAttributedString]()
    var animTextIndex = 1
    var timer : Timer?
    override func viewDidLoad() {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        timer?.invalidate()
        timer = nil
    }
    
    //MARK:- Function
    func initialSetup()  {
        DraftStorage.reset()
        self.title = "Processing" 
        btnOngoingProject.setTitle("  Ongoing projects" , for: .normal)
        startNewShootButton.setTitle("Start a new shoot" , for: .normal)
        createLableString()
        self.navigationItem.hidesBackButton = true
        btnOngoingProject.setTitleColor(UIColor.appColor, for: .normal)
        btnOngoingProject.layer.borderColor = UIColor.appColor?.cgColor
        btnOngoingProject.tintColor = UIColor.appColor
       // imgImageProcessing.image = UIImage.gifImageWithName("ic_image_processing")
        self.title = "Processing" 
       
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)

    }
    
    
    internal func createLableString(){
        //String 1
        var myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.appColor!]
        var title1 = NSMutableAttributedString(string: "Recognizing your car" , attributes: myAttribute )
        arrAnimatelabels.append(title1)
        if lblFeaturedText.text == ""{
            lblFeaturedText.attributedText = title1
        }
        //String 2
        myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
        title1 = NSMutableAttributedString(string: "Driving the car to our studio" , attributes: myAttribute )
        arrAnimatelabels.append(title1)
        
        //String 3
        myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
        title1 = NSMutableAttributedString(string: "Removing that dirty backgorund" , attributes: myAttribute )
        arrAnimatelabels.append(title1)
        
        //String 4
        myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.appColor!]
        title1 = NSMutableAttributedString(string: "Cleaning everything up" , attributes: myAttribute )
        arrAnimatelabels.append(title1)
        
        //String 5
        myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
        title1 = NSMutableAttributedString(string: "Generating the Car Shadows" , attributes: myAttribute )
        arrAnimatelabels.append(title1)
        
        //String 7
        myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
        title1 = NSMutableAttributedString(string: "Building a personalized background for your car" , attributes: myAttribute )
        arrAnimatelabels.append(title1)
       
        
        //String 8
        myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
        title1 = NSMutableAttributedString(string: "Customizing your number plate branding" , attributes: myAttribute )
        arrAnimatelabels.append(title1)
        
        //String 9
        myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
        title1 = NSMutableAttributedString(string: "Giving Final Touches" , attributes: myAttribute )
        arrAnimatelabels.append(title1)
        
    }
    
    @objc func fireTimer() {
        
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push //1.
        animation.subtype = CATransitionSubtype.fromTop
        self.lblFeaturedText.attributedText = arrAnimatelabels[animTextIndex]
        animation.duration = 1.0
        self.lblFeaturedText.layer.add(animation, forKey: CATransitionType.push.rawValue)//2.
        
        if animTextIndex == arrAnimatelabels.count-1{
            animTextIndex = 0
        }else{
            animTextIndex = animTextIndex + 1
        }
        
    }
    
    
    //MARK:- Button Action
    @IBAction func btnActionstartNewShoot(_ sender: UIButton) {
//        AppDelegate.navToHome(selectedIndex: 1)
    }
    
    @IBAction func btnActionOnGoingProject(_ sender: UIButton) {
//        SPCarbonKitProjectVC.currentTabIndex = 1
//        AppDelegate.navToHome(selectedIndex: 2)
        
    }
    
   
}
