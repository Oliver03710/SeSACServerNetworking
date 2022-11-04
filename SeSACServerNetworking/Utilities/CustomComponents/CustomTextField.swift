//
//  CustomTextField.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/03.
//

import UIKit

final class CustomTextField: UITextField {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String, fontSize: CGFloat, keyBoardType: UIKeyboardType = .default) {
        self.init()
        self.placeholder = placeholder
        self.font = .systemFont(ofSize: fontSize)
        self.keyboardType = keyBoardType
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        clipsToBounds = true
        textAlignment = .center
        borderStyle = .bezel
        autocapitalizationType = .none
        autocorrectionType = .no
    }

}
