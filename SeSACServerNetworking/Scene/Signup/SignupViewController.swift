//
//  SignupViewController.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class SignupViewController: BaseViewController {

    // MARK: - Properties
    
    private let titleLabel: CustomLabel = {
        let label = CustomLabel(text: UserDefaultsManager.signupTitle, fontSize: 32)
        return label
    }()
    
    private let nameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: UserDefaultsManager.nameTextField, fontSize: 15)
        return tf
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: UserDefaultsManager.emailTextField, fontSize: 15, keyBoardType: .emailAddress)
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: UserDefaultsManager.passwordTextField, fontSize: 15)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signupButton: CustomButton = {
        let btn = CustomButton(title: UserDefaultsManager.signupTitle, fontSize: 20)
        return btn
    }()
    
    private let viewModel = SignupViewModel()
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
        [nameTextField, titleLabel, emailTextField, passwordTextField, signupButton].forEach { view.addSubview($0) }
        
        nameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.65)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nameTextField.snp.top).offset(-60)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(40)
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
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(52)
        }
    }
    
    private func bindData() {
        let input = SignupViewModel.Input(nameText: nameTextField.rx.text, emailText: emailTextField.rx.text, passwordText: passwordTextField.rx.text, tap: signupButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validation
            .withUnretained(self)
            .bind { (vc, bool) in
                let color: UIColor = bool ? .systemGreen : .darkGray
                vc.signupButton.backgroundColor = color
                vc.signupButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.transitionVC()
            }
            .disposed(by: disposeBag)
        
    }
    
    func transitionVC() {
        SeSACManager.shared.request(router: viewModel.api)
            .subscribe { data in
                guard data.uppercased() == UserDefaultsManager.okay else { return }
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let vc = LoginViewController()
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
            } onFailure: { [weak self] error in
                self?.view.makeToast(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
