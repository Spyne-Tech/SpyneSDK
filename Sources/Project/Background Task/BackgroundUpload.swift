//
//  ImageUploading.swift
//  Spyne
//
//  Created by Vijay Parmar on 27/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import RealmSwift
import PostHog

class BackgroundUpload {
    
    var vmBgUpload = BGUploadViewModel()
//  let vmRealm = RealmViewModel()
    var retryCount: Int = 0
    var lastIdentifier = String()
    var imageData:RealmImageData?
    var imageUploadType = StringCons.regular
    static var isUploadRunning = false
    
    func uploadParent(type:String, serviceStartedBy:String){
        
        //Posthog Event Capture
        let properties = [
            "type" : "\(type)",
            "service_started_by": "\(serviceStartedBy)",
            "upload_running" : "\(BackgroundUpload.isUploadRunning)"
        ]
        
        PosthogEvent.shared.posthogCapture(identity: PosthogEvent.UPLOAD_PARENT_TRIGGERED, properties: properties)
        Storage.isUploadTriggred = true
        
        if Storage.isUploadTriggred && !BackgroundUpload.isUploadRunning {
            if Reachability.isConnectedToNetwork(){
                BackgroundUpload.isUploadRunning = true
                PosthogEvent.shared.posthogCapture(identity: PosthogEvent.UPLOADING_RUNNING, properties: [:])
                self.startUploading()
            }else{
                BackgroundUpload.isUploadRunning = false
            }
        }
    }
    
