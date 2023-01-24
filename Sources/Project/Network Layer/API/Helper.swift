//
//  Helper.swift
//  Created by Vijay Parmar on 21/05/20.
//  Copyright © 2020 Vijay Parmar. All rights reserved.
//

import Foundation
import UIKit
import AVKit
//import SDWebImage
import PostHog
//import RealmSwift
import Toast_Swift
import Amplitude
//APPLICATION  CONSTANSTS
let appName = Bundle.appName()
let appNameDirectory = appName.stripped
let POSTHOG_API_KEY = "FoIzpWdbY_I9T_4jr5k4zzNuVJPcpzs_mIpO6y7581M"

class Settings{
    static var sessionPresetAutomobiles : AVCaptureSession.Preset = .hd1920x1080
    static var imageCompressionQuality:CGFloat = 0.5
}

class Alert{

    //NetWork Messages
    static let Network = "Oops! Please Check Data Connection" 
    static let Timeout = "Oops! Please Check Data Connection" 
    static let Unknown = "It is unknown whether the network is reachable" 
    static let SomethingWrong = "Something went wrong" 

    //Data Validation
    static let EmptyMobile = "Please enter mobile number" 
    static let InvalidMobile = "Please enter valid mobile number" 
    static let InvalidMobileEmail = "invalid email or mobile number" 
    static let InvalidPincode = "Please enter valid pincode" 
    static let EmptyEmail = "Please enter email address"
    static let EmptyEmailMobileNumber = "Please enter email address or mobile number"
    static let InvalidEmail = "Please enter valid email address"
    static let EmptyPassword = "Please enter password" 
    static let EmptyConfirmPassword = "Please enter confirm password" 
    static let InvalidPassword = "Password must be eight character long" 
    static let InvalidPasswordWithChar = "Password must be contains atlest one uppercase, lowercase and numeric value" 
    static let InvalidConfirmPass = "Confirm Password not match" 
    static let EmptyName = "Please enter first name" 
    static let EmptyRefralCode = "Please enter refral code" 
    static let EmptyLastName = "Please enter last name" 
    static let EmptyAddress = "Please enter address" 
    static let EmptyCity = "Please enter city" 
    static let EmptyState = "Please enter state" 
    static let EmptyZipcode = "Please enter pincode" 
    static let EmptyContact = "Please enter contact number" 
    static let EmptyEducation = "Please select education" 
    static let EmptySubject = "Please select Subject" 
    static let EmptyRating = "Please add rating" 
    static let EmptyDescription = "Please enter description" 
    static let EmptyTopicName = "Empty topic name" 
    static let EmptyType = "Select Type" 
    static let EmptyCountryName = "Please Select Country" 
    static let EnterProjectName = "Project name mandatory" 
    static let EnterSKUName = "Product name mandatory" 
    static let NoCategoryAgnosticData = "Category Agnostic Data Not Found For This Category, Please Connect To Admin"
    static let EmptyDate = "Please select date" 
    static let EmptyTime = "Please select time" 
    static let EmptyColor = "Please select color" 
    static let EmptyTexture = "Please select texture" 
    static let EmptyOTP = "Please Enter OTP" 
    static let InvalidOTP = "Please enter valid OTP" 
    static let InvalidOTPLenth = "OTP Must be 6 Digit" 
    static let ImagesDownloaded = "Image Download Completed!"
    static let creditRequired = "Sorry! Your available credits not enough to download images, Please Topup to download HD images" 
    static let creditRequiredUpload = "Sorry! Your available credits not enough to generate 360 shoot output, Please Topup or change fidality fo proceed." 
    static let successfulyUpdateSku = "Successful Update Sku Name" 
    static let exitShootPopupTitle = "Are you sure you want to exit this shoot?" 
    static let skipAnglePopupTitle = "Are you sure want to skip this section?" 
    static let apiErrorGetCompeletedProject = "Something is wrong in get completed project" 
    static let apiErrorGetOngoingProject = "Something is wrong in get Ongoing project" 
    static let termsAndConditionUrl = "https://www.spyne.ai/terms-service" 
    static let showcaseSubCatText = "Select Car Category From List" 
    static let showcaseAngleText = "Select the number of angles" 
    static let showcaseSKUText = "Rename the SKU Name" 
    static let showcaseOverlayText = "Turn the overlay On and Off from here" 
    static let showcaseGallaryText = "You can upload image directly from your Gallery" 
    static let otpCodeMessage:String = "Enter the 6-digit \none time password just sent to sent to \n" 
    static let gyroScopeNotAvailable = "This device not support gyroscope" 
    static let insertProjectError = "Error: Insert project data failure" 
    static let insertSkuError = "Error: Insert sku data failure" 
    static let redGyrometerError = "Your gyrometer is red!\nRe-Adjust your phone and click when the gyrometer turns green!" 
    static let imageUploadError = "Image Upload Failed" 
    static let areYouSureYouWantToExist = "Are you sure you want to exist?" 
    static let chooseYourShootEnvironment = "Please Choose Your Shoot Environment" 

}

