//
//  LoginViewController.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class LoginViewController: BaseViewController {

    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.text = UserDefaultsManager.loginTitle
        label.textAlignment = .center
        return label
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: UserDefaultsManager.emailTextField, fontSize: 15)
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: UserDefaultsManager.passwordTextField, fontSize: 15)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(UserDefaultsManager.loginTitle, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.backgroundColor = .darkGray
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 12
        btn.isEnabled = false
        return btn
    }()
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        bindData()
    }

    override func setConstraints() {
        [titleLabel, emailTextField, passwordTextField, loginButton].forEach { view.addSubview($0) }
        
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.8)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.top).offset(-60)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(52)
        }
    }
    
    private func bindData() {
        let input = LoginViewModel.Input(emailText: emailTextField.rx.text, passwordText: passwordTextField.rx.text, tap: loginButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validation
            .withUnretained(self)
            .bind { (vc, bool) in
                let color: UIColor = bool ? .systemGreen : .darkGray
                vc.loginButton.backgroundColor = color
                vc.loginButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .flatMapLatest { (vc, _) in
                return SeSACManager.shared.request(Login.self, router: vc.viewModel.api)
                }
            .subscribe { data in
                UserDefaultsManager.token = data.token
                guard UserDefaultsManager.token != nil else { return }
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let vc = ProfileViewController()
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
            } onError: { [weak self] error in
                self?.view.makeToast(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