    //MARK: - START UPLOADING
    func startUploading(){
        DispatchQueue.global(qos: .background).async { [unowned self] in
            let vmRealm = RealmViewModel.init()
        repeat {
            
            if !Reachability.isConnectedToNetwork(){
                //Posthog Event Capture
                let properties = [
                    "remaining_images" : [
                        "upload_remaining" : "\(vmRealm.totalRemainingUpload())",
                        "mark_done_remaining" : "\(vmRealm.totalRemainingUpload())"
                    ].jsonString
                ]
                PosthogEvent.shared.posthogCapture(identity: PosthogEvent.CONNECTION_BREAK, properties: properties)
                
                break
            }
            
            var skipFlag = -1
            try! vmRealm.realm.safeWrite {
                imageData = vmRealm.getSingleRealmImageData(status: 0)
                if imageData == nil{
                    imageUploadType = StringCons.skipped
                    imageData = vmRealm.getSingleRealmImageData(status: -1)
                    skipFlag = -2
                }
                
                if imageData == nil && imageUploadType == StringCons.skipped{
                    
                    let skippedImagesCount = vmRealm.updateSkippedImages()
                    
                    let markDoneSkippedCount = vmRealm.updateMarkDoneSkipedImages()
                    
                    if (skippedImagesCount > 0 || markDoneSkippedCount > 0){
                        imageData = vmRealm.getSingleRealmImageData(status: -1)
                    }
                }
            }
            
            if imageData == nil{
                //Posthog Event Capture
                let properties = [
                    "remaining_images" : [
                        "upload_remaining" : "\(vmRealm.totalRemainingUpload())",
                        "mark_done_remaining" : "\(vmRealm.totalRemainingUpload())"
                    ].jsonString
                ]
                PosthogEvent.shared.posthogCapture(identity: PosthogEvent.ALL_UPLOADED_BREAK, properties: properties)
                BackgroundUpload.isUploadRunning = false
                
                break
                
            }else{
                
                lastIdentifier = "\(imageData?.imageName ?? "")_\(imageData?.skuId ?? "")"
            
                //Image Selected
                let properties:[String:Any] = [
                    "sku_id" : imageData?.skuId ?? "",
                    "iteration_id" : lastIdentifier,
                    "retry_count" : "\(retryCount)",
                    "upload_type" : "\(imageUploadType)",
                    
                    "data" : PosthogEvent.shared.getImageDetail(imageData: imageData).jsonString,
                    "remaining_images" : [
                        "upload_remaining" : vmRealm.totalRemainingUpload(),
                        "mark_done_remaining" : vmRealm.totalRemainingUpload(),
                        "remaining_above" : vmRealm.getRemainingAbove(imageData: imageData),
                        "remaining_below" : vmRealm.getRemainingAbove(imageData: imageData)
                    ].jsonString
                ]
               
                PosthogEvent.shared.posthogCapture(identity: PosthogEvent.SELECTED_IMAGE, properties: properties)
            
                if retryCount > 4{
                    
                    let dbStatus = imageData?.uploadFlag != 1 ? vmRealm.skipImage(imageData: imageData, skipFlag: skipFlag) : vmRealm.skipImage(imageData: imageData, skipFlag: -1)
                    
                    //Posthog Event Capture
                    self.captureEvent(eventName: PosthogEvent.MAX_RETRY, image: imageData, isSuccess: false, error: "Image upload limit reached", dbUpdateStatus : dbStatus,response: "", retryCount: retryCount, throwable: "")
                    
                    retryCount = 0
                    
                    continue
                    
                }//: Retry Count Condition
                
                
                if imageData?.uploadFlag == 0 || imageData?.uploadFlag == -1{
                    
                    if imageData?.presignedUrl != ""{
                        
                        //UPLOAD IMAGE CALL
                        
                        var imageUploaded = false
                        
                        guard let image = loadImageFromDocumentDirectory(imageName: "\(self.imageData?.imageName ?? "")", projectId:  "\(self.imageData?.projectId ?? "")",skuId:"\(self.imageData?.skuId ?? "")") else {  return  }
                        
                        imageUploaded = self.uploadBinaryImage(presigned_url: self.imageData?.presignedUrl ?? "", image: image, vmRealm: vmRealm)
                        
                        //if Error in image Uploading then continue
                        if !imageUploaded{
                            continue
                        }
                        
                        //MARK DONE CALL
                        let markDoneParameters = [
                            [
                                "key": "image_id",
                                "value": self.imageData?.imageId ?? "",
                                "type": "text"
                            ],
                            [
                                "key": "auth_key",
                                "value": CLIENT.shared.getUserSecretKey(),
                                "type": "text"
                            ]] as [[String : Any]]
                        
                        
                        var markDone = false
                        
                        markDone = self.markDoneImage(parameters: markDoneParameters, vmRealm: vmRealm)
                        print("DoneDone")
                        if !markDone{
                            continue
                        }
                        
                        print("Start Uploading: imageMarkedDone : ",markDone)
                        continue
                        
                    }//:Presign url check condition
                    
                    else{
                        
                        imageUploadType =  retryCount == 1 ? "Direct" : "Retry"
                
                        guard let imageData = imageData else {
                            return
                        }
                        
                        #warning("first call the save project api so that params can get pass easily to the upload call")
                        let parameters = [
                            [
                                "key": "project_id",
                                "value": imageData.projectId,
                                "type": "text"
                            ],
                            [
                                "key": "sku_id",
                                "value": imageData.skuId,
                                "type": "text"
                            ],
                            [
                                "key": "image_category",
                                "value": imageData.imageCategory,
                                "type": "text"
                            ],
                            [
                                "key": "image_name",
                                "value": imageData.imageName,
                                "type": "text"
                            ],
                            [
                                "key": "overlay_id",
                                "value": imageData.overlay_id,
                                "type": "text"
                            ],
                            [
                                "key": "upload_type",
                                "value": imageUploadType,
                                "type": "text"
                            ],
                            [
                                "key": "frame_seq_no",
                                "value": "\(imageData.frame_seq_no)",
                                "type": "text"
                            ],
                            [
                                "key": "is_reclick",
                                "value": "false",//imageData.is_reclick ? "true" : "false",
                                "type": "text"
                            ],
                            [
                                "key": "is_reshoot",
                                "value": imageData.is_reshoot ? "true" : "false",
                                "type": "text"
                            ],
                            [
                                "key": "tags",
                                "value": imageData.tags,
                                "type": "text"
                            ],
                            [
                                "key": "debug_data",
                                "value": "",
                                "type": "text"
                            ],
                            [
                                "key": "angle",
                                "value": "\(imageData.angle)",
                                "type": "text"
                            ],
                            [
                                "key": "source",
                                "value": "app_ios",
                                "type": "text"
                            ],
                            [
                                "key": "auth_key",
                                "value": CLIENT.shared.getUserSecretKey(),
                                "type": "text"
                            ]] as [[String : Any]]
                        
                        var gotPresigned = false
                        
                        // print(Thread.current.threadName)
                        gotPresigned = self.getPresigned(uploadType: self.imageUploadType, parameters: parameters, vmRealm: vmRealm)
                        
                        if !gotPresigned{
                            continue
                        }
                        
                        //UPLOAD IMAGE CALL
                        var imageUploaded = false
                        
                        guard let image = loadImageFromDocumentDirectory(imageName: "\(imageData.imageName)", projectId:  "\(imageData.projectId )",skuId:"\(imageData.skuId )") else {  return  }
                        
                        imageUploaded = self.uploadBinaryImage(presigned_url: self.imageData?.presignedUrl ?? "", image: image, vmRealm: vmRealm)
                        
                        //if Error in image Uploading then continue
                        if !imageUploaded{
                            continue
                        }
                        
                        
                        //MARK DONE CALL
                        
                        let markDoneParameters = [
                            [
                                "key": "image_id",
                                "value": self.imageData?.imageId ?? "",
                                "type": "text"
                            ],
                            [
                                "key": "auth_key",
                                "value": CLIENT.shared.getUserSecretKey(),
                                "type": "text"
                            ]] as [[String : Any]]
                        
                        
                        var markDone = false
                        
                        markDone = self.markDoneImage(parameters: markDoneParameters, vmRealm: vmRealm)
                        print("DoneDone")
                        if !markDone{
                            continue
                        }
                        
                        print("startUploading: imageMarkedDone : ",markDone)
                        
                        continue
                        
                    }
                    
                }//:upload flag check
                
                else{
                    
                    if imageData == nil{
                       
                        let markDoneCount = vmRealm.markDoneImage(imageData: self.imageData)
                        self.captureEvent(eventName: PosthogEvent.IMAGE_ID_NULL, image: imageData, isSuccess: false,error: "", dbUpdateStatus: markDoneCount, response: "", retryCount: retryCount, throwable: "")
                        
                        retryCount = 0
                        continue
                    }//: Image Id Check
                    else{
                        
                        let markDoneParameters = [
                            [
                                "key": "image_id",
                                "value": self.imageData?.imageId ?? "",
                                "type": "text"
                            ],
                            [
                                "key": "auth_key",
                                "value": CLIENT.shared.getUserSecretKey(),
                                "type": "text"
                            ]] as [[String : Any]]
                        
                        var imageMarkDone = false
                        imageMarkDone = self.markDoneImage(parameters: markDoneParameters, vmRealm: vmRealm)
                        
                        print("DoneDone")
                        if imageMarkDone {
                            retryCount = 0
                        }
                        continue
                        
                    }
                }
            }
            
        }while imageData != nil
        //  if Reachability.isConnectedToNetwork(){
        //    Storage.isUploadRunning = false
        // }
        }
        
    }
    
    
    //Capture Event
    func captureEvent(eventName: String,image: RealmImageData?,isSuccess: Bool,error: String?,dbUpdateStatus: Int,response: String?,retryCount: Int,throwable: String?){
        
        let properties : [String:Any] = [
            "sku_id" : image?.skuId ?? "",
            "iteration_id" : "\(lastIdentifier)",
            "db_update_status" : "\(dbUpdateStatus)",
            "data" : PosthogEvent.shared.getImageDetail(imageData: self.imageData).jsonString,
            "response" : response ?? "",
            "retry_count" : "\(retryCount)",
            "throwable" : throwable ?? ""
        ]
        PosthogEvent.shared.posthogCapture(identity: eventName, properties: properties)
    }
    
