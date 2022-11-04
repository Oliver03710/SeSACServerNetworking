//
//  ProfileViewModel.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/04.
//

import Foundation

import RxCocoa
import RxSwift

final class ProfileViewModel: CommonViewModel {
    
    // MARK: - Properties
    
    var api: SeSACAPI = .profile
    
    let photo = PublishSubject<Data>()
    let userName = PublishRelay<String>()
    let email = PublishRelay<String>()
    
    
    // MARK: - In & Out Data
    
    struct Input {
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let name: SharedSequence<DriverSharingStrategy, String>
        let email: SharedSequence<DriverSharingStrategy, String>
    }
    
    
    // MARK: - Helper Functions
    
    func initialProfile() {
        SeSACManager.shared.request(Profile.self, router: api) { [weak self] resonse in
            switch resonse {
            case .success(let data):
                guard let url = URL(string: data.user.photo) else { return }
                
                DispatchQueue.global().async {
                    do {
                        guard let data = try? Data(contentsOf: url) else { return }
                        self?.photo.onNext(data)
                    }
                }
                
                self?.userName.accept(data.user.username)
                self?.email.accept(data.user.email)
                
            case .failure(let err):
                self?.photo.onError(err)
            }
        }
    }
    
    func transform(input: Input) -> Output {
        
        let nameTransformed = userName.asDriver(onErrorJustReturn: "")
        let emailTransformed = email.asDriver(onErrorJustReturn: "")
        
        return Output(tap: input.tap, name: nameTransformed, email: emailTransformed)
    }
}
