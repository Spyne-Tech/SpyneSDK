//
//  SPProcessedImageTableViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 23/10/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPProcessedImageTableViewCell: UITableViewCell {

    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgBefore: UIImageView!
    @IBOutlet weak var imgAfter: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
