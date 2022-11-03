//
//  SeSACManager.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import Foundation

import Alamofire
import RxSwift

final class SeSACManager {

    
    // MARK: - Properties
    
    static let shared = SeSACManager()
    
    
    // MARK: - Init
    
    private init() { }
    
    
    // MARK: - Helper Functions
        
    func request<T: Codable>(_ types: T.Type = T.self, router: SeSACAPI) -> Single<T> {
        return Single<T>.create { single in
            
            AF.request(router).validate(statusCode: 200..<400).responseDecodable(of: types.self) { response in
                
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure:
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = SeSACError(rawValue: statusCode) else { return }
                    single(.failure(error))
                }
                
            }
            return Disposables.create()
        }
    }
    
    func request(router: SeSACAPI) -> Single<String> {
        return Single<String>.create { single in
            
            AF.request(router).validate(statusCode: 200..<400).responseString() { response in
                switch response.result {
                case .success(let data):
                    single(.success(data))
                case .failure:
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = SeSACError(rawValue: statusCode) else { return }
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func request<T: Codable>(_ types: T.Type = T.self, router: SeSACAPI, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(router).validate(statusCode: 200..<400).responseDecodable(of: types.self) { response in
            
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure:
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = SeSACError(rawValue: statusCode) else { return }
                completion(.failure(error))
            }
            
        }
    }
}


