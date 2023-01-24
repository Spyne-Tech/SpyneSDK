//
//  SPProductDetailListTableViewCell.swift
//  Spyne
//
//  Created by Vijay Parmar on 17/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPProductDetailListTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionImages: UICollectionView!
    var images : [ProjectDetailImage]?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionImages.delegate = self
        collectionImages.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension SPProductDetailListTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPImageCollectionViewCell", for: indexPath)as! SPImageCollectionViewCell
        if let url = URL(string: images?[indexPath.row].inputLres ?? ""){
            cell.imgProductPic.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_logo"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionImages.frame.width / 3.5
        return CGSize(width: width, height: width)
    }
    
    
}
