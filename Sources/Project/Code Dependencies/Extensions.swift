//
//  Extensions.swift
//  Created by Vijay Parmar on 02/04/21.
//  Copyright © 2021 WD. All rights reserved.
//

import Foundation
import UIKit
import SwiftSVG
//import SVGKit
import AVFoundation
import RealmSwift
import SDWebImage

//MARK: - Extensions
extension UIColor{
    
    static let appColor = UIColor(hexString: "#2362CC")
    static let appLightOrange = UIColor(hexString: "#FFFFFF")
    static let appLightColor = UIColor(hexString: "#FFFFFF")
    
    //Static Colors
    static let appGreenColor = UIColor(hexString: "#47CF5D")
    static let pickerLableColor = UIColor(hexString: "#B7B7B7")
    static let appBlue = UIColor(hexString: "#4A80F0")
    static let appYellow = UIColor(hexString: "#D7D26E")
    static let appGreen = UIColor(hexString: "#65C774")
    
}

//extension Bundle {
//    static func appName() -> String {
//        guard let dictionary = Bundle.main.infoDictionary else {
//            return ""
//        }
//        if let version : String = dictionary["CFBundleDisplayName"] as? String {
//            return version
//        } else {
//            return ""
//        }
//    }
//}

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}

extension AVCaptureDevice {
    func set(frameRate: Double) {
        guard let range = activeFormat.videoSupportedFrameRateRanges.first,
              range.minFrameRate...range.maxFrameRate ~= frameRate
        else {
            print("Requested FPS is not supported by the device's activeFormat !")
            return
        }
        
        do { try lockForConfiguration()
            activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
            activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
            unlockForConfiguration()
        } catch {
            print("LockForConfiguration failed with error: \(error.localizedDescription)")
        }
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}

extension UIImage {
    func overlayWith(image: UIImage, posX: CGFloat, posY: CGFloat) -> UIImage {
        let newWidth = posX < 0 ? abs(posX) + max(self.size.width, image.size.width) :
        size.width < posX + image.size.width ? posX + image.size.width : size.width
        let newHeight = posY < 0 ? abs(posY) + max(size.height, image.size.height) :
        size.height < posY + image.size.height ? posY + image.size.height : size.height
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let originalPoint = CGPoint(x: posX < 0 ? abs(posX) : 0, y: posY < 0 ? abs(posY) : 0)
        self.draw(in: CGRect(origin: originalPoint, size: self.size))
        let overLayPoint = CGPoint(x: posX < 0 ? 0 : posX, y: posY < 0 ? 0 : posY)
        image.draw(in: CGRect(origin: overLayPoint, size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}



extension UIView {
    
    func lineTransfrom(degrees:CGFloat){
        
        self.transform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi/180);
        
        
    }
    func takeSnapshotOfView() -> UIImage? {
        
        let size = CGSize(width: frame.size.width, height: frame.size.height)
        let rect = CGRect.init(origin: .init(x: 0, y: 0), size: frame.size)
        
        UIGraphicsBeginImageContext(size)
        drawHierarchy(in: rect, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let imageData = image?.pngData() else {
            return nil
        }
        
        return UIImage.init(data: imageData)
    }
    
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}

extension UIImage {
    
    func saveToPhotoLibrary(_ completionTarget: Any?, _ completionSelector: Selector?) {
        DispatchQueue.global(qos: .userInitiated).async {
            UIImageWriteToSavedPhotosAlbum(self, completionTarget, completionSelector, nil)
        }
    }
    
}

extension UIAlertController {
    
    func present() {
        guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else {
            return
        }
        controller.present(self, animated: true)
    }
}



extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }
        
        return String(data: theJSONData, encoding: .ascii)
    }
}




//extension UIFont{
//    public static func popinsRegular(witSize:CGFloat)->UIFont{
//        return UIFont(name: "Poppins-Regular", size: witSize)!
//    }
//    public static func popinsBold(witSize:CGFloat)->UIFont{
//        return UIFont(name: "Poppins-Bold", size: witSize)!
//    }
//    public static func popinsSemiBold(witSize:CGFloat)->UIFont{
//        return UIFont(name: "Poppins-SemiBold", size: witSize)!
//    }
//    public static func popinsMedium(witSize:CGFloat)->UIFont{
//        return UIFont(name: "Poppins-Medium", size: witSize)!
//    }
//    
//    public static func interBold(witSize:CGFloat)->UIFont{
//        return UIFont(name: "Inter-Bold", size: witSize)!
//    }
//    
//}
extension UIButton {
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.setTitle(newValue , for: .normal)
        }
    }
}

extension UILabel {
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.text = newValue 
        }
    }
}

extension UITextField {
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.text = newValue 
        }
    }
    
    @IBInspectable var localizedPlaceHolder: String {
        get { return "" }
        set {
            self.placeholder = newValue 
        }
    }
}

extension UITextView {
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set {
            self.text = newValue 
        }
    }
}

//extension Bundle {
//    private static var bundle: Bundle!
//
//
//    public static func localizedBundle() -> Bundle! {
//        if bundle == nil {
//            let appLang = UserDefaults.standard.string(forKey: "app_lang") ?? "en"
//            let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
//            bundle = Bundle(path: path!)
//        }
//
//        return bundle;
//    }
//    public static func setLanguage(lang: String) {
//        UserDefaults.standard.set(lang, forKey: "app_lang")
//        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
//        bundle = Bundle(path: path!)
//    }
//}

