//
//  UserDefaultsHelper.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import Foundation

final class UserdefaultsHelper {
    
    // MARK: - Enum
    
    enum Key: String {
        case token
    }
    
    
    // MARK: - Properties
    
    static let standard = UserdefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    var personalToken: String {
        get {
            return userDefaults.string(forKey: Key.token.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Key.token.rawValue)
        }
    }
    
    
    // MARK: - Init
    
    private init() { }
    
    
    // MARK: - Helper Functions
    
    func removeAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: appDomain)
        }
    }
}
