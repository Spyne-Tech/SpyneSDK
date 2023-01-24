//
//  SPOrderNowVC.swift
//  Spyne
//
//  Created by Vijay on 20/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import KRProgressHUD
import SDWebImage
import SDDownloadManager
import WebKit

class SPOrderNowVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Outlet
    @IBOutlet weak var view360: UIView!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var lblExteriorTitle: UILabel!
    @IBOutlet weak var lblInteriorTitle: UILabel!
    @IBOutlet weak var lblMiscellaneousTitle: UILabel!
    @IBOutlet weak var collectionExterior: UICollectionView!
    @IBOutlet weak var collectionInterior: UICollectionView!
    @IBOutlet weak var collectionMiscellaneous: UICollectionView!
    @IBOutlet weak var conExteriorCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var conInteriorCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var conMiscellaneousHeight: NSLayoutConstraint!
    @IBOutlet weak var btnDownloadFreeWatermarkedImage: UIButton!
    
    //MARK:- Variable
    var vmSPOrderNow = SPOrderNowVM()
    var skuId = String()
    private let downloadManager = SDDownloadManager.shared
    var imageCount = 0
    var is360 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup()  {
    
        collectionExterior.dataSource = self
        collectionExterior.delegate = self
        collectionInterior.dataSource = self
        collectionInterior.delegate = self
        collectionMiscellaneous.delegate = self
        collectionMiscellaneous.dataSource = self
        lblExteriorTitle.textColor = UIColor.appColor
        lblInteriorTitle.textColor = UIColor.appColor
        btnDownloadFreeWatermarkedImage.setTitleColor(UIColor.appColor, for: .normal)
        
        if is360{
            let url = URL(string: "https://www.spyne.ai/shoots/shoot?skuId=\(skuId)&type=exterior")
            let request = URLRequest(url: url!)
            webview.uiDelegate = self
            webview.navigationDelegate = self
            webview.scrollView.isScrollEnabled = false
            webview.load(request)
        }else{
            view360.isHidden = true
        }
        
        
        vmSPOrderNow.getProcessedImages(skuId: self.skuId) {
            PosthogEvent.shared.posthogCapture(identity: "iOS Fetched Bulk Upload", properties: ["email":USER.userEmail])
            
            self.collectionExterior.reloadData()
            self.collectionInterior.reloadData()
            self.collectionMiscellaneous.reloadData()
            let size:CGFloat = (self.collectionExterior.frame.size.width) / 2.0
            let exCount = CGFloat(self.vmSPOrderNow.arrExteriorCollectionImage.count)
            let intCount = CGFloat(self.vmSPOrderNow.arrInteriorCollectionImage.count)
            let misCount = CGFloat(self.vmSPOrderNow.arrMiscellaneousImage.count)
            if intCount == 0{
                self.lblInteriorTitle.isHidden = true
            }
            if misCount == 0{
                self.lblMiscellaneousTitle.isHidden = true
            }
            self.conExteriorCollectionHeight.constant =  ((exCount / 2) * size)
            self.conInteriorCollectionHeight.constant = ((intCount / 2) * size)
            self.conMiscellaneousHeight.constant = ((misCount / 2) * size)
            
        } onError: { (message) in
            PosthogEvent.shared.posthogCapture(identity: "iOS Fetch Bulk Upload Failed", properties: ["email":USER.userEmail,"message":message])
            print(message)
        }
    }
    
    //MARK:- Button Action
    
    @IBAction func btnActionBack(_ sender: UIBarButtonItem) {
//        SPCarbonKitProjectVC.currentTabIndex = 1
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActionDownloadHDImages(_ sender: UIButton) {
        if self.vmSPOrderNow.isPaid{
            self.downloadHDImages()
        }else{
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SPOrderSummaryVC")as? SPOrderSummaryVC{
                vc.skuId = self.skuId
                vc.vmOrderNow = self.vmSPOrderNow
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnActionView360SpinShoot(_ sender: UIButton) {
        
        print("View360SpinShoot code here")
    }
    
    @IBAction func btnActionDownloadWatermark(_ sender: UIButton) {
        downloadWatermarkImages()
    }
    
    @IBAction func btnActionCode(_ sender: UIButton) {
       // let story = UIStoryboard(name: "ImageProccesing", bundle: nil)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SPEmbededCodePopupVC") as? SPEmbededCodePopupVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.url = "https://www.spyne.ai/shoots/shoot?skuId=\(skuId)&type=exterior"
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnActionShare(_ sender: UIButton) {
        let url = URL(string: "https://www.spyne.ai/shoots/shoot?skuId=\(skuId)&type=exterior")!
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(vc, animated: true)
        
    }
    //MARK:- Custome Function

    func downloadWatermarkImages() { }
//    {
//        PosthogEvent.shared.posthogCapture(identity: "iOS Watermark Download Started", properties: ["email":USER.userEmail])
//        var  deleteUrl:URL!
//        let myGroup = DispatchGroup()
//        KRProgressHUD.show()
//        for (index,image) in vmSPOrderNow.arrImages.enumerated(){
//            if let imageUrl = image.outputImageLresWmUrl{
//                myGroup.enter()
//                // print("Count  -- >",index)
//                let request = URLRequest(url: URL(string: imageUrl)!)
//                let downloadKey = self.downloadManager.downloadFile(withRequest: request,
//                                                                    inDirectory: "\(appNameDirectory)-\(Date().toString(format: "ddMMyyyyHHmmss"))",
//                                                                    onProgress:  { [weak self] (progress) in
//                                                                        //  let percentage = String(format: "%.1f %", (progress * 100))
//                                                                        //  self?.progressView.setProgress(Float(progress), animated: true)
//                                                                        //   self?.progressLabel.text = "\(percentage) %"
//                                                                    }) { [weak self] (error, url) in
//                    if let error = error {
//                        print("Error is \(error as NSError)")
//                        PosthogEvent.shared.posthogCapture(identity: "iOS Watermark Download Failed", properties: ["email":USER.userEmail,"message":"\(error as NSError)"])
//                        myGroup.leave()
//                    } else {
//                        if let url = url {
//                            deleteUrl = url.deletingLastPathComponent()
//                            if let image = UIImage.init(contentsOfFile: url.path) {
//                                UIImageWriteToSavedPhotosAlbum(image,  nil, nil, nil)
//                                print("Downloaded file's url is \(url.path)")
//                            } else {
//                                fatalError("Can't create image from file \(url)")
//                            }
//
//                            myGroup.leave()
//                            //  self?.finalUrlLabel.text = url.path
//                        }
//                    }
//                }
//            }
//            myGroup.notify(queue: .main) {
//                KRProgressHUD.dismiss()
//                if self.imageCount == self.vmSPOrderNow.arrImages.count - 1{
//                    print("Finished all requests.")
////                    do {
////                        let fileManager = FileManager.default
////
////                        // Check if file exists
////                        if fileManager.fileExists(atPath: deleteUrl.path) {
////                            // Delete file
////                            try fileManager.removeItem(atPath: deleteUrl.path)
////                        } else {
////                            print("File does not exist")
////                        }
////                    } catch {
////                        print("An error took place: \(error)")
////                    }
//                    PosthogEvent.shared.posthogCapture(identity: "iOS Watermark Download Completed", properties: ["email":USER.userEmail,"message":"Finished all requests."])
//                    self.imageCount = 0
//                    ShowAlert(message: Alert.ImagesDownloaded, theme: .success)
//                }else{
//                    self.imageCount = self.imageCount + 1
//                }
//
//            }
//        }
//    }
    
    
    
    
    func downloadHDImages(){
        PosthogEvent.shared.posthogCapture(identity: "iOS Download Started", properties: ["email":USER.userEmail])
        var  deleteUrl:URL!
        let myGroup = DispatchGroup()
        KRProgressHUD.show()
        for (index,image) in vmSPOrderNow.arrImages.enumerated(){
            if let imageUrl = image.inputImageLresURL{
                myGroup.enter()
                // print("Count  -- >",index)
                let request = URLRequest(url: URL(string: imageUrl)!)
                let downloadKey = self.downloadManager.downloadFile(withRequest: request,
                                                                    inDirectory: "\(appNameDirectory)-\(Date().toString(format: "ddMMyyyyHHmmss"))",
                                                                    onProgress:  { [weak self] (progress) in
                                                                        //  let percentage = String(format: "%.1f %", (progress * 100))
                                                                        //  self?.progressView.setProgress(Float(progress), animated: true)
                                                                        //   self?.progressLabel.text = "\(percentage) %"
                                                                    }) { [weak self] (error, url) in
                    if let error = error {
                        PosthogEvent.shared.posthogCapture(identity: "iOS Download Failed", properties: ["email":USER.userEmail,"message":"\(error as NSError)"])
                        print("Error is \(error as NSError)")
                        myGroup.leave()
                    } else {
                        if let url = url {
                            deleteUrl = url.deletingLastPathComponent()
                            if let image = UIImage.init(contentsOfFile: url.path) {
                                UIImageWriteToSavedPhotosAlbum(image,  nil, nil, nil)
                                print("Downloaded file's url is \(url.path)")
                                
                            } else {
                                fatalError("Can't create image from file \(url)")
                            }
                            
                            myGroup.leave()
                            //  self?.finalUrlLabel.text = url.path
                        }
                    }
                }
            }
            myGroup.notify(queue: .main) {
                KRProgressHUD.dismiss()
                if self.imageCount == self.vmSPOrderNow.arrImages.count - 1{
                    
//                    do {
//                        let fileManager = FileManager.default
//                        
//                        // Check if file exists
//                        if fileManager.fileExists(atPath: deleteUrl.path) {
//                            // Delete file
//                            try fileManager.removeItem(atPath: deleteUrl.path)
//                        } else {
//                            print("File does not exist")
//                        }
//                    } catch {
//                        print("An error took place: \(error)")
//                    }
                    
                    PosthogEvent.shared.posthogCapture(identity: "iOS Download Completed", properties: ["email":USER.userEmail,"message":"Finished all requests."])
                    print("Finished all requests.")
                    self.imageCount = 0
                    ShowAlert(message: Alert.ImagesDownloaded, theme: .success)
                    // self.navigationController?.popViewController(animated: true)
                    
                }else{
                    self.imageCount = self.imageCount + 1
                }
                
            }
        }
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

//MARK:- Collectionview Method

extension SPOrderNowVC
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionExterior:
            let exCount = self.vmSPOrderNow.arrExteriorCollectionImage.count
            return exCount
        case collectionInterior:
            return vmSPOrderNow.arrInteriorCollectionImage.count
        case collectionMiscellaneous:
            return vmSPOrderNow.arrMiscellaneousImage.count
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionInterior{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPOrderNowExteriorCell", for: indexPath) as! SPOrderNowExteriorCell
            if indexPath.row % 2 == 0{
                if let imageUrl = URL(string: vmSPOrderNow.arrInteriorCollectionImage[indexPath.row].inputImageLresURL ?? ""){
                    cell.imgExteriorCellImage.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                }
            }else{
                if let imageUrl = URL(string: vmSPOrderNow.arrInteriorCollectionImage[indexPath.row].inputImageLresURL ?? ""){
                    cell.imgExteriorCellImage.contentMode = .scaleAspectFit
                    cell.imgExteriorCellImage.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                }
            }
            
            
            return cell
        }
        else if  collectionView == collectionExterior {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPOrderNowExteriorCell", for: indexPath) as! SPOrderNowExteriorCell
            
            if indexPath.row % 2 == 0{
                if let imageUrl = URL(string: vmSPOrderNow.arrExteriorCollectionImage[indexPath.row].inputImageLresURL ?? ""){
                    cell.imgExteriorCellImage.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                }
            }else{
                if let imageUrl = URL(string: vmSPOrderNow.arrExteriorCollectionImage[indexPath.row].inputImageLresURL ?? ""){
                    cell.imgExteriorCellImage.contentMode = .scaleAspectFit
                    cell.imgExteriorCellImage.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                }
            }
            
            return cell
        }else  {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPOrderNowExteriorCell", for: indexPath) as! SPOrderNowExteriorCell
            
            if indexPath.row % 2 == 0{
                if let imageUrl = URL(string: vmSPOrderNow.arrMiscellaneousImage[indexPath.row].inputImageLresURL ?? ""){
                    cell.imgExteriorCellImage.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                }
            }else{
                if let imageUrl = URL(string: vmSPOrderNow.arrMiscellaneousImage[indexPath.row].inputImageLresURL ?? ""){
                    cell.imgExteriorCellImage.contentMode = .scaleAspectFit
                    cell.imgExteriorCellImage.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                }
            }
            
            return cell
        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size:CGFloat = (collectionView.frame.size.width) / 2.0
        return CGSize(width: size, height: size )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let story = UIStoryboard(name: "Main", bundle: Bundle.spyneSDK)
        if let vc = story.instantiateViewController(withIdentifier: "SPShotSummaryPopup")as? SPShotSummaryPopup{
            if collectionView == collectionExterior{
                vc.arrImages =  everySecond(of: self.vmSPOrderNow.arrExteriorCollectionImage)
            }else  if collectionView == collectionInterior{
                vc.arrImages = everySecond(of: self.vmSPOrderNow.arrInteriorCollectionImage)
            }else{
                vc.arrImages = everySecond(of: self.vmSPOrderNow.arrMiscellaneousImage)  
            }
            vc.selectedIndex = indexPath.row / 2
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func everySecond<T>(of array: [T]) -> [T] {
        return stride(from: array.startIndex, to: array.endIndex, by: 2).map { array[$0] }
    }
}


extension SPOrderNowVC:WKNavigationDelegate,WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.setZoomScale(0.4, animated: true)
    }
    
}