extension String {
    func localized() {
        
    }
    
    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self , arguments: arguments)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}


extension Int{
    
    func toMinSec()->String{
        let seconds: Int = self % 60
        let minutes: Int = (self / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
        
        
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
    
}

//extension SVGKImage {
//    
//    // MARK:- Private Method(s)
//    private func fillColorForSubLayer(layer: CALayer, color: UIColor, opacity: Float) {
//        if layer is CAShapeLayer {
//            let shapeLayer = layer as! CAShapeLayer
//            shapeLayer.fillColor = color.cgColor
//            shapeLayer.opacity = opacity
//        }
//        
//        if let sublayers = layer.sublayers {
//            for subLayer in sublayers {
//                fillColorForSubLayer(layer: subLayer, color: color, opacity: opacity)
//            }
//        }
//    }
//    
//    private func fillColorForOutter(layer: CALayer, color: UIColor, opacity: Float) {
//        if let shapeLayer = layer.sublayers?.first as? CAShapeLayer {
//            shapeLayer.fillColor = color.cgColor
//            shapeLayer.opacity = opacity
//        }
//    }
//    
//    // MARK:- Public Method(s)
//    func fillColor(color: UIColor, opacity: Float) {
//        if let layer = caLayerTree {
//            fillColorForSubLayer(layer: layer, color: color, opacity: opacity)
//        }
//    }
//    
//    func fillOutterLayerColor(color: UIColor, opacity: Float) {
//        if let layer = caLayerTree {
//            fillColorForOutter(layer: layer, color: color, opacity: opacity)
//        }
//    }
//}


extension Float {
    func round(to places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return Darwin.round(self * divisor) / divisor
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
extension URL {
    static func createFolder(folderName: String,subFolderName:String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first {
            // Construct a URL with desired folder name
            var folderURL = documentDirectory.appendingPathComponent(folderName)
            folderURL.appendPathComponent(subFolderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or now created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
    
}


extension Realm {
    
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
    
    public func writeAsync<T: ThreadConfined>(_ passedObject: T, errorHandler: @escaping ((_ error: Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
        let objectReference = ThreadSafeReference(to: passedObject)
        let configuration = self.configuration
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = RealmViewModel.init(configuration: configuration)
                    try realm.realm.safeWrite {
                        // Resolve within the transaction to ensure you get the latest changes from other threads
                        let object = realm.realm.resolve(objectReference)
                        block(realm.realm, object)
                    }
                } catch {
                    errorHandler(error)
                }
            }
        }
    }
  
    
    func asyncWrite<T : ThreadConfined>(obj: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
       let wrappedObj = ThreadSafeReference(to: obj)
       let config = self.configuration
       DispatchQueue.global(qos: .background).async {
         autoreleasepool {
           do {
             let realm = try Realm(configuration: config)
             let obj = realm.resolve(wrappedObj)
              
             try realm.safeWrite {
               block(realm, obj)
             }
           }
           catch {
             errorHandler(error)
           }
         }
       }
     }
      
     func asyncSaveArray<T: Object>(obj: [T]) {
        
       for item in obj {
         self.asyncWrite(obj: item) { (realm, itemToSave) in
           guard itemToSave != nil else { return }
           realm.add(itemToSave!, update: .modified)
         }
       }
     }
    
    
}

extension Thread {
    var threadName: String {
        if isMainThread {
            return "main"
        } else if let threadName = Thread.current.name, !threadName.isEmpty {
            return threadName
        } else {
            return description
        }
    }
    
    var queueName: String {
        if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)) {
            return queueName
        } else if let operationQueueName = OperationQueue.current?.name, !operationQueueName.isEmpty {
            return operationQueueName
        } else if let dispatchQueueName = OperationQueue.current?.underlyingQueue?.label, !dispatchQueueName.isEmpty {
            return dispatchQueueName
        } else {
            return "n/a"
        }
    }
}


extension Notification.Name {
    static let addNewSKU = Notification.Name("addNewSKU")
}


extension String {
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890-_")
        return self.filter {okayChars.contains($0) }
    }
    
    func stringToDate(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let now = df.date(from: self) ?? Date()
        let strDate = df.string(from: now)
        df.dateFormat = format
        let date = df.date(from: strDate) ?? Date()
        return df.string(from: now)
    }
}

extension Dictionary {
    var jsonString: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(jsonString)
    }

}


extension UISwitch {
    @IBInspectable var transfroms: CGFloat {
        set {
            self.transform = CGAffineTransform(scaleX: newValue + 0.05, y: newValue)
        }
        get {
            frame.width
        }
    }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
extension Int {

    func secondsToTime() -> String {

        let (h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)

        let h_string = h < 10 ? "0\(h)" : "\(h)"
        let m_string =  m < 10 ? "0\(m)" : "\(m)"
        let s_string =  s < 10 ? "0\(s)" : "\(s)"

        return "\(h_string):\(m_string):\(s_string)"
    }
}

extension UIImageView {
    
    func setImageSD(url:String, placeholderImage name:String = "ic_logo", imageLoadCompletion:((_ image:UIImage?) -> Void)? = nil) {
        guard let urlImage = URL(string: url) else { self.image = UIImage(named: name); return }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: urlImage) { image, error, type, url in
            if error == nil {
                imageLoadCompletion?(image)
            }else {
                imageLoadCompletion?(nil)
            }
        }
    }
    
}
