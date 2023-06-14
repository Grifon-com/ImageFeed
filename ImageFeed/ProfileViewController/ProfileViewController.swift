//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 8.06.23.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupAvatarImageView()
        setupNameLabel()
        setupLoginNameLabel()
        setupDescriptionLabel()
        setupLogoutButton()
    }
    
    @objc
    func didTapLogoutButton() {}
}

//MARK: - SetupUIElement
extension ProfileViewController {
    
    func setupBackgroundColorAutoresizingMask(andAdd subView: UIView) {
        subView.backgroundColor = .clear
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
    }
    
    func setupAvatarImageView() {
        let avatarImage = UIImage(named: "Avatar")
        let avatarImageView = UIImageView(image: avatarImage)
        setupBackgroundColorAutoresizingMask(andAdd: avatarImageView)
        self.avatarImageView = avatarImageView
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupNameLabel() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 23.0)
        setupBackgroundColorAutoresizingMask(andAdd: nameLabel)
        self.nameLabel = nameLabel
        
        guard let avatarImageView = avatarImageView else { return }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo:avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupLoginNameLabel() {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypGrey
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        setupBackgroundColorAutoresizingMask(andAdd: loginNameLabel)
        self.loginNameLabel = loginNameLabel
        
        guard let nameLabel = nameLabel else { return }
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupDescriptionLabel() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        setupBackgroundColorAutoresizingMask(andAdd: descriptionLabel)
        self.descriptionLabel = descriptionLabel
        guard let loginNameLabel = loginNameLabel else { return }
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupLogoutButton() {
        guard let imageButton = UIImage(named: "ipad.and.arrow.forward") else { return }
        let logoutButton = UIButton.systemButton(with: imageButton, target: self, action: #selector(didTapLogoutButton))
        logoutButton.tintColor = .ypRed
        setupBackgroundColorAutoresizingMask(andAdd: logoutButton)
        
        guard let avatarImageView = avatarImageView else { return }
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
