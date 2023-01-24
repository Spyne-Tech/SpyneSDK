//
//  UIImage+ImageQuality.swift
//

import UIKit

enum ImageType: String {
    case png
    case jpeg
    case instagram = "igo"
    
    var mimeType: String {
        switch self {
        case .png, .instagram:
            return "image/png"
        case .jpeg:
            return "image/jpg"
        }
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case minimum = 0
        case lowest  = 0.20
        case low     = 0.35
        case medium  = 0.60
        case high    = 0.75
        case highest = 0.95
        case maximum = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there now a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return self.pngData() }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there now a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
    
    func save(name: String, to directory: String, type: ImageType = .jpeg, jpegQuality quality: JPEGQuality = .highest) -> String? {
        let data = type == .jpeg ? self.fixOrientation.jpeg(quality) : self.png
        let filetype = type.rawValue
        
        if !FileManager.default.fileExists(atPath: directory) {
            do {
                try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                return nil
            }
        }
        
        let path = directory.appending(name).appending(".\(filetype)")
        do {
            let url = URL(fileURLWithPath: path)
            try data?.write(to: url)
            return path
        }
        catch {
            return nil
        }
    }
    
    var fixOrientation: UIImage {
        if self.imageOrientation == .up { return self }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi / 2)
        case .up, .upMirrored: break
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default: break
        }
        
        guard let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace else {
            return UIImage()
        }
        
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue)
        context?.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: size.height, height: size.width)))
        default:
            context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        }
        
        guard let _cgImage = context?.makeImage() else {
            return UIImage()
        }
        
        return UIImage(cgImage: _cgImage)
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func cropImage(imageToCrop: UIImage, toRect rect: CGRect) -> UIImage {
        let imageRef: CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped: UIImage = UIImage(cgImage: imageRef)
        return cropped
    }
}