    //MARK: - SAVE IMAGE TO DOCUMENT FOLDER AND SAVE REFFRENCE TO REALM FILE
    func saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(imageObject:RealmImageData,image: UIImage,selectedAngle:Int,serviceStartedBy:String) {
    
        
        let documentsUrl = URL.createFolder(folderName: "\(imageObject.projectId)", subFolderName: "\(imageObject.skuId)")
        
        let imageName = "\(imageObject.skuName)_\(imageObject.skuId)_\(imageObject.imageCategory)_\(selectedAngle+1).jpeg"
        
        imageObject.imageName = imageName
        imageObject.uploadType = self.imageUploadType
        
        guard let fileURL = documentsUrl?.appendingPathComponent(imageName) else { return  }
        
        if let imageData = image.jpegData(compressionQuality:Settings.imageCompressionQuality) {
            try? imageData.write(to: fileURL, options: .atomic)
            do {
                imageObject.path = fileURL.absoluteString
                try? RealmViewModel.main.realm.safeWrite {
                    RealmViewModel.main.realm.add(imageObject)
                    if !BackgroundUpload.isUploadRunning {
                        SpyneSDK.upload.uploadParent(type: StringCons.regular, serviceStartedBy: serviceStartedBy)
                    }
                } 
            }  catch {
                print(error)
            }
         }
    }
    
