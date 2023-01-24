
import Foundation
import SwiftMessages

enum ThemeColor {
    
    case yellow
    case minsk
}

func ShowAlert(title : String = appName, message : String, theme: Theme, tapHandler: (() -> Void)? = nil , presentationStyle : SwiftMessages.PresentationStyle = .top , themeColor : ThemeColor = .minsk) {
    
    let view = MessageView.viewFromNib(layout: .cardView)
    view.button?.isHidden = true
    view.configureTheme(theme)
   
    if theme == .warning{
        view.configureTheme(backgroundColor:  UIColor.appColor!, foregroundColor: UIColor.white, iconImage: nil, iconText: "")
    }else if theme == .success{
        view.configureTheme(backgroundColor:  UIColor.green, foregroundColor: UIColor.white, iconImage: nil, iconText: "")
    }else if theme == .error{
        view.configureTheme(backgroundColor:  UIColor.red, foregroundColor: UIColor.white, iconImage: nil, iconText: "")
    }else{
        view.configureTheme(backgroundColor:  UIColor.yellow, foregroundColor: UIColor.white, iconImage: nil, iconText: "")
    }
    
    view.configureContent(title: title, body: message, iconText: "")
    view.tapHandler = { _ in
        SwiftMessages.hide()
        if let block = tapHandler{
            block()
        }
    }
    
    var config = SwiftMessages.defaultConfig
    config.interactiveHide = false
    config.becomeKeyWindow = false
    config.presentationStyle = presentationStyle
    config.duration = .seconds(seconds: 5)
    config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
    SwiftMessages.show(config: config, view: view)
    
}
