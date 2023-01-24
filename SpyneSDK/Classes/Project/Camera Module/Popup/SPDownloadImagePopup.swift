//
//  SPDownloadImagePopup.swift
//  Spyne
//
//  Created by Vijay on 24/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit
import KRProgressHUD
import SDWebImage
import SDDownloadManager

class SPDownloadImagePopup: SPBaseVC {

    @IBOutlet weak var btnDownloadWatermark:UIButton!
    @IBOutlet weak var btnDownloadHDImage:UIButton!
    
    var vmSPOrderNow = SPOrderNowVM()
    var skuId = String()
    private let downloadManager = SDDownloadManager.shared
    var didHDImagesDownloadTapped : (()->Void)?
    var didCloseTapped:(()->Void)?
    var imageCount = 0
    var isPaidProject:Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDownloadWatermark.setTitleColor(UIColor.appColor, for: .normal)
        btnDownloadHDImage.setBackgroundColor(UIColor.appColor!, forState: .normal)
        self.getProcessedImages()
    }
    
   
    
    @IBAction func btnActionBack(_ sender:UIButton){
        if let didTapped = didCloseTapped{
            didTapped()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnActionDownloadHDImages(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        if isPaidProject!{
            downloadHDImages()
        }else{
            if let didTapped = didHDImagesDownloadTapped{
                didTapped()
            }
        }
       
        //downloadHDImages()
    }
    
    @IBAction func btnActionDownloadFreeImages(_ sender: UIButton) {
        
        downloadWatermarkImages()
    }
    
    //MARK:- Custome Function
    internal func getProcessedImages(){
        vmSPOrderNow.getProcessedImages(skuId: self.skuId) {
            
            //print("Fetched")
        } onError: { (message) in
            print(message)
        }
    }
    
    func pushToSPOrderNowVC() {
//        AppDelegate.navToHome(selectedIndex: 0)
//        print("img Proccess")
//        let story = UIStoryboard(name: "ImageProccesing", bundle: nil)
//        if let vc = story.instantiateViewController(withIdentifier: "SPOrderNowVC")as? SPOrderNowVC{
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    func downloadHDImages(){
        PosthogEvent.shared.posthogCapture(identity: "iOS Download Started", properties: ["email":USER.userEmail])
        var  deleteUrl:URL!
        let myGroup = DispatchGroup()
       KRProgressHUD.show()
        for (index,image) in vmSPOrderNow.arrImages.enumerated(){
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
                        print("Error is \(error as NSError)")
                        PosthogEvent.shared.posthogCapture(identity: "iOS Download Failed", properties: ["email":USER.userEmail,"message":"\(error as NSError)"])
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
//
                    PosthogEvent.shared.posthogCapture(identity: "iOS Download Completed", properties: ["email":USER.userEmail,"message":"Finished all requests."])
                    print("Finished all requests.")
                    self.imageCount = 0
                    ShowAlert(message: Alert.ImagesDownloaded, theme: .success)
                    // self.navigationController?.popViewController(animated: true)
                    if let didTapped = self.didCloseTapped{
                        didTapped()
                    }
                    
                }else{
                    self.imageCount = self.imageCount + 1
                }
                
            }
        }
    }
    
    func downloadWatermarkImages(){
        var  deleteUrl:URL!
        let myGroup = DispatchGroup()
        KRProgressHUD.show()
        PosthogEvent.shared.posthogCapture(identity: "iOS Watermark Download Started", properties: ["email":USER.userEmail])
        for (index,image) in vmSPOrderNow.arrImages.enumerated(){
            if let imageUrl = image.outputImageLresURL{
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
                        print("Error is \(error as NSError)")
                        PosthogEvent.shared.posthogCapture(identity: "iOS Watermark Download Failed", properties: ["email":USER.userEmail,"message":"\(error as NSError)"])
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
                    print("Finished all requests.")
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
                    PosthogEvent.shared.posthogCapture(identity: "iOS Watermark Download Completed", properties: ["email":USER.userEmail,"message":"Finished all requests."])
                    self.imageCount = 0
                    ShowAlert(message: Alert.ImagesDownloaded, theme: .success)
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
