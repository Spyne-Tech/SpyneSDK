//
//  SPCompleteProjectTableViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 28/07/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class SPCompleteProjectTableViewCell: UITableViewCell {

    
    @IBOutlet weak var view360: UIView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var imgProject: UIImageView!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblImages: UILabel!
    @IBOutlet weak var lblSKU: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var ImageLabel: UILabel!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        catLabel?.text = "Category"  + " :"
        skuLabel?.text = "SKUs"  + " :"
        ImageLabel?.text = "Images"  + " :"

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
