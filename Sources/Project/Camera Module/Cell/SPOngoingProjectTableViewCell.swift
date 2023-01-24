//
//  SPOngoingProjectTableViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 28/07/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class SPOngoingProjectTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imgProject: UIImageView!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblImages: UILabel!
    @IBOutlet weak var lblSKU: UILabel!
    @IBOutlet weak var view360: UIView!
    @IBOutlet weak var activity: NVActivityIndicatorView!
    @IBOutlet weak var lblCompletedCount: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var skuTitleLabel: UILabel!
    @IBOutlet weak var imagesTitleLabel: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
