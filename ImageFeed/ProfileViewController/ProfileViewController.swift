//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 15.06.23.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginLable: UILabel?
    private var descriptionLable: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupAvatarImageView()
        setupNameLabel()
        setupLoginLable()
        setupDescriptionLable()
        setupLogautButton()
    }
    @objc
    func didTapLogoutButton() {}
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
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.init(name: "HelveticaNeue-Bold", size: 23)
        setupAutoresizingMaskBackgroundColor(andAdd: nameLabel)
        self.nameLabel = nameLabel
        
        guard let avatarImageView = avatarImageView else { return }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupLoginLable() {
        let loginLable = UILabel()
        loginLable.text = "@ekaterina_nov"
        loginLable.textColor = .ypGrey
        loginLable.font = UIFont.systemFont(ofSize: 13)
        setupAutoresizingMaskBackgroundColor(andAdd: loginLable)
        self.loginLable = loginLable
        
        guard let nameLabel = nameLabel else {
            return }
        
        NSLayoutConstraint.activate([
            loginLable.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupDescriptionLable() {
        let descriptionLable = UILabel()
        descriptionLable.text = "Hello, world!"
        descriptionLable.textColor = .ypWhite
        descriptionLable.font = UIFont.systemFont(ofSize: 13)
        setupAutoresizingMaskBackgroundColor(andAdd: descriptionLable)
        self.descriptionLable = descriptionLable
        
        guard let loginLable = loginLable else { return }
        
        NSLayoutConstraint.activate([
            descriptionLable.topAnchor.constraint(equalTo: loginLable.bottomAnchor, constant: 8),
            descriptionLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupLogautButton() {
        let imageButton = UIImage(named: "Exit") ?? UIImage()
        let logautButton = UIButton.systemButton(with: imageButton, target: self, action: #selector(self.didTapLogoutButton))
        logautButton.tintColor = .ypRed
        setupAutoresizingMaskBackgroundColor(andAdd: logautButton)
        
        guard let avatarImageView = avatarImageView else { return }
        
        NSLayoutConstraint.activate([
            logautButton.heightAnchor.constraint(equalToConstant: 44),
            logautButton.widthAnchor.constraint(equalToConstant: 44),
            logautButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logautButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
