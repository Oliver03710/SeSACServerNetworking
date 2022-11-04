//
//  CustomImageView.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/04.
//

import UIKit

final class CustomImageView: UIImageView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isFullCircle()
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        contentMode = .scaleAspectFit
        image = UIImage(systemName: "applelogo")
    }
    
    func isFullCircle() {
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
    }

}
