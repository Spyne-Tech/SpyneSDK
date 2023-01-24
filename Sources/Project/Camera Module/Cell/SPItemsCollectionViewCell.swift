//
//  SPItemsCollectionViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 26/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPItemsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var view360: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgOutput: UIImageView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
