//
//  SPinteriorshootCameraVC+Collectionview.swift
//  Spyne
//
//  Created by Vijay Parmar on 01/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

extension SPShootFocusImagesVC:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Storage.shared.arrFocusedPopup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPProductCategoriesCell", for: indexPath) as! SPProductCategoriesCell
        
        let focused = Storage.shared.arrFocusedPopup[indexPath.row]
        cell.lblProductName.text = focused.displayName  ?? ""
        cell.viewProductView.layer.borderWidth = 3
        cell.viewProductView.backgroundColor = UIColor.clear
        
        if focused.imageUrl != nil{
            if let url = URL(string: focused.imageUrl ?? ""){
                //print(url)
                cell.imgProductImage.sd_setImage(with: url, placeholderImage: UIImage())
            }
        }else if focused.clickedImage != nil{
            cell.imgProductImage.image =  focused.clickedImage
        }else{
            if let url = URL(string: focused.displayThumbnail ?? ""){
                //print(url)
                cell.imgProductImage.sd_setImage(with: url, placeholderImage: UIImage())
            }
        }
    
        if focused.clickedAngle &&  vmShoot.selectedFocusAngles != indexPath.row{
            cell.viewProductView.layer.borderColor = UIColor.green.cgColor
        }else if vmShoot.selectedFocusAngles == indexPath.row{
            cell.viewProductView.layer.borderColor = UIColor.appLightColor?.cgColor
        }else{
            cell.viewProductView.layer.borderColor = UIColor.white.cgColor
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if Storage.shared.arrFocusedPopup[indexPath.row].clickedAngle{
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmReshootPopupVC") as? ConfirmReshootPopupVC{
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                
                vc.btnDidYesTapped = {
                    self.isReclick = true
                    self.vmShoot.selectedFocusAngles = indexPath.row
                    self.collectionFocusImages.reloadData()
                }
                vc.btnDidNoTapped = {
                    
                }
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            isReclick = false
            vmShoot.selectedFocusAngles = indexPath.row
            self.collectionFocusImages.reloadData()
                    
        }
    }
}