class PosthogEvent{

    static let shared = PosthogEvent()

    static let VIDEO_UPLOAD_PARENT_TRIGGERED = "IOS VIDEO UPLOAD PARENT TRIGGERED"
    static let VIDEO_UPLOADING_RUNNING = "IOS VIDEO UPLOADING RUNNING"
    static let VIDEO_CONNECTION_BREAK = "IOS VIDEO CONNECTION BREAK"
    static let VIDEO_ALL_UPLOADED_BREAK = "IOS VIDEO ALL UPLOADED BREAK"
    static let VIDEO_SELECTED_IMAGE = "IOS VIDEO SELECTED_IMAGE"
    static let VIDEO_GET_PRESIGNED_CALL_INITIATED = "IOS VIDEO GET_PRESIGNED_CALL_INITIATED"
    static let VIDEO_GOT_PRESIGNED_IMAGE_URL = "IOS VIDEO GOT PRESIGNED IMAGE URL"
    static let VIDEO_IS_PRESIGNED_URL_UPDATED = "IOS VIDEO IS PRESIGNED URL UPDATED"
    static let VIDEO_UPLOADING_TO_GCP_INITIATED = "IOS VIDEO UPLOADING TO GCP INITIATED"
    static let VIDEO_IMAGE_UPLOAD_TO_GCP_FAILED = "IOS VIDEO IMAGE UPLOAD TO GCP FAILED"
    static let VIDEO_IMAGE_UPLOADED_TO_GCP = "IOS VIDEO IMAGE UPLOADED TO GCP"
    static let VIDEO_IS_MARK_GCP_UPLOADED_UPDATED = "IOS VIDEO IS_MARK_GCP_UPLOADED_UPDATED"
    static let VIDEO_MARK_DONE_CALL_INITIATED = "IOS VIDEO MARK DONE CALL INITIATED"
    static let VIDEO_IMARK_IMAGE_UPLOADED_FAILED = "IOS VIDEO IMARK IMAGE UPLOADED FAILED"
    static let VIDEO_MARKED_IMAGE_UPLOADED = "IOS VIDEO MARKED IMAGE UPLOADED"
    static let VIDEO_IS_MARK_DONE_STATUS_UPDATED = "IOS VIDEO IS_MARK_DONE_STATUS_UPDATED"
    static let VIDEO_SERVICE_STARTED = "IOS VIDEO SERVICE STARTED"
    static let VIDEO_INTERNET_DISCONNECTED = "IOS VIDEO INTERNET DISCONNECTED"
    static let VIDEO_INTERNET_CONNECTED = "IOS VIDEO INTERNET CONNECTED"
    static let VIDEO_MAX_RETRY = "IOS VIDEO MAX RETRY"
    static let VIDEO_GET_PRESIGNED_FAILED = "IOS VIDEO GET PRESIGNED FAILED"
    static let VIDEO_MARK_UPLOADED_FAILED = "IOS  MARK VIDEO UPLOADED FAILED"
    static let VIDEO_IMAGE_ID_NULL = "IOS VIDEO IMAGE ID NULL"
    static let MARKED_VIDEO_UPLOADED = "IOS MARKED VIDEO UPLOADED"
    static let IS_VIDEO_MARK_DONE_STATUS_UPDATED = "IOS VIDEO IS_MARK_DONE_STATUS_UPDATED "

