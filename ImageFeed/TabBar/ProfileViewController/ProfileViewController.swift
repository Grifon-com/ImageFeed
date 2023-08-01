//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 27.05.23.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private static let imageAvatarName = "Avatar"
    private static let textNameLabel = "Екатерина Новикова"
    private static let textLoginNameLabel = "@ekaterina_nov"
    private static let textDescriptionLabel = "Hello, world!"
    private static let imageLogoutButtonName = "ipad.and.arrow.forward"
    private static let imagePlaceholderName = "placeholderAvatar"
    
    private static let titleAlert = "Пока, пока!"
    private static let messageAlert = "Уверены что хотите выйти?"
    private static let titleActionOne = "Да"
    private static let titleActionTwo = "Нет"
    
    private static let fontNameLabel = CGFloat(23)
    private static let fontLoginNameLabel = CGFloat(13)
    private static let fontDescriptionLabel = CGFloat(13)
    
    private let profileService = ProfileService.shared
    private var cleanCookieAndToken: CleanProtocol?
    private var profileModel: Profile?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImage = UIImage(named: ProfileViewController.imageAvatarName)
        let avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        
        return avatarImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = ProfileViewController.textNameLabel
        nameLabel.textColor = .ypWhite
        nameLabel.font = .boldSystemFont(ofSize: ProfileViewController.fontNameLabel)
        
        return nameLabel
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.text = ProfileViewController.textLoginNameLabel
        loginNameLabel.textColor = .ypGrey
        loginNameLabel.font = UIFont.systemFont(ofSize: ProfileViewController.fontLoginNameLabel)
        
        return loginNameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = ProfileViewController.textDescriptionLabel
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: ProfileViewController.fontDescriptionLabel)
        
        return descriptionLabel
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton()
        let imageButton = UIImage(named: ProfileViewController.imageLogoutButtonName)
        logoutButton.setImage(imageButton, for: .normal)
        logoutButton.addTarget(nil, action: #selector(didTapLogoutButton), for: .allTouchEvents)
        logoutButton.tintColor = .ypRed
        
        return logoutButton
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cleanCookieAndToken = Clean()
        setupUIElement()
        applyConstraints()
        updateProfileDetails(profile: profileService.profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    @objc
    private func didTapLogoutButton() {
        let alert = UIAlertController(title: ProfileViewController.titleAlert,
                                      message: ProfileViewController.messageAlert,
                                      preferredStyle: .alert)
        
        let actionAlertOne = UIAlertAction(title: ProfileViewController.titleActionOne,
                                           style: .default) { [weak self] _ in
            guard let self = self,
                  let cleanCookieAndToken = self.cleanCookieAndToken else { return }
            cleanCookieAndToken.cleanCookies()
            cleanCookieAndToken.cleanToken()
            
            guard let window = UIApplication.shared.windows.first else { return }
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
        }
        let alertActionTwo = UIAlertAction(title: ProfileViewController.titleActionTwo, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        alert.addAction(actionAlertOne)
        alert.addAction(alertActionTwo)
        
        present(alert, animated: true)
    }
}

private extension ProfileViewController {
    //MARK: Update profile image for kingfisher
    func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: ProfileViewController.imagePlaceholderName))
    }
    
    //MARK: UpdateProfileDetails
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    //MARK: SetupUIElement
    func setupUIElement() {
        view.backgroundColor = .ypBlack
        [avatarImageView, nameLabel, loginNameLabel, descriptionLabel, logoutButton].forEach {
            view.addSubview($0)
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo:avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
