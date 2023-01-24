//
//  UploadBackgroundVideo.swift
//  Spyne
//
//  Created by Vijay Parmar on 11/02/22.
//  Copyright © 2022 Spyne. All rights reserved.
//

import Foundation
import RealmSwift
import PostHog

class BackgroundUploadVideo {
    
    var vmBgUpload = BGUploadViewModel()
   //let localRealm = try? Realm()
   // let vmRealm = RealmViewModel()
    var retryCount: Int = 0
    var lastIdentifier = String()
    var videoData:RealmVideoData?
    var videoUploadType = StringCons.regular
    static var isVideoUploadRunning = false
    
    func uploadParent(type:String, serviceStartedBy:String){
        
        //Posthog Event Capture
        let properties = [
            "type" : "\(type)",
            "service_started_by": "\(serviceStartedBy)",
            "upload_running" : "\(BackgroundUploadVideo.isVideoUploadRunning)"
        ]
      
        PosthogEvent.shared.posthogCapture(identity: PosthogEvent.VIDEO_UPLOAD_PARENT_TRIGGERED, properties: properties)
        
        Storage.isVideoUploadTriggred = true
        
        if Storage.isVideoUploadTriggred && !BackgroundUploadVideo.isVideoUploadRunning{
            if Reachability.isConnectedToNetwork(){
                BackgroundUploadVideo.isVideoUploadRunning = true
                //Posthog Event Capture
                PosthogEvent.shared.posthogCapture(identity: PosthogEvent.VIDEO_UPLOADING_RUNNING, properties: [:])
                self.startUploading()
            }else{
                BackgroundUploadVideo.isVideoUploadRunning = false
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
            
            videoData = vmRealm.getSingleRealmVideoData(status: 0)
            
            if videoData == nil{
                videoUploadType = StringCons.skipped
                videoData = vmRealm.getSingleRealmVideoData(status: -1)
                skipFlag = -2
            }
            
            if videoData == nil && videoUploadType == StringCons.skipped{
                
                let skippedImagesCount = vmRealm.updateSkippedVideos()
                
                let markDoneSkippedCount = vmRealm.updateMarkDoneSkipedVideos()
                
                if (skippedImagesCount > 0 || markDoneSkippedCount > 0){
                    videoData = vmRealm.getSingleRealmVideoData(status: -1)
                }
            }
            
            if videoData == nil{
                
                //Posthog Event Capture
                let properties = [
                    "remaining_images" : [
                        "upload_remaining" : "\(vmRealm.totalRemainingUploadVideo())",
                        "mark_done_remaining" : "\(vmRealm.totalRemainingUploadVideo())"
                    ].jsonString
                ]
                
                PosthogEvent.shared.posthogCapture(identity: PosthogEvent.VIDEO_ALL_UPLOADED_BREAK, properties: properties)
                BackgroundUploadVideo.isVideoUploadRunning = false
                break
                
            }else{
                
                lastIdentifier = "\(videoData?.videoName ?? "")_\(videoData?.skuId ?? "")"
                
                //Image Selected
                let properties:[String:Any] = [
                    "sku_id" : videoData?.skuId ?? "",
                    "iteration_id" : lastIdentifier,
                    "retry_count" : "\(retryCount)",
                    "upload_type" : "\(videoUploadType)",
                    
                    "data" : PosthogEvent.shared.getVideoDetail(imageData: videoData).jsonString,
                    "remaining_images" : [
                        "upload_remaining" : vmRealm.totalRemainingUpload(),
                        "mark_done_remaining" : vmRealm.totalRemainingUpload(),
                        "remaining_above" : vmRealm.getRemainingAboveVideo(imageData: videoData),
                        "remaining_below" : vmRealm.getRemainingAboveVideo(imageData: videoData)
                    ].jsonString
                ]
               
                PosthogEvent.shared.posthogCapture(identity: PosthogEvent.VIDEO_SELECTED_IMAGE, properties: properties)
            
                if retryCount > 4{
                    
                    let dbStatus = videoData?.uploadFlag != 1 ? vmRealm.skipVideo(imageData: videoData, skipFlag: skipFlag) : vmRealm.skipVideo(imageData: videoData, skipFlag: -1)
                    
                    //Posthog Event Capture
                    self.captureEvent(eventName: PosthogEvent.VIDEO_MAX_RETRY, video: videoData, isSuccess: false, error: "Image upload limit reached", dbUpdateStatus : dbStatus,response: "", retryCount: retryCount, throwable: "")
                    
                    retryCount = 0
                    
                    continue
                    
                }//: Retry Count Condition
                
                
                if videoData?.uploadFlag == 0 || videoData?.uploadFlag == -1{
                    
                    if videoData?.presignedUrl != ""{
                        
                        //UPLOAD IMAGE CALL
                        
                        var imageUploaded = false
                        
//                         guard let image = loadImageFromDocumentDirectory(imageName: "\(self.videoData?.videoName ?? "")", projectId:  "\(self.videoData?.projectId ?? "")",skuId:"\(self.videoData?.skuId ?? "")") else {  return  }
                        
                        imageUploaded = self.uploadBinaryVideo(presigned_url: self.videoData?.presignedUrl ?? "", videoPath: self.videoData?.path ?? "",vmRealm:vmRealm)
                        
                        //if Error in image Uploading then continue
                        if !imageUploaded{
                            continue
                        }
                        
                        //MARK DONE CALL
                        let markDoneParameters = [
                            [
                                "key": "video_id",
                                "value": self.videoData?.videoId ?? "",
                                "type": "text"
                            ],
                            [
                                "key": "auth_key",
                                "value": USER.authKey,
                                "type": "text"
                            ]] as [[String : Any]]
                        
                        
                        var markDone = false
                        
                        markDone = self.markDoneVideo(parameters: markDoneParameters,vmRealm:vmRealm)
                        
                        if !markDone{
                            continue
                        }
                        
                        print("Start Uploading: imageMarkedDone : ",markDone)
                        continue
                        
                    }//:Presign url check condition
                    
                    else{
                        
                        videoUploadType =  retryCount == 1 ? "Direct" : "Retry"
                        
                        guard let imageData = videoData else {
                            return
                        }
                      
                        let parameters = [
                            [
                                "key": "auth_key",
                                "value": USER.authKey,
                                "type": "text"
                            ],
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
                                "key": "category",
                                "value": imageData.videoCategory,
                                "type": "text"
                            ],
                            [
                                "key": "sub_category",
                                "value": imageData.skuId,
                                "type": "text"
                            ],
                            [
                                "key": "total_frames_no",
                                "value": "1",
                                "type": "text"
                            ],
                            [
                                "key": "video_name",
                                "value": imageData.videoName,
                                "type": "text"
                            ],
                            [
                                "key": "background_id",
                                "value": imageData.overlay_id,
                                "type": "text"
                            ]
                            ] as [[String : Any]]
                        
                        var gotPresigned = false
                        
                        // print(Thread.current.threadName)
                        gotPresigned = self.getPresigned(uploadType: self.videoUploadType, parameters: parameters,vmRealm: vmRealm)
                        
                        if !gotPresigned{
                            continue
                        }
                        
                        
                        //UPLOAD IMAGE CALL
                        var imageUploaded = false
                        
                        imageUploaded = self.uploadBinaryVideo(presigned_url: self.videoData?.presignedUrl ?? "", videoPath: self.videoData?.path ?? "",vmRealm:vmRealm)
                        
                        //if Error in image Uploading then continue
                        if !imageUploaded{
                            continue
                        }
                        
                        //MARK DONE CALL
                        let markDoneParameters = [
                            [
                                "key": "video_id",
                                "value": self.videoData?.videoId ?? "",
                                "type": "text"
                            ],
                            [
                                "key": "auth_key",
                                "value": USER.authKey,
                                "type": "text"
                            ]] as [[String : Any]]
                        
                        var markDone = false
                        markDone = self.markDoneVideo(parameters: markDoneParameters,vmRealm: vmRealm)
                        if !markDone{
                            continue
                        }
                        
                        print("startUploading: imageMarkedDone : ",markDone)
                        continue
                    }
                    
                }//:upload flag check
                
                else{
                    
                    if videoData == nil{
                       
                        let markDoneCount = vmRealm.markDoneVideo(videoData: self.videoData)
                        self.captureEvent(eventName: PosthogEvent.VIDEO_IMAGE_ID_NULL, video: videoData, isSuccess: false,error: "", dbUpdateStatus: markDoneCount, response: "", retryCount: retryCount, throwable: "")
                        
                        retryCount = 0
                        continue
                    }//: Image Id Check
                    else{
                        
                        let markDoneParameters = [
                            [
                                "key": "video_id",
                                "value": self.videoData?.videoId ?? "",
                                "type": "text"
                            ],
                            [
                                "key": "auth_key",
                                "value": USER.authKey,
                                "type": "text"
                            ]] as [[String : Any]]
                        
                        var imageMarkDone = false
                        imageMarkDone = self.markDoneVideo(parameters: markDoneParameters,vmRealm: vmRealm)
                        if imageMarkDone {
                            retryCount = 0
                        }
                        continue
                        
                    }
                }
            }
            
        }while videoData != nil
        
        //  if Reachability.isConnectedToNetwork(){
        //    Storage.isVideoUploadRunning = false
        // }
        
    }
    
}
    
    
    //Capture Event
    func captureEvent(eventName: String,video: RealmVideoData?,isSuccess: Bool,error: String?,dbUpdateStatus: Int,response: String?,retryCount: Int,throwable: String?){
        
        let properties : [String:Any] = [
            "sku_id" : video?.skuId ?? "",
            "iteration_id" : "\(lastIdentifier)",
            "db_update_status" : "\(dbUpdateStatus)",
            "data" : PosthogEvent.shared.getVideoDetail(imageData: self.videoData).jsonString,
            "response" : response ?? "",
            "retry_count" : "\(retryCount)",
            "throwable" : throwable ?? ""
        ]
        
        PosthogEvent.shared.posthogCapture(identity: eventName, properties: properties)
       
    }
    
    //MARK: - SAVE IMAGE TO DOCUMENT FOLDER AND SAVE REFFRENCE TO REALM FILE
    func saveVideoToDecumentFolderAndSaveTheReferenceToRealmFile(imageObject:RealmVideoData,url: String,selectedAngle:Int,serviceStartedBy:String) {
        
        guard let sourceUrl = URL(string: url)else{return}
      //  guard let destUrl = tempCompressedURL()else{return}
        
        
        imageObject.path = url
        try? RealmViewModel.main.realm.safeWrite {
            RealmViewModel.main.realm.add(imageObject)
            if !BackgroundUploadVideo.isVideoUploadRunning{
                SpyneSDK.uploadVideo.uploadParent(type: StringCons.regular, serviceStartedBy: serviceStartedBy)
            }
         }
        
        
        //MARK: -  Compression code
      /*  let videoCompressor = LightCompressor()
        let compression: Compression = videoCompressor.compressVideo(
                                        source: sourceUrl,
                                        destination: destUrl,
                                        quality: .medium,
                                        isMinBitRateEnabled: true,
                                        keepOriginalResolution: false,
                                        progressQueue: .main,
                                        progressHandler: { progress in
                                            // progress
                                        },
                                        completion: {[weak self] result in
                                            guard let `self` = self else { return }
                                                     
                                            switch result {
                                            case .onSuccess(let path):
                                                // success

                                            case .onStart: break
                                                // when compression starts
                                                         
                                            case .onFailure(let error): break
                                                // failure error
                                                         
                                            case .onCancelled: break
                                                // if cancelled
                                            }
                                        }
         )

        // to cancel call
        compression.cancel = true
     */
    }

    
    //MARK: - Upload Image
    func getPresigned(uploadType:String,parameters:[[String : Any]],vmRealm: RealmViewModel = RealmViewModel.main)->Bool{
        
        if USER.authKey == ""{
            return false
        }
        
        var getPresignedStatus = false
        var result:ImageUploadRootClass?
        var errorMessage = ""
        
        self.captureEvent(eventName: PosthogEvent.VIDEO_GET_PRESIGNED_CALL_INITIATED, video: videoData, isSuccess: true, error: nil, dbUpdateStatus: 0, response: nil, retryCount: 0, throwable: nil)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
       // var error: Error? = nil
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

        var request = URLRequest(url: URL(string: StringCons.baseUrlUploadVideo)!,timeoutInterval: Double.infinity)
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        
        let decoder = JSONDecoder()
        let  semaphore = DispatchSemaphore (value: 0)
        
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
                //DispatchQueue.global().async {
                getPresignedStatus = false
                semaphore.signal()
                //}
            }
        }
        
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        
        //SET REALM VALUE OUTSIDE THE SEAMPHORE BLOCK BEACAUSE OF THREAD CRASHES
        if getPresignedStatus{
            
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(result)
            let json = String(data: jsonData!, encoding: String.Encoding.utf16)
            
            
            self.captureEvent(eventName: PosthogEvent.VIDEO_GOT_PRESIGNED_IMAGE_URL, video: self.videoData, isSuccess: true, error: nil, dbUpdateStatus: 0, response: json, retryCount: self.retryCount, throwable: nil)
            
            let presignedUrlDataCount = vmRealm.addPreSignedUrl(imageData: self.videoData)
            
            self.captureEvent(eventName: PosthogEvent.VIDEO_IS_PRESIGNED_URL_UPDATED, video: self.videoData, isSuccess: true, error: nil, dbUpdateStatus: presignedUrlDataCount, response: json, retryCount: self.retryCount, throwable: nil)
            
            try! vmRealm.realm.safeWrite {
                self.videoData?.presignedUrl = result?.data?.presignedUrl ?? ""
                self.videoData?.videoId = result?.data?.videoId ?? ""
            }
         
        }else{
            
            var properties:[String:Any] = PosthogEvent.shared.getVideoDetail(imageData: self.videoData)
            properties["message"] = errorMessage
            PosthogEvent.shared.posthogCapture(identity: PosthogEvent.GET_PRESIGNED_FAILED, properties: properties)
            self.retryCount += 1
        }
        return getPresignedStatus
        
    }
    
    //MARK: - Upload Binary Image using session task
    func uploadBinaryVideo(presigned_url:String,videoPath:String,vmRealm: RealmViewModel = RealmViewModel.main)->Bool{
    
        if USER.authKey == ""{
            return false
        }
        
        self.captureEvent(eventName: PosthogEvent.VIDEO_UPLOADING_TO_GCP_INITIATED, video: self.videoData, isSuccess: true, error: "", dbUpdateStatus: 0, response: "", retryCount: self.retryCount, throwable: "")
        
        var errorMessage = ""
        
        var videoUploadStatus = false
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
      //  let imgData = image.jpegData(compressionQuality: 1.0)
        print("Media URL : ",videoPath)
        
        var postData = Data()
        
        if let videoUrl = URL(string: videoPath){
            do {
                postData = try Data(contentsOf: videoUrl)
            }
            catch let error {
                print(error)
            }
        }
        
        guard let url = URL(string: presigned_url)else {return false}
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "PUT"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            guard let _ = data else {
                print(String(describing: error))
                videoUploadStatus = false
                semaphore.signal()
                self.retryCount += 1
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Binary Upload StatusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200{
                    videoUploadStatus = true
                }else{
                    errorMessage = "GCP Image upload Failed"
                    videoUploadStatus = false
                    self.retryCount += 1
                }
            }else{
                errorMessage = "GCP Image upload Failed"
                videoUploadStatus = false
                self.retryCount += 1
            }
            
            //  DispatchQueue.global().async {
            semaphore.signal()
            //   }
        }
        
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        if videoUploadStatus{
           
            try! vmRealm.realm.safeWrite {
                self.videoData?.gcpUpload = true
            }
            
            let markUploadCount = vmRealm.markGCPUploadedVideo(videoData: self.videoData)
            
            self.captureEvent(eventName: PosthogEvent.VIDEO_IS_MARK_GCP_UPLOADED_UPDATED, video: self.videoData, isSuccess: true, error: "", dbUpdateStatus: markUploadCount, response: "", retryCount: self.retryCount, throwable: "")
        }else{
            
            self.captureEvent(eventName: PosthogEvent.VIDEO_IMAGE_UPLOAD_TO_GCP_FAILED, video: self.videoData, isSuccess: false, error: errorMessage, dbUpdateStatus: 0, response: errorMessage, retryCount: self.retryCount, throwable: errorMessage)
            self.retryCount += 1
            
        }
        
        return videoUploadStatus
    }
    
    //MARK: - MARK DONE
    func markDoneVideo(parameters:[[String : Any]],vmRealm: RealmViewModel = RealmViewModel.main)->Bool{
        
        if USER.authKey == ""{
            return false
        }
        
        self.captureEvent(eventName: PosthogEvent.VIDEO_MARK_DONE_CALL_INITIATED, video: self.videoData, isSuccess: true, error: "", dbUpdateStatus: 0, response: "", retryCount: self.retryCount, throwable: "")
        
        var result:CommonMessageRootClass?
        var errorMessage = ""
        
        var markDoneStatus = false
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        //var error: Error? = nil
        
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
        
        guard let url = URL(string: StringCons.baseUrlVideoMarkDone)else {return false}
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "PUT"
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
                    //DispatchQueue.global().async {
                    semaphore.signal()
                    //}
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
            
            self.captureEvent(eventName: PosthogEvent.VIDEO_MARKED_IMAGE_UPLOADED, video: self.videoData, isSuccess: true, error: nil, dbUpdateStatus:0, response: json, retryCount: self.retryCount, throwable: nil)
            
            let markDoneCount = vmRealm.markDoneVideo(videoData: self.videoData)
            
            self.captureEvent(eventName: PosthogEvent.IS_VIDEO_MARK_DONE_STATUS_UPDATED, video: self.videoData, isSuccess: true, error: nil, dbUpdateStatus:markDoneCount, response: json, retryCount: self.retryCount, throwable: nil)
            
            try! vmRealm.realm.safeWrite {
                self.videoData?.uploadFlag = 1
            }
        
        }else{
            
            self.captureEvent(eventName: PosthogEvent.VIDEO_MARK_UPLOADED_FAILED, video: self.videoData, isSuccess: true, error: errorMessage, dbUpdateStatus: 0, response: errorMessage, retryCount: self.retryCount, throwable: errorMessage)
            
        }
        
        self.retryCount = 0
        return markDoneStatus
        
    }
    
}