    static let UPLOAD_PARENT_TRIGGERED = "IOS UPLOAD PARENT TRIGGERED"
    static let UPLOADING_RUNNING = "IOS UPLOADING RUNNING"
    static let CONNECTION_BREAK = "IOS CONNECTION BREAK"
    static let ALL_UPLOADED_BREAK = "IOS ALL UPLOADED BREAK"
    static let SELECTED_IMAGE = "IOS SELECTED_IMAGE"
    static let GET_PRESIGNED_CALL_INITIATED = "IOS GET PRESIGNED CALL INITIATED"
    static let GOT_PRESIGNED_IMAGE_URL = "IOS GOT PRESIGNED IMAGE URL"
    static let IS_PRESIGNED_URL_UPDATED = "IOS IS PRESIGNED URL UPDATED"
    static let UPLOADING_TO_GCP_INITIATED = "IOS UPLOADING TO GCP INITIATED"
    static let IMAGE_UPLOAD_TO_GCP_FAILED = "IOS IMAGE UPLOAD TO GCP FAILED"
    static let IMAGE_UPLOADED_TO_GCP = "IOS IMAGE UPLOADED TO GCP"
    static let IS_MARK_GCP_UPLOADED_UPDATED = "IOS IS MARK GCP UPLOADED UPDATED"
    static let MARK_DONE_CALL_INITIATED = "IOS MARK DONE CALL INITIATED"
    static let MARKED_IMAGE_UPLOADED = "IOS MARKED IMAGE UPLOADED"
    static let IS_MARK_DONE_STATUS_UPDATED = "IOS IS MARK DONE STATUS UPDATED"
    static let SERVICE_STARTED = "IOS SERVICE STARTED"
    static let INTERNET_DISCONNECTED = "IOS INTERNET DISCONNECTED"
    static let INTERNET_CONNECTED = "IOS INTERNET_CONNECTED"
    static let MAX_RETRY = "IOS MAX RETRY"
    static let GET_PRESIGNED_FAILED = "IOS GET PRESIGNED FAILED"
    static let MARK_IMAGE_UPLOADED_FAILED = "MARK IMAGE UPLOADED FAILED"
    static let IMAGE_ID_NULL = "IMAGE ID NULL"
    static let OUTPUT_VIEW_CONTROLLER_INITIATED = "IOS OUTPUT VIEW CONTROLLER INITIATED"
    static let OUTPUT_VIEW_CONTROLLER_DEINITIATED = "IOS OUTPUT VIEW CONTROLLER DEINITIATED"
    static let iOS_GET_SKU_COMPLETED_LIST_INITIATED = "iOS GET SKU COMPLETED LIST INITIATED"
    static let iOS_GET_SKU_COMPLETED_LIST_SUCCESS = "iOS GET SKU COMPLETED LIST SUCCESS"
    static let iOS_GET_SKU_COMPLETED_LIST_FAILED = "iOS GET SKU COMPLETED LIST FAILED"
    static let iOS_OUTPUT_VIEW_CONTROLLER_NEXT_SHOOT_CLICK = "iOS OUTPUT VIEW CONTROLLER NEXT SHOOT CLICK"
    static let iOS_OUTPUT_VIEW_CONTROLLER_GOTO_CART_CLICK = "iOS OUTPUT VIEW CONTROLLER GOTO CART CLICK"
    static let CHECKOUT_VIEW_CONTROLLER_INITIATED = "IOS CHECKOUT VIEW CONTROLLER INITIATED"
    static let CHECKOUT_VIEW_CONTROLLER_DEINITIATED = "IOS CHECKOUT VIEW CONTROLLER DEINITIATED"
    static let GET_CART_CALCULATION_INITIATED = "iOS GET PROJECT DETAIL INITIATED"
    static let GET_CART_CALCULATION_SUCCESS = "iOS GET PROJECT DETAIL SUCCESS"
    static let GET_CART_CALCULATION_FAILED = "iOS GET PROJECT DETAIL FAILED"
    static let UPDATE_PROJECT_ID_INITIATED = "iOS UPDATE PROJECT ID INITIATED"
    static let UPDATE_PROJECT_ID_SUCCESS = "iOS UPDATE PROJECT ID SUCCESS"
    static let UPDATE_PROJECT_ID_FAILED = "iOS UPDATE PROJECT ID FAILED"
    static let GENERATE_ORDER_INITIATED = "iOS GENERATE ORDER INITIATED"
    static let GENERATE_ORDER_SUCCESS = "iOS GENERATE ORDER SUCCESS"
    static let GENERATE_ORDER_FAILED = "iOS GENERATE ORDER FAILED"
    static let OPEN_RAZORPAY_FROM_CHECKOUT_VIEW_CONTROLLER = "iOS OPEN RAZORPAY FROM CHECKOUT VIEW CONTROLLER"
    static let CHECKOUT_VIEW_CONTROLLER_RAZORPAY_PAYMENT_SUCCESS = "iOS CHECKOUT VIEW CONTROLLER RAZORPAY PAYMENT SUCCESS"
    static let CHECKOUT_VIEW_CONTROLLER_RAZORPAY_PAYMENT_FAILED = "iOS CHECKOUT VIEW CONTROLLER RAZORPAY PAYMENT FAILED"
    static let CHECKOUT_VIEW_CONTROLLER_INSERT_PAYMENT_INITIATED = "iOS CHECKOUT VIEW CONTROLLER INSERT PAYMENT INITIATED"
    static let CHECKOUT_VIEW_CONTROLLER_INSERT_PAYMENT_SUCCESS = "iOS CHECKOUT VIEW CONTROLLER INSERT PAYMENT SUCCESS"
    static let CHECKOUT_VIEW_CONTROLLER_INSERT_PAYMENT_FAILED = "iOS CHECKOUT VIEW CONTROLLER INSERT PAYMENT FAILED"
    static let CART_PROJECT_DELETE_POPUP_OPEN = "iOS CART PROJECT DELETE POPUP OPEN"
    static let CART_PROJECT_DELETE = "iOS CART PROJECT DELETE"
    func posthogIdentify(identity:String,properties:[String:String]){
        if let posthog = PHGPostHog.shared(){
            var property = properties
            property.add(["app_name":appName])
            posthog.identify(identity,properties: property)

            Amplitude.instance().setUserId(USER.userId)
        }
    }