    //MARK: - LOAD IMAGE FROM DOCUMENT DIRECTORY
    func loadImageFromDocumentDirectory(imageName: String,projectId:String,skuId:String) -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath.appending("/\(projectId)/\(skuId)")).appendingPathComponent(imageName+".jpg")
            try? FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication], ofItemAtPath: dirPath)
            
            guard let image = UIImage(contentsOfFile: imageURL.path) else { return nil}
            return image
        }
        return nil
    }
    
    //MARK: - Upload Image
    func getPresigned(uploadType:String,parameters:[[String : Any]], vmRealm: RealmViewModel = RealmViewModel.main)->Bool{
        
        if CLIENT.shared.getUserSecretKey() == ""{
            return false
        }
        
        var getPresignedStatus = false
        var result:ImageUploadRootClass?
        var errorMessage = ""
        
        self.captureEvent(eventName: PosthogEvent.GET_PRESIGNED_CALL_INITIATED, image: imageData, isSuccess: true, error: nil, dbUpdateStatus: 0, response: nil, retryCount: 0, throwable: nil)
        
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                if param["contentType"] != nil {
                    body += "\r\nContent-Type: \(param["contentType"] as! String)"
                }
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    let fileData = try? NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData!, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                    + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        //let postData = parameters.data(using: .utf8)
        
        guard let url = URL(string: StringCons.baseUrlUploadImage)else {return false}
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let decoder = JSONDecoder()
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                getPresignedStatus = false
                semaphore.signal()
                return
                
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Binary Upload StatusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200{
                    do {
                        
                        result = try decoder.decode(ImageUploadRootClass.self, from: data)
                        // DispatchQueue.global().async {
                        getPresignedStatus = true
                        semaphore.signal()
                        //  }
                        
                    }
                    catch {
                        
                        errorMessage = error.localizedDescription
                        self.retryCount += 1
                        //  DispatchQueue.global().async {
                        getPresignedStatus = false
                        semaphore.signal()
                        // }
                        
                    }
                }else{
                    //  DispatchQueue.global().async {
                    getPresignedStatus = false
                    semaphore.signal()
                    //  }
                }
            }else{
                errorMessage = error?.localizedDescription ?? ""
                self.retryCount += 1
                // DispatchQueue.global().async {
                getPresignedStatus = false
                semaphore.signal()
                //  }
            }
        }
        
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        
        //SET REALM VALUE OUTSIDE THE SEAMPHORE BLOCK BEACAUSE OF THREAD CRASHES
        if getPresignedStatus{
            
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(result)
            let json = String(data: jsonData!, encoding: String.Encoding.utf16)
            
            
            self.captureEvent(eventName: PosthogEvent.GOT_PRESIGNED_IMAGE_URL, image: self.imageData, isSuccess: true, error: nil, dbUpdateStatus: 0, response: json, retryCount: self.retryCount, throwable: nil)
            
            let presignedUrlDataCount = vmRealm.addPreSignedUrl(imageData: self.imageData)
            
            self.captureEvent(eventName: PosthogEvent.IS_PRESIGNED_URL_UPDATED, image: self.imageData, isSuccess: true, error: nil, dbUpdateStatus: presignedUrlDataCount, response: json, retryCount: self.retryCount, throwable: nil)
            try! vmRealm.realm.safeWrite {
                self.imageData?.presignedUrl = result?.data?.presignedUrl ?? ""
                self.imageData?.imageId = result?.data?.imageId ?? ""
            }
        }else{
            var properties:[String:Any] = PosthogEvent.shared.getImageDetail(imageData: self.imageData)
            properties["message"] = errorMessage
            PosthogEvent.shared.posthogCapture(identity: PosthogEvent.GET_PRESIGNED_FAILED, properties: properties)
            self.retryCount += 1
        }
        return getPresignedStatus
    }
    
    //MARK: - Upload Binary Image using session task
    func uploadBinaryImage(presigned_url:String,image:UIImage, vmRealm: RealmViewModel = RealmViewModel.main)->Bool{
    
        if CLIENT.shared.getUserSecretKey() == ""{
            return false
        }
        
        self.captureEvent(eventName: PosthogEvent.UPLOADING_TO_GCP_INITIATED, image: self.imageData, isSuccess: true, error: "", dbUpdateStatus: 0, response: "", retryCount: self.retryCount, throwable: "")
        
        var errorMessage = ""
        
        var imageUploadStatus = false
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        let imgData = image.jpegData(compressionQuality: 1.0)
        
        let postData = imgData
        
        guard let url = URL(string: presigned_url)else {return false}
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "PUT"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                //      DispatchQueue.global().async {
                var imageUploadStatus = false
                semaphore.signal()
                //      }
                self.retryCount += 1
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Binary Upload StatusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200{
                    imageUploadStatus = true
                }else{
                    errorMessage = "GCP Image upload Failed"
                    imageUploadStatus = false
                    self.retryCount += 1
                }
            }else{
                errorMessage = "GCP Image upload Failed"
                imageUploadStatus = false
                self.retryCount += 1
            }
            
            //  DispatchQueue.global().async {
            semaphore.signal()
            //   }
        }
        
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        if imageUploadStatus{
            try! vmRealm.realm.safeWrite {
                self.imageData?.gcpUpload = true
            }
            let markUploadCount = vmRealm.markGCPUploaded(imageData: self.imageData)
            self.captureEvent(eventName: PosthogEvent.IS_MARK_GCP_UPLOADED_UPDATED, image: self.imageData, isSuccess: true, error: "", dbUpdateStatus: markUploadCount, response: "", retryCount: self.retryCount, throwable: "")
        }else{
            
            self.captureEvent(eventName: PosthogEvent.IMAGE_UPLOAD_TO_GCP_FAILED, image: self.imageData, isSuccess: false, error: errorMessage, dbUpdateStatus: 0, response: errorMessage, retryCount: self.retryCount, throwable: errorMessage)
            self.retryCount += 1
            
        }
        
        return imageUploadStatus
    }
    
    //MARK: - MARK DONE
    private func markDoneImage(parameters:[[String : Any]], vmRealm: RealmViewModel = RealmViewModel.main)->Bool{
        
        if CLIENT.shared.getUserSecretKey() == ""{
            return false
        }
        
        self.captureEvent(eventName: PosthogEvent.MARK_DONE_CALL_INITIATED, image: self.imageData, isSuccess: true, error: "", dbUpdateStatus: 0, response: "", retryCount: self.retryCount, throwable: "")
        
        var result:CommonMessageRootClass?
        var errorMessage = ""
        
        var markDoneStatus = false
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                if param["contentType"] != nil {
                    body += "\r\nContent-Type: \(param["contentType"] as! String)"
                }
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    let fileData = try? NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData!, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                    + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        //let postData = parameters.data(using: .utf8)
        
        guard let url = URL(string: StringCons.baseUrlImageMarkDone)else {return false}
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let decoder = JSONDecoder()
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                markDoneStatus = false
                //       DispatchQueue.global().async {
                semaphore.signal()
                //        }
                return
            }  
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Binary Upload StatusCode: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200{
                    result = try? decoder.decode(CommonMessageRootClass.self, from: data)
                    markDoneStatus = true
                    //      DispatchQueue.global().async {
                    semaphore.signal()
                    //      }
                }else{
                    errorMessage = httpResponse.debugDescription
                    self.retryCount += 1
                    markDoneStatus = false
                    //      DispatchQueue.global().async {
                    semaphore.signal()
                    //      }
                }
            }else{
                errorMessage = response.debugDescription
                self.retryCount += 1
                markDoneStatus = false
                //    DispatchQueue.global().async {
                semaphore.signal()
                //    }
            }
        }
        
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        if markDoneStatus{
        
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(result)
            let json = String(data: jsonData!, encoding: String.Encoding.utf16)
            
            self.captureEvent(eventName: PosthogEvent.MARKED_IMAGE_UPLOADED, image: self.imageData, isSuccess: true, error: nil, dbUpdateStatus:0, response: json, retryCount: self.retryCount, throwable: nil)
            
            let markDoneCount = vmRealm.markDoneImage(imageData: self.imageData)
            
            self.captureEvent(eventName: PosthogEvent.IS_MARK_DONE_STATUS_UPDATED, image: self.imageData, isSuccess: true, error: nil, dbUpdateStatus:markDoneCount, response: json, retryCount: self.retryCount, throwable: nil)
            try! vmRealm.realm.safeWrite {
                self.imageData?.uploadFlag = 1
            }
        
        }else{
            self.captureEvent(eventName: PosthogEvent.MARK_IMAGE_UPLOADED_FAILED, image: self.imageData, isSuccess: true, error: errorMessage, dbUpdateStatus: 0, response: errorMessage, retryCount: self.retryCount, throwable: errorMessage)
        }
        self.retryCount = 0
        return markDoneStatus
    }
    
}
