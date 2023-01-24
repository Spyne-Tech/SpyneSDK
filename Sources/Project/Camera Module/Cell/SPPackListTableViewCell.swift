//
//  SPPackListTableViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 05/07/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPPackListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var imgRadioFill: UIImageView!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var lblDollarPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