    func posthogCapture(identity:String,properties:[String:Any]){

        if let posthog = PHGPostHog.shared(){
            var property = properties
            property.add(["app_name":appName])
            property.add(["internet_details":["is_active":Reachability.isConnectedToNetwork()].jsonString])
            posthog.capture(identity, properties: property)
            Amplitude.instance().logEvent(identity, withEventProperties: property )
         }

    }

    func posthogLogout(){
        // in swift
        if  let posthog = PHGPostHog.shared() {
            posthog.capture("Logged Out")
            posthog.flush()
            Amplitude.instance().clearUserProperties()
        }
    }


    func getImageDetail(imageData:RealmImageData?)->[String:Any]{

        return ["data": imageData?.data ?? "",
                "db_update_status": imageData?.uploadFlag ?? "" ,
                "image_id": imageData?.imageId ?? "" ,
                "image_local_id": imageData?.itemId ?? "" ,
                "image_name": imageData?.imageName ?? "" ,
                "image_path": imageData?.path ?? "" ,
                "image_type": imageData?.imageCategory ?? "" ,
                "is_reclick": imageData?.is_reclick ?? "" ,
                "is_reshoot": imageData?.is_reshoot ?? "" ,
                "iteration_id": "\(imageData?.imageName ?? "")_\(imageData?.skuId ?? "")",
                "make_done_status": "\(imageData?.uploadFlag ?? 0)",
                "message": "Image upload limit reached",
                "overlay_id": imageData?.overlay_id ?? "" ,
                "pre_url": imageData?.presignedUrl ?? "" ,
                "project_id": imageData?.projectId ?? "" ,
                "response": imageData?.response ?? "",
                "retry_count": imageData?.retryCount ?? "" ,
                "sequence": imageData?.frame_seq_no ?? "" ,
                "sku_id": imageData?.skuId ?? "" ,
                "sku_name": imageData?.skuName ?? "" ,
                "upload_status":imageData?.uploadFlag  ?? ""]
        }


    func getVideoDetail(imageData:RealmVideoData?)->[String:Any]{

        return ["data": imageData?.data ?? "",
                "db_update_status": imageData?.uploadFlag ?? "" ,
                "videoId": imageData?.videoId ?? "" ,
                "video_local_id": imageData?.itemId ?? "" ,
                "video_name": imageData?.videoName ?? "" ,
                "video_path": imageData?.path ?? "" ,
                "video_type": imageData?.videoCategory ?? "" ,
                "is_reclick": imageData?.is_reclick ?? "" ,
                "is_reshoot": imageData?.is_reshoot ?? "" ,
                "iteration_id": "\(imageData?.videoName ?? "")_\(imageData?.skuId ?? "")",
                "make_done_status": "\(imageData?.uploadFlag ?? 0)",
                "message": "Image upload limit reached",
                "overlay_id": imageData?.overlay_id ?? "" ,
                "pre_url": imageData?.presignedUrl ?? "" ,
                "project_id": imageData?.projectId ?? "" ,
                "response": imageData?.response ?? "",
                "retry_count": imageData?.retryCount ?? "" ,
                "sequence": imageData?.frame_seq_no ?? "" ,
                "sku_id": imageData?.skuId ?? "" ,
                "sku_name": imageData?.skuName ?? "" ,
                "upload_status":imageData?.uploadFlag  ?? ""]
        }
}

