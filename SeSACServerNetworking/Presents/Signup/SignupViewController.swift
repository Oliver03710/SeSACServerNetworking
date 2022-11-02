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

final class SignupViewController: BaseViewController {

    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.text = "회원가입"
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "이름을 입력하세요.", fontSize: 15)
        return tf
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "이메일주소를 입력하세요.", fontSize: 15)
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "비밀번호를 입력하세요.", fontSize: 15)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signupButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("회원가입", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.backgroundColor = .darkGray
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 12
        btn.isEnabled = false
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
        
        nameTextField.snp.makeConstraints { [unowned self] make in
            make.centerY.equalTo(self.view.snp.centerY).multipliedBy(0.65)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { [unowned self] make in
            make.bottom.equalTo(nameTextField.snp.top).offset(-60)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(nameTextField.snp.bottom).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        signupButton.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).dividedBy(1.5)
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
                SeSACManager.shared.request(router: vc.viewModel.api) { [weak self] str in
                    if str.uppercased() == "OK" {
                        let vc = LoginViewController()
                        vc.modalPresentationStyle = .overFullScreen
                        self?.present(vc, animated: true)
                    }
                } failure: { error in
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
    }

}
