//
//  SPinteriorshootCameraVC+Collectionview.swift
//  Spyne
//
//  Created by Vijay Parmar on 01/05/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

extension SPinteriorshootCameraVC:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Storage.shared.arrInteriorPopup.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPProductCategoriesCell", for: indexPath) as! SPProductCategoriesCell
        let interior = Storage.shared.arrInteriorPopup[indexPath.row]
        
        cell.lblProductName.text = interior.displayName  ?? ""
//        if let imageUrl = URL(string: interior.displayThumbnail ?? ""){
//            cell.imgProductImage.sd_setImage(with: imageUrl, placeholderImage: UIImage())
//        }
        
        if interior.imageUrl != nil{
            if let url = URL(string: interior.imageUrl ?? ""){
                //print(url)
                cell.imgProductImage.sd_setImage(with: url, placeholderImage: UIImage())
            }
        }else if interior.clickedImage != nil{
            cell.imgProductImage.image =  interior.clickedImage
        }else{
            if let url = URL(string: interior.displayThumbnail ?? ""){
                print(url)
                cell.imgProductImage.sd_setImage(with: url, placeholderImage: UIImage())
            }
        }
       
        cell.viewProductView.layer.borderWidth = 3
        cell.viewProductView.backgroundColor = UIColor.clear
        
        if interior.clickedAngle &&  vmShoot.selectedInteriorAngles != indexPath.row{
            cell.viewProductView.layer.borderColor = UIColor.green.cgColor
        }else if vmShoot.selectedInteriorAngles == indexPath.row{
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
        
        if Storage.shared.arrInteriorPopup[indexPath.row].clickedAngle{
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmReshootPopupVC") as? ConfirmReshootPopupVC{
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                
                vc.btnDidYesTapped = {
                    self.isReclick = true
                    self.vmShoot.selectedInteriorAngles = indexPath.row
                    self.collectionProductCategories.reloadData()
                }
                vc.btnDidNoTapped = {
                    
                }
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            isReclick = false
            vmShoot.selectedInteriorAngles = indexPath.row
            self.collectionProductCategories.reloadData()
        }
    }
    
}



