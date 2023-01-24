//
//  SPCaptureImageVC+Collectionview.swift
//  Spyne
//
//  Created by Vijay on 29/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
extension SPReshootCameraVC:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Storage.shared.vmSPOrderNow.arrOverlayByIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPProductCategoriesCell", for: indexPath) as! SPProductCategoriesCell
            cell.viewProductView.layer.borderWidth = 1
            cell.viewProductView.backgroundColor = UIColor.clear
            
            let clickedImage = Storage.shared.vmSPOrderNow.arrOverlayByIds[indexPath.row]
            
            if clickedImage.clickedAngle &&  vmShoot.selectedAngle != indexPath.row{
                cell.viewProductView.layer.borderColor = UIColor.green.cgColor
            }else if vmShoot.selectedAngle == indexPath.row{
                cell.viewProductView.layer.borderColor = UIColor.appColor?.cgColor
            }else{
                cell.viewProductView.layer.borderColor = UIColor.white.cgColor
            }
            if let url = URL(string: clickedImage.displayThumbnail ?? ""){
                print(url)
                cell.imgProductImage.sd_setImage(with: url, placeholderImage: UIImage())
            }
            cell.lblProductName.text = clickedImage.displayName  ?? "" 
            return cell
            
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 3)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if Storage.shared.vmSPOrderNow.arrOverlayByIds[indexPath.row].clickedAngle{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmReshootPopupVC") as? ConfirmReshootPopupVC{
                
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                
                vc.btnDidYesTapped = {
                    self.isReclick = true
                    self.vmShoot.selectedAngle = indexPath.row
                    self.collectionOverlays.reloadData()
                }
                vc.btnDidNoTapped = {
                    
                }
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            isReclick =   false
            vmShoot.selectedAngle = indexPath.row
            setOverlayImage()
            if Storage.shared.vmSPOrderNow.arrImages[self.vmShoot.selectedAngle].imageCategory == "Exterior"{
                self.viewGyrometer.isHidden = false
                
            }else{
                self.viewGyrometer.isHidden = true
                self.btnCapture.isUserInteractionEnabled = true
                self.btnGallery.isUserInteractionEnabled = true
                self.btnCapture.tintColor = UIColor.white
             
            }
            self.collectionOverlays.reloadData()
        }
    }
    
}

