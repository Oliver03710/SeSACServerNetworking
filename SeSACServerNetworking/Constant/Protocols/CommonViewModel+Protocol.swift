//
//  CommonViewModel+Protocol.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/03.
//

import Foundation

protocol CommonViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
