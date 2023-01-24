//
//  SPCategoryCollectionViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 19/07/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import ViewAnimator
class SPCategoryCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var viewSelection: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    override func awakeFromNib() {
        viewSelection.backgroundColor = UIColor.appColor
        lblCategoryName.textColor = UIColor.appColor
    }
    

}
