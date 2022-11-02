//
//  SignupViewModel.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/03.
//

import Foundation

import RxCocoa
import RxSwift

final class SignupViewModel: CommonViewModel {
    
    // MARK: - Properties
    
    var api: SeSACAPI = .signup(userName: "", email: "", password: "")
    let disposeBag = DisposeBag()
    
    
    // MARK: - In & Out Data
    
    struct Input {
        let nameText: ControlProperty<String?>
        let emailText: ControlProperty<String?>
        let passwordText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    
    // MARK: - Helper Functions
    
    func transform(input: Input) -> Output {
        
        Observable.combineLatest(input.nameText.orEmpty, input.emailText.orEmpty, input.passwordText.orEmpty)
            .withUnretained(self)
            .bind { (vc, arg1) in
                let (name, email, password) = arg1
                vc.api = .signup(userName: name, email: email, password: password)
            }
            .disposed(by: disposeBag)
        
        let nameValid = input.nameText.orEmpty
            .map { $0.count > 0 && $0.count <= 12 && !$0.isEmpty }
            .share()
        
        let emailValid = input.emailText.orEmpty
            .map { $0.count > 0 && $0.contains("@") && $0.contains(".") }
            .share()
        
        let passwordValid = input.passwordText.orEmpty
            .map { $0.count >= 8 }
            .share()
        
        let totalValid = Observable.combineLatest(nameValid, emailValid, passwordValid)
            .map { $0 && $1 && $2 }
            .share()
        
        return Output(validation: totalValid, tap: input.tap)
    }
}
