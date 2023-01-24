//
//  SPInterialShootPopup.swift
//  Spyne
//
//  Created by Vijay on 24/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

class SPInterialShootPopup: SPBaseVC, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    //MARK:- Outlet
    @IBOutlet weak var lblPopupTitel: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var collectionShootImages: UICollectionView!
    @IBOutlet weak var shootNowButton: UIButton!
    
    //MARK:- Variable
    var vmSPInterialShootVM = SPInterialShootVM()
    var btnDidConfirmTapped:(()->Void)?
    var btnDidSkipTapped:(()->Void)?
    var strTitle = String()
    var arrImages = [SubCategoryInterior]()
    var imgInterialPic = UIImageView()
    override func viewDidLoad() {
        shootNowButton.setTitle("Shoot Now" , for: .normal)
        btnSkip.setTitle("Skip" , for: .normal)
        super.viewDidLoad()
        initialSetup()
        collectionShootImages.delegate = self
        collectionShootImages.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)

    }

    //MARK:- Function
    func initialSetup()  {
        btnSkip.layer.borderColor = UIColor.appColor?.cgColor
        btnSkip.layer.borderWidth = 1
        btnSkip.layer.cornerRadius = 5
        btnSkip.tintColor = UIColor.appColor
        
        lblPopupTitel.text =  strTitle
        lblPopupTitel.textColor = UIColor.appColor
    }
    // MARK:- Button Action
    @IBAction func skip(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let didSkipTapped = self.btnDidSkipTapped {
                didSkipTapped()
            }
        }
        
    }
    @IBAction func shotNow(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let didTapped = self.btnDidConfirmTapped{
                didTapped()
            }
        }
    }
}


//MARK:- Collection View

extension SPInterialShootPopup{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPInterialShootCell", for: indexPath) as! SPInterialShootCell
        
        if let imageUrl = URL(string: arrImages[indexPath.row].displayThumbnail ?? ""){
            cell.imgShootImage.sd_setImage(with: imageUrl, placeholderImage: UIImage())
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width / 2
        let height = collectionView.frame.size.height / 2
        return CGSize(width: width, height: height)
        
     }

}
