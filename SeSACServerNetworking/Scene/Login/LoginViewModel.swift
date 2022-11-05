//
//  LoginViewModel.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/03.
//

import Foundation

import RxCocoa
import RxSwift

final class LoginViewModel: CommonViewModel {
    
    // MARK: - Properties
    
    var api: SeSACAPI = .login(email: "", password: "")
    let disposeBag = DisposeBag()
    
    
    // MARK: - In & Out Data
    
    struct Input {
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
        
        Observable.combineLatest(input.emailText.orEmpty, input.passwordText.orEmpty)
            .withUnretained(self)
            .bind { (vc, arg1) in
                let (email, password) = arg1
                vc.api = .login(email: email, password: password)
            }
            .disposed(by: disposeBag)
        
        let emailValid = input.emailText.orEmpty
            .map { str in
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailTest.evaluate(with: str)
            }
            .share()
        
        let passwordValid = input.passwordText.orEmpty
            .map { $0.count >= 8 }
            .share()
        
        let totalValid = Observable.combineLatest(emailValid, passwordValid)
            .map { $0 && $1 }
            .share()
        
        return Output(validation: totalValid, tap: input.tap)
    }
}
