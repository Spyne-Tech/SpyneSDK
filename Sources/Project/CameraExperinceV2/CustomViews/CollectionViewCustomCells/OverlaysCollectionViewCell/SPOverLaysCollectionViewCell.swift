//
//  SPOverLaysCollectionViewCell.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 28/11/22.
//

import UIKit

protocol CellIndexDelegate{
    func sendIndex(index: Int)
}

class SPOverLaysCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clickedImageImageView: UIImageView!
    @IBOutlet weak var overlayNameLabel: UILabel!
    
    var index = 0
    var delegate: CellIndexDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func someViewInMyCellTapped(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.sendIndex(index: self.index)
    }
    
    func setValues(imageViewurl: String, overlayName: String, clickedImage:UIImage = UIImage(named: "demoCarImage",in: Bundle.spyneSDK, with: nil)!, mendatory: Bool = false, exterior: Bool = true ,clickedImageUrl: String = "") {
        clickedImageImageView.image = nil
        imageView.image = nil
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.someViewInMyCellTapped(_:)))
        borderView.addGestureRecognizer(tap)
        if imageViewurl == "" && clickedImageUrl == ""{
            clickedImageImageView.isHidden = false
            clickedImageImageView.image = clickedImage
        } else if clickedImageUrl != "" {
            imageView.sd_setImage(with: URL(string: clickedImageUrl))
        } else {
            imageView.sd_setImage(with: URL(string: imageViewurl))
        }
        overlayNameLabel.text = overlayName
        if !exterior {
            if mendatory {
                self.borderView.borderColor = .red
            } else {
                self.borderView.borderColor = .white
            }
        }
    }
}
