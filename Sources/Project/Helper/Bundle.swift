//
//  Bundle.swift
//  Spyne SDK
//
//  Created by Akash Verma on 03/08/22.
//

import Foundation

public class SpyneSDKK {}

public extension Bundle {
    /// Provides SPYNE SDK framework's bundle.
    static var spyneSDK: Bundle { Bundle(for: SpyneSDKK.self) }
    private static var bundle: Bundle!
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleDisplayName"] as? String {
            return version
        } else {
            return ""
        }
    }
    
    static func localizedBundle() -> Bundle! {
            return spyneSDK
        }
    static func setLanguage(lang: String) {
//            UserDefaults.standard.set(lang, forKey: "app_lang")
//            let path = Bundle.main.path(forResource: lang, ofType: "lproj")
//            bundle = Bundle(path: path!)
        }
}
