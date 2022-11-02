//
//  SeSACManager.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import Foundation

import Alamofire

final class SeSACManager {

    
    // MARK: - Properties
    
    static let shared = SeSACManager()
    
    
    // MARK: - Init
    
    private init() { }
    
    
    // MARK: - Helper Functions
    
    func request<T: Codable>(_ types: T.Type = T.self, router: SeSACAPI, success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(router).validate(statusCode: 200..<400).responseDecodable(of: types.self) { response in
                switch response.result {
                case .success(let data):
                    success(data)
                case .failure(let err):
                    failure(err)
                }
            }
        }
    
    func request(router: SeSACAPI, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(router).validate(statusCode: 200..<400).responseString() { response in
                switch response.result {
                case .success(let data):
                    success(data)
                case .failure(let err):
                    failure(err)
                }
            }
        }
}
