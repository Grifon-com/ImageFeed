//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Uригорий Машук on 15.06.23.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginLable: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupAvatarImageView()
    }
}

extension ProfileViewController {
    
    func setupAutoresizingMaskBackgroundColor(andAdd subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = .clear
        view.addSubview(subview)
    }
    
    func setupAvatarImageView() {
        let avatarImage = UIImage(named: "Photo")
        let avatarImageView = UIImageView.init(image: avatarImage)
        setupAutoresizingMaskBackgroundColor(andAdd: avatarImageView)
        self.avatarImageView = avatarImageView
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setupNameLabel() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина новикова"
        nameLabel.tintColor = .ypWhite
        nameLabel.font = UIFont.init(name: <#T##String#>, size: <#T##CGFloat#>)
    }
}
