//
//  SPOrderSummary.swift
//  Spyne
//
//  Created by Vijay on 20/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import SwiftMessages
import KRProgressHUD
import SDDownloadManager
class SPOrderSummaryVC: UIViewController {
    
    @IBOutlet weak var viewCategoryItemView: UIView!
    @IBOutlet weak var imgOrderThumbImage: UIImageView!
    @IBOutlet weak var viewDownloadImageView: UIView!
    @IBOutlet weak var lblCreditAvailable: UILabel!
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var lblTotalClickedImages: UILabel!
    @IBOutlet weak var lblSkuName: UILabel!
    @IBOutlet weak var lblImageCount: UILabel!
    @IBOutlet weak var btnCreditAvailable: UIButton!
    @IBOutlet weak var downloadHDImagesButton: UIButton!
    
    
    var vmOrderNow = SPOrderNowVM()
//    var vmSPHomeVM = SPHomeVM()
    private let downloadManager = SDDownloadManager.shared
    var imageCount = 0
    var skuId = String()
    var isFromDounloadPopup = false
    static var videoUrl:URL?
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //MARK:-Initial Setup
    func initialSetup(){
        downloadHDImagesButton.setTitle("Download HD Images" , for: .normal)
        if isFromDounloadPopup{
            self.tabBarController?.tabBar.isHidden = true
            vmOrderNow.getProcessedImages(skuId: self.skuId) {
                self.setImageData()
                self.getUsersCredit()
            } onError: { (message) in
                print(message)
            }
        }else{
            setImageData()
            getUsersCredit()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialSetup()
    }
    
    internal func setImageData(){
        
        let CreditAvailableMessage = NSMutableAttributedString(string: "Credits Available" , attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#898A8D")])
        
//        CreditAvailableMessage.append(NSAttributedString(string: "(Top Up)", attributes:[NSAttributedString.Key.font : UIFont.popinsRegular(witSize: 14) , NSAttributedString.Key.foregroundColor: UIColor.appColor ] ))
        
        
        btnCreditAvailable.setAttributedTitle(CreditAvailableMessage, for: .normal)
        
        imageCount = vmOrderNow.arrExteriorCollectionImage.count / 2
        viewCategoryItemView.setShadow(width: 0.5, height: 0.5, color: UIColor(hexString: "#000000")!, radius: 2, opacity: 0.4)
        viewDownloadImageView.setShadow(width: 0, height: -0.3, color: UIColor(hexString: "#000000")!, radius: 1, opacity: 0.4)
        
    }
    internal func getUsersCredit(){
//        vmSPHomeVM.getUsersCreditDetails{
//            self.setData()
//            PosthogEvent.shared.posthogCapture(identity: "iOS Fetch Credits", properties: ["email":USER.userEmail])
//        } onError: { (errMessage) in
//            PosthogEvent.shared.posthogCapture(identity: "iOS Fetch Credits Failed", properties: ["email":USER.userEmail])
//            ShowAlert(message: errMessage, theme: .error)
//        }
    }
    
    internal func updateCredit(){
//        vmSPHomeVM.updateCredit(credit_used: "\(imageCount)") {
//            self.updateStatus()
//        } onError: { (message) in
//            ShowAlert(message: message, theme: .error)
//        }
    }
    
    internal func updateStatus(){
        vmOrderNow.updateDownloadStatus(skuId: self.skuId) {
            PosthogEvent.shared.posthogCapture(identity: "iOS Sku Downloaded Status", properties: ["email":USER.userEmail])
            self.downloadHDImages()
        } onError: { (message) in
            PosthogEvent.shared.posthogCapture(identity: "iOS Sku Downloaded Status Failed", properties: ["email":USER.userEmail,"message":message])
            ShowAlert(message: message, theme: .error)
        }
    }
    
//    func setData(){
//        let credit = Storage.shared.getCredit()
//        self.lblImageCount.text = "\(vmOrderNow.arrImages.count) " + "Images".localized()
//        self.lblTotalClickedImages.text = "\(vmOrderNow.arrImages.count) " + "Images".localized()
//        self.lblCreditAvailable.text = "\(credit?.creditAvailable ?? 0) " + "Credit".localized()
//        self.lblTotalCost.text = "\(imageCount) " + "Credit".localized()
//        if vmOrderNow.arrImages.count > 0{
//            if let url = URL(string: vmOrderNow.arrImages.first?.outputImageLresURL ?? ""){
//                self.imgOrderThumbImage.sd_setImage(with: url, placeholderImage: UIImage())
//
//            }
//
//        }
//    }
    
    //MARK:- Button Action
    @IBAction func btnActionBack(_ sender: UIBarButtonItem) {
        if isFromDounloadPopup{
//            SPCarbonKitProjectVC.currentTabIndex = 1
            self.tabBarController?.tabBar.isHidden = false
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActionDownloadHdImage(_ sender: UIButton) {
        
        let credit = Storage.shared.getCredit()
        if imageCount > (credit?.creditAvailable ?? 0){
            ShowAlert(message: Alert.creditRequired, theme: .error)
        }else{
            updateCredit()
        }
        
    }
    
    
    @IBAction func btnActtionTopUp(_ sender: UIButton) {
//        let story = UIStoryboard(name: "Main", bundle: nil)
//        if let vc = story.instantiateViewController(withIdentifier: "SPPackListingViewController")as? SPPackListingViewController{
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    
    //MARK:- Custome Function
    func downloadHDImages(){
        PosthogEvent.shared.posthogCapture(identity: "iOS Download Started", properties: ["email":USER.userEmail])
        var  deleteUrl:URL!
        let myGroup = DispatchGroup()
        KRProgressHUD.show()
        for (index,image) in vmOrderNow.arrImages.enumerated(){
            if let imageUrl = image.outputImageHresURL{
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
                if self.imageCount == self.vmOrderNow.arrImages.count - 1{
                    print("Finished all requests.")
                    self.imageCount = 0
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
                    ShowAlert(message: Alert.ImagesDownloaded, theme: .success)
                     self.navigationController?.popViewController(animated: true)
                    
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
