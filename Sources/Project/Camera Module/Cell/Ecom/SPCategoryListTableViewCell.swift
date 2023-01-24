//
//  SPCategoryListTableViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 17/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPCategoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgCategoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setGradientBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.appColor!.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0.3)
        gradientLayer.endPoint = CGPoint(x:1.0, y: 0.3)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

        viewContent.layer.insertSublayer(gradientLayer, at: 0)
    }

}