class StringCons{
    static let amplitudeKey = "3687bf0a1026abd6f3e7ff459df99ced"
    static let ip = "http://18.232.194.72"
    static let live = "https://www.clippr.ai"
    static let clientStaging = "https://beta-api.spyne.xyz"
    
    static let baseURL = clientStaging
    
    static let baseUrlUploadImage = "\(baseURL)/api/v4/image/upload"
    static let baseUrlImageMarkDone = "\(baseURL)/api/v4/image/mark-done"
    
    static let baseUrlUploadVideo = "\(baseURL)/api/v3/video/video-upload"
    static let baseUrlVideoMarkDone = "\(baseURL)/api/v3/video/video-mark"
    
    static let baseURLSubCategoriesImage = "https://storage.googleapis.com/spyne-cliq/"
    static let miscellaneous = "Miscellaneous"
    static let interior = "Interior"
    static let exterior = "Exterior"
    
    static let skipped = "Skipped"
    static let regular = "Regular"
    static let rechabilityChanges = "rechabilityChanges"
    static let imageClick360 = "360imageClick"
    static let exteriorImageClick = "exteriorImageClick"
    static let imageClick = "ImageClick"
    static let reshootImageClick = "reshootImageClick"
    static let interiorImageClick = "interiorImageClick"
    static let reshootExterior = "reshootExterior"
    static let miscellaneousImageClick = "interiorImageClick"
    static let shootName = "Shoot Name"
    static let numberOfImages = "No of Images"
    static let credits = "Credits"
    static let yourImageIsOutOfFrame = "Your image is out of frame"
    static let yourImageIsInFrame = "Your image is in frame"
    static let imageMatchingTheAngle = "Image Matching the angle"
    static let pleaseReshoot = "Please Reshoot"
    static let yourImageIsPerfectYouAreGoodToGo = "Your image is perfect! You are good to go!"
    static let yourSubjectIsInvalid = "Your Subject Is Invalid"
    static let yourAngleIsInvalid = "Your Angle Is Invalid"
    
}
//
///* MARK:- ====   MARK: RELOAD VIEW CONTROLLER  ==== */
extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }

    func showToast(message:String){

        ToastManager.shared.isQueueEnabled = false
        var style = ToastStyle()

        // this is just one of many style options
        style.messageColor = .black
        style.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
        style.messageAlignment = .center
        // present the toast with the new style
        self.view.makeToast(message, duration: 3.0, position: .bottom, style: style)

    }


    func globalAlert(msg: String) {

        let alertView:UIAlertController = UIAlertController(title:  appName, message: msg, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alertView.dismiss(animated: true, completion: nil)
        }))
        // alertView.show()
        self.present(alertView, animated: true, completion: nil)
    }


    func globalAlertWithOption(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }

    func setNavigationBarTint(color:UIColor,textColor:UIColor)  {
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.isTranslucent = false

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = color
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:textColor]
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance

        } else {
            self.navigationController?.navigationBar.barTintColor = color
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        }
    }


    func posthogIdentify(identity:String,properties:[String:String]){
        guard  let posthog = PHGPostHog.shared() else {return}
        var property = properties
        property.add(["app_name":appName])
        posthog.identify(identity,properties: property)
        Amplitude.instance().setUserId(USER.userId)
    }

//    func posthogCapture(identity:String,properties:[String:String]){
//        guard  let posthog = PHGPostHog.shared() else {return}
//        var property = properties
//        property.add(["app_name":appName])
//        property.add(["internet_details":["is_active":Reachability.isConnectedToNetwork()].jsonString])
//       // posthog.capture(identity, properties: property)
//
//    }
//
//    func posthogLogout(){
//        // in swift
//        guard  let posthog = PHGPostHog.shared() else {return}
//        posthog.capture("Logged Out")
//        posthog.flush()
//    }

}
//
//enum Screen: String {
//    case home = "home"
//    case camera = "camera"
//}
//
//
//func randomString(length: Int) -> String {
//  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//  return String((0..<length).map{ _ in letters.randomElement()! })
//}
//
//func tempURL() -> URL? {
//    do {
//        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
//        let url = documentDirectory.appendingPathComponent(UUID().uuidString + ".mp4")
//        return url
//    }catch{
//        print(error.localizedDescription)
//    }
//    return nil
//}
//
//func tempCompressedURL() -> URL? {
//    do {
//        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
//        let url = documentDirectory.appendingPathComponent(UUID().uuidString + "_compressed.mp4")
//        return url
//    }catch{
//        print(error.localizedDescription)
//    }
//    return nil
//}
