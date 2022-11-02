//
//  Endpoints.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import Foundation

import Alamofire

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
            guard let url = URL(string: "http://api.memolease.com/api/v1/users/") else { return URL(fileURLWithPath: "") }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .signup:
            return "signup"
        case .login:
            return "login"
        case .profile:
            return "me"
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
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .profile:
            return [
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")"
            ]
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .signup(let userName, let email, let password):
            return [
                "userName": userName,
                "email": email,
                "password": password
            ]
        case .login(let email, let password):
            return [
                "email": email,
                "password": password
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
