//
//  SPCarbonKitProjectOngoingCell.swift
//  Spyne
//
//  Created by Vijay on 22/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView
class SPProjectOngoingCell: UITableViewCell {

    @IBOutlet weak var activity: NVActivityIndicatorView!
    @IBOutlet weak var viewPaid: UIView!
    @IBOutlet weak var btnDownload: UIButton!
    
    @IBOutlet weak var imgImageProcessing: UIImageView!
    @IBOutlet weak var viewNoOfImageContainer: UIView!
    @IBOutlet weak var viewConteinerView: UIView!
    @IBOutlet weak var lblImageCount: UILabel!
    @IBOutlet weak var lblSKUName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblNoOfExteriorAndInterior: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgCompletedProjectOutputImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
  
}
