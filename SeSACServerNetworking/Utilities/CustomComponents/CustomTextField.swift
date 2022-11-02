//
//  CustomTextField.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/03.
//

import UIKit

class CustomTextField: UITextField {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String, fontSize: CGFloat) {
        self.init()
        self.placeholder = placeholder
        self.font = .systemFont(ofSize: fontSize)
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.textAlignment = .center
        self.borderStyle = .bezel
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
    }
    
    // MARK: - Helper Functions
    
    func configureUI() { }

    func setConstraints() { }

}
