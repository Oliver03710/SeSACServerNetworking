//
//  SignupViewController.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import UIKit

final class SignupViewController: BaseViewController {

    // MARK: - Properties
    
    
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SeSACManager.shared.request(Login.self, router: SeSACAPI.login(email: "testJack1@testJack.com", password: "12345678")) { data in
            UserdefaultsHelper.standard.personalToken = data.token
            print(data)
        } failure: { error in
            print(error)
        }
        
//        SeSACManager.shared.request(router: SeSACAPI.signup(userName: "Jacks0005", email: "Jacks0005@testJack.com", password: "12345678")) { data in
//            print(data)
//        } failure: { error in
//            print(error)
//        }
        
//        SeSACManager.shared.request(Profile.self, router: SeSACAPI.profile) { data in
//            print(data)
//        } failure: { error in
//            print(error)
//        }
    }

}
