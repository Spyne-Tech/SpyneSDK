//
//  SPShootSelectionV2PopUpView.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 08/12/22.
//

import UIKit

protocol ShootTypeViewDelegate {
    func skipButtonTapped()
    func shootNowButtonTapped()
}

class SPShootSelectionV2PopUpView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var shootTitleLabel: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var label4: UILabel!
    
    var delegate: ShootTypeViewDelegate?
    var interiorImagesArray = ["dashboardOverlay","floorOverlay","seatOverlay","doorOverlay"]
    var interiorLabelArray = ["Dashboard","Floor","Seat","Door Panels"]
    var miscImagesArray = ["hoodOverlay","keyringOverlay","dashboardOverlay","wheelsOverlay"]
    var miscLabelArray = ["Bonnet","Key","Dashboard","Tyre"]
    
    ///overriding the init of frame so that view can maintain its own frame from the common init.
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    ///overriding the frame init requires the coder init.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //MARK: Class functions
    /// commonInit: Commoninit is a private initializer which will initialize the whole view.
    func commonInit() {
        Bundle.spyneSDK.loadNibNamed("SPShootSelectionV2PopUpView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setUpValues(shootType: ShootType){
        if shootType == .Interior {
            self.shootTitleLabel.text = "Interior Shoot"
            image1.setImage(UIImage(named: interiorImagesArray[0],in: Bundle.spyneSDK, with: nil)!)
            image2.setImage(UIImage(named: interiorImagesArray[1],in: Bundle.spyneSDK, with: nil)!)
            image3.setImage(UIImage(named: interiorImagesArray[2],in: Bundle.spyneSDK, with: nil)!)
            image4.setImage(UIImage(named: interiorImagesArray[3],in: Bundle.spyneSDK, with: nil)!)
            label1.text = interiorLabelArray[0]
            label2.text = interiorLabelArray[1]
            label3.text = interiorLabelArray[2]
            label4.text = interiorLabelArray[3]
        } else {
            self.shootTitleLabel.text = "Miscellaneous Shots"
            image1.setImage(UIImage(named: miscImagesArray[0],in: Bundle.spyneSDK, with: nil)!)
            image2.setImage(UIImage(named: miscImagesArray[1],in: Bundle.spyneSDK, with: nil)!)
            image3.setImage(UIImage(named: miscImagesArray[2],in: Bundle.spyneSDK, with: nil)!)
            image4.setImage(UIImage(named: miscImagesArray[3],in: Bundle.spyneSDK, with: nil)!)
            label1.text = miscLabelArray[0]
            label2.text = miscLabelArray[1]
            label3.text = miscLabelArray[2]
            label4.text = miscLabelArray[3]
        }
    }
    
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        delegate?.skipButtonTapped()
    }
    
    @IBAction func shootNowButtonTapped(_ sender: Any) {
        delegate?.shootNowButtonTapped()
    }
}
