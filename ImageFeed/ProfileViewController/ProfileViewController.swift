//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Uригорий Машук on 15.06.23.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    private weak var avatarImageView: UIImageView!
    private weak var nameLabel: UILabel!
    private weak var loginLable: UILabel!
    private weak 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
}


extension ProfileViewController {
    
    func setupAutoresizingMaskBackgroundColor(andAdd subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = .clear
    }
    
    func setupAvatarImageView() {
        
    }
}
