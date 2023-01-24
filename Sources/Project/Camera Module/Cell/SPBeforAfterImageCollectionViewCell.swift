//
//  SPBeforAfterImageCollectionViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 18/06/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPBeforAfterImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgBefore: UIImageView!
    @IBOutlet weak var imgAfter: UIImageView!
    @IBOutlet weak var beforeLabel: UILabel!
    @IBOutlet weak var afterLabel: UILabel!
    
    
    override class func awakeFromNib() {
        
    }
}
