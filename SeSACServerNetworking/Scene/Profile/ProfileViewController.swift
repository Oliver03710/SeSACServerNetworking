//
//  ProfileViewController.swift
//  SeSACServerNetworking
//
//  Created by Junhee Yoon on 2022/11/02.
//

import UIKit

final class ProfileViewController: BaseViewController {

    // MARK: - Properties
    
    private let profileView = ProfileView()
    
    
    // MARK: - Init
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
