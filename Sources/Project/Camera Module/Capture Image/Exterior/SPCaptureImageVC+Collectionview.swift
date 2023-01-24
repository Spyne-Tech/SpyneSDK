//
//  SPCaptureImageVC+Collectionview.swift
//  Spyne
//
//  Created by Vijay on 29/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
extension SPCaptureImageVC:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionOverlays{
            return  vmShoot.arrOverLays.count
        }
        else {
            return vmShoot.arrCatData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionOverlays{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPProductCategoriesCell", for: indexPath) as! SPProductCategoriesCell
            cell.viewProductView.layer.borderWidth = 3
            cell.viewProductView.backgroundColor = UIColor.clear
            
            if vmShoot.arrOverLays[indexPath.row].imageUrl != nil{
                if let url = URL(string: vmShoot.arrOverLays[indexPath.row].imageUrl ?? ""){
                    //print(url)
                    cell.imgProductImage.sd_setImage(with: url, placeholderImage: UIImage())
                }
            }else if vmShoot.arrOverLays[indexPath.row].clickedImage != nil{
                cell.imgProductImage.image =  vmShoot.arrOverLays[indexPath.row].clickedImage
            }else{
                if let url = URL(string: vmShoot.arrOverLays[indexPath.row].displayThumbnail ?? ""){
                    print(url)
                    cell.imgProductImage.sd_setImage(with: url, placeholderImage: UIImage())
                }
            }
            
            
            
            if vmShoot.arrOverLays[indexPath.row].clickedAngle &&  vmShoot.selectedAngle != indexPath.row{
                cell.viewProductView.layer.borderColor = UIColor.green.cgColor
            }else if vmShoot.selectedAngle == indexPath.row{
                cell.viewProductView.layer.borderColor = UIColor.appLightColor?.cgColor
            }else{
                cell.viewProductView.layer.borderColor = UIColor.white.cgColor
            }
           
            cell.lblProductName.text = vmShoot.arrOverLays[indexPath.row].displayName  ?? ""
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPProductCategoriesCell", for: indexPath) as! SPProductCategoriesCell
            if let index = vmShoot.selectedIndex,index == indexPath.row{
                cell.viewProductView.layer.borderWidth = 3
                cell.viewProductView.layer.borderColor = UIColor.appLightColor?.cgColor
                cell.lblProductName.textColor = UIColor.appColor
                vmShoot.cat_id = vmShoot.arrCatData[indexPath.row].prodCatId!
                // print("Product ID" , vmShoot.productId)
            }
            else
            {
                cell.viewProductView.layer.borderWidth = 0
                cell.viewProductView.layer.borderColor = UIColor.appColor?.cgColor
                cell.lblProductName.textColor = UIColor.white
            }
            
            
            if let url = URL(string: "\(vmShoot.arrCatData[indexPath.row].displayThumbnail ?? "")"){
                print(url)
                cell.imgProductImage.sd_setImage(with: url, placeholderImage: UIImage())
            }
            cell.lblProductName.text = vmShoot.arrCatData[indexPath.row].subCatName  ?? ""
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 3)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionProductCategories{
            
            self.viewIndicator.isHidden = true
            self.collectionProductCategories.isHidden = true
            vmShoot.selectedIndex = indexPath.row
            collectionView.reloadData()
            vmShoot.sub_cat_id = vmShoot.arrCatData[indexPath.row].prodSubCatId ?? ""
            getOverlays(frames:vmShoot.noOfAngles)
            
        }else{
            
            
            if vmShoot.arrOverLays[indexPath.row].clickedAngle{
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmReshootPopupVC") as? ConfirmReshootPopupVC{
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    
                    vc.btnDidYesTapped = {
                        self.isReclick = true
                        self.vmShoot.selectedAngle = indexPath.row
                        self.setOverlayImage()
                        self.collectionOverlays.reloadData()
                    }
                    vc.btnDidNoTapped = {
                        
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                isReclick =   false
                vmShoot.selectedAngle = indexPath.row
                self.setOverlayImage()
                self.collectionOverlays.reloadData()
            }
            
        }
        
    }
}

