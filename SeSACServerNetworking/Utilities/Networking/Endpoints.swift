//
//  Endpoints.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import Foundation

import Alamofire

enum SeSACError: Int, Error {
    case invalidAuthorization = 401
    case emailTaken = 406
    case internalError = 500
    case emptyParameters = 501
}

extension SeSACError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidAuthorization:
            return UserDefaultsManager.invalidAutho
        case .emailTaken:
            return UserDefaultsManager.emailTaken
        case .internalError:
            return UserDefaultsManager.interalError
        case .emptyParameters:
            return UserDefaultsManager.emptyParameters
        }
    }
}


enum SeSACAPI {
    case signup(userName: String, email: String, password: String)
    case login(email: String, password: String)
    case profile
}


// MARK: - Extension: URLRequestConvertible

extension SeSACAPI: URLRequestConvertible {
    
    // MARK: - Properties
    
    var url: URL {
        switch self {
        default:
            guard let url = URL(string: UserDefaultsManager.baseURLPath) else { return URL(fileURLWithPath: "") }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .signup:
            return UserDefaultsManager.signupPath
        case .login:
            return UserDefaultsManager.loginPath
        case .profile:
            return UserDefaultsManager.profilePath
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signup, .login:
            return .post
        case .profile:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .signup, .login:
            return [UserDefaultsManager.contentType: UserDefaultsManager.contentValue]
        case .profile:
            return [
                UserDefaultsManager.contentType: UserDefaultsManager.contentValue,
                UserDefaultsManager.autho: UserDefaultsManager.key
            ]
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .signup(let userName, let email, let password):
            return [
                UserDefaultsManager.userName: userName,
                UserDefaultsManager.email: email,
                UserDefaultsManager.password: password
            ]
        case .login(let email, let password):
            return [
                UserDefaultsManager.email: email,
                UserDefaultsManager.password: password
            ]
        default: return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .signup:
            return JSONEncoding.default
        case .login:
            return JSONEncoding.default
        case .profile:
            return URLEncoding.default
        }
    }
    
    
    // MARK: - Helper Functions
    
    func asURLRequest() throws -> URLRequest {
        
        let url = url.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
