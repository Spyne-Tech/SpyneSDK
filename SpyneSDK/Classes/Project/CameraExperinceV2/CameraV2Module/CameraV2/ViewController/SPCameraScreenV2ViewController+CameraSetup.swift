//
//  SPCameraScreenV2ViewController+CameraSetup.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 29/11/22.
//

import UIKit
import AVFoundation

//MARK: - SPCameraScreenV2ViewController Extension which is dedicatedly made for the configuration of the camera module
extension SPCameraScreenV2ViewController:UIGestureRecognizerDelegate{
    
    //MARK: - setupPreview is a method which basically adds the camera on the layer of base view
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraView.layer.addSublayer(previewLayer)
        //Step12
        DispatchQueue.global(qos: .userInitiated).async { [ self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.previewLayer.videoGravity = .resizeAspectFill
                self.previewLayer.connection?.videoOrientation = .landscapeRight
                self.cameraView.layoutIfNeeded()
                self.previewLayer.frame = self.cameraView.bounds
            }
            //Step 13
        }
        
    }
    
    //MARK: - CameraSetup is a method which basically starts the AVSession to make the camera active for the call backs
    internal func cameraSetup(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = Settings.sessionPresetAutomobiles
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print(SPStringV2.unableToAccessBackCamera)
            return
        }
        cameraDevice = backCamera
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupPreview()
            }
        }
        catch let error  {
            PosthogEvent.shared.posthogCapture(identity: SPStringV2.imageCapturedFailed, properties: [PostHogEventsKeys.message:"Error Unable to initialize back camera:  \(error.localizedDescription)"])
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    //MARK: - touchesBegan adds the method so that it can start the call back for the touches to the camera module so that user can adjust the focus and exposure of the camera
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first! as UITouch
        let screenSize = cameraForegroundView.bounds.size
        let focusPoint = CGPoint(x: touchPoint.location(in: cameraForegroundView).y / screenSize.height, y: 1.0 - touchPoint.location(in: cameraForegroundView).x / screenSize.width)
      
        if let device = cameraDevice {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                }
                device.unlockForConfiguration()

            } catch {
                // Handle errors here
            }
        }
    }
    
    
    //MARK: - Focus and Geture
     func attachZoom(_ view: UIView) {
        DispatchQueue.main.async {
            self.zoomGesture.addTarget(self, action: #selector(self._zoomStart(_:)))
            view.addGestureRecognizer(self.zoomGesture)
            self.zoomGesture.delegate = self
        }
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
            beginZoomScale = zoomScale
        }
        
        return true
    }
    
    @objc  func _zoomStart(_ recognizer: UIPinchGestureRecognizer) {
        guard let view = cameraForegroundView,
            let previewLayer = previewLayer
            else { return }
        
        var allTouchesOnPreviewLayer = true
        let numTouch = recognizer.numberOfTouches
        
        for i in 0 ..< numTouch {
            let location = recognizer.location(ofTouch: i, in: view)
            let convertedTouch = previewLayer.convert(location, from: previewLayer.superlayer)
            if !previewLayer.contains(convertedTouch) {
                allTouchesOnPreviewLayer = false
                break
            }
        }
        if allTouchesOnPreviewLayer {
            _zoom(recognizer.scale)
        }
    }
    
    fileprivate func _zoom(_ scale: CGFloat) {
    
        do {
            let captureDevice = device
            try captureDevice?.lockForConfiguration()
            
            zoomScale = max(1.0, min(beginZoomScale * scale, maxZoomScale))
            
            captureDevice?.videoZoomFactor = zoomScale
            
            captureDevice?.unlockForConfiguration()
            
        } catch {
            print(SPStringV2.errorLockingconfiguration)
        }
    }
    
   // MARK: - UIGestureRecognizerDelegate
    public func attachFocus(_ view: UIView) {
        DispatchQueue.main.async {
            self.focusGesture.addTarget(self, action: #selector(self._focusStart(_:)))
            view.addGestureRecognizer(self.focusGesture)
            self.focusGesture.delegate = self
        }
    }
    
    public func attachExposure(_ view: UIView) {
        DispatchQueue.main.async {
            self.exposureGesture.addTarget(self, action: #selector(self._exposureStart(_:)))
            view.addGestureRecognizer(self.exposureGesture)
            self.exposureGesture.delegate = self
        }
    }
    
    public func attachLeftRighSwipe(_ view: UIView) {
        DispatchQueue.main.async {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.configuredLeftRightGesture))
                swipeRight.direction = .right
                self.view.addGestureRecognizer(swipeRight)
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.configuredLeftRightGesture))
                swipeLeft.direction = .left
                self.view.addGestureRecognizer(swipeLeft)
        }
    }
    
    @objc fileprivate func configuredLeftRightGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right: // previous
                switch shootType {
                case .Exterior:
                    vmShoot.selectedAngle = vmShoot.selectedAngle > 0 ? vmShoot.selectedAngle - 1 : vmShoot.selectedAngle
                    setToNextOverlay(isFromPanGesture: true)
                case .Interior:
                    vmShoot.selectedInteriorAngles = vmShoot.selectedInteriorAngles > 0 ? vmShoot.selectedInteriorAngles - 1 : vmShoot.selectedInteriorAngles
                    setToNextInteriorOverlay(isFromPanGesture: true)
                case .Misc:
                    vmShoot.selectedFocusAngles = vmShoot.selectedFocusAngles > 0 ? vmShoot.selectedFocusAngles - 1 : vmShoot.selectedFocusAngles
                    setToNextMiscOverlay(isFromPanGesture: true)
                }
            case .left: // next
                switch shootType {
                    case .Exterior:
                        vmShoot.selectedAngle = vmShoot.selectedAngle < vmShoot.arrOverLays.count - 1 ? vmShoot.selectedAngle + 1 : vmShoot.selectedAngle
                        setToNextOverlay(isFromPanGesture: true)
                    case .Interior:
                    vmShoot.selectedInteriorAngles = vmShoot.selectedInteriorAngles < Storage.shared.arrInteriorPopup.count - 1 ? vmShoot.selectedInteriorAngles + 1 : vmShoot.selectedInteriorAngles
                        setToNextInteriorOverlay(isFromPanGesture: true)
                    case .Misc:
                    vmShoot.selectedFocusAngles = vmShoot.selectedFocusAngles < Storage.shared.arrFocusedPopup.count - 1 ? vmShoot.selectedFocusAngles + 1 : vmShoot.selectedFocusAngles
                        setToNextMiscOverlay(isFromPanGesture: true)
                }
            default:
                break
            }
        }
    }
    
    @objc fileprivate func _focusStart(_ recognizer: UITapGestureRecognizer) {
        _changeExposureMode(mode: .continuousAutoExposure)
        translationY = 0
        exposureValue = 0.5
    
        if let validDevice = device,
            let validPreviewLayer = previewLayer,
            let view = recognizer.view {
            let pointInPreviewLayer = view.layer.convert(recognizer.location(in: view), to: validPreviewLayer)
            let pointOfInterest = validPreviewLayer.captureDevicePointConverted(fromLayerPoint: pointInPreviewLayer)
            
            do {
                try validDevice.lockForConfiguration()
                
                _showFocusRectangleAtPoint(pointInPreviewLayer, inLayer: validPreviewLayer)
                
                if validDevice.isFocusPointOfInterestSupported {
                    validDevice.focusPointOfInterest = pointOfInterest
                }
                
                if validDevice.isExposurePointOfInterestSupported {
                    validDevice.exposurePointOfInterest = pointOfInterest
                }
                
                if validDevice.isFocusModeSupported(focusMode) {
                    validDevice.focusMode = focusMode
                }
                
                if validDevice.isExposureModeSupported(exposureMode) {
                    validDevice.exposureMode = exposureMode
                }
                
                validDevice.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    
    private func getAnimation()  -> CABasicAnimation{
        let disappearOpacityAnimation = CABasicAnimation(keyPath: "opacity")
        disappearOpacityAnimation.fromValue = 1.0
        disappearOpacityAnimation.toValue = 0.0
        disappearOpacityAnimation.beginTime = CACurrentMediaTime() + 0.8
        disappearOpacityAnimation.fillMode = CAMediaTimingFillMode.forwards
        disappearOpacityAnimation.isRemovedOnCompletion = false
        
        return disappearOpacityAnimation
    }
    
    func _showFocusRectangleAtPoint(_ focusPoint: CGPoint, inLayer layer: CALayer, withBrightness brightness: Float? = nil) {
        if let lastFocusRectangle = lastFocusRectangle {
            lastFocusRectangle.removeFromSuperlayer()
            self.lastFocusRectangle = nil
        }
        
        let size = CGSize(width: 75, height: 75)
        let rect = CGRect(origin: CGPoint(x: focusPoint.x - size.width / 2.0, y: focusPoint.y - size.height / 2.0), size: size)
        
        let endPath = UIBezierPath(rect: rect)
        endPath.move(to: CGPoint(x: rect.minX + size.width / 2.0, y: rect.minY))
        endPath.addLine(to: CGPoint(x: rect.minX + size.width / 2.0, y: rect.minY + 5.0))
        endPath.move(to: CGPoint(x: rect.maxX, y: rect.minY + size.height / 2.0))
        endPath.addLine(to: CGPoint(x: rect.maxX - 5.0, y: rect.minY + size.height / 2.0))
        endPath.move(to: CGPoint(x: rect.minX + size.width / 2.0, y: rect.maxY))
        endPath.addLine(to: CGPoint(x: rect.minX + size.width / 2.0, y: rect.maxY - 5.0))
        endPath.move(to: CGPoint(x: rect.minX, y: rect.minY + size.height / 2.0))
        endPath.addLine(to: CGPoint(x: rect.minX + 5.0, y: rect.minY + size.height / 2.0))
        if brightness != nil {
            endPath.move(to: CGPoint(x: rect.minX + size.width + size.width / 4, y: rect.minY))
            endPath.addLine(to: CGPoint(x: rect.minX + size.width + size.width / 4, y: rect.minY + size.height))
            
            endPath.move(to: CGPoint(x: rect.minX + size.width + size.width / 4 - size.width / 16, y: rect.minY + size.height - CGFloat(brightness!) * size.height))
            endPath.addLine(to: CGPoint(x: rect.minX + size.width + size.width / 4 + size.width / 16, y: rect.minY + size.height - CGFloat(brightness!) * size.height))
        }
        
        let startPath = UIBezierPath(cgPath: endPath.cgPath)
        let scaleAroundCenterTransform = CGAffineTransform(translationX: -focusPoint.x, y: -focusPoint.y).concatenating(CGAffineTransform(scaleX: 2.0, y: 2.0).concatenating(CGAffineTransform(translationX: focusPoint.x, y: focusPoint.y)))
        startPath.apply(scaleAroundCenterTransform)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = endPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(red: 1, green: 0.83, blue: 0, alpha: 0.95).cgColor
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        lastFocusRectangle = shapeLayer
        lastFocusPoint = focusPoint
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(0.2)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
        
        CATransaction.setCompletionBlock {
            if shapeLayer.superlayer != nil {
                shapeLayer.removeFromSuperlayer()
                self.lastFocusRectangle = nil
            }
        }
        if brightness == nil {
            let appearPathAnimation = CABasicAnimation(keyPath: "path")
            appearPathAnimation.fromValue = startPath.cgPath
            appearPathAnimation.toValue = endPath.cgPath
            shapeLayer.add(appearPathAnimation, forKey: "path")
            
            let appearOpacityAnimation = CABasicAnimation(keyPath: "opacity")
            appearOpacityAnimation.fromValue = 0.0
            appearOpacityAnimation.toValue = 1.0
            shapeLayer.add(appearOpacityAnimation, forKey: "opacity")
        }
        shapeLayer.add(getAnimation(), forKey: "opacity")
        CATransaction.commit()
    }
    
    @objc fileprivate func _exposureStart(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        let view = gestureRecognizer.view!
        _changeExposureMode(mode: .custom)
        let translation = gestureRecognizer.translation(in: view)
        let currentTranslation = translationY + Float(translation.y)
        if gestureRecognizer.state == .ended {
            translationY = currentTranslation
        }
        if currentTranslation < 0 {
            // up - brighter
            exposureValue = 0.5 + min(abs(currentTranslation) / 400, 1) / 2
        } else if currentTranslation >= 0 {
            // down - lower
            exposureValue = 0.5 - min(abs(currentTranslation) / 400, 1) / 2
        }
        _changeExposureDuration(value: exposureValue)
        
        // UI Visualization
        if gestureRecognizer.state == .began {
            if let validPreviewLayer = previewLayer {
                startPanPointInPreviewLayer = view.layer.convert(gestureRecognizer.location(in: view), to: validPreviewLayer)
            }
        }
        
        if let validPreviewLayer = previewLayer, let lastFocusPoint = self.lastFocusPoint {
            _showFocusRectangleAtPoint(lastFocusPoint, inLayer: validPreviewLayer, withBrightness: exposureValue)
        }
    }
    
    // Available modes:
    // .Locked .AutoExpose .ContinuousAutoExposure .Custom
    func _changeExposureMode(mode: AVCaptureDevice.ExposureMode) {
        if device?.exposureMode == mode {
            return
        }
        do {
            try device?.lockForConfiguration()
            
            if device?.isExposureModeSupported(mode) == true {
                device?.exposureMode = mode
            }
            device?.unlockForConfiguration()
            
        } catch {
            return
        }
    }
    
    func _changeExposureDuration(value: Float) {
            guard let videoDevice = device else {
                return
            }
            
            do {
                try videoDevice.lockForConfiguration()
                
                let p = Float64(pow(value, exposureDurationPower)) // Apply power function to expand slider's low-end range
                let minDurationSeconds = Float64(max(CMTimeGetSeconds(videoDevice.activeFormat.minExposureDuration), exposureMininumDuration))
                let maxDurationSeconds = Float64(CMTimeGetSeconds(videoDevice.activeFormat.maxExposureDuration))
                let newDurationSeconds = Float64(p * (maxDurationSeconds - minDurationSeconds)) + minDurationSeconds // Scale from 0-1 slider range to actual duration
                if videoDevice.exposureMode == .custom {
                    let newExposureTime = CMTimeMakeWithSeconds(Float64(newDurationSeconds), preferredTimescale: 1000 * 1000 * 1000)
                    videoDevice.setExposureModeCustom(duration: newExposureTime, iso: AVCaptureDevice.currentISO, completionHandler: nil)
                }
                videoDevice.unlockForConfiguration()
            } catch {
                return
            }
     }
}
