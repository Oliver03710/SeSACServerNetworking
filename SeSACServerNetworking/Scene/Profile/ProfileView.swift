//
//  ProfileView.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class ProfileView: BaseView {

    // MARK: - Properties
    
    private let profileImageView: CustomImageView = {
        let iv = CustomImageView(frame: .zero)
        return iv
    }()
    
    private let nameLabel: CustomLabel = {
        let label = CustomLabel(text: "testName", fontSize: 15)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = CustomLabel(text: "testEmail", fontSize: 15)
        return label
    }()
    
    private let logoutButton: CustomButton = {
        let btn = CustomButton(title: UserDefaultsManager.logoutTitle, fontSize: 15, isEnabled: true)
        return btn
    }()
    
    private let viewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        viewModel.initialProfile()
        bind()
    }

    override func setConstraints() {
        [profileImageView, nameLabel, emailLabel, logoutButton].forEach { addSubview($0) }
        
        logoutButton.snp.makeConstraints { [unowned self] make in
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(32)
            make.width.equalTo(logoutButton.snp.height).multipliedBy(3)
        }
        
        profileImageView.snp.makeConstraints { [unowned self] make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).dividedBy(1.2)
            make.height.equalTo(self.snp.height).dividedBy(4)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints { [unowned self] make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.height.equalTo(24)
            make.width.equalTo(self.snp.width).dividedBy(2)
        }
        
        emailLabel.snp.makeConstraints { [unowned self] make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(nameLabel.snp.bottom).offset(32)
            make.height.equalTo(nameLabel.snp.height)
            make.width.equalTo(nameLabel.snp.width)
        }
    }
    
    func bind() {
        let input = ProfileViewModel.Input(tap: logoutButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.email
            .drive(emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.name
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - 고장
        viewModel.photo
            .map { UIImage(data: $0) }
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        
//            .observe(on: MainScheduler.instance)
//            .subscribe { (vc, image) in
//                vc.profileImageView.image = image
//            } onError: { [weak self] error in
//                self?.makeToast(error.localizedDescription)
//            }
//            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .flatMapLatest { (vc, _) in
                return vc.toSignupVC()
                }
            .subscribe(onCompleted: {
                print("화면이동 성공적!")
            })
            .disposed(by: disposeBag)
    }
    
    func toSignupVC() -> Completable {
        return Completable.create { completable in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let vc = SignupViewController()
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
            UserDefaultsManager.token = ""
            completable(.completed)
            return Disposables.create()
        }
    }
}
