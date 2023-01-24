//
//  SPShotSummaryPopup.swift
//  Spyne
//
//  Created by Vijay on 24/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPShotSummaryPopup: SPBaseVC {
    
    //Outlet
    @IBOutlet weak var collectionImges: UICollectionView!
    var arrImages = [ProcessedImageData]()
    var selectedIndex = 0
    var isExternal = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionImges.delegate = self
        collectionImges.dataSource = self
    }
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        collectionImges.isPagingEnabled = false
        collectionImges.reloadData()
        collectionImges.layoutIfNeeded()
        collectionImges.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        collectionImges.isPagingEnabled = true
    }
    
    //MARK:- Button Action
    @IBAction func popupClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SPShotSummaryPopup:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPBeforAfterImageCollectionViewCell", for: indexPath)as! SPBeforAfterImageCollectionViewCell
        
        if let url = URL(string: arrImages[indexPath.row].inputImageLresURL ?? ""){
            cell.imgBefore.sd_setImage(with: url, placeholderImage: UIImage())
        }
        
        if let url = URL(string: arrImages[indexPath.row].outputImageLresURL ?? ""){
            cell.imgAfter.sd_setImage(with: url, placeholderImage: UIImage())
        }
        if !isExternal {
            cell.beforeLabel.isHidden = true
            cell.afterLabel.isHidden = true
            cell.imgAfter.isHidden = true
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}
