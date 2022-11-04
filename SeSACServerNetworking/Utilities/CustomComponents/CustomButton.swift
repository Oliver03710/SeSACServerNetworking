//
//  CustomButton.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/04.
//

import UIKit

final class CustomButton: UIButton {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, fontSize: CGFloat, isEnabled: Bool = false) {
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        self.isEnabled = isEnabled
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        clipsToBounds = true
        layer.cornerRadius = 12
        backgroundColor = .darkGray
    }
}
