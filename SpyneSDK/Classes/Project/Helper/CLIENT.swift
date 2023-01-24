//
//  USER.swift
//  Spyne SDK
//
//  Created by Akash Verma on 03/08/22.
//

import Foundation

class CLIENT {
    
    public static let shared = CLIENT()
    
    func setSecretKeyAuthKey(authKey: String) {
        UserDefaults.standard.set(authKey, forKey: SPStrings.userDefaultSecretKey)
    }
    
    func getUserSecretKey() -> String {
        return UserDefaults.standard.string(forKey: SPStrings.userDefaultSecretKey) ?? SPStrings.noDataFound
    }
    
    func setUserApiKey(apiKey: String) {
        UserDefaults.standard.set(apiKey, forKey: SPStrings.userDefaultApiKey)
    }
    
    func getUserApiKey() -> String {
        return UserDefaults.standard.string(forKey: SPStrings.userDefaultApiKey) ?? SPStrings.noDataFound
    }
    
    func setUserCategoryId(categoryId: String) {
        UserDefaults.standard.set(categoryId, forKey: SPStrings.userDefaultCategoryId)
    }
    
    func getUserCategoryId() -> String {
        return UserDefaults.standard.string(forKey: SPStrings.userDefaultCategoryId) ?? SPStrings.noDataFound
    }
}
