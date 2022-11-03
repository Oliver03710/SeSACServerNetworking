//
//  UserDefaults+Wrapper.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/03.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<T> {
    
    private let key: String
    private let defaultValue: T
    private let storage: UserDefaults

    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

struct UserDefaultsManager {
    
    @UserDefaultsWrapper(key: "token", defaultValue: "")
    static var token: String
    
    @UserDefaultsWrapper(key: "loginTitle", defaultValue: "회원가입")
    static var loginTitle: String
    
    @UserDefaultsWrapper(key: "nameTextField", defaultValue: "이름을 입력하세요.")
    static var nameTextField: String
    
    @UserDefaultsWrapper(key: "emailTextField", defaultValue: "이메일주소를 입력하세요.")
    static var emailTextField: String
    
    @UserDefaultsWrapper(key: "passwordTextField", defaultValue: "비밀번호를 입력하세요.")
    static var passwordTextField: String
    
    @UserDefaultsWrapper(key: "Okay", defaultValue: "OK")
    static var okay: String
    
    @UserDefaultsWrapper(key: "key", defaultValue: "Bearer \(Self.token)")
    static var key: String
    
    @UserDefaultsWrapper(key: "contentType", defaultValue: "Content-Type")
    static var contentType: String
    
    @UserDefaultsWrapper(key: "autho", defaultValue: "Authorization")
    static var autho: String
    
    @UserDefaultsWrapper(key: "contentValue", defaultValue: "application/x-www-form-urlencoded")
    static var contentValue: String
    
    @UserDefaultsWrapper(key: "signupPath", defaultValue: "signup")
    static var signupPath: String
    
    @UserDefaultsWrapper(key: "loginPath", defaultValue: "login")
    static var loginPath: String
    
    @UserDefaultsWrapper(key: "profilePath", defaultValue: "me")
    static var profilePath: String
    
    @UserDefaultsWrapper(key: "baseURLPath", defaultValue: "http://api.memolease.com/api/v1/users/")
    static var baseURLPath: String
    
    @UserDefaultsWrapper(key: "userName", defaultValue: "userName")
    static var userName: String
    
    @UserDefaultsWrapper(key: "email", defaultValue: "email")
    static var email: String
    
    @UserDefaultsWrapper(key: "password", defaultValue: "password")
    static var password: String
    
    
    static func removeAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}



