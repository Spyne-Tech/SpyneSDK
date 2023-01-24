//
//  SPConfiguratorPageCollectionViewCell.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 29/11/22.
//

import UIKit

//MARK: - SPConfiguratorPageCollectionViewCell
class SPConfiguratorPageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subCatName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var draftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    ///setValues: takes two parameters image and subCatString
    func setValues(imageUrl: String, subCatNameString: String) {
        subCatName.text = subCatNameString
        imageView.sd_setImage(with: URL(string: imageUrl))
    }
    
    func setDraftValues(imageUrl: String, subCatNameString: String) {
        draftImageView.isHidden = false
        subCatName.text = subCatNameString
        draftImageView.sd_setImage(with: URL(string: imageUrl))
    }
}
