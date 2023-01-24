//
//  SpyneSDK.swift
//  Spyne SDK
//
//  Created by Akash Verma on 01/08/22.
//

/*
 Class name: SpyneSDK
 Entity Work: Connection between SDK and Client app.
 */
import UIKit
import IQKeyboardManagerSwift
import KRProgressHUD
import Siren
import PostHog
import BackgroundTasks
import os
import PostHog
import RealmSwift
import Amplitude

/*
 Class name: SpyneSDK
 Entity Work: Connection between SDK and Client app.
 */

public class SpyneSDK {
    
    public static let shared = SpyneSDK()
    
    var myOrientation: UIInterfaceOrientationMask = .portrait
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait
    static let upload = BackgroundUpload()
    static let uploadVideo = BackgroundUploadVideo()
    var realm  = RealmViewModel.init()
    var reachability: Reachability!
    public var delegate : SP360OrderSummaryVCDelegate!
    
    private var presentingByViewController: UIViewController?
    internal var api_key = ""
    internal var frameNumber = 0
    internal var categoryID = ""
    private var emailID = ""
    private var userId = ""
    internal var skuId = ""
    
    static var referenceVC : UIViewController?
        
    public func onCreate(presentingByViewController: UIViewController ,api_Key: String, categoryId: String, emailID: String, userId: String, skuID: String, frameNumber: Int){
        self.presentingByViewController = presentingByViewController
        SpyneSDK.referenceVC = presentingByViewController
        self.api_key = api_Key
        self.frameNumber = frameNumber
        self.categoryID = categoryId
        self.emailID = emailID
        self.userId = userId
        self.skuId = skuID
        setApiKeyAndCategoryId()
        navigatetoLogin()
        initialSetup()
    }
    
    func initialSetup() {
        IQKeyboardManager.shared.enable = true
        KRProgressHUD.appearance().activityIndicatorColors = [UIColor]([UIColor.appColor!])
        Siren.shared.wail()
        BackgroundTaskManager.shared.scheduleAppRefresh()
//        BackgroundTaskManager.shared.register()
        let configuration = PHGPostHogConfiguration(apiKey: POSTHOG_API_KEY)
        configuration.captureApplicationLifecycleEvents = true
        configuration.recordScreenViews = true
        configuration.flushAt = 1
        PHGPostHog.setup(with: configuration)
        Amplitude.instance().trackingSessionEvents = true
        // Initialize SDK
       Amplitude.instance().initializeApiKey(StringCons.amplitudeKey)
        // Log an event
       Amplitude.instance().logEvent("IOS APP START")
       if Storage.shared.appVersion != "\(UIApplication.release)-\(UIApplication.build)"{
           Storage.shared.appVersion = "\(UIApplication.release)-\(UIApplication.build)"
           
           let configCheck = Realm.Configuration();
           do {
                let fileUrlIs = try schemaVersionAtURL(configCheck.fileURL!)
               print("schema version \(fileUrlIs)")
           } catch  {
               print(error)
           }
           
           // Realm Schema Updation
           let config = Realm.Configuration(
               // Set the new schema version. This must be greater than the previously used
               // version (if you've never set a schema version before, the version is 0).
               schemaVersion: configCheck.schemaVersion+1,
               // Set the block which will be called automatically when opening a Realm with
               // a schema version lower than the one set above
               migrationBlock: { migration, oldSchemaVersion in
                   // We haven’t migrated anything yet, so oldSchemaVersion == 0
                   if (oldSchemaVersion < configCheck.schemaVersion+1) {
                       // Nothing to do!
                       // Realm will automatically detect new properties and removed properties
                       // And will update the schema on disk automatically
                   }
               })
           // Tell Realm to use this new configuration object for the default Realm
           Realm.Configuration.defaultConfiguration = config
           do {
               try reachability = Reachability()
               NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
               try reachability.startNotifier()
           } catch {
               print("This is not working.")
           }
       }
    }
    private func setApiKeyAndCategoryId() {
        CLIENT.shared.setUserApiKey(apiKey: api_key)
        CLIENT.shared.setUserCategoryId(categoryId: categoryID)
    }
    
    private func navigatetoLogin(){
        let storyBoard = UIStoryboard(name: "Auth", bundle: Bundle.spyneSDK)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "SPLoginViewController") as! SPLoginViewController
        loginViewController.presentingByViewController = self.presentingByViewController
        loginViewController.categoryID = self.categoryID
        loginViewController.emailID = self.emailID
        loginViewController.userId = self.userId
        loginViewController.skuName = self.skuId
        presentingByViewController?.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc func reachabilityChanged(_ note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.connection != .unavailable {
            if !BackgroundUpload.isUploadRunning{
                SpyneSDK.upload.uploadParent(type: StringCons.rechabilityChanges, serviceStartedBy: "Network Toggle")
            }
            if !BackgroundUploadVideo.isVideoUploadRunning{
                SpyneSDK.uploadVideo.uploadParent(type: StringCons.rechabilityChanges, serviceStartedBy: "Network Toggle")
            }
            PosthogEvent.shared.posthogCapture(identity: PosthogEvent.INTERNET_CONNECTED, properties: [:])
        } else {
            BackgroundUpload.isUploadRunning = false
            PosthogEvent.shared.posthogCapture(identity: PosthogEvent.INTERNET_DISCONNECTED, properties: [:])
            print("Not reachable")
        }
    }
    
    public func startBackgroundUploadFromTheClientApp(){
        if !BackgroundUpload.isUploadRunning{
            SpyneSDK.upload.uploadParent(type: StringCons.rechabilityChanges, serviceStartedBy: "App Forground")
        }
    }
}

extension UINavigationController {
  func popTo(controllerToPop:UIViewController) {
    //1. get all View Controllers from Navigation Controller
    let controllersArray = self.viewControllers
    //2. check whether that view controller is exist in the Navigation Controller
    let objContain: Bool = controllersArray.contains(where: { $0 == controllerToPop })
    //3. if true then move to that particular controller
    if objContain {
      self.popToViewController(controllerToPop, animated: true)
    }
  }
}

extension SpyneSDK : SP360OrderSummaryVCDelegate{
    public func showAlertDataRequest(skuId: String, isShoot: Bool) {
        ShowAlert(message: "Shoot Completed. Sku Id: \(skuId) ", theme: .warning)

    }
}
