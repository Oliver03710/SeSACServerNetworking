//
//  CustomLabel.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/04.
//

import UIKit

final class CustomLabel: UILabel {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String, fontSize: CGFloat) {
        self.init()
        self.text = text
        self.font = .boldSystemFont(ofSize: fontSize)
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        textAlignment = .center
    }

}
