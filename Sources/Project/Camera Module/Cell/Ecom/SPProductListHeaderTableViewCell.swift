//
//  SPProductListHeaderTableViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 17/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPProductListHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var btnAddImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
